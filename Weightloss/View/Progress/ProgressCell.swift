//
//  ProgressCell.swift
//  Weightloss
//
//  Created by benny mushiya on 19/05/2021.
//

import UIKit
import Firebase

protocol ProgressCellDelegate: class {
    
    func cell(_ cell: ProgressCell, showUserProfilFor uid: String)
    func cell(_ cell: ProgressCell, didLike post: ProgressPost)
    func cell(_ cell: ProgressCell, wantsToCommentOn post: ProgressPost)
    func cell(_ cell: ProgressCell, wantsToChatTo uid: String)
    func cell(_ cell: ProgressCell, wantsToDeleteOrShare post: ProgressPost)
    func cell(_ cell: ProgressCell, wantsToGetCommentCountFor post: ProgressPost)
    
}

class ProgressCell: UICollectionViewCell {
    
    //MARK: - PROPERITES
    
    var viewModel: ProgressPostViewModel? {
        didSet{configureViewModel()}
        
    }
    
    weak var delegate: ProgressCellDelegate?
    
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
    
    private let postImage: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.setHeight(400)
        iv.isUserInteractionEnabled = true
        iv.layer.cornerRadius = 20
        
        return iv
    }()
    
    private var captionLabel: SmallFontLabel = {
        let label = SmallFontLabel(title: "")
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        label.numberOfLines = 2
        
        return label
    }()
    
    private let LikesLabel: SmallFontLabel = {
        let label = SmallFontLabel(title: "")
        label.textAlignment = .center
        label.textColor = .white
        
        return label
    }()
    
    lazy var likesButton: ActionButton = {
        let button = ActionButton(title: "", type: .system, image: "circles.hexagongrid")
        
        button.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
        
        return button
    }()
    
     lazy var commentButton: ActionButton = {
        let button = ActionButton(title: "", type: .system, image: "text.bubble.rtl")
      
        button.addTarget(self, action: #selector(handleComment), for: .touchUpInside)

        return button
    }()
    
    var progressCommentLabel: SmallFontLabel = {
       let label = SmallFontLabel(title: "")
       
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
    
    //MARK: - LIFECYLE

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
        labelStack.anchor(top: topAnchor, left: profileImage.rightAnchor, paddingTop: 15, paddingLeft: 20)
        
        addSubview(chatButton)
        chatButton.anchor(top: topAnchor, right: rightAnchor, paddingTop: 15, paddingRight: 10)
        
        let postStack = UIStackView(arrangedSubviews: [postImage, captionLabel])
        postStack.axis = .vertical
        postStack.spacing = 10
        
        addSubview(postStack)
        postStack.centerX(inView: self)
        postStack.anchor(top: profileImage.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 10, paddingLeft: 10, paddingRight: 10)
        
        dynamicLabeling()
    }
    
    
    
    func checkLabelLength(_ label: UILabel, maxLength: Int) {
        
        guard let labelText = label.text else {return}
        
        if (labelText.count) > maxLength {
            
            label.isHidden = true
        }
    }
    
    
    
    func dynamicLabeling() {
            
        guard let captionText =  captionLabel.text?.count else {return}

        switch captionLabel.text!.count < 50 {
        case true:
            let buttonStack  = UIStackView(arrangedSubviews: [likesButton, commentButton, progressCommentLabel])
            buttonStack.axis = .horizontal
            buttonStack.spacing = 2
            
            addSubview(buttonStack)
            buttonStack.anchor(top: postImage.bottomAnchor, left: leftAnchor, paddingTop: 40, paddingLeft: 10 )
            
            addSubview(LikesLabel)
            LikesLabel.centerX(inView: self)
            LikesLabel.anchor(top: postImage.bottomAnchor, paddingTop: 40)
            
            addSubview(shareButton)
            shareButton.anchor(top: postImage.bottomAnchor, right: rightAnchor, paddingTop: 40, paddingRight: 10)
            
        case false:
            let buttonStack  = UIStackView(arrangedSubviews: [likesButton, commentButton, progressCommentLabel])
            buttonStack.axis = .horizontal
            buttonStack.spacing = 2
            
            addSubview(buttonStack)
            buttonStack.anchor(top: postImage.bottomAnchor, left: leftAnchor, paddingTop: 60, paddingLeft: 10 )
            
            addSubview(LikesLabel)
            LikesLabel.centerX(inView: self)
            LikesLabel.anchor(top: postImage.bottomAnchor, paddingTop: 60)
            
            addSubview(shareButton)
            shareButton.anchor(top: postImage.bottomAnchor, right: rightAnchor, paddingTop: 60, paddingRight: 10)
            
        }
        
    }
    
    //MARK: - SELECTORS

    @objc func handleShowProfile() {
        
        guard let viewModels = viewModel else { return }
        delegate?.cell(self, showUserProfilFor: viewModels.ownerUid)
        
    }
    
    @objc func handleChatWithUser() {
        
        guard let viewModels = viewModel else { return }
        delegate?.cell(self, wantsToChatTo: viewModels.ownerUid)

    }
    
    @objc func handleLike() {
        
        guard let viewModels = viewModel else { return }
        delegate?.cell(self, didLike: viewModels.posts)
    
    }
    
    @objc func handleComment() {
        
        guard let viewModels = viewModel else { return }
        delegate?.cell(self, wantsToCommentOn: viewModels.posts)

    }
    
    @objc func handleShare() {
        
        guard let viewModels = viewModel else { return }
        delegate?.cell(self, wantsToDeleteOrShare: viewModels.posts)
    }
    
    //MARK: - ACTION

    
    @objc func configureViewModel() {
        
        guard let viewModels = viewModel else {return}
        
        profileImage.sd_setImage(with: viewModels.ownerProfileImage)
        nameLabel.text = viewModels.ownerName
        postImage.sd_setImage(with: viewModels.postImage)
        captionLabel.text = viewModels.caption
        
        LikesLabel.attributedText = viewModels.numberOfRelatables
        timePostLabel.text = viewModels.timeStamp
        
        likesButton.setImage(viewModels.likeButtonImage, for: .normal)
        likesButton.tintColor = viewModels.likeButtonTintColor
                
        delegate?.cell(self, wantsToGetCommentCountFor: viewModels.posts)
        //checkLabelLength(captionLabel, maxLength: 50)
        dynamicLabeling()
        
    }
    
}
