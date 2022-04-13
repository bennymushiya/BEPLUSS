//
//  NotificationCell.swift
//  Weightloss
//
//  Created by benny mushiya on 11/06/2021.
//

import UIKit
import SDWebImage

protocol NotificationCellDelegate: class {
    func cell(_ cell: NotificationCell, wantsToShowProfileFor uid: String)
    func cell(_ cell: NotificationCell, wantsToViewPost post: ProgressPost)
    
}


class NotificationCell: UICollectionViewCell {
    
    //MARK: - PROPERITES
    
    weak var delegate: NotificationCellDelegate?
    
    var viewModel: NotificationViewModel? {
        didSet{configureViewModel()}
        
    }
    
    private lazy var profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleToFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 20
        iv.backgroundColor = .lightGray
        iv.setDimensions(height: 58, width: 58)
        iv.isUserInteractionEnabled = true

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleShowProfile))
        
        iv.addGestureRecognizer(tapGesture)

        return iv
    }()
    
    private let infoLabel: SmallFontLabel = {
        let label = SmallFontLabel(title: "")
        label.numberOfLines = 0
        
        return label
    }()
    
    private let timeStampLabel: SmallFontLabel = {
        let label = SmallFontLabel(title: "")
        label.font = UIFont.boldSystemFont(ofSize: 10)
        
        return label
    }()
    
    private let textPostLabel: SmallFontLabel = {
        let label = SmallFontLabel(title: "")
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.numberOfLines = 0
        
        return label
    }()
    
    private lazy var postImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        iv.layer.cornerRadius = 20
        iv.setDimensions(height: 50, width: 50)

        let tap = UITapGestureRecognizer(target: self, action: #selector(handlePostTapped))
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(tap)
        
        return iv
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
        layer.borderColor = #colorLiteral(red: 0.1598605525, green: 0.9373220266, blue: 0.7734893539, alpha: 1)
        layer.borderWidth = 2
        
        contentView.addSubview(profileImageView)
        profileImageView.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 12)
        
        contentView.addSubview(timeStampLabel)
        timeStampLabel.anchor(top: topAnchor, right: rightAnchor, paddingTop: 10, paddingRight: 30)
    
        contentView.addSubview(postImageView)
        postImageView.centerY(inView: self)
        postImageView.anchor(right: rightAnchor, paddingRight: 20)
        
        let stack = UIStackView(arrangedSubviews: [infoLabel, textPostLabel])
        stack.axis = .vertical
        stack.spacing = 5
        
        contentView.addSubview(stack)
        stack.centerY(inView: profileImageView, leftAnchor: profileImageView.rightAnchor, paddingLeft: 8)
        stack.anchor(right: postImageView.leftAnchor, paddingRight: 4)
        
    }
    
    //MARK: - SELECTORS
    
    @objc func handleShowProfile() {
        
       guard let viewModels = viewModel else {return}
        delegate?.cell(self, wantsToShowProfileFor: viewModels.fromUserUid)
        
        print("DEBUGG: ITS THIS \(textPostLabel.text)")
    }
    
    
    @objc func handlePostTapped() {
        
        guard let viewModels = viewModel else {return}
        //delegate?.cell(self, wantsToViewPost: viewModels.postID)
        
    }
    
    //MARK: - ACTION
    
    func configureViewModel() {
        
        guard let viewModels = viewModel else {return}
        
        profileImageView.sd_setImage(with: viewModels.fromUserProfileImage)
        postImageView.sd_setImage(with: viewModels.postImageUrl)
        postImageView.isHidden = viewModels.shouldHidePostText
        
        infoLabel.attributedText = viewModels.notificationMessage
        timeStampLabel.text = viewModels.timeStamp
        
        textPostLabel.isHidden = viewModels.shouldHidePostImage
        textPostLabel.text = viewModels.postTextCaption
        
    }
}


