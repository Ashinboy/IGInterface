
import UIKit

func fetchInstagramData(){
    let urlIG = "https://www.instagram.com/chestnuthead_/?__a=1"
    if let url = URL(string: urlIG){
        URLSession.shared.dataTask(with: url) { data, urlResponse, error in
            let decoder = JSONDecoder()
            //解析時間
            decoder.dateDecodingStrategy = .secondsSince1970
            if let data = data {
                //decoder會throws因此加try嘗試讀取，透過do catch若有問題就會顯示erro
                do{
                    //由於會回傳decoder需要用常數儲存起來
                    let chestnutHeadIGResponse = try decoder.decode(ChestnutHeadIGResponse.self, from: data)
                    print(chestnutHeadIGResponse)
                }catch{
                    print(error)
                }
                
            }
        }.resume()
    }
        
}
