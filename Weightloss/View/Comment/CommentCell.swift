//
//  CommentCell.swift
//  Weightloss
//
//  Created by benny mushiya on 10/05/2021.
//

import UIKit
import SDWebImage


class CommentsCell: UICollectionViewCell  {
    
    
    //MARK: - PROPERTIES
    
    var viewModel: CommentsViewModel? {
        didSet{configureViewModel()}
        
    }
    
    private lazy var profileImage: UIImageView = {
        let iv = UIImageView()
        iv.layer.cornerRadius = 20
        iv.clipsToBounds = true
        iv.setDimensions(height: 56, width: 56)
        iv.backgroundColor = .blue
        iv.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleShowProfile))
        
        iv.addGestureRecognizer(tapGesture)
        
        return iv
    }()
    
    private let nameLabel: SmallFontLabel = {
        let label = SmallFontLabel(title: "")
        
        return label
    }()
    
    private let commentText: SmallFontLabel = {
        let label = SmallFontLabel(title: "")
        label.numberOfLines = 0
        
        return label
    }()
    
    private let underLineView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.1598605525, green: 0.9373220266, blue: 0.7734893539, alpha: 1)
        
        return view
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
        
        backgroundColor = #colorLiteral(red: 0.1019607843, green: 0.1019607843, blue: 0.1019607843, alpha: 0.5)
        addSubview(profileImage)
        profileImage.anchor(top: topAnchor, left: leftAnchor, paddingTop: 10, paddingLeft: 10)
        
        let labelStack = UIStackView(arrangedSubviews: [nameLabel, commentText])
        labelStack.axis = .vertical
        labelStack.spacing = 5
        
        addSubview(labelStack)
        labelStack.anchor(top: topAnchor, left: profileImage.rightAnchor, right: rightAnchor, paddingTop: 15, paddingLeft: 10, paddingRight: 10)
        
        addSubview(underLineView)
        underLineView.anchor(left: leftAnchor, bottom: bottomAnchor, width: frame.width, height: 2)
    }
    
    
    //MARK: - ACTION

    @objc func handleShowProfile() {
        
        
        
    }
    
    func configureViewModel() {
        
        guard let viewModels = viewModel else {return}
        
        profileImage.sd_setImage(with: viewModels.profileImage)
        nameLabel.text = viewModels.name
        commentText.text = viewModels.commentText
        
        
    }
    
}

