//
//  AlertMessages.swift
//  Weightloss
//
//  Created by benny mushiya on 04/05/2021.
//

import UIKit


class AlertMessage: UILabel {
    
    
    init(title: String) {
        super.init(frame: .zero)
        
        text = title
        font = UIFont.systemFont(ofSize: 15, weight: .bold)
        textColor = .red
        alpha = 0
        
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
}

