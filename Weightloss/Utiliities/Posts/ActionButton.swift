//
//  ActionButton.swift
//  Weightloss
//
//  Created by benny mushiya on 15/02/2022.
//

import UIKit



class ActionButton: UIButton {
    
    
    init(title: String, type: ButtonType, image: String) {
        super.init(frame: .zero)
        
        tintColor = .white
        setTitle(title, for: .normal)
        setTitleColor(.white, for: .normal)
        setImage(UIImage(systemName: image), for: .normal)
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 10)
        setDimensions(height: 46, width: 46)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
