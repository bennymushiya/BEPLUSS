//
//  ChatButton.swift
//  Weightloss
//
//  Created by benny mushiya on 09/06/2021.
//

import UIKit


class ChatButtonEx: UIButton {
    
    
    
    init(type: ButtonType, title: String) {
        super.init(frame: .zero)
        
        backgroundColor = .white
        tintColor = .black
        setImage(UIImage(systemName: "exclamationmark.bubble"), for: .normal)
        setDimensions(height: 30, width: 70)
        setTitle(title, for: .normal)
        setTitleColor(.black, for: .normal)
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 10)
        layer.cornerRadius = 10
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
