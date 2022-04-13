//
//  UpdateGoalHeader.swift
//  Weightloss
//
//  Created by benny mushiya on 23/08/2021.
//

import UIKit

protocol UpdateGoalHeaderDelegate: class {
    
    func updateCurrentGoal()
    
}

class UpdateGoalHeader: UIView {
    
    
    //MARK: - PROPERTIES
    
    weak var delegate: UpdateGoalHeaderDelegate?
    
    private var user: User

    private var topLabel: SmallFontLabel = {
        let label = SmallFontLabel(title: "Progress")
        label.font = UIFont.systemFont(ofSize: 30, weight: .black)
        label.textColor = .white
        label.textAlignment = .left
        
        return label
    }()

    private let leftSideLabel: SmallFontLabel = {
        let label = SmallFontLabel(title: "")
        label.font = UIFont.systemFont(ofSize: 35, weight: .black)
        label.textColor = #colorLiteral(red: 0.1598605525, green: 0.9373220266, blue: 0.7734893539, alpha: 1)
        label.textAlignment = .left
        
        return label
    }()
    
    private let rightSideLabel: SmallFontLabel = {
        let label = SmallFontLabel(title: "")
        label.font = UIFont.systemFont(ofSize: 35, weight: .black)
        label.textColor = #colorLiteral(red: 0.1598605525, green: 0.9373220266, blue: 0.7734893539, alpha: 1)
        label.textAlignment = .left
        
        return label
    }()
    
    private let bottomLeftLabel: SmallFontLabel = {
        let label = SmallFontLabel(title: "Current Weight")
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16, weight: .black)
        
        return label
    }()
    
    private let bottomRightLabel: SmallFontLabel = {
        let label = SmallFontLabel(title: "goal weight")
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 16, weight: .black)

        
        return label
    }()
    
    private let middleLineView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.1598605525, green: 0.9373220266, blue: 0.7734893539, alpha: 1)
        
        return view
    }()
    
    private let underLineView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.1598605525, green: 0.9373220266, blue: 0.7734893539, alpha: 1)
        
        return view
    }()
    
    
    //MARK: - LIFEYCLE
    
    init(user: User) {
        self.user = user
        super.init(frame: .zero)
        
        configureUI()
        populateUserData()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - HELPERS
    
    func configureUI() {
        
        backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        addSubview(topLabel)
        topLabel.anchor(top: topAnchor, left: leftAnchor, paddingTop: 10, paddingLeft: 10)
        
        let labelStack = UIStackView(arrangedSubviews: [leftSideLabel, bottomLeftLabel])
        labelStack.axis = .vertical
        labelStack.spacing = 5
        
        addSubview(labelStack)
        labelStack.anchor(top: topLabel.bottomAnchor, left: leftAnchor, paddingTop: 40, paddingLeft: 30)
     
        let rightLabelStack = UIStackView(arrangedSubviews: [rightSideLabel, bottomRightLabel])
        rightLabelStack.axis = .vertical
        rightLabelStack.spacing = 5
        
        addSubview(rightLabelStack)
        rightLabelStack.anchor(top: topLabel.bottomAnchor, right: rightAnchor, paddingTop: 40, paddingRight: 30)
        
        addSubview(middleLineView)
        middleLineView.centerX(inView: self)
        middleLineView.setDimensions(height: 2, width: 2)
        middleLineView.anchor(top: topAnchor, bottom: bottomAnchor, paddingTop: 70, paddingBottom: 20)
        
        addSubview(underLineView)
        underLineView.setDimensions(height: 2, width: 2)
        underLineView.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
        
    }
    
    //MARK: - ACTION
    
    func populateUserData() {
            
        leftSideLabel.text = "\(user.currentWeight)KG"
        rightSideLabel.text = "\(user.futureGoal)KG"
        
    }
    
    //MARK: - SELECTORS

    @objc func handleUpdateGoal() {
        
        delegate?.updateCurrentGoal()
        
    }
}


