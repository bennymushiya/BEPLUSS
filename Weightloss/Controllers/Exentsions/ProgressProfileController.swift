//
//  ProgressProfileController.swift
//  Weightloss
//
//  Created by benny mushiya on 23/10/2021.
//

import UIKit

private let reuseIdentifier = "profile celll"

class ProgressProfileController: UICollectionViewController {
    
    
    //MARK: - PROPERTIES
    
    private var user: User
    
    private var posts = [ProgressPost]() {
        didSet{collectionView.reloadData()}
    }
    
    private let refresher = UIRefreshControl()
    
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
    
    //MARK: - LIFECYCLE
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = false
    }
    
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
        fetchUserProgressPosts()
        
    }
    
    //MARK: - HELPERS

    func configureUI() {
        
        navigationItem.title = "Personal Progress"
        collectionView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        let notificationButton = UIBarButtonItem(customView: notificationButton)
        let chatButton = UIBarButtonItem(customView: chatButton)
        
        navigationItem.rightBarButtonItems = [chatButton, notificationButton]
        
        collectionView.register(ProgressCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        refresher.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.refreshControl = refresher
        
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
    
    func fetchUserProgressPosts() {
        
        ProgressServices.fetchUserProgressPost(withUid: user.uid) { progress in
            self.posts = progress
            self.collectionView.reloadData()
        }
    }
    
    func checkIfUserLikedPost() {
        
        posts.forEach { postz in
            ProgressServices.checkIfUserlikedPost(post: postz) { didRelate in
                
                if let index = self.posts.firstIndex(where: { $0.postID == postz.postID}) {
                    self.posts[index].didRelate = didRelate
                    
                }
            }
        }
    }
    
    //MARK: - ACTION
    
    @objc func handleChat() {
        
        let controller = ChatController(config: .notProfile)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func handleNotification() {
        
        let controller = NotificationController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func handleRefresh() {
        
        posts.removeAll()
        fetchUserProgressPosts()
    }
}

//MARK: - UICollectionViewDataSource

extension ProgressProfileController {
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ProgressCell
        
        cell.viewModel = ProgressPostViewModel(posts: posts[indexPath.row])
        cell.delegate = self
        
        return cell
        
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension ProgressProfileController: UICollectionViewDelegateFlowLayout {


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let viewModel = ProgressPostViewModel(posts: posts[indexPath.row])
        let height = viewModel.size(forWidth: view.frame.width).height

        return CGSize(width: 400, height: height + 560)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        return .init(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 20
    }
}

//MARK: - ProgressCellDelegate

extension ProgressProfileController: ProgressCellDelegate {
    
    func cell(_ cell: ProgressCell, wantsToGetCommentCountFor post: ProgressPost) {
        
        CommentServices.fetchCommentCountForProgressPost(forPost: post) { commentCount in
            cell.progressCommentLabel.text = "\(commentCount)"
        }
    }
    
    func cell(_ cell: ProgressCell, wantsToDeleteOrShare post: ProgressPost) {
        
        
        if user.uid.elementsEqual(post.ownerUid) {
            
            var actions: [(String, UIAlertAction.Style)] = []
            actions.append(("Delete Post", UIAlertAction.Style.default))
            actions.append(("Share Post", UIAlertAction.Style.destructive))
            actions.append(("Cancel", UIAlertAction.Style.cancel))
            
            showActionsheet(viewController: self, title: "whats good", message: "ahahahhahahahahaha", actions: actions) { index in
                
                switch index {
                case 0:
                    
                    ProgressServices.deletePost(post: post) { error in
                        if let error = error {
                            
                            print("failed to delete the work \(error.localizedDescription)")
                            return
                        }
                        print("successfully deleted the post")
                    }

                case 1:

                    self.presentShareSheet()
                    
                default:
                    break
                }
            }
        
        } else {
            
           print("its not your post lad")
            showMessage(withTitle: "ERROR", message: "its not your post therefore your unable to delete it")
            
        }
    }
    
    func cell(_ cell: ProgressCell, showUserProfilFor uid: String) {
        
        UserServices.fetchUser(withCurrentUser: uid) { user in
            let controller = ProfileController(user: user)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func cell(_ cell: ProgressCell, wantsToChatTo uid: String) {
        
        UserServices.fetchUser(withCurrentUser: uid) { user in
            let controller = MessageController(user: user)
            self.HidePostButton()
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    

    func cell(_ cell: ProgressCell, didLike post: ProgressPost) {
        
        cell.viewModel?.posts.didRelate.toggle()
        
        if  post.didRelate {
            
            ProgressServices.dislikePost(post: post) { error in
                if let error = error {
                    
                    print("failed to dislike \(error.localizedDescription)")
                    return
                }
                
                cell.likesButton.setImage(UIImage(systemName: "circles.hexagongrid"), for: .normal)
                cell.likesButton.tintColor = .black
                cell.viewModel?.posts.likes = post.likes - 1
            }
            
            
        }else {
            
            ProgressServices.likedPost(post: post) { error in
                if let error = error {
                    
                    print("DEBUGG: FAILED TO UPLOAD \(error.localizedDescription)")
                    return
                }
                
                cell.likesButton.tintColor = .systemPink
                cell.likesButton.setImage(UIImage(systemName: "bolt.heart.fill"), for: .normal)
                cell.viewModel?.posts.likes = post.likes + 1
                
//                NotificationServices.uploadProgressPostNotifications(toUid: post.ownerUid, fromUser: self.user, type: .likes, progressPost: post)
                
                NotificationServices.uploadNotifications(toUid: post.ownerUid, fromUser: self.user, type: .likes, post: nil, progressPost: post)
            }
        }
    }
    
    
    
    func cell(_ cell: ProgressCell, wantsToCommentOn post: ProgressPost) {
        
        let controller = ImageCommentController(post: post, user: user)
        navigationController?.pushViewController(controller, animated: true)
        

    }
    
}

