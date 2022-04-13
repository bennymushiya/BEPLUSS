//
//  NewGoalUpdateViewModel.swift
//  Weightloss
//
//  Created by benny mushiya on 13/10/2021.
//

import UIKit


enum NewGoalUpdateOptions: Int, CaseIterable {
    
    case currentWeight
    case GoalWeight
    
    var description: String {
        
        switch self {
            
        case .currentWeight: return "CurrentWeight"
        case .GoalWeight: return "GoalWeight"
            
        }
    }
    
    
}

struct NewGoalUpdateCellViewModel {
    
    var user: User
    var options: NewGoalUpdateOptions
    var value: String?
    
    var titleDescription: String {
        
        return options.description
    }
    
    var optionsValue: String {
        
        switch options {
            
        case .currentWeight: return "\(user.currentWeight)"
            
            
        case .GoalWeight: return "\(user.futureGoal)"
            
        }
        
    }
    
    var currentWeight: String {
        
        return "\(user.currentWeight)KG"
    }
    
    var goalWeight: String {
        
        return "\(user.futureGoal)KG"
    }
    
    var shouldHidePlaceHolderLabel: Bool {
        
        return user.futureGoal != nil
        
    }
    
    
    init(user: User, options: NewGoalUpdateOptions) {
        self.user = user
        self.options = options
        
        
        switch options {
            
        case .currentWeight:
            
            value = "\(user.currentWeight)"
            
        case .GoalWeight:
            
            value = "\(user.futureGoal)"
        }
        
    }
}
