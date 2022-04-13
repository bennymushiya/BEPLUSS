//
//  SearchViewModel.swift
//  Weightloss
//
//  Created by benny mushiya on 15/06/2021.
//

import UIKit


struct SearchViewModel {
    
    
    let user: User
    
    var username: String {
        
        return user.name
    }
    
    var profileImage: URL? {
        
        return URL(string: user.profileImage)
        
    }
    
    var fitnessGoals: String {
        
        return user.fitnessGoals
    }
    
    init(user: User) {
        self.user = user
    }
    
}
