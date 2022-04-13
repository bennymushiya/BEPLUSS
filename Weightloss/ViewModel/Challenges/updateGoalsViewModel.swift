//
//  updateGoalsViewModel.swift
//  Weightloss
//
//  Created by benny mushiya on 25/08/2021.
//

import UIKit

struct updateGoalsHeaderViewModel {
    
    var user: User
    
    var currentGoal: String {
        
        return "\(user.currentWeight)KG"
        
    }
    
    var targetGoal: String {
        
        return "\(user.futureGoal)KG"
    }
    
    
    init(user: User) {
        self.user = user
        
    }
}
