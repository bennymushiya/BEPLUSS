//
//  ChallengeFilterOptions.swift
//  Weightloss
//
//  Created by benny mushiya on 23/06/2021.
//

import UIKit


enum ChallengeFilterOptions: Int, CaseIterable {
    
    case weightLoss
    //case quotes
    case weightGain
    
    
    var description: String {
        
        switch self {
        
        case .weightLoss: return "Physical Health Challenges"
            
        //case .quotes: return "Quotes"
            
        case .weightGain: return "Mental Health Challenges"
            
      
            
        }
    }
    
}
