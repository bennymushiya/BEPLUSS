//
//  EmailConfirmation.swift
//  Weightloss
//
//  Created by benny mushiya on 09/06/2021.
//

import Foundation


struct EmailConfirmation {
    
    
    /// makes sure the email is a valid email, that already exists and not just a random email.
    
   static func validateEmail(enteredEmail:String) -> Bool {

        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: enteredEmail)

    }
    
}

