//
//  CommentController.swift
//  Weightloss
//
//  Created by benny mushiya on 06/05/2021.
//

import UIKit
import FirebaseAuth
import Firebase

private let headerIdentifier = "header"
private let reuseIdentifier = "cell"


class CommentController: UICollectionViewController {
    
    
    //MARK: - PROPERTIES
    
    private let post: TextPost
    
    private var commentsArray = [Comments]()
    
    let user: User
    
    // the reason we make it a lazy var is because we are accessing cgrect properites outside an initiailiser.
    private lazy var commentInputView: CommentInputAccesoryView = {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let cv = CommentInputAccesoryView(frame: frame)
        cv.delegate = self
        return cv
    }()
    
    
    //MARK: - LIFECYCLE
    
    init(post: TextPost, user: User) {
        self.post = post
        self.user = user
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        fetchComments()
    }
    
    /// declares the commentInputView created above, as this Views input accessory view.
    override var inputAccessoryView: UIView? {
        
        get { return commentInputView }
    }
    
    /// gives the input view the functionality of hiding and showing the keyboard.
    override var canBecomeFirstResponder: Bool {
        
        return true
    }
    
    // gets called everytime the view is about to appear on screen, unlike viewController that only gets called once.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.isHidden = false
    }
    
    // gets called everytime the view is about to disapear.
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        tabBarController?.tabBar.isHidden = false
    }
    
    //MARK: - HELPERS
    
    func configureUI() {
        
        collectionView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        collectionView.register(CommentsHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        collectionView.register(CommentsCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        // makes the collectionView always movable even of we have 1 comments. thus we can dismiss the keyboard upon interaction.
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .interactive
        commentInputView.viewModel = HomeHeaderViewModel(user: user)

        
    }
    
    //MARK: - ACTION

    func fetchComments () {
        
        CommentServices.fetchComments(forPost: post) { comments in
            self.commentsArray = comments
            self.collectionView.reloadData()
            
            print("DEBUGG: THE AMOUNT OF COMMENTS ARE \(self.commentsArray.count)")
        }
        
    }
    
    
//    func fetchUser() {
//
//        guard let tab = tabBarController as? MainTabBarController else {return}
//        guard let user = tab.user else {return}
//
//
//
//    }
    
    
}


//MARK: - UICollectionViewDataSource

extension CommentController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return commentsArray.count
    }
    
   
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! CommentsHeader
        
        header.viewModel = CommentsHeaderViewModel(post: post)
        header.delegate = self
        
        return header
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CommentsCell
        
        cell.viewModel = CommentsViewModel(comments: commentsArray[indexPath.row])
        
        return cell
     }

}

//MARK: - UICollectionViewDelegateFlowLayout

extension CommentController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        let viewModel = TextPostViewModel(posts: post)
        let captionHeight = viewModel.size(forWidth: view.frame.width).height
        
        return CGSize(width: view.frame.width, height: captionHeight + 150)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width, height: 100)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return .init(top: 10, left: 0, bottom: 0, right: 0)
    }
    
    
}

//MARK: - CommentInputAccesoryViewDelegate

extension CommentController: CommentInputAccesoryViewDelegate {
    
    
    func inputView(_ inputView: CommentInputAccesoryView, wantsToUploadComment comment: String) {
        
        guard let tab = tabBarController as? MainTabBarController else { return }
        guard let currentUser = tab.user else { return }
        
        CommentServices.uploadComments(caption: comment, post: post, user: currentUser) { error in
            if let error = error {
                
                print("failed tp upload comment \(error.localizedDescription)")
                return
            }
            
            print("successfully upload the commetn")
            inputView.clearCommentTextView()
            
            NotificationServices.uploadNotifications(toUid: self.post.ownerUid, fromUser: currentUser, type: .comments, post: self.post)
            
            PushNotificationServices.sendNotificationToUser(to: self.post.user.pushID, nameOfUser: self.user.name, body: "Commented on your post")
        }
    }
    
}

//MARK: - CommentsHeaderDelegate

extension CommentController: CommentsHeaderDelegate {
    
    func cell(_ cell: CommentsHeader, didRelateTo post: TextPost) {
        
        cell.viewModel?.post.didRelate.toggle()
        
        if post.didRelate {
        
            WeightLossServices.unrelateWeightLossPost(post: post) { error in
                if let error = error {
                    
                    print("failed to unrelate to post \(error.localizedDescription)")
                    return
                }
                
                cell.relateButton.setImage(UIImage(systemName: "circles.hexagongrid"), for: .normal)
                cell.relateButton.tintColor = .black
                cell.viewModel?.post.relatables = post.relatables - 1
            }
            
        }else {
            
            WeightLossServices.relateToWeightLossPost(post: post) { error  in
                if let error = error {
                    
                    print("failed to relate to post \(error.localizedDescription)")
                    return
                }
                
                cell.relateButton.setImage(UIImage(systemName: "circles.hexagongrid.fill"), for: .normal)
                cell.relateButton.tintColor = .systemPink
                cell.viewModel?.post.relatables = post.relatables + 1
                
                NotificationServices.uploadNotifications(toUid: post.ownerUid, fromUser: self.user, type: .relatables, post: post)
                
                PushNotificationServices.sendNotificationToUser(to: post.user.pushID, nameOfUser: self.user.name, body: "Related to your post")
            }
        }
        
    }
    
    func cell(_ cell: CommentsHeader, wantsToReplyTo post: TextPost) {
        
       showMessage(withTitle: "ERROR", message: "you are already in the comments section")
        
    }
    
    func cell(_ cell: CommentsHeader, wantsToShowProfileFor uid: String) {
        
        UserServices.fetchUser(withCurrentUser: uid) { user in
            let controller = ProfileController(user: user)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func cell(_ cell: CommentsHeader, didLike post: TextPost) {
        
        cell.viewModel?.post.didLike.toggle()
        
        if post.didLike {
            
            WeightLossServices.dislikeWeightLossPost(post: post) { error in
                if let error = error {
                    
                    print("failed to unrelate to post \(error.localizedDescription)")
                    return
                }
                
                cell.likeButton.setImage(UIImage(systemName: "suit.heart"), for: .normal)
                cell.likeButton.tintColor = .black
                cell.viewModel?.post.likes = post.likes - 1
            }
            
        }else {
            
            WeightLossServices.likedWeightLossPost(post: post) { error  in
                if let error = error {
                    
                    print("failed to relate to post \(error.localizedDescription)")
                    return
                }
                
                cell.likeButton.setImage(UIImage(systemName: "heart.circle.fill"), for: .normal)
                cell.likeButton.tintColor = .systemPurple
                cell.viewModel?.post.likes = post.likes + 1
                
                NotificationServices.uploadNotifications(toUid: post.ownerUid, fromUser: self.user, type: .likes, post: post)
                
                PushNotificationServices.sendNotificationToUser(to: post.user.pushID, nameOfUser: self.user.name, body: "Liked your post")
                
                
            }
        }
    }
    
    func cell(_ cell: CommentsHeader, wantsToChatWith uid: String) {
        
        UserServices.fetchUser(withCurrentUser: uid) { user in
            let controller = MessageController(user: user)
            self.HidePostButton()
            self.navigationController?.pushViewController(controller, animated: true)
        }
       
    }
    
}

