//
//  ProfileFilterOptions.swift
//  Weightloss
//
//  Created by benny mushiya on 30/04/2021.
//

import UIKit

enum ProfileFilterOptions: Int, CaseIterable {
            
    case weightLoss
    
    
    
    var description: Any {
        
        switch self {
        case .weightLoss: return "Posts"
            
        }
        
    }

}

struct ProfileFilterCellViewModel {
    
    let bottom: ProfileBottomView
    

    var text: String {
        
        return bottom.text
    }

    
    init(bottom: ProfileBottomView) {
        self.bottom = bottom
        
    }
    
    
}


