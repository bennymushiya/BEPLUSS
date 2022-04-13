//
//  UploadTweetController.swift
//  Weightloss
//
//  Created by benny mushiya on 05/05/2021.
//

import UIKit
import SDWebImage
import FirebaseAuth
import Firebase


class UploadTweetController: UIViewController {
    
    //MARK: - PROPERTIES
    
    private var user: User
    
    // we make this a lazy var because the order of initialisation on the button is wrong, thus unless we make it a lazy var we cant add a target on it.
    private lazy var PostButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .black
        button.setTitle("Post", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        button.setDimensions(height: 32, width: 84)
        
        // by dividing the height of the button by 2 we get an oval shape
        button.layer.cornerRadius = 32 / 2
        button.addTarget(self, action: #selector(handleUploadPost), for: .touchUpInside)
        
        return button
    }()
    
    private let profileImage: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.setDimensions(height: 66, width: 66)
        iv.layer.cornerRadius = 20
        
        return iv
    }()
    
    private let captionTextView = CaptionTextView()
    
    //MARK: - LIFECYCLE
    
    // we use a dependency injection to pass the user details to this controller, rather than making another API call to fetch the user. thus this controller requires a user before its initialised.
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureUserData()
        
    }
    
    //MARK: - HELPERS

    func configureUI() {
        
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: PostButton)
        
        let stack = UIStackView(arrangedSubviews: [profileImage, captionTextView])
        stack.axis = .horizontal
        stack.spacing = 12
        stack.alignment = .leading
        
        view.addSubview(stack)
        stack.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 20, paddingRight: 20)
        
        
    }
    
    //MARK: - SELECTORS

    @objc func handleCancel() {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    
    @objc func handleUploadPost() {
        
        WeightLossServices.uploadWeightLossPost(post: captionTextView.text) { error in
            if let error = error {
                
                print("failed to upload data ")
                return
                
            }
            
            print("successfully upload the post")
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    
    //MARK: - ACTION

    func configureUserData() {
        
        var image = URL(string: user.profileImage)
        
        profileImage.sd_setImage(with: image)

        
    }
    
    
    
}
