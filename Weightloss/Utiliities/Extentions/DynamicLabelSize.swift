//
//  DynamicLabelSize.swift
//  Weightloss
//
//  Created by benny mushiya on 28/10/2021.
//

import UIKit


class DynamicLabelSize: UIViewController {
    
    
    static func height(text: String?, width: CGFloat) -> CGFloat {

        var currentHeight: CGFloat

        let label = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.text = text
        label.numberOfLines = 0
        label.sizeToFit()
        label.lineBreakMode = .byWordWrapping

        currentHeight = label.frame.height
        label.removeFromSuperview()

        return currentHeight

    }
    
 
    
    
    
}
