//
//  PaperOnboardingController.swift
//  Weightloss
//
//  Created by benny mushiya on 16/11/2021.
//

import UIKit
import paper_onboarding


class PaperOnboardingController: UIViewController {
    
    //MARK: - PROPERTIES
    
    private var onboardingItems = [OnboardingItemInfo]()
    private var onboardingView = PaperOnboarding()
   
    private let signUpButton: AuthButton = {
        let button = AuthButton(title: "Get Started", type: .system)
        button.isEnabled = true
        button.alpha = 0
        button.backgroundColor = .clear
        button.setTitleColor(.white, for: .normal)
        button.layer.borderColor = #colorLiteral(red: 0.1598605525, green: 0.9373220266, blue: 0.7734893539, alpha: 1)
        button.layer.borderWidth = 5.0
        
        button.addTarget(self, action: #selector(handleRegistration), for: .touchUpInside)

        return button
    }()
    
    private let logInButton: AuthButton = {
        let button = AuthButton(title: "Log In", type: .system)
        button.isEnabled = true
        button.alpha = 0
        button.backgroundColor = #colorLiteral(red: 0.1598605525, green: 0.9373220266, blue: 0.7734893539, alpha: 1)
        button.setTitleColor(.black, for: .normal)
        
        button.addTarget(self, action: #selector(handleLogIn), for: .touchUpInside)

        return button
    }()
    
    
    
    
    //MARK: - LIFECYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureOnboardingDataSource()
    }
    
    //MARK: - HELPERS
    
    func animateGetStartedButtons(_ shouldShow: Bool) {
        
        // an alpha of 1 means its showing an alpha of 0 means it hidden. so below we are saying if shouldshow is 1 then its true if its 0 then its false
        let alpha: CGFloat = shouldShow ? 1 : 0
        
        // here we call the buttons to show/animate if it returns true.
        UIView.animate(withDuration: 0.9) {
            self.logInButton.alpha = alpha
            self.signUpButton.alpha = alpha

        }
        
    }
    
    
    func configureUI() {
        
        navigationController?.navigationBar.isHidden = true
        
        view.addSubview(onboardingView)
        onboardingView.fillSuperview()
        onboardingView.delegate = self
        
        let buttonStack = UIStackView(arrangedSubviews: [signUpButton, logInButton])
        buttonStack.axis = .horizontal
        buttonStack.spacing = 20
        buttonStack.distribution = .fillEqually
        
        view.addSubview(buttonStack)
        buttonStack.centerX(inView: view)
        buttonStack.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingLeft: 20, paddingBottom: 70, paddingRight: 20)
        
    }
    
    
    func configureOnboardingDataSource() {
        
        let item1 = OnboardingItemInfo(informationImage: #imageLiteral(resourceName: "app_icon-2").withRenderingMode(.alwaysOriginal), title: FIRST_ONBOARDING_TITLE, description: FIRST_ONBOARDING_DESCRIPTION, pageIcon: UIImage(), color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), titleColor: #colorLiteral(red: 0.1598605525, green: 0.9373220266, blue: 0.7734893539, alpha: 1), descriptionColor: .white, titleFont: UIFont.systemFont(ofSize: 20, weight: .heavy), descriptionFont: UIFont.boldSystemFont(ofSize: 20))
        
        let item2 = OnboardingItemInfo(informationImage: #imageLiteral(resourceName: "app_icon-2").withRenderingMode(.alwaysOriginal), title: SECOND_ONBOARDING_TITLE, description: SECOND_ONBOARDING_MESSAGE, pageIcon: UIImage(), color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), titleColor: #colorLiteral(red: 0.1598605525, green: 0.9373220266, blue: 0.7734893539, alpha: 1), descriptionColor: .white, titleFont: UIFont.systemFont(ofSize: 20, weight: .heavy), descriptionFont: UIFont.boldSystemFont(ofSize: 20))
        
        let item3 = OnboardingItemInfo(informationImage: #imageLiteral(resourceName: "app_icon-2").withRenderingMode(.alwaysOriginal), title: THIRD_ONBOARDING_TITLE, description: THIRD_ONBOARDING_MESSAGE, pageIcon: UIImage(), color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) , titleColor: #colorLiteral(red: 0.1598605525, green: 0.9373220266, blue: 0.7734893539, alpha: 1), descriptionColor: .white, titleFont: UIFont.systemFont(ofSize: 20, weight: .heavy), descriptionFont: UIFont.boldSystemFont(ofSize: 20))
        
        
        onboardingItems.append(item1)
        onboardingItems.append(item2)
        onboardingItems.append(item3)
        
       onboardingView.dataSource = self
       onboardingView.reloadInputViews()
        
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

    //MARK: - PaperOnboardingDataSource


extension PaperOnboardingController: PaperOnboardingDataSource {
    
    func onboardingItemsCount() -> Int {
        
        return onboardingItems.count
    }
    
    func onboardingItem(at index: Int) -> OnboardingItemInfo {
        
        return onboardingItems[index]
    }
    
}

//MARK: - PaperOnboardingDelegate

extension PaperOnboardingController: PaperOnboardingDelegate {
    
    func onboardingDidTransitonToIndex(_ index: Int) {
        
        // if the index is equal to the array count - 1 which is 2, then return true else returns false. no matter how manny items you have if you do it like this then its the most effiecient algorithem.
        let shouldShow = index == onboardingItems.count - 1 ? true : false
        
        animateGetStartedButtons(shouldShow)
        
    }
    
}
    

