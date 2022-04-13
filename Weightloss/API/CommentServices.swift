//
//  CommentServices.swift
//  Weightloss
//
//  Created by benny mushiya on 10/05/2021.
//

import UIKit
import Firebase
import FirebaseAuth


struct CommentServices {
    
    
    static func uploadComments(caption: String, post: TextPost, user: User, completion: @escaping(FirestoreCompletion)) {
        
        let comments = ["commentText": caption,
                    "uid": user.uid,
                    "name": user.name,
                    "profileImage": user.profileImage,
                    "timeStamp": Timestamp(date: Date())] as [String: Any]
        
        
        COLLECTION_TEXTPOST.document(post.postID).collection("comments").addDocument(data: comments, completion: completion)
        
    }
    
    
    static func fetchComments(forPost postID: TextPost, completion: @escaping([Comments]) -> Void) {
        
        var comments = [Comments]()
        
        let query = COLLECTION_TEXTPOST.document(postID.postID).collection("comments").order(by: "timeStamp", descending: true)
        
        query.addSnapshotListener { snapshot, error in
            if let error = error {
                
                print("failed to get documents \(error.localizedDescription)")
                return
            }
            
            snapshot?.documentChanges.forEach({ change in
                if change.type == .added {
                    let dictionary = change.document.data()
                    let comment = Comments(dictionary: dictionary)
                    
                    comments.append(comment)
                }
                
                completion(comments)
            })
        }
    }
    
    static func fetchCommentCount(forPost post: TextPost, completion: @escaping(Int) -> Void) {
         
     COLLECTION_TEXTPOST.document(post.postID).collection("comments").getDocuments { snapshot, error in
             
         guard let comments = snapshot?.documents.count else {return}
                          
             completion(comments)
         }
     }
    
    static func fetchCommentCountForProgressPost(forPost post: ProgressPost, completion: @escaping(Int) -> Void) {
        
        COLLECTION_PROGRESS.document(post.postID).collection("comments").getDocuments { snapshot, error in
            
            guard let comments = snapshot?.documents.count else {return}
            
            completion(comments)
        }
    }
}
