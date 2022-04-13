//
//  OnboardingModel.swift
//  Weightloss
//
//  Created by benny mushiya on 26/04/2021.
//

import UIKit


struct OnboardingModel {
    
    var title: String
    var description: String
    var backgroundImage: UIImage?
    
    init(title: String, description: String, backgroundImage: UIImage?) {
        self.title = title
        self.description = description
        self.backgroundImage = backgroundImage
        
        
    }
}
