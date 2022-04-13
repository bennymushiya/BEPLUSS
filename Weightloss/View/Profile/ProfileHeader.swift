//
//  ProfileHeader.swift
//  Weightloss
//
//  Created by benny mushiya on 30/04/2021.
//

import UIKit
import Firebase

protocol ProfileHeaderDelegate: class {
    
    func header(_ header: ProfileHeader, wantsToChatWith uid: String)
   // func didSelectFilter(_ filter: ProfileFilterOptions)
    func wantsToGoToProgressPost()
    
}


class ProfileHeader: UICollectionReusableView {
    
    //MARK: - PROPERTIES
    
    weak var delegate: ProfileHeaderDelegate?
    
    var viewModel: ProfileHeaderViewModel? {
        didSet{configureViewModel()}
        
    }
    
    private let filterBar = ProfileFilterView()
    
    private let backgroundImage: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.setHeight(300)
        iv.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleFullScreenImage))
        iv.addGestureRecognizer(tapGesture)
        
        return iv
    }()
    
    private let mainProfileImage: UIImageView = {
        let iv = UIImageView()
        iv.layer.cornerRadius = 20
        iv.clipsToBounds = true
        iv.backgroundColor = .systemGroupedBackground
        iv.tintColor = .black
        iv.setDimensions(height: 100, width: 100)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleFullScreenImage))
        iv.addGestureRecognizer(tapGesture)
        
        return iv
    }()
    
    private let weightLossPost: SmallFontLabel = {
        let label = SmallFontLabel(title: "")
        label.textAlignment = .center
        
        return label
    }()
    
    
    private let weightGainPost: SmallFontLabel = {
        let label = SmallFontLabel(title: "")
        label.textAlignment = .center

        
        return label
    }()
    
    private let nameLabel: SmallFontLabel = {
        let label = SmallFontLabel(title: "")
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        
        return label
    }()
    
    private let fitnessGoalsLabel: SmallFontLabel = {
        let label = SmallFontLabel(title: "")
        label.numberOfLines = 0
        label.textAlignment = .center

        return  label
    }()
    
    private lazy var progressButton: ProfileButton = {
        let button = ProfileButton(title: "Progress", type: .system)
        button.addTarget(self, action: #selector(handleFollow), for: .touchUpInside)

        return button
    }()
    
    private lazy var messageButton: ProfileButton = {
        let button = ProfileButton(title: "Message", type: .system)
        
        button.addTarget(self, action: #selector(handleMessage), for: .touchUpInside)
        
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
        
        backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            
        addSubview(backgroundImage)
        backgroundImage.centerX(inView: self)
        backgroundImage.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: -50, paddingLeft: 0, paddingRight: 0)
        
        addSubview(mainProfileImage)
        mainProfileImage.centerX(inView: self)
        mainProfileImage.anchor(top: backgroundImage.bottomAnchor, paddingTop: -50)
        
        addSubview(weightLossPost)
        weightLossPost.anchor(top: backgroundImage.bottomAnchor, left: leftAnchor, right: mainProfileImage.leftAnchor, paddingTop: 10, paddingLeft: 10, paddingRight: 10)
        
        addSubview(weightGainPost)
        weightGainPost.anchor(top: backgroundImage.bottomAnchor, left: mainProfileImage.rightAnchor, right: rightAnchor, paddingTop: 10, paddingLeft: 10, paddingRight: 10)
        
        let labelStack = UIStackView(arrangedSubviews: [nameLabel, fitnessGoalsLabel])
        labelStack.axis = .vertical
        labelStack.spacing = 10

        addSubview(labelStack)
        labelStack.centerX(inView: self)
        labelStack.anchor(top: mainProfileImage.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 10, paddingLeft: 10, paddingRight: 10)
        
        let butttonStack = UIStackView(arrangedSubviews: [progressButton, messageButton])
        butttonStack.axis = .horizontal
        butttonStack.spacing = 20
        butttonStack.distribution = .fillEqually
        
        addSubview(butttonStack)
        butttonStack.centerX(inView: self)
        butttonStack.anchor(top: labelStack.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 20, paddingLeft: 10, paddingRight: 10)
        
        addSubview(filterBar)
        filterBar.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, height: 40)
        
        
    }
    
    //MARK: - SELECTORS
    
    @objc func handleFullScreenImage() {
        
        
    }

    @objc func handleFollow() {
        
        delegate?.wantsToGoToProgressPost()
        
    }
    
    @objc func handleMessage() {
        
        guard let viewModels = viewModel else {return}

        if viewModels.user.isCurrentUser {
            
            delegate?.header(self, wantsToChatWith: viewModels.user.uid)

        }else {

            delegate?.header(self, wantsToChatWith: viewModels.user.uid)
        }
        
    }
    
    //MARK: - ACTION
    
    func configureViewModel() {
        
        guard let viewModels = viewModel else {return}
        
        backgroundImage.sd_setImage(with: viewModels.backgroundImage)
        mainProfileImage.sd_setImage(with: viewModels.profileImage)
        weightLossPost.attributedText = viewModels.numberOfPostsLabel
        weightGainPost.attributedText = viewModels.numberOfProgressLabel
        nameLabel.text = viewModels.fullname
        fitnessGoalsLabel.text = viewModels.fitnessGoals
        weightLossPost.isHidden = viewModels.hideWeightLossLabel
        weightGainPost.isHidden = viewModels.hideMuscleGainLabel
        
        messageButton.setTitle(viewModels.messageButtonEdit, for: .normal)
        
    }
}




