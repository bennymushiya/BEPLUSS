//
//  ChatController.swift
//  Weightloss
//
//  Created by benny mushiya on 30/04/2021.
//

import UIKit

enum chatControllerConfiguration {

    case profile
    case notProfile
}

private let reuseIdentifier = "cell"

class ChatController: UITableViewController {
    
    //MARK: - PROPERTIES
    
    private var controllerConfiguration: chatControllerConfiguration = .notProfile
    
    private var conversation = [Conversations]()
    
    // the key will be the to user uid and the value will be the messages sent to that user. this way we avoid duplicate keys, rather it only adds to the conversation.
    private var conversationsDictionary = [String: Conversations]()
    

    
    
    //MARK: - LIFECYCLE
    
    init(config: chatControllerConfiguration) {
        self.controllerConfiguration = config
        super.init(style: .plain)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        fetchConversations()
        
    }

    //MARK: - HELPERS
    
    private func configureUI() {

        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        navigationItem.title = controllerConfiguration == .profile ? "New Message" : "Chat"
        tableView.rowHeight = 100
        
        
        tableView.register(ChatCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        if controllerConfiguration == .profile {
            
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleDissmall))
            
            navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            navigationController?.navigationBar.tintColor = .white
            
        }
        
    }
    
    //MARK: - API

    func fetchConversations() {
        
        MessagesServices.fetchConversations { conversations in
            
            // loop through our conversations
            conversations.forEach { conversation in
                
                // we set up our dictionary
                let message = conversation.messages
                
                // we set the key as chatPartnerId and the value is the conversation
                self.conversationsDictionary[message.chatPartnerId] = conversation
            }

            self.conversation = Array(self.conversationsDictionary.values)
            self.tableView.reloadData()
        }
        
    }
    
    
    //MARK: - ACTION
    
    func presentMessageController(forUser user: User) {
        
        let controller = MessageController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func handleDissmall() {
        
        dismiss(animated: true, completion: nil)
        
    }
}

//MARK: - DataSource

extension ChatController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return conversation.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ChatCell
        
        //cell.textLabel?.text = conversations[indexPath.row].messages.text
        
        cell.viewModel = ConversationViewModel(conversations: conversation[indexPath.row])

        return cell
    }
    
}

//MARK: - Delegate

extension ChatController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        let user = conversation[indexPath.row].user
        presentMessageController(forUser: user)

    }
}

