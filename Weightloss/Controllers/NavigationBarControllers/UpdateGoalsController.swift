//
//  UpdateGoalsController.swift
//  Weightloss
//
//  Created by benny mushiya on 23/08/2021.
//

import UIKit
import Firebase
import FirebaseAuth

private let reuseIdentifier = "cell"

class UpdateGoalsController: UITableViewController {

    //MARK: - PROPERTIES
    
    var user: User
    
    private lazy var headerView = UpdateGoalHeader(user: user)
    
    private var topLabel: UILabel = {
        let label = UILabel()
        label.text = "Dashboard"
        label.font = UIFont.systemFont(ofSize: 30, weight: .black)
        label.textColor = .black
        label.textAlignment = .left
        
        return label
    }()
    
  private let titleLabel: SmallFontLabel = {
       let label = SmallFontLabel(title: "Until Your Reach Your Goal")
       label.font = UIFont.systemFont(ofSize: 20, weight: .black)
       label.textColor = .white
       
       return label
   }()
    
    private let secondTitleLabel: SmallFontLabel = {
         let label = SmallFontLabel(title: "Update Your Goals")
         label.font = UIFont.systemFont(ofSize: 20, weight: .black)
         label.textColor = .white
         
         return label
     }()
   
    private let currentGoalButton: GoalsButton = {
       let button = GoalsButton(title: "", type: .system)
       button.setTitleColor(#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1), for: .normal)
       button.layer.borderWidth = 2.0
       button.layer.borderColor = #colorLiteral(red: 0.1598605525, green: 0.9373220266, blue: 0.7734893539, alpha: 1)
       button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
       button.setDimensions(height: 66, width: 66)
       button.layer.cornerRadius = 66 / 2
       button.tintColor = .black
       button.titleLabel?.tintColor = .black
       
       return button
   }()
    
    private var currentGoalView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.layer.cornerRadius = 20
        view.layer.borderWidth = 2
        view.layer.borderColor = #colorLiteral(red: 0.1598605525, green: 0.9373220266, blue: 0.7734893539, alpha: 1)
        view.setHeight(100)
        
        return view
    }()
    
    private lazy var changeGoalView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.layer.cornerRadius = 20
        view.layer.borderWidth = 2
        view.layer.borderColor = #colorLiteral(red: 0.1598605525, green: 0.9373220266, blue: 0.7734893539, alpha: 1)
        view.setHeight(100)
        view.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleChangedGoal))
        
        view.addGestureRecognizer(tapGesture)
        
        return view
    }()
    
    
    private var buttonsArray = [
    
        UpdateGoalModel(title: "Until You Reach Your Goal", image: UIImage(systemName: "")),
        
        UpdateGoalModel(title: "Update Your Goals?", image: UIImage(systemName: "ahhahahah"))
    
    ]
    
    
    private let refresher = UIRefreshControl()
  
    //MARK: - LIFECYCLE
    
    init(user: User) {
        self.user = user
        super.init(style: .plain)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        fetchUser()
        fetchData()
        
    }
    
    //MARK: - HELPERS
    
    func configureUI() {
        
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        tableView.tableHeaderView = headerView
        //tableView.register(UpdateGoalCell.self, forCellReuseIdentifier: reuseIdentifier)
        //tableView.rowHeight = 90
        
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 250)
        tableView.separatorStyle = .none
        
        let viewStack = UIStackView(arrangedSubviews: [currentGoalView, changeGoalView])
        viewStack.axis = .vertical
        viewStack.spacing = 20
        
        tableView.addSubview(viewStack)
        viewStack.centerX(inView: tableView)
        viewStack.anchor(top: headerView.bottomAnchor, left: tableView.leftAnchor, right: tableView.rightAnchor, paddingTop: 20, paddingLeft: 10, paddingRight: 10)
        
        currentGoalView.addSubview(currentGoalButton)
        currentGoalButton.centerY(inView: currentGoalView)
        currentGoalButton.anchor(left: currentGoalView.leftAnchor, paddingLeft: 20)
        
        currentGoalView.addSubview(titleLabel)
        titleLabel.centerY(inView: currentGoalView)
        titleLabel.anchor(left: currentGoalButton.rightAnchor, paddingLeft: 10)
        
        changeGoalView.addSubview(secondTitleLabel)
        secondTitleLabel.centerY(inView: changeGoalView)
        secondTitleLabel.centerX(inView: changeGoalView)
        
        tableView.refreshControl = refresher
        
        refresher.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        
        
    }
    
    //MARK: - API
    
    func fetchUser() {
        
        guard let currentUser = Auth.auth().currentUser?.uid else {return}
                
        UserServices.fetchUser(withCurrentUser: currentUser) { user in
            self.user = user
        }
    }
    
    func fetchData() {
        
        currentGoalButton.setTitle("\(user.currentWeight - user.futureGoal)KG", for: .normal)
        
    }

    //MARK: - ACTION
    
    @objc func handleChangedGoal() {
        
        let controller = EditGoalsController(user: user)
        controller.delegate = self
        navigationController?.pushViewController(controller, animated: true)
        
    }
    
    
    @objc func handleRefresh() {
        
        
    }
    
}

//MARK: - EditGoalsControllerDelegate

extension UpdateGoalsController: EditGoalsControllerDelegate {
    func controller(_ controller: EditGoalsController, wantsToUpdate user: User) {
         self.user = user
         self.tableView.reloadData()
        
        print("DEBUGG: the details of the user are \(user)")
    }

    
}




////MARK: - UICollectionViewDataSource
//
//extension UpdateGoalsController {
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//
//        return buttonsArray.count
//
//    }
//
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! UpdateGoalCell
//
//        if indexPath.row == 0 {
//
//            cell.currentGoalButton.setTitle("\(user.currentWeight - user.futureGoal)KG", for: .normal)
//            cell.titleLabel.text = buttonsArray[indexPath.row].title
//
//        }else {
//
//            cell.currentGoalButton.setImage(buttonsArray[indexPath.row].image, for: .normal)
//            cell.titleLabel.text = buttonsArray[indexPath.row].title
//        }
//
//        return cell
//
//    }
//}
//
//extension UpdateGoalsController {
//
//
//
//
//
//}


////MARK: - UICollectionViewDelegate
//
//extension UpdateGoalsController {
//
//    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//
//        switch indexPath.row {
//
//        case 0:
//
//           print("not working")
//
//        case 1:
//
//            let controller = newGoalsController()
//            navigationController?.pushViewController(controller, animated: true)
//
//        default:
//            break
//        }
//    }
//}
//
////MARK: - UpdateGoalHeaderDelegate
//
//extension UpdateGoalsController: UpdateGoalHeaderDelegate {
//    func updateCurrentGoal() {
//
//        print(" go update it then")
//
//    }
//}
////MARK: - UICollectionViewDelegateFlowLayout
//
//extension UpdateGoalsController: UICollectionViewDelegateFlowLayout {
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//
//        return CGSize(width: view.frame.width, height: 250)
//
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//        return CGSize(width: 400, height: 100)
//
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//
//        return .init(top: 60, left: 10, bottom: 10, right: 10)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//
//        return 10
//
//    }
//
//
//}
