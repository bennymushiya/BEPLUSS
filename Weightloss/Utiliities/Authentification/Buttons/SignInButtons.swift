//
//  SignInButtons.swift
//  Weightloss
//
//  Created by benny mushiya on 28/04/2021.
//

import UIKit



class SignInButtons: UIButton {
    
    
    
    init(image: UIImage?, type: ButtonType) {
        super.init(frame: .zero)
        
        
        setImage(image, for: .normal)
        setDimensions(height: 46, width: 46)
        
        
    }
    
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
