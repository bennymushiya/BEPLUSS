//
//  CustomActionSheet.swift
//  Weightloss
//
//  Created by benny mushiya on 15/05/2021.
//

import UIKit

protocol CustomActionSheetDelegate: class {
    
    func actionSheet(_ sheet: CustomActionSheet, didSelectControllerAt index: IndexPath)
}

private let reuseIdentifier = "cell"

class CustomActionSheet: NSObject {
    
    //MARK: - PROPERTIES
    
    weak var delegate: CustomActionSheetDelegate?
    
    private let tableView = UITableView()
    
    // represents the window that our app is contained within. the reason we use the uiwindow is because we want this action sheet to have a presenting functionality were it presents a black view over the entire view of the screen.
    private var window: UIWindow?
    
    private lazy var blackView: UIView = {
        let view = UIView()
        view.alpha = 0
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDismissal))
        view.addGestureRecognizer(tapGesture)
        
        return view
    }()
        
    private var actionArray = [
    
        ActionSheetModel(image: UIImage(systemName: "doc.plaintext.fill"), description: "Upload Weightloss Post"),
        
        ActionSheetModel(image: UIImage(systemName: "doc.richtext.fill.ar"), description: "Upload Weightgain Post"),
        
        ActionSheetModel(image: UIImage(systemName: "camera.metering.multispot"), description: "Upload a Progress Post ")
        
    ]
    
    private lazy var cancelButton: AuthButton = {
        let button = AuthButton(title: "Cancel", type: .system)
        button.isEnabled = true
        
        button.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var footerView: UIView = {
        let view = UIView()
        
        view.addSubview(cancelButton)
        cancelButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        cancelButton.anchor(left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 12, paddingRight: 12)
        cancelButton.centerY(inView: view)
        cancelButton.layer.cornerRadius = 50 / 2
        
        return view
    }()
        
    //MARK: - LIFECYCLE
    
    override init() {
        super.init()
        
        configureUI()
    }
    
    //MARK: - HELPERS
    
    func configureUI() {
        
        tableView.backgroundColor = .white
        tableView.rowHeight = 80
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.layer.cornerRadius = 5
        tableView.isScrollEnabled = false
        tableView.register(ActionSheetCell.self, forCellReuseIdentifier: reuseIdentifier)
        
    }

    
    func show() {
        
        guard let window = UIApplication.shared.windows.first(where: {$0.isKeyWindow}) else {return}
        self.window = window
        
        window.addSubview(blackView)
        blackView.frame = window.frame
        
        
        window.addSubview(tableView)
        let height = CGFloat(3 * 80) + 100
        
        // the x and y axis starts from the left side of the top of the screen. the y axis goes vertically, whilst the x axis goes accross screen horizontal.
        tableView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: height)
        
        // here we animate the blackView to show itself and and we take 300 from the y axis that covers the whole screen height, as we declared above so we reduce the screen so we can animate the action sheet.
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 1
            self.tableView.frame.origin.y -= height
        }
    }
    
    //MARK: - ACTION

    @objc func handleDismissal() {
        
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 0
            self.tableView.frame.origin.y += 350
        }
    }
}
//MARK: - UITableViewDataSource

extension CustomActionSheet: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return actionArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ActionSheetCell
        
        cell.viewModel = ActionSheetViewModel(actionSheet: actionArray[indexPath.row])
        
        return cell
        
    }
    
}

//MARK: - UITableViewDelegate

extension CustomActionSheet: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        delegate?.actionSheet(self, didSelectControllerAt: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

//MARK: - UITableViewFooterView

extension CustomActionSheet {
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        return footerView
    }
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 80
    }
    
}
