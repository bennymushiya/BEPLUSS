//
//  Messages.swift
//  Weightloss
//
//  Created by benny mushiya on 25/05/2021.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

struct Messages {
    
    let text: String
    let toID: String
    let fromID: String
    let timeStamp: Timestamp
    
    
    // we put this here so we can populate a users detaisls on the UI
    var user: User?
    
    
    var isFromCurrentUser: Bool {
        
        return Auth.auth().currentUser?.uid == fromID
    }
    
    // if the message is from the currentUser return whoever they sent the message too. if its not from the currentUser return whoever the message is from.
    var chatPartnerId: String {
        
        return isFromCurrentUser ? toID : fromID
    }
    
    init(dictionary: [String: Any]) {
        self.text = dictionary["text"] as? String ?? ""
        self.toID = dictionary["toID"] as? String ?? ""
        self.fromID = dictionary["fromID"] as? String ?? ""
        self.timeStamp = dictionary["timeStamp"] as? Timestamp ?? Timestamp(date: Date())
        
      // self.isFromCurrentUser = fromID == Auth.auth().currentUser?.uid
        
    }
    
}
