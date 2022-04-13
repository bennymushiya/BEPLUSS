//
//  CustomTextFields.swift
//  Weightloss
//
//  Created by benny mushiya on 26/04/2021.
//

import UIKit


class CustomTextField: UITextField {
    
    
    init(placeHolder: String) {
    super.init(frame: .zero)
        
        
        let spacer = UIView()
        spacer.setDimensions(height: 12, width: 40)
        leftView = spacer
        leftViewMode = .always
        
        textColor = .white
        keyboardAppearance = .dark
        font = UIFont.systemFont(ofSize: 15, weight: .bold)
        setHeight(60)
        layer.cornerRadius = 20
        backgroundColor = #colorLiteral(red: 0.1019607843, green: 0.1019607843, blue: 0.1019607843, alpha: 0.5)
        attributedPlaceholder = NSAttributedString(string: placeHolder, attributes: [.foregroundColor: UIColor.white])
        
        
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}

