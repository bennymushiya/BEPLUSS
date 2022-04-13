//
//  TextButton.swift
//  Weightloss
//
//  Created by benny mushiya on 26/04/2021.
//

import UIKit



class TextButton: UIButton {
    
    
    init(text: String, type: ButtonType) {
        super.init(frame: .zero)
        
        
        setTitle(text, for: .normal)
        setTitleColor(.black, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}

