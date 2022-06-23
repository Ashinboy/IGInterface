//
//  JsonData.swift
//  IGInterface
//
//  Created by Ashin Wang on 2022/4/26.
//

import Foundation


struct ChestnutHeadIGResponse: Codable{
    let graphql: Graphql
    struct Graphql:Codable{
        let user: User
        struct User: Codable{
            //自介
            let biography: String
            
            //粉絲數
            let edge_followed_by: Edge_followed_by
            struct Edge_followed_by: Codable{
                let count: Int
            }
            //追蹤數
            let edge_follow: Edge_follow
            struct Edge_follow: Codable{
                let count: Int
            }
            //使用者帳號名
            let username: String
            //使用者名稱
            let full_name: String
            //類別內容
            let category_name: String
            //頭像
            let profile_pic_url_hd: URL
            
            //貼文
            let edge_owner_to_timeline_media: Edge_owner_to_timeline_media
            struct Edge_owner_to_timeline_media: Codable {
                let count: Int
                
                var edges: [Edges]
                struct Edges: Codable{
                    
                    var node: Node
                    struct Node: Codable{
                        //內文圖
                        let display_url: URL
                        //內文
                        let edge_media_to_caption: Edge_media_to_caption
                        struct Edge_media_to_caption: Codable{
                            let edges: [Edges]
                            struct Edges: Codable{
                                var node: Node
                                struct Node: Codable{
                                    var text: String
                                }
                            }
                        }
                        //留言
                        let edge_media_to_comment: Edge_media_to_comment
                        struct Edge_media_to_comment: Codable{
                            let count: Int
                        }
                        //貼文按愛心數
                        let edge_liked_by: Edge_liked_by
                        struct Edge_liked_by: Codable{
                            let count: Int
//                            var likeFill: Bool
                        }
                        //貼文時間
                        let taken_at_timestamp: Date
                    }
                }
            }
        }
        
        
    }
}
