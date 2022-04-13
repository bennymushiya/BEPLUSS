//
//  MainTabBarController.swift
//  Weightloss
//
//  Created by benny mushiya on 26/04/2021.
//

import UIKit
import Firebase
import YPImagePicker
import FirebaseAuth


enum UploadButtonConfiguration {
    
    case notProfile
    case profile
}

class MainTabBarController: UITabBarController {
    
    
    //MARK: - PROPERTIES
    
    private var buttonConfiguration: UploadButtonConfiguration = .notProfile
    
    var user: User? {
        
        didSet{
            guard let user = user else {return}
            configureTabBar(user: user)
        }
    }
    
    private let customActionSheet = CustomActionSheet()
    
    private var customTabBar = TabBarVCC()
    
    private let uploadPostButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "waveform.path.badge.plus"), for: .normal)
        button.backgroundColor = .red
        button.layer.cornerRadius = 20
        button.tintColor = .white
        button.layer.shadowOpacity = 0.1
        button.layer.shadowOffset = CGSize(width: 4, height: 4)
        button.addTarget(self, action: #selector(handleUploadTweet), for: .touchUpInside)
    
        return button
    }()
    
     let uploadButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "plus.square.fill.on.square.fill"), for: .normal)
        button.tintColor = .white
        button.setDimensions(height: 66, width: 66)
        button.backgroundColor = #colorLiteral(red: 0.1598605525, green: 0.9373220266, blue: 0.7734893539, alpha: 1)
        button.layer.cornerRadius = 66 / 2
        button.layer.shadowOpacity = 0.1
        button.layer.shadowOffset = CGSize(width: 4, height: 4)
        
        button.addTarget(self, action: #selector(handleUpload), for: .touchUpInside)
        
        return button
    }()
    
    //MARK: - LIFECYCLE
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        fetchUser()
        uploadButton.isHidden = false
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        fetchUser()
        checkIfUserIsLoggedIn()
       // self.delegate = self

    }
    
    //MARK: - HELPERS
    
    func configureUI() {
        
        view.addSubview(uploadButton)
        uploadButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingBottom: 60, paddingRight: 20)
        self.delegate = self
        
    }

    func configureTabBar(user: User) {
        
        customActionSheet.delegate = self
        
        let controller = EditProfileController(user: user)
        controller.delegate = self

        let home = configureNavigationTemplate(selectedImage: UIImage(systemName: "house.circle.fill"), unselectedImage: UIImage(systemName: "house.circle"), text: "Home", rootViewController: HomeController(user: user))
        
        let search = configureNavigationTemplate(selectedImage: UIImage(systemName: "magnifyingglass"), unselectedImage: UIImage(systemName: "magnifyingglass"), text: "Search", rootViewController: SearchController(user: user))
        
        let Progress = configureNavigationTemplate(selectedImage: UIImage(systemName: "camera.metering.matrix"), unselectedImage: UIImage(systemName: "camera.aperture"), text: "Progress", rootViewController: ProgressController(user: user))
        
        let challenge = configureNavigationTemplate(selectedImage: UIImage(systemName: "newspaper.fill"), unselectedImage: UIImage(systemName: "newspaper"), text: "Challenges", rootViewController: ChallengesController(user: user))
        
        let profile = configureNavigationTemplate(selectedImage: UIImage(systemName: "rectangle.stack.person.crop.fill"), unselectedImage: UIImage(systemName: "rectangle.stack.person.crop"), text: "Profile", rootViewController: ProfileController(user: user))
        
        viewControllers = [home, search, Progress, challenge, profile]
        
        tabBar.barTintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        tabBar.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        tabBarItem.badgeColor = .white
        tabBar.tintColor = .white
        tabBar.layer.masksToBounds = true
        tabBar.layer.cornerRadius = 40
        tabBar.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
       
    }
    
    
    func configureNavigationTemplate(selectedImage: UIImage?, unselectedImage: UIImage?, text: String, rootViewController: UIViewController) -> UINavigationController {
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    
   
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.selectedImage = selectedImage
        selectedImage?.withTintColor(.black)
        nav.tabBarItem.image = unselectedImage
        nav.tabBarItem.title = text
        nav.tabBarItem.badgeColor = .red
        nav.navigationBar.barTintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        nav.navigationBar.standardAppearance = appearance
        nav.navigationBar.compactAppearance = appearance
        nav.navigationBar.scrollEdgeAppearance = appearance
        nav.navigationBar.prefersLargeTitles = true
        nav.navigationBar.isTranslucent = true
        nav.navigationBar.tintColor = .white
        nav.delegate = self
        
        return nav
    }
    
    func setUpMiddleButton() {
        
       let uploadPostsButton = UIButton(frame: CGRect(x: (self.view.bounds.width / 2) - 25, y: -20, width: 50, height: 50))
        
        uploadPostsButton.setImage(UIImage(systemName: "waveform.path.badge.plus"), for: .normal)
        uploadPostsButton.backgroundColor = .black
        uploadPostsButton.layer.cornerRadius = 20
        uploadPostsButton.tintColor = .white
        uploadPostsButton.layer.shadowOpacity = 0.1
        uploadPostsButton.layer.shadowOffset = CGSize(width: 4, height: 4)
        uploadPostsButton.addTarget(self, action: #selector(handleUploadTweet), for: .touchUpInside)
        
         self.tabBar.addSubview(uploadPostsButton)
         self.view.layoutIfNeeded()
        
    }
    
    
    //MARK: - API
    
    // checks if a user is logged in if they are we do nothing and leave them here. if there not we present the loginContoller.
    func checkIfUserIsLoggedIn() {
        
        if Auth.auth().currentUser == nil {
            
            presentOnboardingController()
        }
    }

    func fetchUser() {
        
        guard let currentUser = Auth.auth().currentUser?.uid else {return}
        
        UserServices.fetchUser(withCurrentUser: currentUser) { user in
            self.user = user
            
            print("DEBUGG: THE NAME OF THE USER IS \(user.name)")
            print("DEBUGG: THE NAME OF THE USER IS \(user.uid)")

        }
        
    }
    
    //MARK: - SELECTORS
    
    @objc func handleUpload() {
                
        switch buttonConfiguration {
            
        case .notProfile:
            
            customActionSheet.show()

        case .profile:
            
            let controller = ChatController(config: .profile)
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true, completion: nil)

        }

    }
        
    
    @objc func handleUploadTweet() {
        
        self.selectedIndex = 2
        customActionSheet.show()
    }
    
  
    //MARK: - ACTION

    // we present the loginController, but on the main thread, rather than the background thread. meaning it will be done quickly and visible to the users 
    func presentLogInController() {
        
        DispatchQueue.main.async {
            let controller = LogInController()
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            controller.delegate = self
            self.present(nav, animated: true, completion: nil)
            
        }
        
    }
    
    
    func presentOnboardingController() {
        
        DispatchQueue.main.async {
            let controller = PaperOnboardingController()
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
            
        }
    }
    
    
    func didFinishPickingMedia(_ picker: YPImagePicker) {

        picker.didFinishPicking { image, _ in
            picker.dismiss(animated: true)

            guard let selectedImage = image.singlePhoto?.image else {return}

            let controller = UploadImageController()
            controller.selectedImage = selectedImage
            controller.delegate = self
            controller.currentUser = self.user

            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)

        }

    }
}

//MARK: - AuthentificationDidComplete

extension MainTabBarController: AuthentificationDidComplete {
    
    func authentificationDidComplete() {
        
        fetchUser()
        
    }
}

//MARK: - CustomActionSheetDelegate

extension MainTabBarController: CustomActionSheetDelegate {

    func actionSheet(_ sheet: CustomActionSheet, didSelectControllerAt index: IndexPath) {

        guard let currentUser = user else {return}

        switch index.row {

        case 0:

            switch currentUser.chosenCommunity.elementsEqual("weightGainCommunity") {
            case true:

                showMessage(withTitle: "No Access", message: " you are part of the weightGain community, therefore you cannot post on the weightLoss community")

            case false:
                let controller = UploadTweetController(user: currentUser)
                let nav = UINavigationController(rootViewController: controller)
                nav.modalPresentationStyle = .fullScreen
                present(nav, animated: true, completion: nil)
                sheet.handleDismissal()
            }

        case 1:

            switch currentUser.chosenCommunity.elementsEqual("WeightLossCommunity") {
            case true:
                showMessage(withTitle: "No Access", message: "you are part of the weightLoss communnity, therefore you cant post in the weightGain community")

            case false:
                let controller  = UploadWeightGainPostController(user: currentUser)
                let nav = UINavigationController(rootViewController: controller)
                nav.modalPresentationStyle = .fullScreen
                present(nav, animated: true, completion: nil)
                sheet.handleDismissal()
            }

        case 2:

            var configureImage = YPImagePickerConfiguration()
            configureImage.library.mediaType = .photo
            configureImage.shouldSaveNewPicturesToAlbum = false
            configureImage.startOnScreen = .library
            configureImage.screens = [.library]
            configureImage.hidesStatusBar = false
            configureImage.hidesBottomBar = false
            // allows users to posts multiple posts at a time or just one
            configureImage.library.maxNumberOfItems = 1

            let picker = YPImagePicker(configuration: configureImage)
            picker.modalPresentationStyle = .fullScreen
            present(picker, animated: true, completion: nil)

            didFinishPickingMedia(picker)
            sheet.handleDismissal()

        default:
            print("fefualt")

        }
    }
}

//MARK: - UploadImageControllerDelegate

extension MainTabBarController: UploadImageControllerDelegate {


    func controllerDidFinshUploadingPost(_ controller: UploadImageController) {

        selectedIndex = 2
        dismiss(animated: true, completion: nil)

        guard let progressNav = viewControllers?.first as? UINavigationController else {return}

        guard let progress = progressNav.viewControllers.first as? ProgressController else {return}

        progress.handleRefresh()

    }
}

//MARK: - UINavigationBarDelegate

extension MainTabBarController: UINavigationControllerDelegate {
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        
        return .topAttached
    }
    
    
    
}

//MARK: - EditProfileControllerDelegate

extension MainTabBarController: EditProfileControllerDelegate {
    
    func controller(_ controller: EditProfileController, wantsToUpdate user: User) {
        self.user = user
        
    }
}

//MARK: - UITabBarControllerDelegate

extension MainTabBarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        let index = viewControllers?.firstIndex(of: viewController)
        let imageName = index == 4 ? "text.bubble.fill" : "plus.square.fill.on.square.fill"
        self.uploadButton.setImage(UIImage(systemName: imageName), for: .normal)
        buttonConfiguration = index == 4 ? .profile : .notProfile
    }
    
}
