//
//  InputDetails.swift
//  Weightloss
//
//  Created by benny mushiya on 27/04/2021.
//

import UIKit


struct InputDetails {
    
    
    static var shared = InputDetails()
    
    var name: String  = ""
    var email: String = ""
    var password: String = ""
    var chosenCommunity: String = ""
    var currentWeight: Int = 0
    var futureGoalWeight: Int = 0
    var profileImage: UIImage?
    var fitnessGoals: String = ""
    var pushID: String = ""

    
    
    
}
