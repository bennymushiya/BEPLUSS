//
//  TextPost.swift
//  Weightloss
//
//  Created by benny mushiya on 05/05/2021.
//

import UIKit
import Firebase

struct TextPost {
    
    var post: String
    var timeStamp: Timestamp
    var ownerUid: String
    var postID: String
    var relatables: Int
    var likes: Int
    var type: String
    
    var didRelate = false
    var didLike = false
    
    var commentStat: commentStats!
    
    let user: User

    init(user: User, postID: String, dictionary: [String: Any]) {
        self.post = dictionary["post"] as? String ?? ""
        self.timeStamp = dictionary["timeStamp"] as? Timestamp ?? Timestamp(date: Date())
        self.ownerUid = dictionary["ownerUid"] as? String ?? ""
        self.postID = postID
        self.user = user
        self.relatables = dictionary["relatables"] as? Int ?? 0
        self.likes = dictionary["likes"] as? Int ?? 0
        self.type = dictionary["type"] as? String ?? ""
        
        self.commentStat = commentStats(numberOfComments: 0)
    }
    
}

struct commentStats {
    
    var numberOfComments: Int
}
