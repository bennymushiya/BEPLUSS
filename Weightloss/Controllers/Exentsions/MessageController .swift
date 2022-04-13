//
//  MessageController .swift
//  Weightloss
//
//  Created by benny mushiya on 12/05/2021.
//

import UIKit
import SDWebImage
import Firebase
import FirebaseAuth


private let reuseIdentifier = "collectionCell"

class MessageController: UICollectionViewController {
    
    
    //MARK: - PROPERTIES
    
    private var messages = [Messages]()
    
    private let user: User
    
    var fromCurrentUser = false
    
    private lazy var customInputView: CustomInputAccessoryView = {
        let iv = CustomInputAccessoryView(frame: CGRect(x: 0, y: 0,
                                                        width: view.frame.width,
                                                        height: 50))
        iv.delegate = self
        return iv
    }()
    
    //MARK: - LIFECYCLE
    
    init(user: User) {
        self.user = user
        // collection view has to be initialised by a collection view layout
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        fetchMessages()
        
        
    }
    
    override var inputAccessoryView: UIView? {
        get { return customInputView }
        
    }
    
    override var canBecomeFirstResponder: Bool {
        
        get { return true }
         
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        navigationController?.navigationBar.isHidden = false
    }
    
    //MARK: - HELPERS
    
    func configureUI() {
        
        collectionView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        navigationItem.title = user.name
        
        // registering and adding our collection cell
        collectionView.register(MessageCell.self,forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.alwaysBounceVertical = true
           
        // dismisses the keyboard whenever we scroll up
        collectionView.keyboardDismissMode = .interactive
        
    }
    
    //MARK: - API

    func fetchMessages() {
        
        MessagesServices.fetchMessages(forUser: user) { message in
            self.messages = message
            self.collectionView.reloadData()
            
            // everytime a new message is sent the controller automaticaly scrolls down to the bottom of the collection view.
            self.collectionView.scrollToItem(at: [0, self.messages.count - 1], at: .bottom, animated: true)
        }
    }
    
    //MARK: - ACTIONS
    
    
    
}

//MARK: - UICollectionViewDataSource

extension MessageController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MessageCell
        
        cell.message = messages[indexPath.row]
        cell.message?.user = user
                
        return cell
        
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

// customizes the apearance and size of number of cells/sections weve demanded above.
extension MessageController: UICollectionViewDelegateFlowLayout {
    
    //customizes the padding and spacing of the cells
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return.init(top: 16, left: 5, bottom: 16, right: 0)
    }
    
    
    // customizes the height and width of the cells.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let estimatedSizeCell = MessageCell(frame: frame)
        estimatedSizeCell.message = messages[indexPath.row]
        
        //if the height is less or equal to 50 it wont do anything if its greater then this function below is called.
        estimatedSizeCell.layoutIfNeeded()
        
        let targetSize = CGSize(width: view.frame.width, height: 1000)
        
        // helps us figure out how tall a cell should be based on the estimatedSizeCell.
        let estimateSize = estimatedSizeCell.systemLayoutSizeFitting(targetSize)
        
        return .init(width: view.frame.width, height: estimateSize.height)
    }
}

//MARK: - CustomInputAccessoryViewDelegate

extension MessageController: CustomInputAccessoryViewDelegate {
    
    func inputView(_ inputView: CustomInputAccessoryView) {
        
        inputView.sendButton.isEnabled = true
    }
    
    
    func inputView(_ inputView: CustomInputAccessoryView, wantsToSend message: String) {
        
        guard let tab = tabBarController as? MainTabBarController else {return}
        guard let username = tab.user?.name else {return}
        
        // we initialise this controller with the user from the post, thus we send them the message.
            MessagesServices.uploadMessage(message: message, toUser: user) { error in
                if let error = error {
                    
                    print("DBEUGG: FAILLED TO UPLOAD DATA \(error.localizedDescription)")
                    return
                }
                
                print("DEBUGG: SUCCESSDFULLY UPLOAD DATA")
                PushNotificationServices.sendNotificationToUser(to: self.user.pushID, nameOfUser: username, body: message)

                inputView.clearMessage()
                inputView.sendButton.isEnabled = false
            }
    }
    
}
