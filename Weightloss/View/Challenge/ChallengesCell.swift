//
//  ChallengesCell.swift
//  Weightloss
//
//  Created by benny mushiya on 18/06/2021.
//

import UIKit

class ChallengesCell: UICollectionViewCell {
    
    //MARK: - PROPERITES
    
    var viewModel: ChallengesViewModel? {
        didSet{configureViewModel()}
        
    }
    
    private let monthLabel: SmallFontLabel = {
        let label = SmallFontLabel(title: "")
        label.font = UIFont.systemFont(ofSize: 25, weight: .black)
        label.numberOfLines = 0
        label.textColor = .white
        
        return label
    }()
    
    private let descriptionLabel: SmallFontLabel = {
        let label = SmallFontLabel(title: "")
        label.font = UIFont.systemFont(ofSize: 20, weight: .black)
        label.numberOfLines = 0
        label.textAlignment = .center
        
        return label
    }()
    
    private let benefitLabel: SmallFontLabel = {
        let label = SmallFontLabel(title: "")
        label.font = UIFont.systemFont(ofSize: 16, weight: .black)
        label.numberOfLines = 0
        label.textAlignment = .center

        return label
    }()
    
    private let benefitsDescription: SmallFontLabel = {
        let label = SmallFontLabel(title: "")
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.numberOfLines = 0
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
        layer.cornerRadius = 20
        layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMinYCorner]
        layer.borderWidth = 2.0
        layer.borderColor = #colorLiteral(red: 0.1598605525, green: 0.9373220266, blue: 0.7734893539, alpha: 1)
        
        contentView.addSubview(monthLabel)
        monthLabel.centerX(inView: self)
        monthLabel.anchor(top: topAnchor, paddingTop: 10)
        
        let labelStack = UIStackView(arrangedSubviews: [descriptionLabel, benefitLabel, benefitsDescription])
        labelStack.axis = .vertical
        labelStack.spacing = 10
        
        contentView.addSubview(labelStack)
        labelStack.centerX(inView: self)
        labelStack.anchor(top: monthLabel.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 20, paddingLeft: 10, paddingRight: 10)

        
    }
    
    //MARK: - SELECTORS
    
 
    
    
    //MARK: - ACTION
    
    func configureViewModel() {
        
        guard let viewModels = viewModel else {return}
        
        monthLabel.text = viewModels.month
        descriptionLabel.text = viewModels.description
        benefitLabel.text = viewModels.benefits
        benefitsDescription.text = viewModels.benefitsDescription
        
    }
   
    
    
}



