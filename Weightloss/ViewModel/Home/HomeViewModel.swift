//
//  HomeViewModel.swift
//  Weightloss
//
//  Created by benny mushiya on 04/05/2021.
//

import UIKit

struct HomeHeaderViewModel {
    
    let user: User
    
  
    var name: String {
        
        return user.name
        
    }
    
    var profileImage: URL? {
        
        return URL(string: user.profileImage)
    }
    
   

    
    init(user: User) {
        self.user = user
        
    }
    
}
