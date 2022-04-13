//
//  BackButton.swift
//  Weightloss
//
//  Created by benny mushiya on 18/02/2022.
//

import UIKit


class BackButton: UIButton {
    
    
    init(image: String, type: ButtonType) {
        super.init(frame: .zero)
        
        setDimensions(height: 46, width: 46)
        tintColor = .white
        backgroundColor = #colorLiteral(red: 0.1598605525, green: 0.9373220266, blue: 0.7734893539, alpha: 1)
        layer.cornerRadius = 20
        isEnabled = true
        setImage(UIImage(systemName: image), for: .normal)
        
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
