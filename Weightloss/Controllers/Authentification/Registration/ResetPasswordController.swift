//
//  EndOfRegistrationController.swift
//  Weightloss
//
//  Created by benny mushiya on 26/04/2021.
//

import UIKit


protocol ResetPasswordControllerDelegate: class {
    func controllerDidSendResetPasswordLink(_ controller: ResetPasswordController)
}

class ResetPasswordController: UIViewController {
    
    
    //MARK: - PROPERTIES
    
    weak var delegate: ResetPasswordControllerDelegate?
    
    var email: String?
    
    private var viewModel = resetPasswordViewModel()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrowshape.turn.up.backward.2.circle.fill"), for: .normal)
        button.setDimensions(height: 46, width: 46)
        button.tintColor = .white
        button.backgroundColor = #colorLiteral(red: 0.1598605525, green: 0.9373220266, blue: 0.7734893539, alpha: 1)
        button.layer.cornerRadius = 20
        button.isEnabled = true
        
        button.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        
        return button
    }()
    
    private var titleLabel: AuthLabels = {
        let label = AuthLabels(title: "Reset Password")
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 30, weight: .black)
        label.textAlignment = .left
        
        return label
    }()
    
    private var descriptionLabel: AuthLabels = {
        let label = AuthLabels(title: "Enter the email associated with your account and we'll send an email with instructions on how to reset your password.")
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 15)
        
        return label
    }()
    
    private let emailTextField: CustomTextField = {
        let tf = CustomTextField(placeHolder: "Email")
        tf.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        
        return tf
    }()
    
    private let sendInstructionsButton: AuthButton = {
        let button = AuthButton(title: "Send Instructions", type: .system)
        button.layer.cornerRadius = 50 / 2
        button.backgroundColor = #colorLiteral(red: 0.1598605525, green: 0.9373220266, blue: 0.7734893539, alpha: 1)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .black)
        button.addTarget(self, action: #selector(handleFinish), for: .touchUpInside)
        
        return button
    }()
    
    //MARK: - LIFECYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
    }
    
    //MARK: - HELPERS
    
    private func configureUI() {
        
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
        
        emailTextField.text = email
        viewModel.email = email
        
        view.addSubview(backButton)
        backButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingTop: 5, paddingLeft: 10)
        
        let labelStack = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel])
        labelStack.axis = .vertical
        labelStack.spacing = 5
        
        view.addSubview(labelStack)
        labelStack.anchor(top: backButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 40, paddingLeft: 10, paddingRight: 10)
        
        let buttonStack = UIStackView(arrangedSubviews: [emailTextField, sendInstructionsButton])
        buttonStack.axis = .vertical
        buttonStack.spacing = 30
        
        view.addSubview(buttonStack)
        buttonStack.anchor(top: labelStack.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 10, paddingRight: 10)
        
    }
    
    //MARK: - SELECTORS
    
    @objc func textDidChange(sender: UITextField) {
        
        if sender == emailTextField {
            
            viewModel.email = sender.text
        }
        
        updateForm()
        
    }
    
    @objc func handleBack() {
        
        let controller = LogInController()
        navigationController?.pushViewController(controller, animated: true)
        
    }
    
    @objc func handleFinish() {
        
        guard let email = emailTextField.text else {return}
        
        showLoader(true)
        AuthServices.resetPassword(withEmail: email) { error in
            if let error = error {
                
                self.showLoader(false)
                self.showMessage(withTitle: "ERROR", message: error.localizedDescription)
                return
            }
            
            self.delegate?.controllerDidSendResetPasswordLink(self)
            
        }
        
    }

    //MARK: - ACTION
    
    func updateForm() {
        
        sendInstructionsButton.backgroundColor = viewModel.buttonBackgroundColor
        sendInstructionsButton.isEnabled = viewModel.formIsValid
    }
    
    
}

