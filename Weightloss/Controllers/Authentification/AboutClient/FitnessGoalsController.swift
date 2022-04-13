//
//  FitnessGoalsController.swift
//  Weightloss
//
//  Created by benny mushiya on 04/05/2021.
//

import UIKit


class FitnessGoalsController: UIViewController {
    
    //MARK: - PROPERTIES
    
    private let topBackgroundImage: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "fitnessGoals")
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
        let label = AuthLabels(title: "What is Your Fitness Goals")
        label.font = UIFont.systemFont(ofSize: 25, weight: .black)
        label.textAlignment = .left
        label.textColor = .black
        
        return label
    }()
    
    private let descriptionLabel: AuthLabels = {
        let label = AuthLabels(title: "Below write a few lines to describes your fitness goals")
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.textAlignment = .left
        label.textColor = .black

        
        return label
    }()
    
    private let textView: UITextView = {
        let tv = UITextView()
        tv.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        tv.setHeight(200)
        tv.layer.cornerRadius = 20
        
        return tv
    }()
    
    let alertMessageLabel: AlertMessage = {
        let label = AlertMessage(title: "Please Enter Your Fitness Goal")
        
        return label
    }()
    
    
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
        setUpBackgroundTouch()
        
    }
    
    //MARK: - HELPERS
    
    func configureUI() {
        
        view.backgroundColor = .white
        
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
        
        view.insertSubview(topBackgroundImage, at: 0)
        topBackgroundImage.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0)
        
        
        let labelStack = UIStackView(arrangedSubviews: [headlineLabel, descriptionLabel])
        labelStack.axis = .vertical
        labelStack.spacing = 10
        
        view.addSubview(labelStack)
        labelStack.centerX(inView: view, topAnchor: topBackgroundImage.bottomAnchor, paddingTop: 20)
        labelStack.anchor(left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 20, paddingRight: 20)
        
        let textViewStack = UIStackView(arrangedSubviews: [textView, alertMessageLabel])
        textViewStack.axis = .vertical
        textViewStack.spacing = 10
        
        view.addSubview(textViewStack)
        textViewStack.centerX(inView: view)
        textViewStack.anchor(top: labelStack.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 30, paddingLeft: 20, paddingRight: 20)
        
        let buttonStack = UIStackView(arrangedSubviews: [backButton, continueButton])
        buttonStack.axis = .horizontal
        buttonStack.spacing = 200
        
        view.addSubview(buttonStack)
        buttonStack.centerX(inView: view)
        buttonStack.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingLeft: 20, paddingBottom: 40, paddingRight: 20)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleFinishingEditing), name: UITextView.textDidChangeNotification, object: nil)
        
    }
    
    //MARK: - SELECTORS
    
    @objc func handleFinishingEditing() {
        
        continueButton.isEnabled = true
        continueButton.backgroundColor = #colorLiteral(red: 0.1598605525, green: 0.9373220266, blue: 0.7734893539, alpha: 1)
        
    }
    
    @objc func handleBack() {
        
        //let controller = CurrentAndFutureGoalsController()
       // navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func handleNextPage() {
        
        guard let fitnessGoals = textView.text else { return }
        
        if fitnessGoals != "" {
            
            InputDetails.shared.fitnessGoals = fitnessGoals
            let controller = BackgroundImageController()
            navigationController?.pushViewController(controller, animated: true)
            
        } else {
            
            alertMessageLabel.alpha = 1
        }
    }
    
    @objc func handleTap() {
        
        alertMessageLabel.alpha = 0
        textView.resignFirstResponder()
    }
    
    //MARK: - ACTION

    func setUpBackgroundTouch() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
        
    }
}
