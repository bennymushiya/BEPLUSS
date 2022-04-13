//
//  PushNotificationServices.swift
//  Weightloss
//
//  Created by benny mushiya on 19/11/2021.
//

import UIKit
import Firebase
import SwiftUI


struct PushNotificationServices {
    
    
    static func sendNotificationToUser(to token: String, nameOfUser: String, body: String) {
        
        let url = URL(string: "https://fcm.googleapis.com/fcm/send")!
        
        let paramString : [String : Any] = ["to" : token,
                                            "notification" : [
                                                "title" : nameOfUser,
                                                "body" : body,
                                                "badge" : "1",
                                                "sound" : "default"
                                            ]
        ]
        
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: paramString, options: [.prettyPrinted])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("key=\(PUSH_NOTIFICATION_KEY)", forHTTPHeaderField: "Authorization")
        
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            (data, response, error) in
            
            
        }

        task.resume()
    }
    
    
    
    static func sendNotificationToUserWithType(to token: String, title: String, type: NotificationsType ) {
        
        let url = URL(string: "https://fcm.googleapis.com/fcm/send")!
        
        let paramString : [String : Any] = ["to" : token,
                                            "notification" : [
                                                "title" : title,
                                                "body" : type.rawValue,
                                                "budge" : "1",
                                                "sound" : "default"
                                            ]
        ]
        
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: paramString, options: [.prettyPrinted])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("key=\(PUSH_NOTIFICATION_KEY)", forHTTPHeaderField: "Authorization")
        
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            (data, response, error) in
            
            
        }

        task.resume()
    }
    
    
}
