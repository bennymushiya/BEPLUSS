//
//  HomeController.swift
//  Weightloss
//
//  Created by benny mushiya on 26/04/2021.
//

import UIKit
import Firebase
import YPImagePicker
import FirebaseAuth

private let headerIdentifier = "header identifier"
private let reuseIdentifier = "cell identifier"


class HomeController: UICollectionViewController {
    
    
    //MARK: - PROPERTIES
    
    private var user: User
    
    private let refresher = UIRefreshControl()
    
    private let customActionSheet = CustomActionSheet()
    
    private var currentKey: String?
    
    private var headerView = HomeHeader()
    
    
    // we set the FilterOptions to start at weightloss, and we use the didset property to set the new data if the filter view is changed to another property. and we reload the data to see the change.
    private var selectedFilter: HomeFilterOptions = .weightLoss {
        didSet{collectionView.reloadData()}
        
    }
    
    // we get an empty array of each dataSource that we will populate below.
    private var weightGainPosts = [TextPost]()
    private var weightLossPosts = [TextPost]() {
        didSet{collectionView.reloadData()}
        
    }
    
    
    // we create a currentDataSource with the same model. the switch statement adopts the selectedFilter property above and returns each dataSource above as its property.
    private var currentDataSource: [TextPost] {
        switch selectedFilter {
        
        case .weightLoss:
            return weightLossPosts
            
        case .weightGain:
            return weightGainPosts
        }
        
    }
    
    private var postID = [String]()
    
    private lazy var notificationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "note.text.badge.plus"), for: .normal)
        button.tintColor = .white
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 10)
        button.setDimensions(height: 46, width: 46)
        
        button.addTarget(self, action: #selector(handleNotification), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var chatButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "text.bubble.fill"), for: .normal)
        button.tintColor = .white
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 10)
        button.setDimensions(height: 46, width: 46)
      
        button.addTarget(self, action: #selector(handleChat), for: .touchUpInside)
        
        return button
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
        //paginateHomePage()
        //fetchItLad()
        //fetchWeightLossPostsWithPagination()
        fetchWeightLossPosts()
        fetchWeightGainPosts()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        displayPostButton()
        navigationController?.navigationBar.isHidden = false
        self.collectionView.reloadData()

    }
    
    //MARK: - HELPERS

    func configureUI() {
        
        collectionView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        navigationItem.title = "Home"
        navigationItem.titleView?.backgroundColor = .white
        
        let notificationButton = UIBarButtonItem(customView: notificationButton)
        let chatButton = UIBarButtonItem(customView: chatButton)
        
        navigationItem.rightBarButtonItems = [chatButton, notificationButton]
        
//        collectionView.addSubview(underLineView)
//        underLineView.anchor(top: collectionView.safeAreaLayoutGuide.topAnchor, paddingTop: 500)
        

        collectionView.register(HomeHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        
        collectionView.register(HomeCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        refresher.addTarget(self, action: #selector(handleRefresher), for: .valueChanged)
        
        collectionView.refreshControl = refresher
        
    }
    
    
    //MARK: - API
    
//    func paginateHomePage() {
//
//        WeightLossServices.paginateHomePage { textPost in
//            self.weightLossPosts = textPost
//            self.postID = self.weightLossPosts.map({$0.postID})
//            self.collectionView.refreshControl?.endRefreshing()
//            self.checkIfUserRelatedToPost()
//            self.checkIfUserLikedWeightLossPost()
//
//            print("DEBUGG: the next posts are \(textPost.count)")
//        }
//    }
    
//
//    func fetchItLad() {
//
//        WeightLossServices.fetchExplorePagePosts { textPost in
//            self.weightLossPosts = textPost
//            self.postID = self.weightLossPosts.map({$0.postID})
//            self.collectionView.refreshControl?.endRefreshing()
//            self.checkIfUserRelatedToPost()
//            self.checkIfUserLikedWeightLossPost()
//        }
//
//    }
    
    func fetchWeightLossPosts() {

        WeightLossServices.fetchWeightLossPost { textPost in
                self.weightLossPosts = textPost
                self.postID = self.weightLossPosts.map({$0.postID})
                self.collectionView.refreshControl?.endRefreshing()
                self.checkIfUserRelatedToPost()
                self.checkIfUserLikedWeightLossPost()

        }
    }
    
//    func fetchWeightLossPostsWithPagination() {
//
//        WeightLossServices.fetchWeightLossPostsWithPagination { textPost in
//            self.weightLossPosts = textPost
//            self.postID = self.weightLossPosts.map({$0.postID})
//            self.collectionView.refreshControl?.endRefreshing()
//            self.checkIfUserRelatedToPost()
//            self.checkIfUserLikedWeightLossPost()
//        }
//    }
    
    
    func checkIfUserRelatedToPost() {
        
        self.weightLossPosts.forEach { postss in
            WeightLossServices.checkIfUserRelatedWeightLossPost(post: postss) { didRelate in
                
                if let index = self.weightLossPosts.firstIndex(where: { $0.postID == postss.postID}) {
                    self.weightLossPosts[index].didRelate = didRelate
                    
                }
            }
        }
    }
    
    func checkIfUserLikedWeightLossPost() {
        
        self.weightLossPosts.forEach { postlad in
            WeightLossServices.checkIfUserlikedPost(post: postlad) { didLike in
                
                if let index = self.weightLossPosts.firstIndex(where: {$0.postID == postlad.postID}) {
                    
                    self.weightLossPosts[index].didLike = didLike
                }
            }
        }
        
    }
    
    
    func fetchWeightGainPosts() {

        WeightGainServices.fetchWeightGainPost { textPosts in
            self.weightGainPosts = textPosts
            self.checkIfUserRelatedToWeightGainPost()
            self.checkIfUserLikedWeightGainPost()
            self.collectionView.refreshControl?.endRefreshing()
            self.collectionView.reloadData()

        }
    }
    
    
    func checkIfUserRelatedToWeightGainPost() {
        
        self.weightGainPosts.forEach { postss in
            WeightGainServices.checkIfUserRelatedWeightGainPost(post: postss) { didRelate in
                
                if let index = self.weightGainPosts.firstIndex(where: { $0.postID == postss.postID}) {
                    self.weightGainPosts[index].didRelate = didRelate
                
                }
            }
        }
    }

    func checkIfUserLikedWeightGainPost() {
        
        self.weightGainPosts.forEach { postlad in
            WeightGainServices.checkIfUserlikedWeightGainPost(post: postlad) { didLike in
                
                if let index = self.weightGainPosts.firstIndex(where: {$0.postID == postlad.postID}) {
                    
                    self.weightGainPosts[index].didLike = didLike
                }
            }
        }
    }
    
    
    func fetchDailyQuotes() {
        
        
        
    }
    
    //MARK: - SELECTORS
    
    @objc func handleUpload() {
        
        customActionSheet.show()
        
    }
    
    @objc func handleNotification() {
                
        let controller = NotificationController(user: user)
        HidePostButton()
        navigationController?.pushViewController(controller, animated: true)
        
    }

    @objc func handleChat() {
                
        let controller = ChatController(config: .notProfile)
        HidePostButton()
        navigationController?.pushViewController(controller, animated: true)
        
    }

    //MARK: - ACTION

    @objc func handleRefresher() {
        
        weightLossPosts.removeAll()
        weightGainPosts.removeAll()
        fetchWeightLossPosts()
        fetchWeightGainPosts()
    }
    
    func presentOnboardingController() {
        
        DispatchQueue.main.async {
            let controller = PaperOnboardingController()
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
            
        }
    }
}

//MARK: - UICollectionViewDataSource

extension HomeController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return currentDataSource.count
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! HomeHeader
        
        // header.viewModel = QuotesViewModel(quotes: Quotes)
        // header.delegate = self
        
        return header
        
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! HomeCell
        
        cell.viewModel = TextPostViewModel(posts: currentDataSource[indexPath.row])
        cell.delegate = self
        
        return cell
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if weightLossPosts.count > 3 {
            
            if indexPath.item == weightLossPosts.count - 1 {
                //fetchWeightLossPosts()
                //fetchWeightGainPosts()
            }
        }
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension HomeController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: 300, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return .init(top: 70, left: 0, bottom: 10, right: 0)
    }
    
    // we get the size of our post label, then we add 80 pixel to it, including on top and below
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let viewModel = TextPostViewModel(posts: currentDataSource[indexPath.row])
        let height = viewModel.size(forWidth: view.frame.width).height
        
        return CGSize(width: view.frame.width, height: height + 150)
    }
}

//MARK: - HomeHeaderDelegate

//extension HomeController: HomeHeaderDelegate {
//
//    func filter(_ filter: HomeFilterOptions) {
//
//        self.selectedFilter = filter
//    }
//
//}

//MARK: - HomeCellDelegate

extension HomeController: HomeCellDelegate {
    
    func cell(_ cell: HomeCell, wantsToGetCommentCountFor post: TextPost) {
        
        CommentServices.fetchCommentCount(forPost: post) { commentCount in
            cell.viewModel?.posts.commentStat.numberOfComments = commentCount
            
        }
    }
    
    func cell(_ cell: HomeCell, wantsToChatWith uid: String) {
        
        UserServices.fetchUser(withCurrentUser: uid) { users in
            
            let controller = MessageController(user: users)
            self.HidePostButton()
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    
    func cell(_ cell: HomeCell, wantsToDelete post: TextPost) {
        
        if user.uid.elementsEqual(post.ownerUid) {
            
            var actions: [(String, UIAlertAction.Style)] = []
            actions.append(("Delete Post", UIAlertAction.Style.default))
            actions.append(("Share Post", UIAlertAction.Style.destructive))
            actions.append(("Cancel", UIAlertAction.Style.cancel))
            
            showActionsheet(viewController: self, title: "Delete or Share", message: "Choose from the options below", actions: actions) { index in
                
                switch index {
                case 0:
                    
                    WeightLossServices.deleteWeightLossPost(post: post) { error in
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
    
    func cell(_ cell: HomeCell, didRelateTo post: TextPost) {

        cell.viewModel?.posts.didRelate.toggle()
        
        if post.didRelate {
            
            WeightLossServices.unrelateWeightLossPost(post: post) { error in
                if let error = error {
                    
                    print("failed to unrelate \(error.localizedDescription)")
                    return
                    
                }
                cell.relateButton.setImage(UIImage(systemName: "circles.hexagongrid"), for: .normal)
                cell.relateButton.tintColor = .black
                cell.viewModel?.posts.relatables = post.relatables - 1
                
            }
           
        }else {
            
            WeightLossServices.relateToWeightLossPost(post: post) { error in
                if let error = error {
                    
                    print("FAILED TO RELATE TO THE THING \(error.localizedDescription)")
                    return
                }
                
                cell.relateButton.setImage(UIImage(systemName: "circles.hexagongrid.fill"), for: .normal)
                cell.relateButton.tintColor = .purple
                cell.viewModel?.posts.relatables = post.relatables + 1
                
                NotificationServices.uploadNotifications(toUid: post.ownerUid, fromUser: self.user, type: .relatables, post: post)
                
                PushNotificationServices.sendNotificationToUser(to: post.user.pushID, nameOfUser: self.user.name, body: "Related to your Post")
                
            }
            
        }
        
        if post.didRelate {
            
            WeightGainServices.unrelateWeightGainPost(post: post) { error in
                if let error = error {
                    
                    print("failed to unrelate to post \(error.localizedDescription)")
                    return
                }
                
                cell.relateButton.setImage(UIImage(systemName: "circles.hexagongrid"), for: .normal)
                cell.relateButton.tintColor = .black
                cell.viewModel?.posts.relatables = post.relatables - 1
            }
            
        }else {
            
            WeightGainServices.relateToWeightGainPost(post: post) { error in
                if let error = error {
                    
                    print("failed to relate to post \(error.localizedDescription)")
                    return
                }
                cell.relateButton.setImage(UIImage(systemName: "circles.hexagongrid.fill"), for: .normal)
                cell.relateButton.tintColor = .purple
                cell.viewModel?.posts.relatables = post.relatables + 1
                
                //NotificationServices.uploadNotifications(toUid: post.ownerUid, fromUser: self.user, type: .relatables, post: post)
                
                //PushNotificationServices.sendNotificationToUser(to: post.user.pushID, nameOfUser: self.user.name, body: "Related to your Post")
                
            }
        }
    }
    
    
    func cell(_ cell: HomeCell, didLike post: TextPost) {
        
        cell.viewModel?.posts.didLike.toggle()
        
        if post.didLike {
            
            WeightLossServices.dislikeWeightLossPost(post: post) { error in
                if let error = error {
                    
                    print("failed to dislike the ting \(error.localizedDescription)")
                    return
                }
                
                cell.likeButton.setImage(UIImage(systemName: "suit.heart"), for: .normal)
                cell.likeButton.tintColor = .black
                cell.viewModel?.posts.likes = post.likes - 1
            }

        }else {
            
            WeightLossServices.likedWeightLossPost(post: post) { error in
                if let error = error {
                    
                    print("DEBUGG: FAILED TO LIKE THE POST")
                    return
                }
                
                cell.likeButton.setImage(UIImage(systemName: "heart.circle.fill"), for: .normal)
                cell.likeButton.tintColor = .systemPurple
                cell.viewModel?.posts.likes = post.likes + 1
                
                NotificationServices.uploadNotifications(toUid: post.ownerUid, fromUser: self.user, type: .likes, post: post)
                
                PushNotificationServices.sendNotificationToUser(to: post.user.pushID, nameOfUser: self.user.name, body: "Liked your post")
                
            }
        }
        
        if post.didLike {
            
            WeightGainServices.dislikeWeightGainPost(post: post) { error in
                if let error = error {
                    
                    print("failed to like weight gain post \(error.localizedDescription)")
                    return
                }
                
                cell.likeButton.setImage(UIImage(systemName: "suit.heart"), for: .normal)
                cell.likeButton.tintColor = .black
                cell.viewModel?.posts.likes = post.likes - 1
                
            }
            
        }else {
            
            WeightGainServices.likedWeightGainPost(post: post) { error  in
                if let error = error {
                    
                    print("failed to like th weightgain post \(error.localizedDescription)")
                    return
                }
                
                cell.likeButton.setImage(UIImage(systemName: "heart.circle.fill"), for: .normal)
                cell.likeButton.tintColor = .systemPurple
                cell.viewModel?.posts.likes = post.likes + 1
                
               // NotificationServices.uploadNotifications(toUid: post.ownerUid, fromUser: self.user, type: .likes, post: post)
                
                //PushNotificationServices.sendNotificationToUser(to: post.user.pushID, nameOfUser: self.user.name, body: "Liked your post")
                
                
            }
            
        }
        
    }
    
    
    func cell(_ cell: HomeCell, wantsToReplyTo post: TextPost) {
        
        let controller = CommentController(post: post, user: user)
        HidePostButton()
        navigationController?.pushViewController(controller, animated: true)
        
    }
    
    func cell(_ cell: HomeCell, wantsToShowProfileFor uid: String) {
        

        // we fetch a user with thier specific uid, which we set in our cell View.
        UserServices.fetchUser(withCurrentUser: uid) { user in
             let controller = ProfileController(user: user)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}

//MARK: - EditProfileControllerDelegate

extension HomeController: EditProfileControllerDelegate {
    
    func controller(_ controller: EditProfileController, wantsToUpdate user: User) {
        self.user = user
        self.collectionView.reloadData()
        controller.delegate = self
        handleRefresher()
        
        print("DEBUGG: ITS LOADING IN THE HOMEPAGE")
        
    }
}

