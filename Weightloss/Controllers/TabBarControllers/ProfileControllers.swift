//
//  ProfileControllers.swift
//  Weightloss
//
//  Created by benny mushiya on 29/10/2021.
//

import UIKit
import Firebase
import FirebaseAuth


private let headerIdentifier = "header cell"
private let cellIdentifier = "cell"

class ProfileController: UICollectionViewController {
    
    //MARK: - PROPERTIES
    
    private var user: User
    
    private var userPosts = [TextPost]()
    
    private let refresher = UIRefreshControl()
        
    //MARK: - LIFECYCLE
    
    init(user: User) {
        self.user = user
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden = false
        collectionView.reloadData()

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        fetchUsersTextPosts()
        fetchUserStats()
        handleRefresh()
    }
    
    //MARK: - HELPERS

    func configureUI() {
        
        collectionView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        navigationController?.navigationBar.isHidden = true
        collectionView.refreshControl = refresher
        refresher.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        
        collectionView.register(ProfileCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.register(ProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        
    }
    
    //MARK: - API
    
    func fetchUserWeightLossPosts() {
        
        WeightLossServices.fetchWeightLossPostForCurrentUser(withUid: user.uid) { textPost in
            self.userPosts = textPost
            self.collectionView.refreshControl?.endRefreshing()
            self.checkIfUserRelatedToPost()
            self.checkIfUserLikedWeightLossPost()
            self.collectionView.reloadData()

        }
    }
    
    func fetchUsersTextPosts() {
        
        let chosenCommunity = "WeightLossCommunity"
        
        switch user.chosenCommunity.elementsEqual(chosenCommunity) {
        case true:
           fetchUserWeightLossPosts()
        case false:
          fetchUserWeightGainPosts()
        }
        
    }
    
    func fetchUserWeightGainPosts() {
        
        WeightGainServices.fetchWeightGainPostForCurrentUser(withUid: user.uid) { textPost in
            self.userPosts = textPost
            self.collectionView.refreshControl?.endRefreshing()
            self.collectionView.reloadData()
            
        }
    }
    
    func checkIfUserRelatedToPost() {
        
        self.userPosts.forEach { postss in
            WeightLossServices.checkIfUserRelatedWeightLossPost(post: postss) { didRelate in
                
                if let index = self.userPosts.firstIndex(where: { $0.postID == postss.postID}) {
                    self.userPosts[index].didRelate = didRelate
                    
                }
            }
        }
    }
    
    func checkIfUserLikedWeightLossPost() {
        
        self.userPosts.forEach { postlad in
            WeightLossServices.checkIfUserlikedPost(post: postlad) { didLike in
                
                if let index = self.userPosts.firstIndex(where: {$0.postID == postlad.postID}) {
                    
                    self.userPosts[index].didLike = didLike
                }
            }
        }
    }
    
    
    func fetchWeightLossStats() {
        
        UserServices.fetchUserStats(currentUser: user.uid) { stats in
            self.user.stats = stats
            self.collectionView.reloadData()

        }
    }
    
    func fetchWeightGainStats() {
        
        UserServices.fetchWeightGainStats(withUid: user.uid) { stats in
            self.user.weightGainStats = stats
            self.collectionView.reloadData()
        }
    }
    
    
    func fetchUserStats() {
        
        let chosenCommunity = "WeightLossCommunity"
        
        if user.chosenCommunity.elementsEqual(chosenCommunity) {
            
            fetchWeightLossStats()
        }else {
            
            fetchWeightGainStats()
        }
    }

    //MARK: - ACTION

    @objc func handleRefresh() {
        
        userPosts.removeAll()
        //fetchUserWeightLossPosts()
        fetchUsersTextPosts()
        
    }
    
    
    func presentLogInController() {
        
        DispatchQueue.main.async {
            let controller = LogInController()
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        }
    }
}

//MARK: - UICollectionViewDataSource

extension ProfileController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return userPosts.count
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! ProfileHeader
        
        header.viewModel = ProfileHeaderViewModel(user: user)
        header.delegate = self
        
        return header
    }
    
   
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! ProfileCell
        
        cell.viewModel = TextPostViewModel(posts: userPosts[indexPath.row] as! TextPost)
        cell.delegate = self
        
        return cell
        
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension ProfileController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        let viewModel = ProfileHeaderViewModel(user: user)
        let height = viewModel.size(forWidth: view.frame.width).height
        
        return CGSize(width: view.frame.width, height: height + 460)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return .init(top: 20, left: 0, bottom: 0, right: 0)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let viewModel = TextPostViewModel(posts: userPosts[indexPath.row] as! TextPost)
        let height = viewModel.size(forWidth: view.frame.width).height
        
        return CGSize(width: view.frame.width, height: height + 150)
    }
    
}

//MARK: - ProfileHeaderDelegate

extension ProfileController: ProfileHeaderDelegate {
    
    func wantsToGoToProgressPost() {
        
        let controller = ProgressProfileController(user: user)
        navigationController?.pushViewController(controller, animated: true)
        
    }
    
    func header(_ header: ProfileHeader, wantsToChatWith uid: String) {
        
        guard let isCurrentUser = header.viewModel?.user.isCurrentUser else {return}

        if isCurrentUser {
            
            let controller = EditProfileController(user: user)
            controller.delegate = self
           navigationController?.pushViewController(controller, animated: true)
            
        }else{
            
            UserServices.fetchUser(withCurrentUser: uid) { userz in
                let controller = MessageController(user: userz)
                self.HidePostButton()
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }
    }
}

//MARK: - ProfileCellDelegate

extension ProfileController: ProfileCellDelegate {
    
    func cell(_ cell: ProfileCell, wantsToGetCommentCountFor post: TextPost) {
        
        CommentServices.fetchCommentCount(forPost: post) { commentCount in
            cell.viewModel?.posts.commentStat.numberOfComments = commentCount
            //cell.viewModel?.posts.commentStat.numberOfComments = commentCount
            
    }
}
    
    func cell(_ cell: ProfileCell, didRelateTo post: TextPost) {
        
        cell.viewModel?.posts.didRelate.toggle()
        
        if post.didRelate {
        
            WeightLossServices.unrelateWeightLossPost(post: post) { error in
                if let error = error {
                    
                    print("failed to unrelate to post \(error.localizedDescription)")
                    return
                }
                
                cell.relateButton.setImage(UIImage(systemName: "circles.hexagongrid"), for: .normal)
                cell.relateButton.tintColor = .black
                cell.viewModel?.posts.relatables = post.relatables - 1
            }
            
        }else {
            
            WeightLossServices.relateToWeightLossPost(post: post) { error  in
                if let error = error {
                    
                    print("failed to relate to post \(error.localizedDescription)")
                    return
                }
                
                cell.relateButton.setImage(UIImage(systemName: "circles.hexagongrid.fill"), for: .normal)
                cell.relateButton.tintColor = .systemPink
                cell.viewModel?.posts.relatables = post.relatables + 1
            }
        }
    }
    
    func cell(_ cell: ProfileCell, wantsToReplyTo post: TextPost) {
        
        let controller = CommentController(post: post, user: user)
        navigationController?.navigationBar.isHidden = false
        navigationController?.pushViewController(controller, animated: true)
        
    }
    
    
    func cell(_ cell: ProfileCell) {
        
        print("share ad that")
        
    }
    
    func cell(_ cell: ProfileCell, didLike post: TextPost) {
        
        cell.viewModel?.posts.didLike.toggle()
        
        if post.didLike {
            
            WeightLossServices.dislikeWeightLossPost(post: post) { error in
                if let error = error {
                    
                    print("failed to unrelate to post \(error.localizedDescription)")
                    return
                }
                
                cell.likeButton.setImage(UIImage(systemName: "suit.heart"), for: .normal)
                cell.likeButton.tintColor = .black
                cell.viewModel?.posts.likes = post.likes - 1
            }
            
        }else {
            
            WeightLossServices.likedWeightLossPost(post: post) { error  in
                if let error = error {
                    
                    print("failed to relate to post \(error.localizedDescription)")
                    return
                }
                
                cell.likeButton.setImage(UIImage(systemName: "heart.circle.fill"), for: .normal)
                cell.likeButton.tintColor = .systemPurple
                cell.viewModel?.posts.likes = post.likes + 1
            }
        }
        
    }
    
}

//MARK: - EditProfileControllerDelegate

extension ProfileController: EditProfileControllerDelegate {
    
    func controller(_ controller: EditProfileController, wantsToUpdate user: User) {
        //controller.dismiss(animated: true, completion: nil)
        self.user = user
        self.collectionView.reloadData()
        
    }
    
}

