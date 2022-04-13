//
//  TextPostLabel.swift
//  Weightloss
//
//  Created by benny mushiya on 09/06/2021.
//

import UIKit


class TextPostLabel: UILabel {
    
    
    override func layoutSubviews() {
            super.layoutSubviews()

            if bounds.size.width < intrinsicContentSize.width {
                frame = CGRect.zero
            }
        }
    
    init(title: String) {
        super.init(frame: .zero)
        
        font = UIFont.boldSystemFont(ofSize: 15)
        textColor = .white
        numberOfLines = 0
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
