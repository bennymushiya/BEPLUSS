//
//  EditProfileOptions.swift
//  Weightloss
//
//  Created by benny mushiya on 03/06/2021.
//

import UIKit


enum EditProfileOptions: Int, CaseIterable {
    
    case name
    case fitnessGoals
    
    
    var description: String {
        
        switch self {
        case .name: return "Name:"
        case .fitnessGoals: return "Fitness Goals:"
            
        }
    }
}


struct EditProfileViewModel {
    
    private var user: User
    var options: EditProfileOptions
    var value: String?
    
    
    var titleText: String {
        
        return options.description
    }
    
    var optionValue: String {
        
        switch options {
        case .name: return user.name
        case .fitnessGoals: return user.fitnessGoals
            
        }
        
    }
    
    var shouldHideTextField: Bool {
        
        return options != .name
    }
    
    
    var shouldHideTextView: Bool {
        
        return options != .fitnessGoals
    }
    
    
    
    var shouldHidePlaceHolderLabel: Bool {
        
        return user.fitnessGoals != nil
    }
    
    var placeHolderText: String {
        
        return "enter \(options.description)"
        
    }
    
    init(user: User, options: EditProfileOptions) {
        self.user = user
        self.options = options
        
    
        
        switch options {
            
        case .name:
            value = user.name
            
        case .fitnessGoals:
            value = user.fitnessGoals
            
        }
        
    }
    
}





