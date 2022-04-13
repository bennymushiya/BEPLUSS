//
//  ImageCommentController.swift
//  Weightloss
//
//  Created by benny mushiya on 27/05/2021.
//


import UIKit
import FirebaseAuth
import FirebaseCore

private let headerIdentifier = "header"
private let reuseIdentifier = "cell"


class ImageCommentController: UICollectionViewController {
    
    
    //MARK: - PROPERTIES
    
    private var post: ProgressPost {
        didSet{collectionView.reloadData()}
    }
        
    private var commentsArray = [Comments]()
    
    let user: User
    
    // the reason we make it a lazy var is because we are accessing cgrect properites outside an initiailiser.
    private lazy var commentInputView: CommentInputAccesoryView = {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let cv = CommentInputAccesoryView(frame: frame)
        cv.delegate = self
        return cv
    }()
    
    private let refresher = UIRefreshControl()
    
    
    //MARK: - LIFECYCLE
    
    init(post: ProgressPost, user: User) {
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
        gestureRecogniser()
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
        collectionView.register(ImageCommentHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        collectionView.register(CommentsCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        commentInputView.viewModel = HomeHeaderViewModel(user: user)

        
        // makes the collectionView always movable even of we have 1 comments. thus we can dismiss the keyboard upon interaction.
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .interactive
        checkIfUserLikedPosts()
        collectionView.refreshControl = refresher
        
        refresher.addTarget(self, action: #selector(handleRefreshPage), for: .valueChanged)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    func gestureRecogniser() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDismissKeyBoard))
        
        collectionView.addGestureRecognizer(tapGesture)
        
    }
    
    //MARK: - SELECTORS
    
    @objc func handleDismissKeyBoard() {
        
        commentInputView.endEditing(true)
        
    }

    //makes the textfields go up when the keyboard shows itself.
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    // makes the textfields go back into place when clicked on the view.
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    //MARK: - ACTION

    func fetchComments () {
        
        ProgressServices.fetchComments(forPost: post) { comments in
            self.commentsArray = comments
            self.checkIfUserLikedPosts()
            self.collectionView.refreshControl?.endRefreshing()
            self.collectionView.reloadData()
        }
    }
    
    private func checkIfUserLikedPosts() {
            
            ProgressServices.checkIfUserlikedPost(post: post) { didRelate in
                self.post.didRelate = didRelate
                
            }
    }
    
    
    @objc func handleRefreshPage() {
        
        commentsArray.removeAll()
        fetchComments()
        checkIfUserLikedPosts()
    }
    
}


//MARK: - UICollectionViewDataSource

extension ImageCommentController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return commentsArray.count
    }
   
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! ImageCommentHeader
        
        header.viewModel = ProgressHeaderCommentViewModel(post: post)
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

extension ImageCommentController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        let viewModel = ProgressHeaderCommentViewModel(post: post)
        let height = viewModel.size(forWidth: view.frame.width).height
        
        
        
        return CGSize(width: view.frame.width, height: height + 570)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width, height: 100)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return .init(top: 10, left: 0, bottom: 0, right: 0)
    }
    
    
}

//MARK: - ImageCommentHeaderDelegate

extension ImageCommentController: ImageCommentHeaderDelegate {
    
    func cell(_ cell: ImageCommentHeader, wantsToDeleteOrShare post: ProgressPost) {
                
        if post.user.uid.elementsEqual(post.ownerUid) {
            
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
    
    func cell(_ cell: ImageCommentHeader, showUserProfilFor uid: String) {
        
        UserServices.fetchUser(withCurrentUser: uid) { user in
            let controller = ProfileController(user: user)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func cell(_ cell: ImageCommentHeader, didLike post: ProgressPost) {
        
        guard let tab = tabBarController as? MainTabBarController else { return }
        guard let currentUser = tab.user else { return }
        
        cell.viewModel?.post.didRelate.toggle()
        
        if  post.didRelate {
            
            ProgressServices.dislikePost(post: post) { error in
                if let error = error {
                    
                    print("failed to dislike \(error.localizedDescription)")
                    return
                }
                
                cell.likesButton.setImage(UIImage(systemName: "circles.hexagongrid"), for: .normal)
                cell.likesButton.tintColor = .black
                cell.viewModel?.post.likes = post.likes - 1
            }
            
            
        }else {
            
            ProgressServices.likedPost(post: post) { error in
                if let error = error {
                    
                    print("DEBUGG: FAILED TO UPLOAD \(error.localizedDescription)")
                    return
                }
                
                cell.likesButton.tintColor = .systemPink
                cell.likesButton.setImage(UIImage(systemName: "bolt.heart.fill"), for: .normal)
                cell.viewModel?.post.likes = post.likes + 1
                
                NotificationServices.uploadNotifications(toUid: post.ownerUid, fromUser: currentUser, type: .relatables, post: nil, progressPost: post)
                
                PushNotificationServices.sendNotificationToUser(to: post.user.pushID, nameOfUser: self.user.name, body: "Related to your Post")
                
            }
        }

    }
    
    func cell(_ cell: ImageCommentHeader, wantsToCommentOn post: ProgressPost) {
        
        showMessage(withTitle: "ERROR", message: "Your already in the comment section")

    }
    
    func cell(_ cell: ImageCommentHeader, wantsToChatWith uid: String) {
        
        UserServices.fetchUser(withCurrentUser: uid) { user in
            let controller = MessageController(user: user)
            self.HidePostButton()
            self.navigationController?.pushViewController(controller, animated: true)
        }

    }
    
}

//MARK: - CommentInputAccesoryViewDelegate

extension ImageCommentController: CommentInputAccesoryViewDelegate {
    
    
    func inputView(_ inputView: CommentInputAccesoryView, wantsToUploadComment comment: String) {
        
        guard let tab = tabBarController as? MainTabBarController else { return }
        guard let currentUser = tab.user else { return }
        
        ProgressServices.uploadComments(caption: comment, post: post, user: currentUser) { error in
            if let error = error {
                
                print("DEBUGG: FAILED TO UPLOAD COMMENT \(error.localizedDescription)")
                return
            }
            
            print("SUCCESSFULLY UPLOAD THE COMMENT")
            inputView.clearCommentTextView()
            
            NotificationServices.uploadNotifications(toUid: self.post.ownerUid, fromUser: currentUser, type: .comments, post: nil, progressPost: self.post)
            
            PushNotificationServices.sendNotificationToUser(to: self.post.user.pushID, nameOfUser: self.user.name, body: "Commented on your progress post")
        }
       
    }
    
}


