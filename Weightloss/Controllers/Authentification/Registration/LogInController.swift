//
//  LogInController.swift
//  Weightloss
//
//  Created by benny mushiya on 27/04/2021.
//

import UIKit
import SwiftUI

protocol AuthentificationDidComplete: class {
    
    func authentificationDidComplete()
}

class LogInController: UIViewController {
    
    
    //MARK: - PROPERTIES
    
    weak var delegate: AuthentificationDidComplete?
    
    
    private let logInLabel: SmallFontLabel = {
        let label = SmallFontLabel(title: "Log In Now")
        label.font = UIFont.systemFont(ofSize: 40, weight: .black)
        
        return label
    }()
    
    private let RegistrationPageButton: UIButton = {
        let button = UIButton(type: .system)
        button.attributedTitle(firstPart: "Are You New?", secondPart: "Create Account")
        
        button.addTarget(self, action: #selector(handleRegistrationPage), for: .touchUpInside)
        
        return button
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
    
    private var resetPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.attributedTitle(firstPart: "Forgot Password?", secondPart: "Reset Here")
        
        button.addTarget(self, action: #selector(handleResetPassword), for: .touchUpInside)
        
        return button
    }()
    
    private let logInButton: AuthButton = {
        let button = AuthButton(title: "Log In", type: .system)
        button.layer.cornerRadius = 50 / 2
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .black)
        button.backgroundColor = .black
        button.layer.borderWidth = 5
        button.layer.borderColor = #colorLiteral(red: 0.1598605525, green: 0.9373220266, blue: 0.7734893539, alpha: 1)
        button.setDimensions(height: 50, width: 180)
        
        button.addTarget(self, action: #selector(handleNext), for: .touchUpInside)


        return button
    }()
    
    private var viewModel = LogInViewModel()
    
    private let backgroundImageController = BackgroundImageController()
    
    //MARK: - LIFECYCLE

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        gestureRecogniser()
        
    }
    
    //MARK: - HELPERS

    func configureUI() {
        
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
        
        backgroundImageController.delegate = delegate
        
       
        let topStack = UIStackView(arrangedSubviews: [logInLabel, RegistrationPageButton])
        topStack.axis = .vertical
        topStack.spacing = 20
        topStack.distribution = .fillEqually
        
        
        view.addSubview(topStack)
        topStack.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingTop: 150, paddingLeft: 20)
        
    
        
        let textFieldStack = UIStackView(arrangedSubviews: [emailTextField, passwordTextField])
        textFieldStack.axis = .vertical
        textFieldStack.spacing = 20
        
        view.addSubview(textFieldStack)
        textFieldStack.centerX(inView: view)
        textFieldStack.anchor(top: topStack.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 70, paddingLeft: 30, paddingRight: 30)
        
        view.addSubview(resetPasswordButton)
        resetPasswordButton.anchor(top: textFieldStack.bottomAnchor, left: view.leftAnchor, paddingTop: 30, paddingLeft: 30)
        
        view.addSubview(logInButton)
        logInButton.anchor(top: resetPasswordButton.bottomAnchor, right: view.rightAnchor, paddingTop: 50, paddingRight: 30)
       
        
        
    }
    
    //MARK: - SELECTORS

    @objc func handleRegistrationPage() {
        
        let controller = RegistrationController()
        navigationController?.pushViewController(controller, animated: true)
        
    }
    
    @objc func handleEditingChanged(sender: UITextField) {
        
        if sender == emailTextField {
            
            viewModel.email = sender.text
            
        }else {
            
            viewModel.password = sender.text
        }
       
        updateForm()
        
    }
    
    
    @objc func handleNext() {
        
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        
        showLoader(true)
        
        AuthServices.logUserIn(withEmail: email, password: password) { results, error in
            self.showLoader(false)

            if let error = error {
                
                print("DEBUGG: failed to log user in \(error.localizedDescription)")
                self.showMessage(withTitle: "ERROR", message: error.localizedDescription)
                return
            }
            
            self.delegate?.authentificationDidComplete()
            print("successfully logged user in")
            let controller = MainTabBarController()
            self.navigationController?.pushViewController(controller, animated: true)
        }

    }
    
    @objc func handleTap() {
        
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
    }
    
    
    @objc func handleResetPassword() {
        
        let controller = ResetPasswordController()
        controller.email = emailTextField.text
        controller.delegate = self
        navigationController?.pushViewController(controller, animated: true)
        
    }
    
    //MARK: - ACTION

    func updateForm() {
        
        logInButton.isEnabled = viewModel.formIsValid
        logInButton.backgroundColor = viewModel.changeButtonColor
        logInButton.setTitle(viewModel.changeButtonText, for: .normal)
        
    }
    
    func gestureRecogniser() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tap)
    }
    
}

//MARK: - ResetPasswordControllerDelegate

extension LogInController: ResetPasswordControllerDelegate {
    
    func controllerDidSendResetPasswordLink(_ controller: ResetPasswordController) {
        
        navigationController?.popViewController(animated: true)
        showMessage(withTitle: "Success", message: "we sent the link to your email.")
        
    }
    
}


