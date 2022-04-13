//
//  Labels.swift
//  Weightloss
//
//  Created by benny mushiya on 26/04/2021.
//


import UIKit



class AuthLabels: UILabel {
    
    
    init(title: String) {
        super.init(frame: .zero)
        
        
        text = title
        font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        textColor = .white
        textAlignment = .center
        numberOfLines = 0
        
        
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
}
