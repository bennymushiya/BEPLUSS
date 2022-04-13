//
//  Comments.swift
//  Weightloss
//
//  Created by benny mushiya on 10/05/2021.
//

import UIKit
import Firebase

struct Comments {
    
    let uid: String
    let commentText: String
    let name: String
    let profileImage: String
    let timeStamp: Timestamp
    let numberOfComments: Int
    
    
    init(dictionary: [String: Any]) {
        self.name = dictionary["name"] as? String ?? ""
        self.commentText = dictionary["commentText"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
        self.profileImage = dictionary["profileImage"] as? String ?? ""
        self.timeStamp = dictionary["timeStamp"] as? Timestamp ?? Timestamp(date: Date())
        self.numberOfComments = dictionary["numberOfComments"] as? Int ?? 0
        
    }
}



