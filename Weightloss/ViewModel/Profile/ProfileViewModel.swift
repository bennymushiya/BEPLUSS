//
//  ProfileViewModel.swift
//  Weightloss
//
//  Created by benny mushiya on 04/05/2021.
//

import UIKit


struct ProfileHeaderViewModel {
    
    let user: User
    
    var fullname: String {
        
        return user.name
        
    }
    
    var profileImage: URL? {
        
        return URL(string: user.profileImage)
    }
    
    var backgroundImage: URL? {
        
        return URL(string: user.backgroundImage)
    }
    
    var fitnessGoals: String {
        
        return user.fitnessGoals
        
    }
    
    var numberOfPostsLabel: NSAttributedString {
        
        
        return attributedTextll(label: "Weight loss", value: user.stats.posts)
        
    }
    
    
    var numberOfProgressLabel: NSAttributedString {
        
        return attributedTextll(label: "Muscle gain", value: user.weightGainStats.posts)
        
    }
    
    var hideWeightLossLabel: Bool {
        
        return user.chosenCommunity == "weightGainCommunity"
    }
    
    var hideMuscleGainLabel: Bool {
        
        return user.chosenCommunity == "WeightLossCommunity"
        
    }
    
//    var followButtonEdited: String {
//        
//        return user.isCurrentUser ? "Progress" : "Follow"
//        
//    }
    
    var messageButtonEdit: String {
        
        return user.isCurrentUser ? "Edit" : "Message"
    }
    
    init(user: User) {
        self.user = user
        
    }
    
    
    func attributedTextll(label: String, value: Int) -> NSAttributedString {
        
        let attributedText = NSMutableAttributedString(string: "\(value)\n", attributes: [.font: UIFont.systemFont(ofSize: 14, weight: .black)])
        
        attributedText.append(NSAttributedString(string: "\(label)", attributes: [.font: UIFont.systemFont(ofSize: 14, weight: .bold), .foregroundColor: UIColor.darkGray]))
        
        return attributedText
        
    }

    func size(forWidth width: CGFloat) -> CGSize {
        let measurementLabel = UILabel()
        measurementLabel.text = user.fitnessGoals
        measurementLabel.numberOfLines = 0
        measurementLabel.lineBreakMode = .byWordWrapping
        measurementLabel.translatesAutoresizingMaskIntoConstraints = false
        measurementLabel.widthAnchor.constraint(equalToConstant: width).isActive = true
        
        return measurementLabel.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }
}
