//
//  Notifications.swift
//  Weightloss
//
//  Created by benny mushiya on 11/06/2021.
//

import UIKit
import Firebase


enum NotificationsType: Int {
    
    case relatables
    case likes
    case comments
    case message
    
    var relatedMessage: String {
        
        return " Related to your Post "
    }
    
    var notificationMessage: String {
        
        switch self {
        case .relatables: return " Related to your Post "
        case .likes: return " Liked your Post"
        case .comments: return " commented on your Post"
        case .message: return " sent you a message "
            
        }
    }
}

struct Notification {
    
    let fromUid: String
    var postImageUrl: String?
    var postId: String
    let timestamp: Timestamp
    let type: NotificationsType
    let documentID: String
    let fromUserProfileImageUrl: String
    let fromUsername: String
    var postText: String?
    
    let user: User

    
    init(user: User, dictionary: [String: Any]) {
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        self.documentID = dictionary["documentID"] as? String ?? ""
        self.fromUid = dictionary["fromUid"] as? String ?? ""
        self.postId = dictionary["postID"] as? String ?? ""
        self.postImageUrl = dictionary["image"] as? String ?? ""
        self.type = NotificationsType(rawValue: dictionary["type"] as? Int ?? 0) ?? .relatables
        self.fromUserProfileImageUrl = dictionary["fromUserProfileImageUrl"] as? String ?? ""
        self.fromUsername = dictionary["fromUsername"] as? String ?? ""
        self.postText = dictionary["post"] as? String ?? ""
        self.user = user

    }
    
}
