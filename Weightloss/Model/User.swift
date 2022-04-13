//
//  User.swift
//  Weightloss
//
//  Created by benny mushiya on 28/04/2021.
//

import UIKit
import Firebase
import FirebaseAuth

struct User {
    
    var name: String
    var profileImage: String
    let uid: String
    var chosenCommunity: String
    var fitnessGoals: String
    var backgroundImage: String
    var currentWeight: Int
    var futureGoal: Int
    var pushID: String
    
    
    var stats: UserStats!
    var weightGainStats: weightGainPostStats!
    
    var isCurrentUser: Bool {
        
        return Auth.auth().currentUser?.uid == uid
        
    }
    
    
    init(dictionary: [String: Any]) {
        self.name = dictionary["name"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
        self.profileImage = dictionary["profileImage"] as? String ?? ""
        self.chosenCommunity = dictionary["chosenCommunity"] as? String ?? ""
        self.fitnessGoals = dictionary["fitnessGoals"] as? String ?? ""
        self.backgroundImage = dictionary["backgroundImage"] as? String ?? ""
        self.currentWeight = dictionary["currentWeight"] as? Int ?? 0
        self.futureGoal = dictionary["futureGoal"] as? Int ?? 0
        self.pushID = dictionary["pushID"] as? String ?? ""
        
        self.stats = UserStats(posts: 0)
        self.weightGainStats = weightGainPostStats(posts: 0)
        
    }
}

struct UserStats {
    let posts: Int
    
}

struct weightGainPostStats {
    let posts: Int
}
