//
//  ProfileButton.swift
//  Weightloss
//
//  Created by benny mushiya on 10/05/2021.
//

import UIKit



class ProfileButton: UIButton {
    
    
    init(title: String, type: ButtonType) {
        super.init(frame: .zero)
        
        
        backgroundColor = #colorLiteral(red: 0.1598605525, green: 0.9373220266, blue: 0.7734893539, alpha: 1)
        setTitle(title, for: .normal)
        setTitleColor(.white, for: .normal)
        layer.cornerRadius = 15
        setHeight(40)
        
        
        // Apply Gradient Color
            let gradientLayer:CAGradientLayer = CAGradientLayer()
            gradientLayer.frame.size = frame.size
            gradientLayer.colors =
                [UIColor.white.cgColor,UIColor.green.withAlphaComponent(1).cgColor]
            //Use diffrent colors
            layer.addSublayer(gradientLayer)
    
   }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
