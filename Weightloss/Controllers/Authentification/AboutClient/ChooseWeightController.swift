//
//  ChooseWeightController.swift
//  Weightloss
//
//  Created by benny mushiya on 04/02/2022.
//

import UIKit


class ChooseWeightCategoryController: UIViewController {
    
    
    //MARK: - PROPERTIES
    
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
    
    
    private let topBackgroundImage: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "pickWeightLoss")
        iv.setHeight(250)
        
        return iv
    }()
    
    private var weightLossCommunity: String = ""
    private var weightGainCommunity: String = ""
    
    private let ChooseCommunityLabel: AuthLabels = {
        let label = AuthLabels(title: "Whats the reason you want to become a better Leader?")
        label.font = UIFont.systemFont(ofSize: 28, weight: .black)
        label.textAlignment = .left
        label.textColor = .black
        
        return label
    }()
    
    private let descriptionLabel: AuthLabels = {
        let label = AuthLabels(title: "Which of these areas would you like to focus on the most ")
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.textAlignment = .left
        label.textColor = .black

        return label
    }()
    
    
    
    private let weightLossButton: ChooseCommunityButton = {
        let button = ChooseCommunityButton(image: UIImage(systemName: "newspaper.fill"), type: .custom, title: " Weight loss")
        
        button.imageView?.centerY(inView: button)
        button.imageView?.anchor(left: button.leftAnchor, paddingLeft: 30)
        button.titleLabel?.anchor(left: button.imageView?.rightAnchor, paddingLeft: 50)
        
        button.addTarget(self, action: #selector(handleWeightLoss), for: .touchUpInside)

        return button
    }()
    
    
    private let weightGainButton: ChooseCommunityButton = {
        let button = ChooseCommunityButton(image: UIImage(systemName: "newspaper.fill"), type: .custom, title: " Muscle gain")
        
        button.imageView?.centerY(inView: button)
        button.imageView?.anchor(left: button.leftAnchor, paddingLeft: 30)
        button.titleLabel?.anchor(left: button.imageView?.rightAnchor, paddingLeft: 50)
        
        button.addTarget(self, action: #selector(handleWeightGain), for: .touchUpInside)

        return button
    }()
    
    private var termsAndConditionButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.numberOfLines = 0
        button.attributedTitle(firstPart: "By continuing you are agreeing to the", secondPart: "Terms and Conditions of B+")
        
        button.addTarget(self, action: #selector(handleTermsAndCondition), for: .touchUpInside)
        
        return button
    }()
    
    
    //MARK: - LIFEYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
    }
    
    
    //MARK: - HELPERS
    
    func configureUI() {
        
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
        
        view.insertSubview(topBackgroundImage, at: 0)
        topBackgroundImage.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0)
        
       
        let labelStack = UIStackView(arrangedSubviews: [ChooseCommunityLabel, descriptionLabel])
        labelStack.axis = .vertical
        labelStack.spacing = 10
        
        
        view.addSubview(labelStack)
        labelStack.anchor(top: topBackgroundImage.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 20, paddingRight: 20)
        

        let buttonStack = UIStackView(arrangedSubviews: [weightLossButton, weightGainButton])
        buttonStack.axis = .vertical
        buttonStack.spacing = 20
        buttonStack.distribution = .fillEqually

        view.addSubview(buttonStack)
        buttonStack.centerX(inView: view)
        buttonStack.anchor(top: labelStack.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 40, paddingLeft: 20, paddingRight: 20)
        
        let bottomStack = UIStackView(arrangedSubviews: [backButton, termsAndConditionButton ])
        bottomStack.axis = .horizontal
        bottomStack.spacing = 100
    
        view.addSubview(bottomStack)
        bottomStack.centerX(inView: view)
        bottomStack.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingLeft: 20, paddingBottom: 40, paddingRight: 10)
        
//        view.addSubview(backButton)
//        backButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingLeft: 20, paddingBottom: 40)
      
        
    }
    
    
    //MARK: - ACTION
    
    @objc func handleBack() {
        
        let controller = RegistrationController()
        navigationController?.pushViewController(controller, animated: true)
        
    }
    
    
    @objc func handleTermsAndCondition() {
        
        let controller = TermsAndConditionsController()
        navigationController?.pushViewController(controller, animated: true)
        
        
    }
    
    @objc func handleWeightLoss() {
        
        switch weightLossButton.isSelected {
        case true:
            print("its wegihtloss")
        
        case false:
            
            weightLossCommunity.append("WeightLossCommunity")
            InputDetails.shared.chosenCommunity = weightLossCommunity
            //let controller = CurrentAndFutureGoalsController()
           // navigationController?.pushViewController(controller, animated: true)
            
            print(InputDetails.shared.chosenCommunity)


        }
        
    }
    
    
    @objc func handleWeightGain() {
        
        switch weightGainButton.isSelected {
        case true:
            print("its weightgain lad ")
        case false:
            
            weightGainCommunity.append("weightGainCommunity")
            InputDetails.shared.chosenCommunity = weightGainCommunity
            //let controller = CurrentAndFutureGoalsController()
            //navigationController?.pushViewController(controller, animated: true)
            
            print(InputDetails.shared.chosenCommunity)

        
        }
       
    }
    
}

