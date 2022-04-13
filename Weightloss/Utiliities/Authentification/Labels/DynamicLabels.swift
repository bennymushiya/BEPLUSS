//
//  DynamicLabels.swift
//  Weightloss
//
//  Created by benny mushiya on 07/02/2022.
//

import UIKit


class DynamicLabels: UILabel {
    
    
    init(title: String) {
        super.init(frame: .zero)
        
        text = title
        textColor = .white
        font = .systemFont(ofSize: 15, weight: .black)
        numberOfLines = 0
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
