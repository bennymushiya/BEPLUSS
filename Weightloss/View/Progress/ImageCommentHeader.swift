//
//  ImageCommentHeader.swift
//  Weightloss
//
//  Created by benny mushiya on 27/05/2021.
//

import UIKit
import Firebase

protocol ImageCommentHeaderDelegate: class {
    func cell(_ cell: ImageCommentHeader, showUserProfilFor uid: String)
    func cell(_ cell: ImageCommentHeader, didLike post: ProgressPost)
    func cell(_ cell: ImageCommentHeader, wantsToCommentOn post: ProgressPost)
    func cell(_ cell: ImageCommentHeader, wantsToChatWith uid: String)
    func cell(_ cell: ImageCommentHeader, wantsToDeleteOrShare post: ProgressPost)

}


class ImageCommentHeader: UICollectionReusableView  {
    
    
    //MARK: - PROPERTIES
    
    weak var delegate: ImageCommentHeaderDelegate?
    
    var viewModel: ProgressHeaderCommentViewModel? {
        didSet{configureViewModel()}
        
    }
    
    private lazy var profileImage: UIImageView = {
        let iv = UIImageView()
        iv.layer.cornerRadius = 20
        iv.clipsToBounds = true
        iv.setDimensions(height: 56, width: 56)
        iv.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleShowProfile))
        
        iv.addGestureRecognizer(tapGesture)
        
        return iv
    }()
    
    private let nameLabel: SmallFontLabel = {
        let label = SmallFontLabel(title: "")
        
        return label
    }()
    
    private let timePostLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 10)
        label.textColor = .gray
        
        return label
    }()
    
    private lazy var chatButton: ChatButtonEx = {
        let button = ChatButtonEx(type: .system, title: "Chat")
        
        button.addTarget(self, action: #selector(handleChatWithUser), for: .touchUpInside)
        
        return button
    }()
    
    
    private let postImage: UIImageView = {
        let iv = UIImageView()
        //iv.image = #imageLiteral(resourceName: "vs dating image 3")
        iv.clipsToBounds = true
        iv.setHeight(400)
        iv.isUserInteractionEnabled = true
        iv.layer.cornerRadius = 20
        
        return iv
    }()
    
    private let likesLabel: SmallFontLabel = {
        let label = SmallFontLabel(title: " ")
        
        return label
    }()
    
    private let captionLabel: SmallFontLabel = {
        let label = SmallFontLabel(title: "this pic is mad i still like it though kuchi ?")
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        label.numberOfLines = 2
        
        return label
    }()
    
    lazy var likesButton: ActionButton = {
        let button = ActionButton(title: "", type: .system, image: "circles.hexagongrid")
      
        button.addTarget(self, action: #selector(handleRelate), for: .touchUpInside)
        
        return button
    }()
    
    
    private lazy var commentButton: ActionButton = {
        let button = ActionButton(title: "", type: .system, image: "text.bubble.rtl")
      
        button.addTarget(self, action: #selector(handleComment), for: .touchUpInside)

        return button
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
        layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
                
        addSubview(profileImage)
        profileImage.anchor(top: topAnchor, left: leftAnchor, paddingTop: 10, paddingLeft: 10)
        
        let labelStack = UIStackView(arrangedSubviews: [nameLabel, timePostLabel])
        labelStack.axis = .vertical
        labelStack.spacing = 5
        
        addSubview(labelStack)
        labelStack.anchor(top: topAnchor, left: profileImage.rightAnchor, paddingTop: 15, paddingLeft: 20)
        
        addSubview(chatButton)
        chatButton.anchor(top: topAnchor, right: rightAnchor, paddingTop: 15, paddingRight: 10)
        
        let postStack = UIStackView(arrangedSubviews: [postImage, captionLabel])
        postStack.axis = .vertical
        postStack.spacing = 10
        
        addSubview(postStack)
        postStack.centerX(inView: self)
        postStack.anchor(top: profileImage.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 10, paddingLeft: 10, paddingRight: 10)
        
        let buttonStack  = UIStackView(arrangedSubviews: [likesButton, commentButton])
        buttonStack.axis = .horizontal
        buttonStack.spacing = 2
        
        addSubview(buttonStack)
        buttonStack.anchor(top: postImage.bottomAnchor, left: leftAnchor, paddingTop: 60, paddingLeft: 10 )
        
        addSubview(likesLabel)
        likesLabel.centerX(inView: self)
        likesLabel.anchor(top: postImage.bottomAnchor, paddingTop: 60)
        
        addSubview(shareButton)
        shareButton.anchor(top: postImage.bottomAnchor, right: rightAnchor, paddingTop: 60, paddingRight: 10)
        
        
        addSubview(underLineView)
        underLineView.anchor(left: leftAnchor, bottom: bottomAnchor, width: frame.width, height: 2)
        
        
    }
    
    
    //MARK: - SELECTORS
    
    @objc func handleShowProfile() {
        
        guard let viewModels = viewModel else {return}
        delegate?.cell(self, showUserProfilFor: viewModels.ownerUid)
        
    }
    
    @objc func handleChatWithUser() {
        
        guard let viewModels = viewModel else {return}
        delegate?.cell(self, wantsToChatWith: viewModels.ownerUid)
        
        
    }
    
    @objc func handleRelate() {
        
        guard let viewModels = viewModel else {return}
        delegate?.cell(self, didLike: viewModels.post)
        
        
    }
    
    @objc func handleComment() {
        
        guard let viewModels = viewModel else {return}
        delegate?.cell(self, wantsToCommentOn: viewModels.post)

    }
    
    @objc func handleShare() {
        
        guard let viewModels = viewModel else {return}
        delegate?.cell(self, wantsToDeleteOrShare: viewModels.post)
        
    }

    
    
    //MARK: - ACTION

    func configureViewModel() {
        
        guard let viewModels = viewModel else {return}
        
        profileImage.sd_setImage(with: viewModels.profileImage)
        postImage.sd_setImage(with: viewModels.postImage)

        nameLabel.text = viewModels.fullname
        timePostLabel.text = viewModels.timeStamp
        captionLabel.text = viewModels.caption
        
        likesLabel.attributedText = viewModels.numberOfLikes
        likesButton.setImage(viewModels.likeButtonImage, for: .normal)
        likesButton.tintColor = viewModels.likeButtonTintColor
        
        
        
        
    }
    
}
