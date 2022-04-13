//
//  SmallFontLabel.swift
//  Weightloss
//
//  Created by benny mushiya on 04/05/2021.
//

import UIKit



class SmallFontLabel: UILabel {
    
    
    override func layoutSubviews() {
            super.layoutSubviews()

            if bounds.size.width < intrinsicContentSize.width {
                frame = CGRect.zero
            }
        }
    
    init(title: String) {
        super.init(frame: .zero)
        
        
        text = title
        font = UIFont.systemFont(ofSize: 15, weight: .heavy)
        textColor = .white
        textAlignment = .center
        numberOfLines = 0
        textAlignment = .left
        
        
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
}
