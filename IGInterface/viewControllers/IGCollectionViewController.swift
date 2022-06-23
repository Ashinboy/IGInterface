//
//  IGCollectionViewController.swift
//  IGInterface
//
//  Created by Ashin Wang on 2022/4/27.
//

import UIKit

private let reuseIdentifier = "IGCollectionViewCell"

class IGCollectionViewController: UICollectionViewController {
    
    var ChestnutHeadIGData: ChestnutHeadIGResponse?
    var ChestnutHeadIGPic = [ChestnutHeadIGResponse.Graphql.User.Edge_owner_to_timeline_media.Edges]()
    
    //點選主頁圖片跳至cell
    
    @IBSegueAction func showPosts(_ coder: NSCoder) -> postsDetailCollectionViewController? {
        guard let row =   collectionView.indexPathsForSelectedItems?.first?.row else {return nil}
        
        print("row:\(row)")
        
        return postsDetailCollectionViewController.init(coder: coder, ChestnutHeadIGData: ChestnutHeadIGData!, indexPath: row)
    }
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchInstagramData()
        configureCellSize()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Register cell classes
        
        //        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        // Do any additional setup after loading the view.
    }
   
    
    func configureCellSize(){
        
        let itemSpace: Double = 3
        let columnCount: Double = 3
        let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout
        
        let width = floor((collectionView.bounds.width - itemSpace * (columnCount-1)) / columnCount)
        
        flowLayout?.itemSize = CGSize(width: width , height: width)
        flowLayout?.estimatedItemSize = .zero
        flowLayout?.minimumLineSpacing = itemSpace
        flowLayout?.minimumInteritemSpacing = itemSpace
        
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return ChestnutHeadIGPic.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? IGCollectionViewCell else { return UICollectionViewCell() }
        
        let item = ChestnutHeadIGPic[indexPath.item]
        //在背景讀取資料
        URLSession.shared.dataTask(with: item.node.display_url) { data, response, error in
            if let data = data {
                DispatchQueue.main.async {
                    cell.mainImage.image = UIImage(data: data)
                }
            }
        }.resume()
        
        // Configure the cell
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let reusableView =  collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "IGHeaderCollectionReusableView", for: indexPath) as? IGCollectionReusableView else
        {return UICollectionReusableView()}
        
        if let profilPiceUrl = self.ChestnutHeadIGData?.graphql.user.profile_pic_url_hd{
            //背景抓資料
            URLSession.shared.dataTask(with: profilPiceUrl) { data, response, error in
                if let data = data {
                    do {
                        //更新畫面讓資料在mainthread執行
                        DispatchQueue.main.async {
                            reusableView.profileImageVIew.layer.cornerRadius = reusableView.profileImageVIew.frame.width / 2
                            reusableView.profileImageVIew.image = UIImage(data: data)
                        }
                    } catch {
                        print(error)
                    }
                }
            }.resume()
        }
        if let posts =
            self.ChestnutHeadIGData?.graphql.user.edge_owner_to_timeline_media.count ,
           let follower = self.ChestnutHeadIGData?.graphql.user.edge_followed_by.count,
           let following = self.ChestnutHeadIGData?.graphql.user.edge_follow.count,
           let fullName = self.ChestnutHeadIGData?.graphql.user.full_name,
           let category = self.ChestnutHeadIGData?.graphql.user.category_name,
           
            let biography = self.ChestnutHeadIGData?.graphql.user.biography {
            reusableView.postLabel.text = "\(posts)"
            reusableView.followerLabel.text = "\(follower)"
            reusableView.followingLabel.text = "\(following)"
            reusableView.fullNameLabel.text = "\(fullName)"
            reusableView.categoryNameLabel.text = "\(category)"
            reusableView.categoryNameLabel.textColor = .systemGray
            reusableView.biographyTextView.isEditable = false
            reusableView.biographyTextView.text = "\(biography)"
            
        }
        
        return reusableView
    }
    
    
    //抓取資料
    func fetchInstagramData(){
        let urlIG = "https://www.instagram.com/chestnuthead_/?__a=1"
        if let url = URL(string: urlIG){
            URLSession.shared.dataTask(with: url) { data, urlResponse, error in
                let decoder = JSONDecoder()
                //解析時間
                decoder.dateDecodingStrategy = .secondsSince1970
                if let data = data {
                    //decoder會throws因此加try嘗試讀取，透過do catch若有問題就會顯示error
                    do{
                        //由於會回傳decoder需要用常數儲存起來
                        let chestnutHeadIGResponse = try decoder.decode(ChestnutHeadIGResponse.self, from: data)
                        self.ChestnutHeadIGData = chestnutHeadIGResponse
                        self.updateData()
                        
                        
                        //更新畫面
                        DispatchQueue.main.async {
                            self.navigationItem.title = self.ChestnutHeadIGData?.graphql.user.username
                            self.navigationItem.backButtonTitle = "Profile"
                            self.collectionView.reloadData()
                        }
                    }catch{
                        print("check",error)
                    }
                    
                }
            }.resume()
        }
        
    }
    
    func updateData(){
        self.ChestnutHeadIGPic = (self.ChestnutHeadIGData?.graphql.user.edge_owner_to_timeline_media.edges)!
    }
    
    // MARK: UICollectionViewDelegate
    
    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment this method to specify if the specified item should be selected
     override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
     
     }
     */
    
}
