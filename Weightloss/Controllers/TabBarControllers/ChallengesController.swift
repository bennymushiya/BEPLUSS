//
//  ChallengesController.swift
//  Weightloss
//
//  Created by benny mushiya on 18/06/2021.
//

import UIKit
import Firebase
import FirebaseAuth


private let headerIdentifier = "challenge header"
private let reuseIdentifier = "challenge cell"

class ChallengesController: UICollectionViewController {
    
    //MARK: - PROPERTIES
    
    private var user: User
   
    
    private lazy var chatButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "text.bubble.fill"), for: .normal)
        button.tintColor = .white
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 10)
        button.setDimensions(height: 46, width: 46)
      
        button.addTarget(self, action: #selector(handleChat), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var notificationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "note.text.badge.plus"), for: .normal)
        button.tintColor = .white
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 10)
        button.setDimensions(height: 46, width: 46)
        
        button.addTarget(self, action: #selector(handleNotification), for: .touchUpInside)

        
        return button
    }()
    
    private lazy var updateGoalButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "timelapse"), for: .normal)
        button.tintColor = .white
        button.setDimensions(height: 46, width: 46)
        
        button.addTarget(self, action: #selector(handleUpdateGoal), for: .touchUpInside)
        
        return button
    }()
    
    private let challengeLabel: UILabel = {
        let label = UILabel()
        label.text = "Monthly Challenges"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 20, weight: .black)
        
        return label
    }()
    
    private var selectedFilter: ChallengeFilterOptions = .weightLoss {
        didSet{collectionView.reloadData()}
    }
    
    private var weightLossChallenges = [
    
        ChallengesModel(month: "February 2022", description: "REDUCE SUGAR INTAKE TO ONCE A WEEK", benefits: "Benefits", benefitsDescription: " * Younger looking Skin \n\n * Bye bye to abdominal fat \n\n * Lasting energy"),
        
        
        ChallengesModel(month: "March 2022", description: "BEGIN INTERMITTENT FASTING", benefits: "Benefits", benefitsDescription: "* Has benefits for your brain \n\n * Extends your lifespan \n\n * Reduces the chances of heart disease "),
        
        ChallengesModel(month: "April 2022", description: "BEGIN TO EXERCISE 5 TIMES A WEEK", benefits: "Benefits", benefitsDescription: "* Lower blood pressure and improve heart health. \n\n * Reduce feelings of anxiety and depression \n\n * improve your quality of sleep "),

    ]
    
    
    private var weightGainChallenges = [
        
        ChallengesModel(month: "February 2022", description: "EAT WHOLE FOODS 90% OF THE TIME", benefits: "Benefits", benefitsDescription: "* Healthy heart \n\n * More energy from food sources \n\n * Decrease consumptions of unhealthy sugars"),
        
        ChallengesModel(month: "March 2021", description: "EAT MORE PROTEIN IN YOUR DIET", benefits: "Benefits", benefitsDescription: "* Increases muscle mass and strength \n\n * Boosts metabolism and increases fat burning \n\n * Helps your body repair itself after injury "),

    ]
    
    private var currentDataSource: [ChallengesModel] {
        
        switch selectedFilter {
        
        case .weightLoss: return weightLossChallenges
            
        case .weightGain: return weightGainChallenges
            
       // case .quotes: return dailyQuotes
            
        }
        
    }
    
    //MARK: - LIFECYCLE
    
    init(user: User) {
        self.user = user
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        fetchUser()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        displayPostButton()
        navigationController?.navigationBar.isHidden = false
        self.collectionView.reloadData()
    }
    
    //MARK: - HELPERS
    
    func configureUI() {
        
        navigationItem.title = "Challenges"
        
        let notificationButton = UIBarButtonItem(customView: notificationButton)
        let chatButton = UIBarButtonItem(customView: chatButton)
        let updateGoal = UIBarButtonItem(customView: updateGoalButton)
        
        navigationItem.rightBarButtonItems = [chatButton, notificationButton, updateGoal]
        
        collectionView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        collectionView.layer.cornerRadius = 50
        collectionView.register(ChallengesHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        collectionView.register(ChallengesCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
    }
    
    
    private func configureCollectionViewGradient() {
        
       let collectionViewBackgroundView = UIView()
       let gradientLayer = CAGradientLayer()
       gradientLayer.frame.size = view.frame.size
       // Start and end for left to right gradient
       //gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
       //gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.colors = [UIColor.systemPink.cgColor, UIColor.systemPurple.cgColor]
       collectionView.backgroundView = collectionViewBackgroundView
       collectionView.backgroundView?.layer.addSublayer(gradientLayer)
        
     }
    
    //MARK: - API
    
    func fetchUser() {
        
        guard let currentUser = Auth.auth().currentUser?.uid else {return}
        
        UserServices.fetchUser(withCurrentUser: currentUser) { user in
            self.user = user
            self.collectionView.reloadData()
            
            print("DEBUGG: THE CURRENT WEIGHT IS \(user.currentWeight)")
        }
    }
    
    //MARK: - ACTION
    
    @objc func handleUpdateGoal() {
       
        let controller = UpdateGoalsController(user: user)
        HidePostButton()
        navigationController?.pushViewController(controller, animated: true)
        
    }
    
    @objc func handleChat() {
        
        let controller = ChatController(config: .notProfile)
        HidePostButton()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func handleNotification() {
        
        let controller = NotificationController(user: user)
        HidePostButton()
        navigationController?.pushViewController(controller, animated: true)
    }
}

//MARK: - UICollectionViewDataSource

extension ChallengesController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return currentDataSource.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! ChallengesHeader
        
        header.delegate = self
        
        header.viewModel = ChallengesHeaderViewModel(user: user)
        
        print("DEBUGG: THE WEIGT IS \(header.currentGoalImage.titleLabel?.text)")
        
        return header
    }
   
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ChallengesCell
        
        cell.viewModel = ChallengesViewModel(challenges: currentDataSource[indexPath.row])
        
        return cell
        
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension ChallengesController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: view.frame.width, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let viewModel = ChallengesViewModel(challenges: currentDataSource[indexPath.row])
        let height = viewModel.size(forWidth: 400).height
        
        return CGSize(width: view.frame.width, height: height + 250)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return .init(top: 50, left: 50, bottom: 10, right: 0)
    }
}

//MARK: - ChallengesHeaderDelegate

extension ChallengesController: ChallengesHeaderDelegate {
    
    func filter(_ filter: ChallengeFilterOptions) {
        
        self.selectedFilter = filter
        
    }
    
}

//MARK: - EditGoalsControllerDelegate

extension ChallengesController: EditGoalsControllerDelegate {
    
    func controller(_ controller: EditGoalsController, wantsToUpdate user: User) {
        self.user = user
        
    }
    
}
