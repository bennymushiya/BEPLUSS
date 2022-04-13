//
//  NewGoalsHeader.swift
//  Weightloss
//
//  Created by benny mushiya on 19/10/2021.
//

import UIKit


class NewGoalsHeader: UIView {
    
    
    //MARK: - PROPERTIES

    
    private let descriptionLabel: SmallFontLabel = {
        let label = SmallFontLabel(title: "Edit Weight Goals")
        label.font = UIFont.systemFont(ofSize: 30, weight: .black)
        label.textAlignment = .left

        return label
    }()
    

    //MARK: - LIFECYCLE
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    //MARK: - HELPERS
    
    func configureUI() {
        
        backgroundColor = .white
        
        addSubview(descriptionLabel)
        descriptionLabel.anchor(top: topAnchor, left: leftAnchor, paddingTop: 5, paddingLeft: 10)
        
    }
    
    
    //MARK: - ACTION
    
   
    
}


