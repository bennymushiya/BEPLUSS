//
//  NotificationController.swift
//  Weightloss
//
//  Created by benny mushiya on 10/06/2021.
//

import UIKit
import SwiftUI

private let headerIdentifier = "notification header"
private let reuseIdentifier = "notification cell"


class NotificationController: UICollectionViewController {
    
    //MARK: - PROPERTIES
    
    private var notifications = [Notification]()
    
    var index = 0
    
    let user: User
    
    private let noNotificationsLabel: UILabel = {
        let label = UILabel()
        label.text = "sorry you dont have any notifications"
        label.font = UIFont.systemFont(ofSize: 20, weight: .black)
        label.alpha = 0
        
        return label
    }()
    
    
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
        fetchNotifications()
        


    }
    
    //MARK: - HELPERS
    
    func configureUI() {
        
        collectionView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        collectionView.register(NotificationHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        collectionView.register(NotificationCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        collectionView.addSubview(noNotificationsLabel)
        noNotificationsLabel.centerY(inView: collectionView)
        noNotificationsLabel.centerX(inView: collectionView)
                
    }
    
//    private func configureCollectionViewGradient() {
//        
//       let collectionViewBackgroundView = UIView()
//       let gradientLayer = CAGradientLayer()
//       gradientLayer.frame.size = view.frame.size
//       // Start and end for left to right gradient
//       //gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
//       //gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
//        gradientLayer.colors = [UIColor.systemPink.cgColor, UIColor.systemPurple.cgColor]
//       collectionView.backgroundView = collectionViewBackgroundView
//       collectionView.backgroundView?.layer.addSublayer(gradientLayer)
//     }
    
    //MARK: - API
    
    func fetchNotifications() {
        
        NotificationServices.fetchNotifications { notification in
            self.notifications = notification
            self.collectionView.reloadData()
            
            print("DEBUGG: notifcation is \(self.notifications.count)")
            
//            if self.notifications.count != 0 {
//                
//                self.noNotificationsLabel.alpha = 0
//                
//            }else {
//                
//                self.noNotificationsLabel.alpha = 1
//
//            }
        }
    }

    //MARK: - ACTION
    
}

//MARK: - UICollectionViewDataSource

extension NotificationController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return notifications.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! NotificationHeader
        
        return header
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! NotificationCell
        
        cell.delegate = self
        cell.viewModel = NotificationViewModel(notifications: notifications[indexPath.row])
        
        return cell
    }
}

//MARK: - UICollectionViewDelegate

extension NotificationController {
    
    
}

//MARK: - UICollectionViewDelegateFlowLayout

extension NotificationController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: view.frame.width, height: 100)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return .init(top: 20, left: 30, bottom: 0, right: 0)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width, height: 100)
    }
}

//MARK: - NotificationCellDelegate

extension NotificationController: NotificationCellDelegate {
    
    func cell(_ cell: NotificationCell, wantsToViewPost post: ProgressPost) {
        
        guard let tab = tabBarController as? MainTabBarController else {return}
        guard let user = tab.user else {return}
        
        
        let controller = ImageCommentController(post: post, user: user )
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func cell(_ cell: NotificationCell, wantsToShowProfileFor uid: String) {
        
        UserServices.fetchUser(withCurrentUser: uid) { user in
            let controller = ProfileController(user: user)
            self.navigationController?.pushViewController(controller, animated: true)
        }

    }
    
}


