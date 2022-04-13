//
//  BackgroundImageController.swift
//  Weightloss
//
//  Created by benny mushiya on 04/05/2021.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore

class BackgroundImageController: UIViewController {
    
    
    //MARK: - PROPERTIES
    
    weak var delegate: AuthentificationDidComplete?
    
    private let topBackgroundImage: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "backgroundimage")
        iv.setHeight(250)
        
        return iv
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrowshape.turn.up.backward.2.circle.fill"), for: .normal)
        button.setDimensions(height: 56, width: 56)
        button.tintColor = .white
        button.backgroundColor = #colorLiteral(red: 0.1598605525, green: 0.9373220266, blue: 0.7734893539, alpha: 1)
        button.layer.cornerRadius = 20
        button.isEnabled = true
        button.imageView?.setDimensions(height: 30, width: 30)
        
        button.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        
        return button
    }()
        
    private let headlineLabel: AuthLabels = {
        let label = AuthLabels(title: "Choose a Background Image")
        label.font = UIFont.systemFont(ofSize: 25, weight: .black)
        label.textAlignment = .left
        label.textColor = .black

        
        return label
    }()
    
    private let descriptionLabel: AuthLabels = {
        let label = AuthLabels(title: "this image will be used for your profile")
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.textAlignment = .left
        label.textColor = .black
        
        return label
    }()
    
    private let backgroundProfileImage: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        button.layer.cornerRadius = 50 / 2
        button.setHeight(200)
        button.setImage(UIImage(systemName: "camera.fill.badge.ellipsis"), for: .normal)
        button.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        button.addTarget(self, action: #selector(uploadImage), for: .touchUpInside)
        
        return button
    }()
    
    private let imagePicker = UIImagePickerController()
    private var backgroundImage: UIImage?
    
    private let continueButton: AuthButton = {
        let button = AuthButton(title: "Continue", type: .system)
        button.addTarget(self, action: #selector(handleNextPage), for: .touchUpInside)
        button.isEnabled = false
        button.backgroundColor = #colorLiteral(red: 0.6148123741, green: 0.1017967239, blue: 0.1002308354, alpha: 1)
        
        return button
    }()
    
    //MARK: - LIFECYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
    }
    
    //MARK: - HELPERS
    
    func configureUI() {
        
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
        imagePicker.delegate = self
        
        view.insertSubview(topBackgroundImage, at: 0)
        topBackgroundImage.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0)
        
        
        let labelStack = UIStackView(arrangedSubviews: [headlineLabel, descriptionLabel])
        labelStack.axis = .vertical
        labelStack.spacing = 10
        
        view.addSubview(labelStack)
        labelStack.centerX(inView: view, topAnchor: topBackgroundImage.bottomAnchor, paddingTop: 20)
        labelStack.anchor(left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 20, paddingRight: 20)
        
        view.addSubview(backgroundProfileImage)
        backgroundProfileImage.centerX(inView: view)
        backgroundProfileImage.anchor(top: labelStack.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 30, paddingLeft: 20, paddingRight: 20)
        
        let buttonStack = UIStackView(arrangedSubviews: [backButton, continueButton])
        buttonStack.axis = .horizontal
        buttonStack.spacing = 200
        
        view.addSubview(buttonStack)
        buttonStack.centerX(inView: view)
        buttonStack.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingLeft: 20, paddingBottom: 40, paddingRight: 20)
        
    }
    
    
    //MARK: - ACTION
    
    @objc func handleBack() {
        
       // let controller = FitnessGoalsController()
       // navigationController?.pushViewController(controller, animated: true)
                
    }
    
    @objc func uploadImage() {
        
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    func showMessages(withTitle title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    
    @objc func handleNextPage() {
        
        let name = InputDetails.shared.name
        let email = InputDetails.shared.email
        let password = InputDetails.shared.password
        let chosenCommunity = InputDetails.shared.chosenCommunity
        let currentWeight = InputDetails.shared.currentWeight
        let futureGoal = InputDetails.shared.futureGoalWeight
        guard let profileImage = InputDetails.shared.profileImage else {return}
        let fitnessGoals = InputDetails.shared.fitnessGoals
        guard let backgroundImage = backgroundImage else {return}
        guard let pushID = Messaging.messaging().fcmToken else {return}

        
        let credentials = AuthCredentials(name: name, email: email, password: password, chosenCommunity: chosenCommunity, profileImage: profileImage, fitnessGoals: fitnessGoals, backgroundImage: backgroundImage, currentWeight: currentWeight, futureGoal: futureGoal, pushID: pushID)
        
        showLoader(true)
        
        AuthServices.createUser(withCredentials: credentials) { error in
            
            self.showLoader(false)
            if let error = error {
                self.showMessages(withTitle: "error", message: "error")
                return
                
            }
            
            self.delegate?.authentificationDidComplete()
            print("succesuflly upload all information")
            let controller = MainTabBarController()
            self.navigationController?.pushViewController(controller, animated: true)
        
        }
    }
}

//MARK: - UIImagePickerControllerDelegate

extension BackgroundImageController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let selectedImage = info[.originalImage] as? UIImage else {return}
        
        backgroundImage = selectedImage
        
        backgroundProfileImage.setImage(selectedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        backgroundProfileImage.layer.cornerRadius = 20
        backgroundProfileImage.layer.masksToBounds = true
        continueButton.isEnabled = true
        continueButton.backgroundColor = #colorLiteral(red: 0.1598605525, green: 0.9373220266, blue: 0.7734893539, alpha: 1)
        
        dismiss(animated: true, completion: nil)
        
        
    }
}
