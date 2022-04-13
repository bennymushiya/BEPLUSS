//
//  PasswordStrength.swift
//  Weightloss
//
//  Created by benny mushiya on 09/06/2021.
//

import UIKit


struct PasswordStrength {
    
    
    static func containsUpperCase(_ password: String) -> Bool {
        let regex = NSPredicate(format:"SELF MATCHES %@", "^(?=.*[A-Z]).*$")
        return regex.evaluate(with: password)
    }
    
    static func containsLowerCase(_ password: String) -> Bool {
        let regex = NSPredicate(format:"SELF MATCHES %@", "^(?=.*[a-z]).*$")
        return regex.evaluate(with: password)
    }
    
    static func containsNumber(_ password: String) -> Bool {
        let regex = NSPredicate(format:"SELF MATCHES %@", "^(?=.*[0-9]).*$")
        return regex.evaluate(with: password)
    }
    
    static func containsSymbol(_ password: String) -> Bool {
        let regex = NSPredicate(format:"SELF MATCHES %@", ".*[^A-Za-z0-9].*")
        return regex.evaluate(with: password)
        
    }
    
    static func showErrrorIfPasswordDontMatch(passwordText: String, message: Any) {
        
        switch PasswordStrength.containsNumber(passwordText) || PasswordStrength.containsLowerCase(passwordText) || PasswordStrength.containsSymbol(passwordText) || PasswordStrength.containsUpperCase(passwordText){
        case true:
            print("got it right")
        case false:
            message
        }
        
       
        
    }
    
   static func validatingPassword(passwordText: String, message: UILabel, message2: UILabel, message3: UILabel, message4: UILabel) {
        
        switch PasswordStrength.containsNumber(passwordText)  {
        case true:
            message.textColor = .green
        case false:
            message.textColor = .red
           
        }
        
        switch PasswordStrength.containsUpperCase(passwordText) {
        case true:
            message2.textColor = .green
        case false:
            message2.textColor = .red
        
        }
        
        switch PasswordStrength.containsLowerCase(passwordText) {
        case true:
            message3.textColor = .green
        case false:
            message3.textColor = .red
        }
        
        switch PasswordStrength.containsSymbol(passwordText) {
        case true:
            message4.textColor = .green
        case false:
            message4.textColor = .red
        }
        
}
    
    
    
}

