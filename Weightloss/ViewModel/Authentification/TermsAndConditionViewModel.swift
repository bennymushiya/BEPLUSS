//
//  TermsAndConditionViewModel.swift
//  Weightloss
//
//  Created by benny mushiya on 10/12/2021.
//

import UIKit


struct TermsAndConditionViewModel {
    
    
    let model: TermsAndCondModel
    
    
    var title: String {
        
        return model.titleLabel
    }
    
    var description: String {
        
        return model.descripionLabel
    }
    
    
    
    init(models: TermsAndCondModel) {
        self.model = models
        
    }
    
    
    
    
}
