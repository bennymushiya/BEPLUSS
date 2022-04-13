//
//  SearchController.swift
//  Weightloss
//
//  Created by benny mushiya on 10/06/2021.
//

import UIKit
import FirebaseAuth
import Firebase

private let reuseIdenitifier = "search cell"
private let cellIdentifier = "collection cell"

class SearchController: UIViewController {
    
    
    //MARK: - PROPERTIES
    
    private let tableView = UITableView()
    private var users = [User]()
    
    private var filteredUsers = [User]()
    
    let user: User
    
    private let customActionSheet = CustomActionSheet()
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    private var posts = [ProgressPost]()
        
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
    
    private var inSearchMode: Bool {
        
        return searchController.isActive && !searchController.searchBar.text!.isEmpty
        
    }
    
    private var displaySearchMaterial: Bool {
        
        return searchController.isActive && !searchController.searchBar.text!.isEmpty
        
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.dataSource = self
        cv.delegate = self
        cv.backgroundColor = .white
        cv.register(SearchCollectionCell.self, forCellWithReuseIdentifier: cellIdentifier)
        
        return cv
    }()
    
    
    //MARK: - LIFECYCLE
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSearchController()
        configureUI()
        fetchUsers()
        fetchProgressPosts()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        displayPostButton()
        navigationController?.navigationBar.isHidden = false
        self.tableView.reloadData()
    }
    
    //MARK: - HELPERS
    
    func configureUI() {
        
        let notificationButton = UIBarButtonItem(customView: notificationButton)
        let chatButton = UIBarButtonItem(customView: chatButton)
        
       // navigationItem.rightBarButtonItems = [chatButton, notificationButton]
        tableView.delegate = self
        tableView.dataSource = self
        
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        navigationItem.title = "Search"
        tableView.register(SearchCell.self, forCellReuseIdentifier: reuseIdenitifier)
        tableView.rowHeight = 80
        tableView.isHidden = true
        
        view.addSubview(tableView)
        tableView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        tableView.fillSuperview()
        
        view.addSubview(collectionView)
        collectionView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        collectionView.fillSuperview()
        
    }
    
    
    func configureSearchController() {
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = false
        searchController.searchBar.barTintColor = #colorLiteral(red: 0.1598605525, green: 0.9373220266, blue: 0.7734893539, alpha: 1)
        searchController.searchBar.tintColor = #colorLiteral(red: 0.1598605525, green: 0.9373220266, blue: 0.7734893539, alpha: 1)
        searchController.searchBar.delegate = self

        
    }
    
    //MARK: - API
    
    func fetchUsers() {
        
        UserServices.fetchUsers { users in
            self.users = users
            self.tableView.reloadData()
            
            print("DEBUGG: THE AMOUNT OF USERS ARE \(users.count)")
        }
    }
    
    func fetchProgressPosts() {
        
        ProgressServices.fetchProgressPost { posts in
            self.posts = posts
            self.collectionView.reloadData()
        }
        
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
    
}

//MARK: - UITableViewDataSource

extension SearchController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return inSearchMode ? filteredUsers.count : users.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdenitifier, for: indexPath) as! SearchCell
        
        let user = inSearchMode ? filteredUsers[indexPath.row] : users[indexPath.row]
        cell.viewModel = SearchViewModel(user: user)
        
        return cell
        
    }
}

//MARK: - UITableViewDelegate

extension SearchController: UITableViewDelegate {
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let user = inSearchMode ? filteredUsers[indexPath.row] : users[indexPath.row]
        
        let controller = ProfileController(user: user)
        navigationController?.pushViewController(controller, animated: true)
        
    }
}

//MARK: - UISearchBarDelegate

extension SearchController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    
        searchBar.showsCancelButton = true
        collectionView.isHidden = true
        tableView.isHidden = false
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.endEditing(true)
        searchBar.showsCancelButton = false
        searchBar.text = nil
        
        collectionView.isHidden = false
        tableView.isHidden = true
    }
    
}

//MARK: - UISearchResultsUpdating

extension SearchController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let searchText = searchController.searchBar.text?.lowercased() else {return}
        
        filteredUsers = users.filter({
            $0.name.lowercased().contains(searchText) ||
                $0.fitnessGoals.lowercased().contains(searchText)
            
        })
        
        self.tableView.reloadData()

    }
    
}

//MARK: - UICollectionViewDataSource

extension SearchController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return inSearchMode ? filteredUsers.count : posts.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! SearchCollectionCell
        
        cell.viewModel = ProgressPostViewModel(posts: posts[indexPath.row])
        
        return cell
    }
}

//MARK: - UICollectionViewDelegate

extension SearchController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let controller = ImageCommentController(post: posts[indexPath.row], user: user)
        HidePostButton()
        navigationController?.pushViewController(controller, animated: true)
        
    }
    
}

//MARK: - UICollectionViewDelegateFlowLayout

extension SearchController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (view.frame.width - 2) / 2
        
        return CGSize(width: width, height: width)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return .init(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 1
    }
    
    
}
