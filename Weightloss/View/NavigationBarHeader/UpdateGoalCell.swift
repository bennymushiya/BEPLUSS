//
//  UpdateGoalCell.swift
//  Weightloss
//
//  Created by benny mushiya on 23/08/2021.
//

import UIKit

class UpdateGoalCell: UITableViewCell {
    
    //MARK: - PROPERTIES
    
     let titleLabel: SmallFontLabel = {
        let label = SmallFontLabel(title: "Until Your Reach Your Goal")
        label.font = UIFont.systemFont(ofSize: 20, weight: .black)
        label.textColor = .white
        
        return label
    }()
    
    
     let currentGoalButton: GoalsButton = {
        let button = GoalsButton(title: "", type: .system)
        button.setTitleColor(#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1), for: .normal)
        button.layer.borderWidth = 2.0
        button.layer.borderColor = #colorLiteral(red: 0.1598605525, green: 0.9373220266, blue: 0.7734893539, alpha: 1)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.setDimensions(height: 66, width: 66)
        button.layer.cornerRadius = 66 / 2
        button.tintColor = .black
        button.titleLabel?.tintColor = .black
        
        return button
    }()
    
    //MARK: - LIFEYCLE
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
        layoutMargins = UIEdgeInsets(top: 20, left: 10, bottom: 0, right: 10)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - HELPERS
    
    
    func configureUI() {
        
        backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        layer.cornerRadius = 20
        layer.borderWidth = 4.0
        layer.borderColor = #colorLiteral(red: 0.1598605525, green: 0.9373220266, blue: 0.7734893539, alpha: 1)
        

        
        let stack = UIStackView(arrangedSubviews: [currentGoalButton, titleLabel])
        stack.axis = .horizontal
        stack.spacing = 10
        
        addSubview(stack)
        stack.centerY(inView: self)
        stack.anchor(left: leftAnchor, right: rightAnchor, paddingLeft: 20, paddingRight: 10)
       
        
    }
    
    //MARK: - ACTION
    
    
}
