//
//  ProfileCell.swift
//  Weightloss
//
//  Created by benny mushiya on 30/04/2021.
//

import UIKit
import SDWebImage

protocol ProfileCellDelegate: class {
    
    func cell(_ cell: ProfileCell, didRelateTo  post: TextPost)
    func cell(_ cell: ProfileCell, wantsToReplyTo post: TextPost)
    func cell(_ cell: ProfileCell)
    func cell(_ cell: ProfileCell, didLike post: TextPost)
    func cell(_ cell: ProfileCell, wantsToGetCommentCountFor post: TextPost)

}


class ProfileCell: UICollectionViewCell {
    
    //MARK: - PROPERTIES
    
    var viewModel: TextPostViewModel? {
        didSet{configureViewModel()}
        
    }
    
    weak var delegate: ProfileCellDelegate?
    
    private let profileImage: UIImageView = {
        let iv = UIImageView()
        iv.layer.cornerRadius = 56 / 2
        iv.clipsToBounds = true
        iv.setDimensions(height: 56, width: 56)
        iv.backgroundColor = .blue
        
        return iv
    }()
    
    private let nameLabel: SmallFontLabel = {
        let label = SmallFontLabel(title: "")
        
        return label
    }()
    
    private let timePostLabel: SmallFontLabel = {
        let label = SmallFontLabel(title: "")
        label.font = UIFont.boldSystemFont(ofSize: 10)
        
        return label
    }()
    
    private let joinButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .blue
        button.tintColor = .white
        button.setImage(UIImage(systemName: "plus.square.fill.on.square.fill"), for: .normal)
        button.setDimensions(height: 30, width: 70)
        button.setTitle(" Join", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 10)
        button.layer.cornerRadius = 10
        
        return button
    }()
    
    private let postText: TextPostLabel = {
        let label = TextPostLabel(title: "")
        
        return label
    }()
    
    lazy var relateButton: ActionButton = {
        let button = ActionButton(title: "", type: .system, image: "circles.hexagongrid")
      
      
        button.addTarget(self, action: #selector(handleRelate), for: .touchUpInside)
        
        return button
    }()
    
    lazy var relateLabel: SmallFontLabel = {
        let label = SmallFontLabel(title: "")
        
        return label
    }()
    
    private lazy var commentButton: ActionButton = {
        let button = ActionButton(title: "", type: .system, image: "text.bubble.rtl")
      
        button.addTarget(self, action: #selector(handleComment), for: .touchUpInside)

        return button
    }()
    
     var profileCommentLabel: SmallFontLabel = {
        let label = SmallFontLabel(title: "")
        
        return label
    }()
    
    lazy var likeButton: ActionButton = {
        let button = ActionButton(title: "", type: .system, image: "suit.heart")
        button.setImage(UIImage(systemName: "suit.heart"), for: .normal)
        
        button.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
        
        return button
    }()
    
    lazy var likeLabel: SmallFontLabel = {
        let label = SmallFontLabel(title: "")
        label.font = UIFont.boldSystemFont(ofSize: 15)
        
        return label
    }()
    
    private lazy var shareButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrowshape.turn.up.right.circle"), for: .normal)
        button.tintColor = .white
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 10)
        button.backgroundColor = #colorLiteral(red: 0.1598605525, green: 0.9373220266, blue: 0.7734893539, alpha: 1)
        button.layer.cornerRadius = 36 / 2
        button.setDimensions(height: 36, width: 36)
        
        button.addTarget(self, action: #selector(handleShare), for: .touchUpInside)

        return button
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
        layer.cornerRadius = 20

        
        addSubview(profileImage)
        profileImage.anchor(top: topAnchor, left: leftAnchor, paddingTop: 10, paddingLeft: 10)
        
        let labelStack = UIStackView(arrangedSubviews: [nameLabel, timePostLabel])
        labelStack.axis = .vertical
        labelStack.spacing = 5
        
        addSubview(labelStack)
        labelStack.anchor(top: topAnchor, left: profileImage.rightAnchor, paddingTop: 15, paddingLeft: 10)
        
        addSubview(postText)
        postText.anchor(top: profileImage.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 10, paddingLeft: 10, paddingRight: 10)
        
        configureRelatableButton()
        configureCommentButton()
        configureLikeButton()
        
        addSubview(shareButton)
        shareButton.anchor(bottom: bottomAnchor, right: rightAnchor, paddingBottom: 10, paddingRight: 10, height: 50)
        
    }
    
    func configureRelatableButton() {
        
        let buttonStack = UIStackView(arrangedSubviews: [relateButton, relateLabel])
        buttonStack.axis = .horizontal
        buttonStack.spacing = 2
        
        addSubview(buttonStack)
        buttonStack.anchor(left: leftAnchor, bottom: bottomAnchor, paddingLeft: 10, paddingBottom: 10)
        
    }
    
    
    func configureCommentButton() {
        
        let buttonStack = UIStackView(arrangedSubviews: [commentButton, profileCommentLabel])
        buttonStack.axis = .horizontal
        buttonStack.spacing = 2
        
        addSubview(buttonStack)
        buttonStack.anchor(left: relateLabel.rightAnchor, bottom: bottomAnchor, paddingLeft: 60, paddingBottom: 10)
        
    }
    
    func configureLikeButton() {
        
        let buttonStack = UIStackView(arrangedSubviews: [likeButton, likeLabel])
        buttonStack.axis = .horizontal
        buttonStack.spacing = 2
        
        addSubview(buttonStack)
        buttonStack.anchor(left: profileCommentLabel.rightAnchor, bottom: bottomAnchor, paddingLeft: 60, paddingBottom: 10)
        
    }
    
    //MARK: - SELECTORS

    @objc func handleRelate() {
        
        guard let viewModels = viewModel else {return}
        delegate?.cell(self, didRelateTo: viewModels.posts)
    
    }
    
    @objc func handleComment() {
        
        guard let viewModels = viewModel else {return}
        delegate?.cell(self, wantsToReplyTo: viewModels.posts)

    }
    
    @objc func handleLike() {
        
        guard let viewModels = viewModel else {return}
        delegate?.cell(self, didLike: viewModels.posts)

    }
    
    
    @objc func handleShare() {
        
        
    }
    
    //MARK: - ACTION

    
    func configureViewModel() {
        
        guard let viewModels = viewModel else {return}
        
        nameLabel.text = viewModels.fullname
        profileImage.sd_setImage(with: viewModels.profileImage)
        postText.text = viewModels.post
        timePostLabel.text = viewModels.timeStamp
        
        relateButton.setImage(viewModels.relatableButtonImage, for: .normal)
        relateButton.tintColor = viewModels.relatableButtontintColor
        relateLabel.text = viewModels.numberOfRelatable
        
        likeButton.setImage(viewModels.likeButtonImage, for: .normal)
        likeButton.tintColor = viewModels.likeButtonTintColor
        likeLabel.text = viewModels.numberOfLikes
        
        profileCommentLabel.text = viewModels.commentStats
        
        delegate?.cell(self, wantsToGetCommentCountFor: viewModels.posts)

    }
}




    


