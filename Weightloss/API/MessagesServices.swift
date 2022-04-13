//
//  MessagesServices.swift
//  Weightloss
//
//  Created by benny mushiya on 25/05/2021.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore


struct MessagesServices {
    
    
    static func uploadMessage(message: String, toUser user: User , completion: @escaping(FirestoreCompletion)) {
        
        guard let currentUser = Auth.auth().currentUser?.uid else {return}
        
        let data = ["text": message,
                    "toID": user.uid,
                    "fromID": currentUser,
        "timeStamp": Timestamp(date: Date())] as [String: Any]
        
        COLLECTION_MESSAGES.document(currentUser).collection(user.uid).addDocument(data: data) { _ in
            
           // COLLECTION_MESSAGES.document(user.uid).collection(currentUser).addDocument(data: data, completion: completion)
            
            COLLECTION_MESSAGES.document(currentUser).collection("recent-messages").document(user.uid).setData(data)

            COLLECTION_MESSAGES.document(user.uid).collection("recent-messages").document(currentUser).setData(data, completion: completion)
        }
    }
    
    
    static func fetchMessages(forUser user: User, completion: @escaping(([Messages]) -> Void)) {
        
        var messages = [Messages]()
        
        guard let currentUser = Auth.auth().currentUser?.uid else {return}
        
        let query = COLLECTION_MESSAGES.document(currentUser).collection(user.uid).order(by: "timeStamp")
        
        query.addSnapshotListener { snapshot, error in
            
            snapshot?.documentChanges.forEach({ change in
                if change.type == .added {
                    let dictonary = change.document.data()
                    messages.append(Messages(dictionary: dictonary))
                    
                    completion(messages)
                }
            })
        }
    }
    
    
    static func fetchConversations(completion: @escaping(([Conversations]) -> Void)) {
        
        var conversation = [Conversations]()
        
        guard let currentUser = Auth.auth().currentUser?.uid else {return}
        
         let query = COLLECTION_MESSAGES.document(currentUser).collection("recent-messages").order(by: "timeStamp")
        
   
        query.addSnapshotListener { snapshot, error in
            
            snapshot?.documentChanges.forEach({ change in
                //if change.type == .added {
                    let dictionary = change.document.data()
                    let messages = Messages(dictionary: dictionary)
                    
                    // even though we grab the recent- messages from the our current user, we need the other users information, hence why we fetch them with thier uid and initialise conversation model with messages from our current user and the user were talking to.
                    UserServices.fetchUser(withCurrentUser: messages.chatPartnerId) { user in
                        let conversations = Conversations(user: user, messages: messages)
                        conversation.append(conversations)
                        completion(conversation)
                        
                    }
            })
        }
    }
}
