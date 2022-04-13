//
//  ActionSheetModel.swift
//  Weightloss
//
//  Created by benny mushiya on 15/05/2021.
//

import UIKit


struct ActionSheetModel {
    
    let image: UIImage?
    let description: String
    
    
    init(image: UIImage?, description: String) {
        self.image = image
        self.description = description
        
    }
}
