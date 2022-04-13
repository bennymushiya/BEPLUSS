//
//  UploadWeightGainPostController .swift
//  Weightloss
//
//  Created by benny mushiya on 18/05/2021.
//

import UIKit
import SDWebImage


class UploadWeightGainPostController: UIViewController {
    
    //MARK: - PROPERTIES
    
    private var user: User
    
    // we make this a lazy var because the order of initialisation on the button is wrong, thus unless we make it a lazy var we cant add a target on it.
    private lazy var postButton: ReusableButton = {
        let button = ReusableButton(title: "Post", type: .system)
        
        // by dividing the height of the button by 2 we get an oval shape
        button.layer.cornerRadius = 52 / 2
        button.addTarget(self, action: #selector(handleUploadPost), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var cancelButton: ReusableButton = {
        let button = ReusableButton(title: "Cancel", type: .system)
        
        // by dividing the height of the button by 2 we get an oval shape
        button.layer.cornerRadius = 52 / 2
        button.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        
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
        navigationController?.navigationBar.isHidden = true
        
        let stack = UIStackView(arrangedSubviews: [profileImage, captionTextView])
        stack.axis = .horizontal
        stack.spacing = 12
        stack.alignment = .leading
        
        view.addSubview(stack)
        stack.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 40, paddingLeft: 20, paddingRight: 20)
        
        let buttonStack = UIStackView(arrangedSubviews: [cancelButton, postButton])
        buttonStack.axis = .horizontal
        buttonStack.spacing = 20
        buttonStack.distribution = .fillEqually
        
        view.addSubview(buttonStack)
        buttonStack.anchor(top: stack.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 20, paddingRight: 20)
    

    }
    
    //MARK: - SELECTORS

    @objc func handleCancel() {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    
    @objc func handleUploadPost() {
        
        WeightGainServices.uploadWeightGainPost(post: captionTextView.text, user: user) { error in
            
            if let error = error {
                
                print("DEBUGG: FAILED TO UPLOAD DATA \(error.localizedDescription)")
                return
            }
            
            print("DEBUGG: SUCCESSFULLY UPLOAD THE DATA")
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    //MARK: - ACTION
   

    func configureUserData() {
        
        var image = URL(string: user.profileImage)
        
        profileImage.sd_setImage(with: image)

    }
}
