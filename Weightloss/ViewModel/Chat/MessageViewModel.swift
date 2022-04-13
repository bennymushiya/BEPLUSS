//
//  MessageViewModel.swift
//  Weightloss
//
//  Created by benny mushiya on 25/05/2021.
//

import UIKit


struct MessageViewModel {
    
    var message: Messages
    
    
    var messageText: String {
        
        return message.text
    }
    
    
    var fromID: String {
        
        return message.fromID
    }
    
    
    var toID: String {
        
        return message.toID
        
    }
    
    
    var messageBackgroundColor: UIColor {
        
        return message.isFromCurrentUser ? #colorLiteral(red: 0.1598605525, green: 0.9373220266, blue: 0.7734893539, alpha: 1) : .systemPink
        
    }
    
    var messageTextColor: UIColor {
        
        return message.isFromCurrentUser ? .black : .black
    }
    
    
    // if isFromCurrentUser return false then this computted property returns true. becasue we have negated isFromCurrentUser so it returns false with the exclamation mark at the begining.
    var leftAnchorActive: Bool {
        
        return message.isFromCurrentUser
        
    }
    
    
    // if isFromCurrentUser return true then this computted property returns true. 
    var rightAnchorActive: Bool {
        
        return message.isFromCurrentUser
        
    }
    
    
    var timeStamp: String? {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.unitsStyle = .full
        formatter.maximumUnitCount = 1
        return formatter.string(from: message.timeStamp.dateValue(), to: Date())
        
    }
    
    
    init(message: Messages) {
        self.message = message
        
    }
    
    func size(forWidth width: CGFloat) -> CGSize {
        let measurementLabel = UILabel()
        measurementLabel.text = message.text
        measurementLabel.lineBreakMode = .byWordWrapping
        measurementLabel.numberOfLines = 0
        measurementLabel.translatesAutoresizingMaskIntoConstraints = false
        measurementLabel.widthAnchor.constraint(equalToConstant: width).isActive = true
        
        return measurementLabel.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        
    }
    
}
