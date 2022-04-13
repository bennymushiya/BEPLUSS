//
//  HomeFilterOptions.swift
//  Weightloss
//
//  Created by benny mushiya on 30/04/2021.
//

import UIKit

// caseIterable enables us to access all the cases inside the enum, like an array.
enum HomeFilterOptions: Int, CaseIterable {
    
    case weightLoss
    case weightGain
    
    
    var description: String {
        
        switch self {
        case .weightLoss: return "Followed Users"
        case .weightGain: return "Discoveries"
       
      
        }
    }
}
