//
//  SearchController.swift
//  Weightloss
//
//  Created by benny mushiya on 26/04/2021.
//

import UIKit
import Firebase
import FirebaseAuth


private let reuseIdentifier = "progress cell"

class ProgressController: UICollectionViewController {
    
    
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
    
    private lazy var quotesButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "equal.square.fill"), for: .normal)
        button.tintColor = .white
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 10)
        button.setDimensions(height: 46, width: 46)
        
       // button.addTarget(self, action: #selector(handleQuotes), for: .touchUpInside)

        
        return button
    }()
    
    //MARK: - LIFECYCLE
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        displayPostButton()
        navigationController?.navigationBar.isHidden = false
        self.collectionView.reloadData()
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
        fetchProgressPosts()
        
    }
    
    //MARK: - HELPERS

    func configureUI() {
        
        navigationItem.title = "Progress"
        collectionView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        let quotesButton = UIBarButtonItem(customView: quotesButton)
        let chatButton = UIBarButtonItem(customView: chatButton)
        
        navigationItem.rightBarButtonItems = [chatButton, quotesButton]
        
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
    
    func fetchProgressPosts() {
        
        ProgressServices.fetchProgressPost { postImage in
            self.posts = postImage
            self.collectionView.refreshControl?.endRefreshing()
            self.checkIfUserLikedPost()
            
            print("DEBUGG: THE CAPTION OF THE POST IS \(self.posts[0].caption)")
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
        HidePostButton()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    
    @objc func handleRefresh() {
        
        posts.removeAll()
        fetchProgressPosts()
    }
}

//MARK: - UICollectionViewDataSource

extension ProgressController {
    
    
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

extension ProgressController: UICollectionViewDelegateFlowLayout {


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

extension ProgressController: ProgressCellDelegate {
    
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
            
            showActionsheet(viewController: self, title: "Delete or Share", message: "Choose from the options below", actions: actions) { index in
                
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
            
            self.presentShareSheet()
            
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
                
                NotificationServices.uploadNotifications(toUid: post.ownerUid, fromUser: self.user, type: .likes, post: nil, progressPost: post)
                
                PushNotificationServices.sendNotificationToUser(to: post.user.pushID, nameOfUser: self.user.name, body: "Related to your progress post")
            }
        }
    }
    
    
    
    func cell(_ cell: ProgressCell, wantsToCommentOn post: ProgressPost) {
        
        let controller = ImageCommentController(post: post, user: user)
        HidePostButton()
        navigationController?.pushViewController(controller, animated: true)
        

    }
    
}
