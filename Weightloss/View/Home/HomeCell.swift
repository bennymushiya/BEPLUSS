//
//  HomeCell.swift
//  Weightloss
//
//  Created by benny mushiya on 30/04/2021.
//

import UIKit
import SDWebImage

protocol HomeCellDelegate: class {
    
    func cell(_ cell: HomeCell, didRelateTo  post: TextPost)
    func cell(_ cell: HomeCell, wantsToReplyTo post: TextPost)
    func cell(_ cell: HomeCell, wantsToShowProfileFor uid: String)
    func cell(_ cell: HomeCell, wantsToDelete post: TextPost)
    func cell(_ cell: HomeCell, didLike post: TextPost)
    func cell(_ cell: HomeCell, wantsToChatWith uid: String)
    func cell(_ cell: HomeCell, wantsToGetCommentCountFor post: TextPost)
    
}


class HomeCell: UICollectionViewCell {
    
    //MARK: - LIFEYCLE

    var viewModel: TextPostViewModel? {
        didSet{configureViewModel()}
        
    }
    
    weak var delegate: HomeCellDelegate?
    
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
    
    private let timePostLabel: SmallFontLabel = {
        let label = SmallFontLabel(title: "")
        label.font = UIFont.boldSystemFont(ofSize: 10)
        
        return label
    }()
    
    private lazy var chatButton: ChatButtonEx = {
        let button = ChatButtonEx(type: .system, title: "Chat")
       
        button.addTarget(self, action: #selector(handleChatWithUser), for: .touchUpInside)
        
        return button
    }()
    
    private let postText: TextPostLabel = {
        let label = TextPostLabel(title: "")
       
        return label
    }()
    
  private let captionTextView = CaptionTextView()
    
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
    
    
     var commentLabel: SmallFontLabel = {
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
    
    //MARK: - LIFEYCLE
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
       configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - LIFEYCLE

    func configureUI() {
        
        
        layer.cornerRadius = 20
        layer.borderColor = #colorLiteral(red: 0.1598605525, green: 0.9373220266, blue: 0.7734893539, alpha: 1)
        layer.borderWidth = 5
        backgroundColor = #colorLiteral(red: 0.1019607843, green: 0.1019607843, blue: 0.1019607843, alpha: 0.5)
        captionTextView.isUserInteractionEnabled = false
        
        addSubview(profileImage)
        profileImage.anchor(top: topAnchor, left: leftAnchor, paddingTop: 10, paddingLeft: 10)
        
        let labelStack = UIStackView(arrangedSubviews: [nameLabel, timePostLabel])
        labelStack.axis = .vertical
        labelStack.spacing = 5
        
        addSubview(labelStack)
        labelStack.anchor(top: topAnchor, left: profileImage.rightAnchor, paddingTop: 15, paddingLeft: 10)
        
        addSubview(chatButton)
        chatButton.anchor(top: topAnchor, right: rightAnchor, paddingTop: 15, paddingRight: 10)
        
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
        
        let buttonStack = UIStackView(arrangedSubviews: [commentButton, commentLabel])
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
        buttonStack.anchor(left: commentLabel.rightAnchor, bottom: bottomAnchor, paddingLeft: 60, paddingBottom: 10)
        
    }
    
    
    //MARK: - SELECTORS
    
    
    @objc func handleShowProfile() {
        
        guard let viewModels = viewModel else {return}
        delegate?.cell(self, wantsToShowProfileFor: viewModels.ownerUid)
        
    }
    
    
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
        
        guard let viewModels = viewModel else {return}
        
        delegate?.cell(self, wantsToDelete: viewModels.posts)
        
    }
    
    
    @objc func handleChatWithUser() {
        
        guard let viewModels = viewModel else {return}
        delegate?.cell(self, wantsToChatWith: viewModels.ownerUid )
        
    }



//MARK: - ACTION

    
    func configureViewModel() {
        
        guard let viewModels = viewModel else {return}
        
        postText.text = viewModels.post
        profileImage.sd_setImage(with: viewModels.profileImage)
        nameLabel.text = viewModels.fullname
        timePostLabel.text = viewModels.timeStamp
        
        relateButton.setImage(viewModels.relatableButtonImage, for: .normal)
        relateButton.tintColor = viewModels.relatableButtontintColor
        relateLabel.text = viewModels.numberOfRelatable
        
        likeButton.setImage(viewModels.likeButtonImage, for: .normal)
        likeButton.tintColor = viewModels.likeButtonTintColor
        likeLabel.text = viewModels.numberOfLikes
        commentLabel.text = viewModels.commentStats
        
        delegate?.cell(self, wantsToGetCommentCountFor: viewModels.posts)

    }

}

    
    
   
