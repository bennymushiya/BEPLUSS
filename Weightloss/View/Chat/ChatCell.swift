//
//  ChatCell.swift
//  Weightloss
//
//  Created by benny mushiya on 30/04/2021.
//

import UIKit
import SDWebImage


class ChatCell: UITableViewCell {
    
    //MARK: - PROPERTIES
    
    var viewModel: ConversationViewModel? {
        didSet{configureViewModel()}
    
    }
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleToFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 20
        iv.backgroundColor = .lightGray
        
        return iv
    }()
    
    
    private let timestampLabel: SmallFontLabel = {
        let ts = SmallFontLabel(title: "")
        ts.font = UIFont.systemFont(ofSize: 12)
        
        return ts
        
    }()
    
    private let usernameLabel: SmallFontLabel = {
        let label = SmallFontLabel(title: "")
        label.font = UIFont.systemFont(ofSize: 16, weight: .black)
        
        return label
    }()
    
    private let messageTextLabel: SmallFontLabel = {
        let label = SmallFontLabel(title: "")
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 2
        
        return label
    }()
    
  
    //MARK: - LIFEYCYCLE
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
           
           configureUI()
        
       }
    
    //MARK: - HELPERS
    
    func configureUI() {
        
        backgroundColor = #colorLiteral(red: 0.1019607843, green: 0.1019607843, blue: 0.1019607843, alpha: 0.5)
        
        addSubview(profileImageView)
        profileImageView.anchor(left: leftAnchor, paddingLeft: 13)
        profileImageView.setDimensions(height: 70, width: 70)
        profileImageView.centerY(inView: self)
        
        let stack = UIStackView(arrangedSubviews: [usernameLabel, messageTextLabel])
        stack.axis = .vertical
        stack.spacing = 4
        
        addSubview(stack)
        stack.centerY(inView: profileImageView)
        stack.anchor(left: profileImageView.rightAnchor, right: rightAnchor, paddingLeft: 20, paddingRight: 16)
        
        addSubview(timestampLabel)
        timestampLabel.anchor(top: topAnchor, right: rightAnchor, paddingTop: 20, paddingRight: 12)
       
    }
    
    
    //MARK: - ACTION
    
    func configureViewModel() {
        
        guard let viewModels = viewModel else {return}
        
        profileImageView.sd_setImage(with: viewModels.profileImage)
        usernameLabel.text = viewModels.username
        timestampLabel.text = viewModels.timeStamp
        messageTextLabel.text = viewModels.message
        
        
    }
   
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
}
    
    
    


    
    
    


