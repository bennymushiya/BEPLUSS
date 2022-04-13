//
//  ProgressPost.swift
//  Weightloss
//
//  Created by benny mushiya on 24/05/2021.
//

import UIKit
import Firebase
import FirebaseFirestore

struct ProgressPost {
    
    let caption: String?
    let image: String
    let ownerUid: String
    var likes: Int
    let timeStamp: Timestamp
    let postID: String
    

    
    let user: User
    
    var didRelate = false
    
    init(user: User, postID: String, dictionary: [String:Any]) {
        self.caption = dictionary["caption"] as? String ?? ""
        self.image = dictionary["image"] as? String ?? ""
        self.ownerUid = dictionary["ownerUid"] as? String ?? ""
        self.likes = dictionary["likes"] as? Int ?? 0
        self.timeStamp = dictionary["timeStamp"] as? Timestamp ?? Timestamp(date: Date())
        self.postID = postID
        self.user = user

        
        
        
        
    }
    
    
    
}
