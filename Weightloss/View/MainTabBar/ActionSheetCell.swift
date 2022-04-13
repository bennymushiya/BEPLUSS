//
//  ActionSheetCell.swift
//  Weightloss
//
//  Created by benny mushiya on 15/05/2021.
//

import UIKit

class ActionSheetCell: UITableViewCell {
    
    //MARK: - PROPERTIES
    
    
    var viewModel: ActionSheetViewModel? {
        didSet{configureViewModel()}
        
    }
    
    private let optionsImageView: UIButton = {
        let iv = UIButton(type: .system)
        iv.setDimensions(height: 56, width: 56)
        iv.tintColor = .black
        iv.backgroundColor = .white
        iv.layer.cornerRadius = 56 / 2
        
        return iv
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 20, weight: .black)
        label.textColor = .white
        
        return label
    }()
    
    //MARK: - LIFECYCLE
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - HELPERS

    func configureUI() {
        
        backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        addSubview(optionsImageView)
        optionsImageView.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 20)
        
        addSubview(descriptionLabel)
        descriptionLabel.centerY(inView: self)
        descriptionLabel.anchor(left: optionsImageView.rightAnchor, right: rightAnchor, paddingLeft: 20, paddingRight: 10)
        
    }
    
    
    //MARK: - ACTION

    func configureViewModel() {
        
        guard let viewModels = viewModel else {return}
        
        optionsImageView.setImage(viewModels.image, for: .normal) 
        descriptionLabel.text = viewModels.descriptionLabel
        
        
    }
}
