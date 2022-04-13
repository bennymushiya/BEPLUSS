//
//  CommentInputAccessoryView.swift
//  Weightloss
//
//  Created by benny mushiya on 10/05/2021.
//

import UIKit
import SDWebImage

protocol CommentInputAccesoryViewDelegate: class {
    
    func inputView(_ inputView: CommentInputAccesoryView, wantsToUploadComment comment: String)
    
}

class CommentInputAccesoryView: UIView {
    
    // MARK: - Properties
    
    weak var delegate: CommentInputAccesoryViewDelegate?
    
    var viewModel: HomeHeaderViewModel? {
        didSet{configureViewModel()}
        
    }
    
    private let profileImage: UIImageView = {
        let iv = UIImageView()
        iv.layer.cornerRadius = 10
        iv.clipsToBounds = true
        iv.setDimensions(height: 56, width: 56)
        iv.backgroundColor = .blue
        iv.isUserInteractionEnabled = true
        
        return iv
    }()
        
    private let commentTextView: InputTextView = {
        let tv = InputTextView()
        tv.placeHolderText = "Enter comment.."
        tv.font = UIFont.systemFont(ofSize: 15)
        tv.isScrollEnabled = false
        tv.placeHolderShouldCenter = true
        tv.textColor = .black
        tv.backgroundColor = .white
        
        return tv
    }()
    
    private let postButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Post", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.backgroundColor = #colorLiteral(red: 0.1598605525, green: 0.9373220266, blue: 0.7734893539, alpha: 1)
        button.setDimensions(height: 50, width: 50)
        button.layer.cornerRadius = 50 / 2
        button.addTarget(self, action: #selector(handlePostTapped), for: .touchUpInside)
        
        return button
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        autoresizingMask = .flexibleHeight
        
        addSubview(postButton)
        postButton.anchor(top: topAnchor, right: rightAnchor, paddingTop: 8, paddingRight: 8)
        
        
        let stack = UIStackView(arrangedSubviews: [profileImage, commentTextView])
        stack.axis = .horizontal
        stack.spacing = 10
        
        addSubview(stack)
        stack.anchor(top: topAnchor, left: leftAnchor,
                               bottom: safeAreaLayoutGuide.bottomAnchor, right: postButton.leftAnchor,
                               paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 8)
        
        let divider = UIView()
        divider.backgroundColor = .lightGray
        addSubview(divider)
        divider.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, height: 0.5)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return .zero
    }
    
    // MARK: - Actions
    
    @objc func handlePostTapped() {
        
        delegate?.inputView(self, wantsToUploadComment: commentTextView.text)
        
    }
    
    func configureViewModel() {
        
        guard let viewModels = viewModel else {return}
        
        profileImage.sd_setImage(with: viewModels.profileImage)
        
    }
    
    
    // MARK: - Helpers
    
    func clearCommentTextView() {
        commentTextView.text = nil
        commentTextView.placeHolderLabel.isHidden = false
    }
}

