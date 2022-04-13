//
//  GoalsButton.swift
//  Weightloss
//
//  Created by benny mushiya on 23/08/2021.
//

import UIKit


class GoalsButton: UIButton {
    
    
    init(title: String, type: ButtonType) {
        super.init(frame: .zero)
        
        backgroundColor = .white
        layer.cornerRadius = 120 / 2
        setDimensions(height: 120, width: 120)
        layer.borderWidth = 5
        layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        setTitle(title, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 35, weight: .black)
        setTitleColor(.black, for: .normal)
        isEnabled = false
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
