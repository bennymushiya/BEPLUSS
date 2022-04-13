//
//  NotificationHeader.swift
//  Weightloss
//
//  Created by benny mushiya on 11/06/2021.
//

import UIKit


class NotificationHeader: UICollectionReusableView {
    
    //MARK: - PROPERITES
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Notifications"
        label.font = UIFont.systemFont(ofSize: 40, weight: .black)
        label.textColor = .white
        label.textAlignment = .left

        return label
    }()
    
    
    //MARK: - LIFEYCLE
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - HELPERS
    
    func configureUI() {
        
        backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        addSubview(descriptionLabel)
        descriptionLabel.anchor(top: topAnchor, left: leftAnchor, paddingTop: 15, paddingLeft: 20)
        
    }
    
    
    //MARK: - ACTION
    
    
   
    
}
