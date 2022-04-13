//
//  ChooseCommunityButton.swift
//  Weightloss
//
//  Created by benny mushiya on 02/05/2021.
//

import UIKit

class ChooseCommunityButton: UIButton {
    
    
    
    init(image: UIImage?, type: ButtonType, title: String) {
        super.init(frame: .zero)
        
        setImage(image, for: .normal)
        setTitle(title, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 30, weight: .black)
        setTitleColor(.white, for: .normal)
        tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        backgroundColor = #colorLiteral(red: 0.1598605525, green: 0.9373220266, blue: 0.7734893539, alpha: 1)
        layer.cornerRadius = 20
        imageView?.setDimensions(height: 50, width: 50)
        
        setDimensions(height: 100, width: 350)
      
        
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
