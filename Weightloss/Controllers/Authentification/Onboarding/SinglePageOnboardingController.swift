//
//  SinglePageOnboardingController.swift
//  Weightloss
//
//  Created by benny mushiya on 18/02/2022.
//

import UIKit
import SwiftUI


class SinglePageOnboardingController: UIViewController {
    
    //MARK: - PROPERTIES
    
    
    private let backgroundLogo: LogoImage = {
        let iv = LogoImage(image: "app_icon-2")
        iv.setDimensions(height: 550, width: 550)
        iv.backgroundColor = .black
        
        return iv
    }()
    
    private let headlineLabel: AuthLabels = {
        let label = AuthLabels(title: "Connect & Learn")
        label.font = UIFont.systemFont(ofSize: 30, weight: .black)
        label.textAlignment = .center
        label.textColor = .white
        
        return label
    }()
    
    private let descriptionLabel: AuthLabels = {
        let label = AuthLabels(title: "Join A Community That Helps You Get Closer To Your Goals. Interact and Challenge yourself with Monthly Challenges To Help Develop Good Habits.")
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.textAlignment = .center
        label.textColor = .white

        
        return label
    }()
    
   
    private let signUpButton: AuthButton = {
        let button = AuthButton(title: "GET STARTED", type: .system)
        button.isEnabled = true
        button.backgroundColor = .clear
        button.setTitleColor(.white, for: .normal)
        button.layer.borderColor = #colorLiteral(red: 0.1598605525, green: 0.9373220266, blue: 0.7734893539, alpha: 1)
        button.layer.borderWidth = 5.0
        button.layer.cornerRadius = 50 / 2
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        
        button.addTarget(self, action: #selector(handleRegistration), for: .touchUpInside)

        return button
    }()
    
    private let logInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.white, for: .normal)
        button.attributedTitle(firstPart: "Already have an account?", secondPart: "Log In")
        
        button.addTarget(self, action: #selector(handleLogIn), for: .touchUpInside)

        return button
    }()
    
    
    //MARK: - LIFECYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
    }
    
    //MARK: - HELPERS
    
    
    func configureUI() {
        
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        view.addSubview(backgroundLogo)
        backgroundLogo.centerX(inView: view)
        backgroundLogo.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 100, paddingLeft: 10, paddingRight: 10)
        
        let labelStack = UIStackView(arrangedSubviews: [headlineLabel, descriptionLabel])
        labelStack.axis = .vertical
        labelStack.spacing = 10
        
        view.addSubview(labelStack)
        labelStack.centerX(inView: view)
        labelStack.anchor(top: backgroundLogo.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 100, paddingLeft: 10, paddingRight: 10)
        
        
        let buttonStack = UIStackView(arrangedSubviews: [signUpButton, logInButton])
        buttonStack.axis = .vertical
        buttonStack.spacing = 50
        buttonStack.distribution = .fillEqually
        
        view.addSubview(buttonStack)
        buttonStack.centerX(inView: view)
        buttonStack.anchor(top: labelStack.bottomAnchor, paddingTop: 150)
        
        
    }


     //MARK: - SELECTORS
    
    @objc func handleRegistration() {
        
        let controller = RegistrationController()
        navigationController?.pushViewController(controller, animated: true)
        
    }
    
    @objc func handleLogIn() {
        
        let controller = LogInController()
        navigationController?.pushViewController(controller, animated: true)
        
        
    }
}

    
