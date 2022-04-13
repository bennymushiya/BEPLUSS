//
//  ChallengesHeader.swift
//  Weightloss
//
//  Created by benny mushiya on 18/06/2021.
//

import UIKit


protocol ChallengesHeaderDelegate: class {
    func filter(_ filter: ChallengeFilterOptions)
}

class ChallengesHeader: UICollectionReusableView {
    
    
    //MARK: - PROPERITES
    
    var viewModel: ChallengesHeaderViewModel? {
        didSet{configureViewModel()}
        
    }
    
    weak  var delegate: ChallengesHeaderDelegate?
    
     let currentGoalImage: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        button.setDimensions(height: 100, width: 100)
        button.layer.cornerRadius = 100 / 2
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .black)
        button.setTitleColor(.white, for: .normal)
        button.layer.borderWidth = 4.0
        button.layer.borderColor = #colorLiteral(red: 0.1598605525, green: 0.9373220266, blue: 0.7734893539, alpha: 1)
        
        return button
    }()
    
    private let currentGoalLabel: SmallFontLabel = {
        let label = SmallFontLabel(title: "Current weight")
        label.font = UIFont.systemFont(ofSize: 15, weight: .black)
        
        return label
    }()
    
    
    private let differenceImage: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        button.setDimensions(height: 100, width: 100)
        button.layer.cornerRadius = 100 / 2
        button.setTitle("10Kg", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .black)
        button.setTitleColor(.white, for: .normal)
        button.layer.borderWidth = 4.0
        button.layer.borderColor = #colorLiteral(red: 0.1598605525, green: 0.9373220266, blue: 0.7734893539, alpha: 1)
        
        return button
    }()
    
    private let differenceLabel: SmallFontLabel = {
        let label = SmallFontLabel(title: "Difference")
        label.font = UIFont.systemFont(ofSize: 15, weight: .black)
        
        return label
    }()
    
    
    private let GoalImage: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        button.setDimensions(height: 100, width: 100)
        button.layer.cornerRadius = 100 / 2
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .black)
        button.setTitleColor(.white, for: .normal)
        button.layer.borderWidth = 4.0
        button.layer.borderColor = #colorLiteral(red: 0.1598605525, green: 0.9373220266, blue: 0.7734893539, alpha: 1)
        
        return button
    }()
    
    private let GoalLabel: SmallFontLabel = {
        let label = SmallFontLabel(title: "Goal weight")
        label.font = UIFont.systemFont(ofSize: 15, weight: .black)
        
        return label
    }()
    
    private var filterView = ChallengeFiltierView()

    //MARK: - LIFEYCLE
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - HELPERS
    
    func configureUI() {
        
        backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        filterView.delegate = self
       
        let topStack = UIStackView(arrangedSubviews: [currentGoalImage, differenceImage, GoalImage])
        topStack.axis = .horizontal
        topStack.spacing = 10
        topStack.alignment = .leading
        topStack.distribution = .equalSpacing
        
        addSubview(topStack)
        topStack.centerX(inView: self)
        topStack.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 10, paddingLeft: 10, paddingRight: 10)
        
        let bottomStack = UIStackView(arrangedSubviews: [currentGoalLabel, differenceLabel, GoalLabel])
        bottomStack.axis = .horizontal
        bottomStack.spacing = 10
        bottomStack.alignment = .leading
        bottomStack.distribution = .equalSpacing

        addSubview(bottomStack)
        bottomStack.anchor(top: topStack.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 10, paddingLeft: 10, paddingRight: 10)
        
        addSubview(filterView)
        filterView.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, height: 50)
        
    }
    
    //MARK: - ACTION
    
    func configureViewModel() {
        
        guard let viewModels = viewModel else {return}
        
        currentGoalImage.setTitle(viewModels.currentWeightGoal, for: .normal)
        GoalImage.setTitle(viewModels.futureWeightGoal, for: .normal)
        differenceImage.setTitle("\(viewModels.differenceBetweenCurrentAndGoalWeight)KG", for: .normal)
        
        
    }
   
}

//MARK: - ChallengeFiltierViewDelegate

extension ChallengesHeader: ChallengeFiltierViewDelegate {
    
    
    func filterView(_ view: ChallengeFiltierView, didSelect index: Int) {
        
        guard let filter = ChallengeFilterOptions(rawValue: index) else {return}
        
        delegate?.filter(filter)


    }

    
}
