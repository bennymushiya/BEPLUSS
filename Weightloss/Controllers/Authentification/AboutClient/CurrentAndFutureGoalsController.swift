//
//  CurrentAndFutureGoalsController.swift
//  Weightloss
//
//  Created by benny mushiya on 30/07/2021.
//

//import UIKit
//
//
//class CurrentAndFutureGoalsController: UIViewController {
//    
//    //MARK: - PROPERTIES
//    
//    private let topImage: UIImageView = {
//        let iv = UIImageView()
//        iv.image = UIImage(named: "pickWeight")
//        
//        return iv
//    }()
//    
//    private let currentWeightTitle: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.systemFont(ofSize: 20, weight: .black)
//        label.text = "whats your current weight"
//        label.textColor = .black
//        
//        return label
//    }()
//    
//    private lazy var weightSlider: UISlider = {
//        let slider = UISlider()
//        slider.tintColor = #colorLiteral(red: 0.1598605525, green: 0.9373220266, blue: 0.7734893539, alpha: 1)
//        slider.addTarget(self, action: #selector(handleSliderChanged), for: .valueChanged)
//        
//        return slider
//    }()
//    
//    private var weightNumber: UILabel = {
//        let label = UILabel()
//        label.text = "0KG"
//        
//        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
//        label.textColor = .black
//        
//        return label
//    }()
//    
//    private let goalWeightTitle: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.systemFont(ofSize: 20, weight: .black)
//        label.text = "Whats your Target Weight"
//        label.textColor = .black
//
//        
//        return label
//    }()
//    
//    private var goalWeightNumber: UILabel = {
//        let label = UILabel()
//        label.text = "0KG"
//        
//        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
//        label.textColor = .black
//
//        
//        return label
//    }()
//    
//    private lazy var goalWeightSlider: UISlider = {
//        let slider = UISlider()
//        slider.tintColor = #colorLiteral(red: 0.1598605525, green: 0.9373220266, blue: 0.7734893539, alpha: 1)
//        
//        slider.addTarget(self, action: #selector(handleGoalWeightSlider), for: .valueChanged)
//        
//        return slider
//    }()
//    
//    private lazy var backButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.setImage(UIImage(systemName: "arrowshape.turn.up.backward.2.circle.fill"), for: .normal)
//        button.setDimensions(height: 56, width: 56)
//        button.tintColor = .white
//        button.backgroundColor = #colorLiteral(red: 0.1598605525, green: 0.9373220266, blue: 0.7734893539, alpha: 1)
//        button.layer.cornerRadius = 20
//        button.isEnabled = true
//        button.imageView?.setDimensions(height: 30, width: 30)
//        
//        button.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
//        
//        return button
//    }()
//    
//    private let nextButton: AuthButton = {
//        let button = AuthButton(title: "Next", type: .system)
//        button.setWidth(100)
//        button.backgroundColor = #colorLiteral(red: 0.1598605525, green: 0.9373220266, blue: 0.7734893539, alpha: 1)
//        button.isEnabled = true
//        button.addTarget(self, action: #selector(handleNextPage), for: .touchUpInside)
//        
//        return button
//    }()
//    
//    //MARK: - LIFECYCLE
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        configureUI()
//        
//    }
//    
//    //MARK: - HELPERS
//    
//    func configureUI() {
//        
//        view.backgroundColor = .white
//        navigationController?.navigationBar.isHidden = true
//        navigationController?.navigationBar.barStyle = .black
//        
//        view.addSubview(topImage)
//        topImage.centerX(inView: view)
//        topImage.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 600, paddingRight: 0)
//        
//        let currentWeightStack = UIStackView(arrangedSubviews: [currentWeightTitle, weightNumber, weightSlider])
//        currentWeightStack.axis = .vertical
//        currentWeightStack.spacing = 5
//        
//        view.addSubview(currentWeightStack)
//        currentWeightStack.anchor(top: topImage.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 10, paddingRight: 10)
//        
//        let goalWeightStack = UIStackView(arrangedSubviews: [goalWeightTitle, goalWeightNumber, goalWeightSlider])
//        goalWeightStack.axis = .vertical
//        goalWeightStack.spacing = 5
//        
//        view.addSubview(goalWeightStack)
//        goalWeightStack.anchor(top: currentWeightStack.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 50, paddingLeft: 10, paddingRight: 10)
//        
//        let buttonStack = UIStackView(arrangedSubviews: [backButton, nextButton])
//        buttonStack.axis = .horizontal
//        buttonStack.spacing = 200
//        
//        view.addSubview(buttonStack)
//        buttonStack.centerX(inView: view)
//        buttonStack.anchor(top: goalWeightStack.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 50, paddingLeft: 20, paddingRight: 20)
//        
//    }
//    
//    //MARK: - ACTION
//    
//    @objc func handleSliderChanged(sender: UISlider) {
//        
//        let weight = sender.value
//        let actaulWeight = (Int)(weight * 270)
//        
//        weightNumber.text = "\(actaulWeight)Kg"
//        
//    }
//    
//    
//    @objc func handleGoalWeightSlider(sender: UISlider) {
//        
//        let goalWeight = sender.value
//        let actualGoalWeight = (Int)(goalWeight * 270)
//        
//        goalWeightNumber.text = "\(actualGoalWeight)Kg"
//        
//    }
//    
//    @objc func handleBack() {
//    
//        let controller = ChooseWeightCategoryController()
//        navigationController?.pushViewController(controller, animated: true)
//    
//        
//    }
//    
//    
//    @objc func handleNextPage() {
//        
//        let currentWeight = (Int)(weightSlider.value * 270)
//        let goalWeight = (Int)(goalWeightSlider.value * 270)
//        
//        if weightSlider.value > 0 && goalWeightSlider.value > 0  {
//            
//            InputDetails.shared.currentWeight = currentWeight
//            InputDetails.shared.futureGoalWeight = goalWeight
//            
//            let controller = FitnessGoalsController()
//            navigationController?.pushViewController(controller, animated: true)
//            
//        }else {
//            
//            showMessage(withTitle: "ERROR", message: "please choose your chosen weight ")
//        }
//       
//    }
//}
