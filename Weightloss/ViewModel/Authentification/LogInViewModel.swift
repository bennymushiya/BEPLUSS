//
//  LogInViewModel.swift
//  Weightloss
//
//  Created by benny mushiya on 27/04/2021.
//

import UIKit


struct RegistrationViewModel {
    
    var name: String?
    var email: String?
    var password: String?
    var profileImage: UIImage?
    
    
    var profileImageIsFilled: Bool {
        
        return profileImage != nil
    }
    
    var formIsValid: Bool {
        
        return name?.isEmpty == false && email?.isEmpty == false && password?.isEmpty == false
        
    }
    
    var changeButtonColor: UIColor {
        
        return formIsValid && profileImageIsFilled ? .black : .red
        
    }
    
    var changeProfileImageColor: UIColor {
        
        return formIsValid && profileImageIsFilled ? .systemGroupedBackground : .red
    }
    
    var changeProfileImageText: String {
        
        return formIsValid && profileImageIsFilled ? "Upload Photo" : "upload Image"
    }
    
    var hideProfileButton: Bool {
        
        return formIsValid && profileImageIsFilled ? false : true
    }
    
    var changeTextSign: String {
        
        return formIsValid && profileImageIsFilled ? "Sign In" : "Fill in all the TextField"
        
    }
    
    var changeTextFont: UIFont {
        
        return formIsValid && profileImageIsFilled ? UIFont.systemFont(ofSize: 20, weight: .black) : UIFont.boldSystemFont(ofSize: 10)
        
    }
}


struct LogInViewModel {
    
    var email: String?
    var password: String?
    
    
    var formIsValid: Bool {
        
        return email?.isEmpty == false && password?.isEmpty == false
        
    }
    
    var changeButtonColor: UIColor {
        
        return formIsValid ? #colorLiteral(red: 0.1598605525, green: 0.9373220266, blue: 0.7734893539, alpha: 1) : UIColor.black
        
    }
    
    var changeButtonText: String {
        
        return formIsValid ? "LogIn" : "Fill Both TextFields"
    }
}


struct resetPasswordViewModel {
    
    var email: String?
    
    var formIsValid: Bool {
        
        return email?.isEmpty == false
    }
    
    var buttonBackgroundColor: UIColor {
        
        return formIsValid ? #colorLiteral(red: 0.1294117719, green: 0.2156862766, blue: 0.06666667014, alpha: 1) : #colorLiteral(red: 0.6148123741, green: 0.1017967239, blue: 0.1002308354, alpha: 1)
        
    }
}


