//
//  EditGoalController.swift
//  Weightloss
//
//  Created by benny mushiya on 20/10/2021.
//

import UIKit

protocol EditGoalsControllerDelegate: class {
    
    func controller(_ controller: EditGoalsController, wantsToUpdate user: User)
    
}

private let reuseIdentifier = "cell"

class EditGoalsController: UITableViewController {
    
    //MARK: - PROPERTIES
    
    private var user: User
    
    weak var delegate: EditGoalsControllerDelegate?
    
    lazy var headerView = NewGoalsHeader(frame: .init(x: 0, y: 0, width: view.frame.width, height: 100))
    
    lazy var footerView = NewGoalFooter(frame: .init(x: 0, y: 0, width: view.frame.width, height: 100))
    
    private var userChangedGoals = false
    
    //MARK: - LIFEYCYCLE
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
    }
    
    //MARK: - HELPERS
    
    func configureUI() {
    
        tableView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        tableView.tableHeaderView = headerView
        tableView.tableFooterView = footerView
        tableView.register(NewGoalsCell.self, forCellReuseIdentifier: reuseIdentifier)
        footerView.delegate = self
    
    }
    
    //MARK: - ACTION
    
    func updateUserGoals() {
        
        
        
    }
    
    func UpdateTextFieldInfo() {
        
        showLoader(true)
        UserServices.updateUserGoals(user: user) { error in
            self.showLoader(false)
            if let error = error {
                print("DEBUGG: FAILED TO UPDATE YOUR GOALS \(error.localizedDescription)")
                return
            }
            
            print("DEBUGG: SUCCESSFULLY UPDATED YOUR DATA")
            self.delegate?.controller(self, wantsToUpdate: self.user)
            
        }
    }
}

//MARK: - UITableViewDataSource

extension EditGoalsController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return NewGoalUpdateOptions.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! NewGoalsCell
        
        guard let options = NewGoalUpdateOptions(rawValue: indexPath.row) else {return cell}
        cell.viewModel = NewGoalUpdateCellViewModel(user: user, options: options)
        cell.delegate = self
        
        return cell
    }
}

//MARK: - UITableViewDelegate

extension EditGoalsController {
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        guard let options = NewGoalUpdateOptions(rawValue: indexPath.row) else {return 0}
        
        return options == .GoalWeight ? 48 : 48
    }
}

//MARK: - NewGoalsCellDelegate

extension EditGoalsController: NewGoalsCellDelegate {
    
    
    func updateUserGoals(_ cell: NewGoalsCell, wantsToUpdate value: String, for section: NewGoalUpdateOptions) {
        
        footerView.updateButton.isEnabled = true
        footerView.updateButton.backgroundColor = #colorLiteral(red: 0.1598605525, green: 0.9373220266, blue: 0.7734893539, alpha: 1)
        
        switch section {
            
        case .currentWeight:
            
            user.currentWeight = Int(value) ?? user.currentWeight
            
            print("DEBUGG: current WEIHT IS \(value)")
            print("DEBUGG: user current WEIHT IS \(user.currentWeight)")


            
        case .GoalWeight:
             
            user.futureGoal = Int(value) ?? user.futureGoal
            
            print("DEBUGG: GOAL WEIHT IS \(value)")
            print("DEBUGG: user future WEIHT IS \(user.futureGoal)")
            
            break

        }
    }
}

//MARK: - NewGoalFooterDelegate

extension EditGoalsController: NewGoalFooterDelegate {
    
    
    func updateInfo() {
        
        view.endEditing(true)
        
        showLoader(true)
        UserServices.updateUserGoals(user: user) { error in
            self.showLoader(false)
            self.delegate?.controller(self, wantsToUpdate: self.user)

        }
    }
    
    func cancel() {
        
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
        
    }
    
    
    
    
    
}
