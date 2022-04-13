//
//  ChallengesHeaderViewModel.swift
//  Weightloss
//
//  Created by benny mushiya on 13/08/2021.
//

import UIKit


struct ChallengesHeaderViewModel {
    
    var user: User
    
    var currentWeightGoal: String {
        
        return "\(user.currentWeight)KG"
    }
    
    var futureWeightGoal: String {
        
        return "\(user.futureGoal)KG"
    }
    
    var differenceBetweenCurrentAndGoalWeight: Int {
        
        return user.currentWeight - user.futureGoal
    }
    
    init(user: User) {
        self.user = user
        
    }
    
    
}
