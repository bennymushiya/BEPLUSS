//
//  SearchCell.swift
//  Weightloss
//
//  Created by benny mushiya on 14/06/2021.
//

import UIKit
import SDWebImage

class SearchCell: UITableViewCell {
    
    
    //MARK: - PROPERTIES
    
    var viewModel: SearchViewModel? {
        didSet{configureViewModel()}
        
    }
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        iv.setDimensions(height: 58, width: 58)
        iv.layer.cornerRadius = 20
        
        return iv
    }()
    
    private let usernameLabel: SmallFontLabel = {
        let label = SmallFontLabel(title: "")
        
        return label
    }()
    
    private let fitnessGoalLabel: SmallFontLabel = {
        let label = SmallFontLabel(title: "")
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.numberOfLines = 1
        
        return label
    }()
    
    
    
    //MARK: - LIFEYCLE
    
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
        
        addSubview(profileImageView)
        profileImageView.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 12)
        
        let stack = UIStackView(arrangedSubviews: [usernameLabel, fitnessGoalLabel])
        stack.axis = .vertical
        stack.spacing = 4
        stack.alignment = .leading
        
        addSubview(stack)
        stack.centerY(inView: profileImageView, leftAnchor: profileImageView.rightAnchor,
                      paddingLeft: 8)
    }
    
    //MARK: - ACTION
    
    func configureViewModel() {
        
        guard let viewModels = viewModel else {return}
        
        profileImageView.sd_setImage(with: viewModels.profileImage)
        usernameLabel.text = viewModels.username
        fitnessGoalLabel.text = viewModels.fitnessGoals
        
        
    }
    
}
