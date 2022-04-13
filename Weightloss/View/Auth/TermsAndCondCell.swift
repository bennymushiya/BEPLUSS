//
//  TermsAndCondCell.swift
//  Weightloss
//
//  Created by benny mushiya on 10/12/2021.
//

import UIKit


class TermsAndCondCell: UICollectionViewCell {
    
    //MARK: - PROPERTIES
    
    
    var viewModel: TermsAndConditionViewModel? {
        didSet{configureViewModel()}
        
        
    }
    
    private let titleLabel: AuthLabels = {
        let label = AuthLabels(title: "")
        label.font = UIFont.systemFont(ofSize: 35, weight: .heavy)
        label.textAlignment = .center
        label.textColor = .black
        
        return label
    }()
    
    private let descriptionLabel: AuthLabels = {
        let label = AuthLabels(title: "")
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.textAlignment = .center
        label.textColor = .black
        
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
        
        let stack = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel])
        stack.axis = .vertical
        stack.spacing = 10
        
        addSubview(stack)
        stack.centerX(inView: self)
        stack.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 20, paddingLeft: 10, paddingRight: 10 )
        
    }
    
    //MARK: - ACTION
    
    func configureViewModel() {
        
        guard let viewModels = viewModel else {return}
        
        titleLabel.text = viewModels.title
        descriptionLabel.text = viewModels.description
        
        
    }
    
}
