//
//  ChallengesModel.swift
//  Weightloss
//
//  Created by benny mushiya on 19/06/2021.
//

import UIKit


struct ChallengesModel {
    
    let month: String
    let description: String
    let benefits: String
    let benefitsDescription: String
    
    
    init(month: String, description: String, benefits: String, benefitsDescription: String) {
        self.month = month
        self.description = description
        self.benefits = benefits
        self.benefitsDescription = benefitsDescription
    }
    
}
