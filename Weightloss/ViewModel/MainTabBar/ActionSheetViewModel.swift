//
//  ActionSheetViewModel.swift
//  Weightloss
//
//  Created by benny mushiya on 15/05/2021.
//

import UIKit


struct ActionSheetViewModel {
    
    let actionSheet: ActionSheetModel
    
    var image: UIImage? {
        
        return actionSheet.image
    }
    
    var descriptionLabel: String {
        
        return actionSheet.description
    }
    
    
    init(actionSheet: ActionSheetModel) {
        self.actionSheet = actionSheet
        
    }
}
