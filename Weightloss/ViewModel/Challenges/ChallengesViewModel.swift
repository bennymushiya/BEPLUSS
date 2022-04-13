//
//  ChallengesViewModel.swift
//  Weightloss
//
//  Created by benny mushiya on 21/06/2021.
//

import UIKit


struct ChallengesViewModel {
    
    let challenges: ChallengesModel
    
    var month: String {
        
        return challenges.month
    }
    
    var description: String {
        
        return challenges.description
    }
    
    var benefits: String {
        
        return challenges.benefits
    }
    
    var benefitsDescription: String {
        
        return challenges.benefitsDescription
        
    }
    
    
    init(challenges: ChallengesModel) {
        self.challenges = challenges
        
    }
    
    func size(forWidth width: CGFloat) -> CGSize {
        let measurementLabel = UILabel()
        measurementLabel.text = challenges.benefits
        measurementLabel.numberOfLines = 0
        measurementLabel.lineBreakMode = .byWordWrapping
        measurementLabel.translatesAutoresizingMaskIntoConstraints = false
        measurementLabel.widthAnchor.constraint(equalToConstant: width).isActive = true
        
        return measurementLabel.systemLayoutSizeFitting(UICollectionViewCell.layoutFittingCompressedSize)
        
    }
}
