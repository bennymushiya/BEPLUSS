//
//  RegistrationController.swift
//  Weightloss
//
//  Created by benny mushiya on 26/04/2021.
//

import UIKit
import FirebaseStorage

class RegistrationController: UIViewController {
    
    
    //MARK: - PROPERTIES
    
    private let imagePicker = UIImagePickerController()
    private var viewModel = RegistrationViewModel()
    private var profileImage: UIImage?

    
    
    private let descriptionLabel: AuthLabels = {
         let label = AuthLabels(title: "Register Now")
        label.font = UIFont.systemFont(ofSize: 40, weight: .black)
        label.textColor = .white
        label.textAlignment = .left
         
         return label
     }()
    
    
    private let LogInPageButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.attributedTitle(firstPart: "Aready Have An Account?", secondPart: "Log In")
        
        button.addTarget(self, action: #selector(handlelogInPage), for: .touchUpInside)
        
        return button
    }()
    
    private let uploadProfileButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "camera.fill.badge.ellipsis"), for: .normal)
        button.backgroundColor = .systemGroupedBackground
        button.layer.cornerRadius = 76 / 2
        button.tintColor = .white
        button.layer.borderWidth = 5
        button.layer.borderColor = #colorLiteral(red: 0.1598605525, green: 0.9373220266, blue: 0.7734893539, alpha: 1)
        button.setDimensions(height: 76, width: 76)
        
        button.addTarget(self, action: #selector(uploadImage), for: .touchUpInside)
        
        return button
    }()
    
    
    private let uploadPhotoLabel: AuthLabels = {
        let label = AuthLabels(title: "Upload Photo")
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 10)
        label.textColor = .white

        
        return label
    }()
    
    
    private let nameTextField: CustomTextField = {
         let tf = CustomTextField(placeHolder: "Name")
         tf.addTarget(self, action: #selector(handleEditingChanged), for: .editingChanged)
     
         return tf
     }()
    
   private let emailTextField: CustomTextField = {
        let tf = CustomTextField(placeHolder: "Email")
        tf.addTarget(self, action: #selector(handleEditingChanged), for: .editingChanged)
    
    
        return tf
    }()
    
    
    private let passwordTextField: CustomTextField = {
         let tf = CustomTextField(placeHolder: "Password")
        tf.addTarget(self, action: #selector(handleEditingChanged), for: .editingChanged)
        tf.isSecureTextEntry = true
     
         return tf
     }()
    
    
    private let registerButton: AuthButton = {
        let button = AuthButton(title: "next", type: .system)
        button.layer.cornerRadius = 50 / 2
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .black)
        button.backgroundColor = .black
        button.layer.borderWidth = 5
        button.layer.borderColor = #colorLiteral(red: 0.1598605525, green: 0.9373220266, blue: 0.7734893539, alpha: 1)
        button.setDimensions(height: 50, width: 180)
        button.isEnabled = false
        
        button.addTarget(self, action: #selector(handleNextScreen), for: .touchUpInside)


        return button
    }()
    

    //MARK: - LIFECYCLE

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        tapGesture()
        updateForm()
        
    }
    
    //MARK: - HELPERS

    func configureUI() {
        
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
        imagePicker.delegate = self
        

        
         let topStack = UIStackView(arrangedSubviews: [descriptionLabel, LogInPageButton])
         topStack.axis = .vertical
         topStack.spacing = 20
         topStack.distribution = .fillEqually
         
         
         view.addSubview(topStack)
         topStack.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingTop: 150, paddingLeft: 20)
        
        let ImagePropertiesStack = UIStackView(arrangedSubviews: [uploadProfileButton, uploadPhotoLabel])
        ImagePropertiesStack.axis = .vertical
        ImagePropertiesStack.spacing = 5
        
        
        view.addSubview(ImagePropertiesStack)
        ImagePropertiesStack.anchor(top: topStack.bottomAnchor, right: view.rightAnchor, paddingTop: 20, paddingRight: 30)

        let textFieldStack = UIStackView(arrangedSubviews: [nameTextField, emailTextField, passwordTextField])
        textFieldStack.axis = .vertical
        textFieldStack.spacing = 20
        
        view.addSubview(textFieldStack)
        textFieldStack.centerX(inView: view)
        textFieldStack.anchor(top: ImagePropertiesStack.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 30, paddingLeft: 30, paddingRight: 30)


        view.addSubview(registerButton)
        registerButton.anchor(top: textFieldStack.bottomAnchor, right: view.rightAnchor, paddingTop: 50, paddingRight: 30)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    
    }
    
    //MARK: - SELECTORS
    
    //makes the textfields go up when the keyboard shows itself.
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    
    // makes the textfields go back into place when clicked on the view.
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    
    @objc func handlelogInPage() {
        
        let controller = LogInController()
        navigationController?.pushViewController(controller, animated: true)
        
    }
    
    @objc func uploadImage() {
        
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    
    @objc func handleEditingChanged(sender: UITextField) {
        
        if sender == nameTextField {
            
            viewModel.name = sender.text
            
        }else if sender == emailTextField {
            
            viewModel.email = sender.text

        }else {
            
            viewModel.password = sender.text
            
        }
        
        updateForm()
        
    }
    
    
    @objc func handleNextScreen() {
        
        guard let name = nameTextField.text else {return}
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        guard let profileImage = profileImage else {return}
        
        InputDetails.shared.name = name
        InputDetails.shared.email = email
        InputDetails.shared.password = password
        InputDetails.shared.profileImage = profileImage
        

        switch password != "" && PasswordStrength.containsSymbol(password) && PasswordStrength.containsNumber(password) && PasswordStrength.containsUpperCase(password) || email != "" && EmailConfirmation.validateEmail(enteredEmail: email) {

        case true:

            let controller = ChooseWeightCategoryController()
            navigationController?.pushViewController(controller, animated: true)

        case false:

            showMessage(withTitle: "ERROR", message: "make sure your password contains a \n symbol \n number \n Uppercase letter and your email is well formatted")

        }
     
    }
    
    
    @objc func handleDismiss() {
        
        nameTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
    }
    
    //MARK: - ACTION

    func updateForm() {
        
        registerButton.isEnabled = viewModel.formIsValid
        registerButton.backgroundColor = viewModel.changeButtonColor
        registerButton.setTitle(viewModel.changeTextSign, for: .normal)
        registerButton.titleLabel?.font = viewModel.changeTextFont
        uploadProfileButton.backgroundColor = viewModel.changeProfileImageColor
       // uploadProfileButton.setTitle(viewModel.changeProfileImageText, for: .normal)
        //uploadProfileButton.imageView?.isHidden = viewModel.hideProfileButton
    }
    
    func tapGesture() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleDismiss))
        view.addGestureRecognizer(tap)
    }
    
}

//MARK: - UIImagePickerControllerDelegate

extension RegistrationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let selectedImage = info[.originalImage] as? UIImage else {return}
        
        profileImage = selectedImage
        viewModel.profileImage = selectedImage
        
        uploadProfileButton.setImage(selectedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        uploadProfileButton.layer.cornerRadius = 20
        uploadProfileButton.layer.masksToBounds = true
        
        dismiss(animated: true, completion: nil)
        
        updateForm()
        
    }
    
}
