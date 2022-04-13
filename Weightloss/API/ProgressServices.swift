//
//  ProgressServices.swift
//  Weightloss
//
//  Created by benny mushiya on 24/05/2021.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore


struct ProgressServices {
    
    
    static func uploadImagePost(image: UIImage, caption: String?, user: User, completion: @escaping(FirestoreCompletion)) {
        
        guard let  currentUser = Auth.auth().currentUser?.uid else {return}
        
        ImageUploader.uploadImage(image: image) { imageUrl in
            
            var data = ["image": imageUrl,
                        "likes": 0,
                        "timeStamp": Timestamp(date: Date()),
            "ownerUid": currentUser] as [String: Any]
            
            if let caption = caption {
                data["caption"] = caption

            }
            
            COLLECTION_PROGRESS.addDocument(data: data, completion: completion)
        }
    }
    
    
    static func deletePost(post: ProgressPost, completion: @escaping(FirestoreCompletion)) {
         
         guard let currentUser = Auth.auth().currentUser?.uid else {return}
         
     COLLECTION_PROGRESS.document(post.postID).delete(completion: completion)
         
     }
    
    
    
   static func fetchUserProgressPost(withUid uid: String, completion: @escaping(([ProgressPost]) -> Void)) {
        
        var progressPosts = [ProgressPost]()
        
        COLLECTION_PROGRESS.whereField("ownerUid", isEqualTo: uid).getDocuments { snapshot, error in
            
            guard let documents = snapshot?.documents else {return}
            
            documents.forEach { docs in
                let dictionary = docs.data()
                guard let ownerUid = dictionary["ownerUid"] as? String else {return}
                
                UserServices.fetchUser(withCurrentUser: ownerUid) { user in
                    
                    let posts = ProgressPost(user: user, postID: docs.documentID , dictionary: dictionary)
                    
                    progressPosts.append(posts)
                    
                    progressPosts.sorted(by: { $0.timeStamp.seconds > $1.timeStamp.seconds })
                    
                    completion(progressPosts)
                }
            }
        }
    }
    
    static func fetchProgressPost(completion: @escaping([ProgressPost]) -> Void) {
        
        var progressPost = [ProgressPost]()
        
        COLLECTION_PROGRESS.order(by: "timeStamp", descending: true).getDocuments { snapshot, error in
            
            guard let documents = snapshot?.documents else {return}
            
            documents.forEach { docs in
                let dictionary = docs.data()
                guard let ownerUid = dictionary["ownerUid"] as? String else {return}
                
                UserServices.fetchUser(withCurrentUser: ownerUid) { user in
                    
                    let posts = ProgressPost(user: user, postID: docs.documentID, dictionary: dictionary)
                    
                    progressPost.append(posts)
                    
                    progressPost.sorted(by: { $0.timeStamp.seconds > $1.timeStamp.seconds })
                    
                    completion(progressPost)
                    
                }
            }
        }
    }
    
    
    static func likedPost(post: ProgressPost, completion: @escaping(FirestoreCompletion)) {
        
        guard let currentUser = Auth.auth().currentUser?.uid else {return}
        
        COLLECTION_PROGRESS.document(post.postID).updateData(["likes": post.likes + 1])
        
        COLLECTION_PROGRESS.document(post.postID).collection("post-likes").document(currentUser).setData([:]) { _ in
            
            COLLECTION_USERS.document(currentUser).collection("user-likes").document(post.postID).setData([:], completion: completion)
        }
        
    }
    
    static func dislikePost(post: ProgressPost, completion: @escaping(FirestoreCompletion)) {
        
        
        guard let currentUser = Auth.auth().currentUser?.uid else {return}
        
        guard post.likes > 0 else {return}

        
        COLLECTION_PROGRESS.document(post.postID).updateData(["likes": post.likes - 1])
        
        COLLECTION_PROGRESS.document(post.postID).collection("post-likes").document(currentUser).delete { _ in
            
            COLLECTION_USERS.document(currentUser).collection("user-likes").document(post.postID).delete(completion: completion)
        }
        
    }
    
    static func checkIfUserlikedPost(post: ProgressPost, completion: @escaping(Bool) -> Void) {
        
        guard let currentUser = Auth.auth().currentUser?.uid else {return}
        
        COLLECTION_USERS.document(currentUser).collection("user-likes").document(post.postID).getDocument { snapshot, error in
            
            guard let didLike = snapshot?.exists else {return}
            
            completion(didLike)
        }
        
    }
    
    static func uploadComments(caption: String, post: ProgressPost, user: User, completion: @escaping(FirestoreCompletion)) {
        
        let comments = ["commentText": caption,
                    "uid": user.uid,
                    "name": user.name,
                    "profileImage": user.profileImage,
                    "timeStamp": Timestamp(date: Date())] as [String: Any]
        
        
        COLLECTION_PROGRESS.document(post.postID).collection("comments").addDocument(data: comments, completion: completion)
        
    }
    
    
    static func fetchComments(forPost postID: ProgressPost, completion: @escaping([Comments]) -> Void) {
        
        var comments = [Comments]()
        
        let query = COLLECTION_PROGRESS.document(postID.postID).collection("comments").order(by: "timeStamp", descending: true)
        
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
    
    
}
