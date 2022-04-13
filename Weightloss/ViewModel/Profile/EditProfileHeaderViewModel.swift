//
//  EditProfileHeaderViewModel.swift
//  Weightloss
//
//  Created by benny mushiya on 31/05/2021.
//

import UIKit


enum EditProfileCellSections: Int, CaseIterable {
    case name
    case fitnessGoals
    case backgroundImage
    
    var description: String {
        
        switch self {
        case .name: return "Name"
        case .fitnessGoals: return "fitnessGoals"
        case .backgroundImage: return "backgroundImage"
        
        }
    }
    
    
    
}

struct EditProfileCellViewModel {
    
    var user: User
    
    var fullname: String {
        
        return user.name
    }
    
    var profileImage: URL? {
        
        return URL(string: user.profileImage)
    }
    
    var backgroundImage: URL? {
        
        return URL(string: user.backgroundImage)
        
    }
 
    
    
    init(user: User) {
        self.user = user
        
    }
    
    
    
}
