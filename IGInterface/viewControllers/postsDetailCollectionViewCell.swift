//
//  postsDetailCollectionViewCell.swift
//  IGInterface
//
//  Created by Ashin Wang on 2022/5/1.
//

import UIKit

class postsDetailCollectionViewCell: UICollectionViewCell {
    
    var likeBtnStatus:Bool = false
    //header Image
    @IBOutlet weak var headerImage: UIImageView!
    @IBOutlet weak var postsImage: UIImageView!
    //userName
    @IBOutlet weak var userNameLabel: UILabel!
    //title
    @IBOutlet weak var postsLikeLabel: UILabel!
    //comment
    @IBOutlet weak var postsCommentLabel: UILabel!
    //date
    @IBOutlet weak var postsDateLabel: UILabel!
    //postsContent
    @IBOutlet weak var postsTextVIew: UITextView!
    //button
    @IBOutlet weak var postsLikeButton: UIButton!

    @IBAction func postsLikeFIllBtn(_ sender: UIButton) {
        likeBtnStatus = !likeBtnStatus
        
        if likeBtnStatus{
            postsLikeButton.setImage(UIImage(named: "IG_icon_like_fill"), for: UIControl.State.normal)
        }else{
            postsLikeButton.setImage(UIImage(named: "IG_icon_like"), for: UIControl.State.normal)
        }
       
    }
}
