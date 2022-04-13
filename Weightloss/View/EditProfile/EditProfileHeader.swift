//
//  EditProfileHeader.swift
//  Weightloss
//
//  Created by benny mushiya on 31/05/2021.
//

import UIKit
import SDWebImage

protocol EditProfileHeaderDelegate: class {
    
    func selectProfilePhoto(_ header: EditProfileHeader)

}


class EditProfileHeader: UIView {
    
    
    //MARK: - PROPERTIES
    
    weak var delegate: EditProfileHeaderDelegate?
    
    var viewModel: EditProfileCellViewModel? {
        didSet{configureViewModel()}
        
    }
    
    private let descriptionLabel: SmallFontLabel = {
        let label = SmallFontLabel(title: "Edit Profile")
        label.font = UIFont.systemFont(ofSize: 30, weight: .black)
        label.textAlignment = .left

        return label
    }()
    
    var buttons = [UIImageView]()
    
    lazy var profileImage = createButtons(0)
    lazy var backgroundImage = createButtons(1)

    
    
    private let uploadProfileImage: AuthLabels = {
        let label = AuthLabels(title: "Upload Profile Photo")
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 10)
        
        return label
    }()
    
    
    private let uploadbackgroundImage: AuthLabels = {
        let label = AuthLabels(title: "Upload BackgroundImage")
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 10)
        
        return label
    }()
    
     var buttonIndex = 0
    

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
        
        buttons.append(profileImage)
        buttons.append(backgroundImage)
        
        addSubview(descriptionLabel)
        descriptionLabel.anchor(top: topAnchor, left: leftAnchor, paddingTop: 5, paddingLeft: 10)
        
        addSubview(profileImage)
        profileImage.setHeight(270)
        profileImage.anchor(top: descriptionLabel.bottomAnchor, left: leftAnchor, paddingTop: 10, paddingLeft: 10)
        
        // whatever our screen size is the button will be half of the screen sizes width.
        profileImage.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.45).isActive = true

        addSubview(backgroundImage)
        backgroundImage.setWidth(180)
        backgroundImage.anchor(top: descriptionLabel.bottomAnchor, left: profileImage.rightAnchor, bottom: profileImage.bottomAnchor, right: rightAnchor, paddingTop: 10, paddingLeft: 10, paddingRight: 10)
        
        let stack = UIStackView(arrangedSubviews: [uploadProfileImage, uploadbackgroundImage])
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        
        addSubview(stack)
        stack.anchor(top: profileImage.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 10, paddingLeft: 10, paddingRight: 10)
        
    }
    
    //MARK: - SELECTORS

    
    @objc func handleSelectPhoto(sender: UITapGestureRecognizer) {
        
        self.buttonIndex = sender.view!.tag
        delegate?.selectProfilePhoto(self)
    }
    
    //MARK: - ACTION
    
    func createButtons(_ index: Int) -> UIImageView {
        let iv = UIImageView()
        iv.layer.cornerRadius = 10
        iv.clipsToBounds = true
        iv.backgroundColor = .systemGroupedBackground
        iv.tag = index
        iv.isUserInteractionEnabled = true
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(systemName: "camera.fill.badge.ellipsis")
        iv.tintColor = .black
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleSelectPhoto))
        iv.addGestureRecognizer(tapGesture)
        
        return iv
    }
    
    // we go into the buttons array that contains all of our buttons and we go through it like an index path with our button index that was assigned the sender tag and we set each images to each button.
    func setImages(_ images: UIImage) {
        
        buttons[buttonIndex].image = images
        
    }
    
    
    func configureViewModel() {
        
        guard let viewModels = viewModel else {return}

        profileImage.sd_setImage(with: viewModels.profileImage)
        backgroundImage.sd_setImage(with: viewModels.backgroundImage)

        
    }
    
}


