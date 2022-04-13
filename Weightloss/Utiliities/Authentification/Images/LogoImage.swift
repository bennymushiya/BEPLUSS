//
//  LogoImage.swift
//  Weightloss
//
//  Created by benny mushiya on 18/02/2022.
//

import UIKit


class LogoImage: UIImageView {
    
    
    init(image: String) {
        super.init(frame: .zero)
        
        contentMode = .scaleAspectFit
        self.image = UIImage(named: image)
        setDimensions(height: 200, width: 200)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
