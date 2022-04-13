//
//  UpdateGoalsViewModell.swift
//  Weightloss
//
//  Created by benny mushiya on 15/09/2021.
//

import UIKit


struct UpdateGoalsViewModel {
    
    let user: User
    let model: UpdateGoalModel
    
    var differenceBetweenGoals: Int {
        
        return user.currentWeight - user.futureGoal
    }
    
    var image: UIImage? {
        
        return model.image
        
    }
    
    var title: String {
        
        return model.title
    }
    
    
    init(user: User, model: UpdateGoalModel) {
        self.user = user
        self.model = model
        
    }
    
}
