//
//  NotificationViewModel.swift
//  Weightloss
//
//  Created by benny mushiya on 11/06/2021.
//

import UIKit

struct NotificationViewModel {
    
    let notifications: Notification
    let user: User
    
    var fromUserProfileImage: URL? {
        
        return URL(string: notifications.user.profileImage)
    }
    
    var fromUsername: String {
        
        return notifications.user.name
    }
    
    var postImageUrl: URL? {
        
        return URL(string: notifications.postImageUrl ?? "")
        
    }
    
    var postTextCaption: String? {
        
        return notifications.postText ?? ""
    }

    
    var timeStamp: String? {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 0
        formatter.unitsStyle = .abbreviated
        
        return formatter.string(from: notifications.timestamp.dateValue(), to: Date())

    }
    
    var notificationMessage: NSAttributedString {
        let username = notifications.user.name
        let message = notifications.type.relatedMessage
        
        let attributedText = NSMutableAttributedString(string: username, attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: message, attributes: [.font: UIFont.systemFont(ofSize: 14)]))
        
        return attributedText
        
    }
    
    var shouldHidePostImage: Bool {
        
        return notifications.postImageUrl != ""
        
    }
    
    var shouldHidePostText: Bool {
        
        return notifications.postText != ""
        
    }
    
    var fromUserUid: String {
        
        return notifications.fromUid
    }
    
    var postID: String {
        
        return notifications.postId
    }
    
    
    init(notifications: Notification) {
        self.notifications = notifications
        self.user = notifications.user
    }
}
