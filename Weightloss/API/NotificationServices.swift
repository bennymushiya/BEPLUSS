//
//  NotificationServices.swift
//  Weightloss
//
//  Created by benny mushiya on 11/06/2021.
//

import UIKit
import Firebase
import FirebaseAuth


struct NotificationServices {
    
    static func uploadNotifications(toUid uid: String, fromUser: User, type: NotificationsType, post: TextPost? = nil, progressPost: ProgressPost? = nil) {
        
        guard let currentUser = Auth.auth().currentUser?.uid else {return}
        guard uid != currentUser else {return}
        
        let docRef = COLLECTION_NOTIFICATIONS.document(uid).collection("user-notifications").document()
        
        var data = ["timeStamp": Timestamp(date: Date()),
                    "fromUid": fromUser.uid,
                    "fromUsername": fromUser.name,
                    "fromUserProfileImageUrl": fromUser.profileImage,
                    "documentID": docRef.documentID,
        "type": type.rawValue] as [String: Any]
        
        if let post = post {
            data["postID"] = post.postID
            data["post"] = post.post
            
        } else {
            
            if let progressPost = progressPost {
                data["postID"] = progressPost.postID
                data["image"] = progressPost.image
                
            }
        }
        
        docRef.setData(data)
    }
    
    
    static func fetchNotifications(completion: @escaping([Notification]) -> Void) {
        
        var notifications = [Notification]()
        
        guard let currentUser = Auth.auth().currentUser?.uid else {return}
        
        let query = COLLECTION_NOTIFICATIONS.document(currentUser).collection("user-notifications").order(by: "timeStamp", descending: true)
        
        query.getDocuments { snapshot, error in
            
            guard let documents = snapshot?.documents else {return}
            
            documents.forEach { docs in
                let dictionary = docs.data()
                guard let fromUid = dictionary["fromUid"] as? String else {return}
                
                UserServices.fetchUser(withCurrentUser: fromUid) { user in
                    
                    let notification = Notification(user: user, dictionary: dictionary)
                    
                    notifications.append(notification)
                    
                    completion(notifications)
                }
            }
        }
    }
    
    
}
