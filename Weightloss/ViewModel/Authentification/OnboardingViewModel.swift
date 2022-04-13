//
//  OnboardingViewModel.swift
//  Weightloss
//
//  Created by benny mushiya on 16/11/2021.
//

import Foundation
import paper_onboarding



struct OnboardingViewModel {
    
    private let itemCount: Int
    
    
    init(itemCount: Int) {
        self.itemCount = itemCount
    }
    
    
    func shouldShowGetStartedButtons(forIndex index: Int) -> Bool {
        
        return index == itemCount - 1 ? true : false
    }
}

