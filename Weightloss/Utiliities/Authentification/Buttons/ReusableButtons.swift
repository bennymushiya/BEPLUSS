//
//  ReusableButtons.swift
//  Weightloss
//
//  Created by benny mushiya on 08/02/2022.
//

import UIKit

class ReusableButton: UIButton {
    
    
    init(title: String, type: ButtonType) {
        super.init(frame: .zero)
        
        setTitle(title, for: .normal)
        setTitleColor(.white, for: .normal)
        layer.cornerRadius = 10
        backgroundColor = .black
        setDimensions(height: 52, width: 52)
        isEnabled = false
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel?.textAlignment = .center


        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


