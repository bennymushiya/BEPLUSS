//
//  AuthButton.swift
//  Weightloss
//
//  Created by benny mushiya on 26/04/2021.
//

import UIKit

class AuthButton: UIButton {
    
    
    init(title: String, type: ButtonType) {
        super.init(frame: .zero)
        
        setTitle(title, for: .normal)
        setTitleColor(.white, for: .normal)
        layer.cornerRadius = 10
        backgroundColor = .black
        setHeight(50)
        isEnabled = false
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

