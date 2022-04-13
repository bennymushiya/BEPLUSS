//
//  WeightGainServices.swift
//  Weightloss
//
//  Created by benny mushiya on 17/05/2021.
//

import UIKit
import Firebase
import FirebaseAuth



struct WeightGainServices {
    
    
    static func uploadWeightGainPost(post: String, user: User, completion: @escaping(FirestoreCompletion)) {
        
        guard let currentUser = Auth.auth().currentUser?.uid else {return}
        
        let data = ["post": post,
                    "ownerName": user.name,
                    "timeStamp": Timestamp(date: Date()),
                    "ownerUid": currentUser,
                    "relatables": 0,
                    "likes": 0,
                    "numberOfComments": 0,
                    "type": "weightGain",
                    "ownerProfileImage": user.profileImage] as [String: Any]
        
        COLLECTION_WEIGHTGAIN.addDocument(data: data, completion: completion)
        
    }
    
    
    static func fetchWeightGainPost(completion: @escaping([TextPost]) -> Void) {
        
        var textPost = [TextPost]()
        
        COLLECTION_WEIGHTGAIN.order(by: "timeStamp", descending: true).getDocuments { snapshot, error in
            
            guard let documents = snapshot?.documents else {return}
            
            documents.forEach { docs in
                let dictionary = docs.data()
                guard let ownerUid = dictionary["ownerUid"] as? String else {return}
                
                UserServices.fetchUser(withCurrentUser: ownerUid) { user in
                    
                    let posts = TextPost(user: user, postID: docs.documentID, dictionary: dictionary)
                    
                    textPost.append(posts)
                    
                    textPost.sorted(by: { $0.timeStamp.seconds > $1.timeStamp.seconds })
                                      
                    
                    completion(textPost)
                    
                }
            }
        }
    }
    
    
    static func relateToWeightGainPost(post: TextPost, completion: @escaping(FirestoreCompletion)) {
        
        guard let currentUser = Auth.auth().currentUser?.uid else {return}
        
        COLLECTION_WEIGHTGAIN.document(post.postID).updateData(["relatables": post.relatables + 1])
        
        COLLECTION_WEIGHTGAIN.document(post.postID).collection("post-relatables").document(currentUser).setData([:]) { _ in
            
            COLLECTION_USERS.document(currentUser).collection("user-weightGain-relatables").document(post.postID).setData([:], completion: completion)
        }
        
    }
    
    
    static func unrelateWeightGainPost(post: TextPost, completion: @escaping(FirestoreCompletion)) {
        
        guard let currentUser = Auth.auth().currentUser?.uid else {return}

        guard post.relatables > 0 else {return}
        
        COLLECTION_WEIGHTGAIN.document(post.postID).updateData(["relatables": post.relatables - 1])
        
        COLLECTION_WEIGHTGAIN.document(post.postID).collection("post-relatables").document(currentUser).delete { _ in
            
            COLLECTION_USERS.document(currentUser).collection("user-weightGain-relatables").document(post.postID).delete(completion: completion)
        }
        
    }
    
    
    static func checkIfUserRelatedWeightGainPost(post: TextPost, completion: @escaping(Bool) -> Void) {
        
        guard let currentUser = Auth.auth().currentUser?.uid else {return}
        
        COLLECTION_USERS.document(currentUser).collection("user-weightGain-relatables").document(post.postID).getDocument { snapshot, error in
            
            guard let didLike = snapshot?.exists else {return}
            
            completion(didLike)
        }
        
    }
    
    
    static func likedWeightGainPost(post: TextPost, completion: @escaping(FirestoreCompletion)) {
        
        guard let currentUser = Auth.auth().currentUser?.uid else {return}
        
        COLLECTION_WEIGHTGAIN.document(post.postID).updateData(["likes": post.likes + 1])
        
        COLLECTION_WEIGHTGAIN.document(post.postID).collection("post-likes").document(currentUser).setData([:]) { _ in
            
            COLLECTION_USERS.document(currentUser).collection("user-weightGain-likes").document(post.postID).setData([:], completion: completion)
        }
        
    }
    
    static func dislikeWeightGainPost(post: TextPost, completion: @escaping(FirestoreCompletion)) {
        
        
        guard let currentUser = Auth.auth().currentUser?.uid else {return}
        
        guard post.likes > 0 else {return}

        
        COLLECTION_WEIGHTGAIN.document(post.postID).updateData(["likes": post.likes - 1])
        
        COLLECTION_WEIGHTGAIN.document(post.postID).collection("post-likes").document(currentUser).delete { _ in
            
            COLLECTION_USERS.document(currentUser).collection("user-weightGain-likes").document(post.postID).delete(completion: completion)
        }
        
    }
    
    static func checkIfUserlikedWeightGainPost(post: TextPost, completion: @escaping(Bool) -> Void) {
        
        guard let currentUser = Auth.auth().currentUser?.uid else {return}
        
        COLLECTION_USERS.document(currentUser).collection("user-weightGain-likes").document(post.postID).getDocument { snapshot, error in
            
            guard let didLike = snapshot?.exists else {return}
            
            completion(didLike)
        }
        
        
    }
    
    static func fetchWeightGainPostForCurrentUser(withUid uid: String, completion: @escaping([TextPost]) -> Void) {
        
        var textPost = [TextPost]()
                
        COLLECTION_WEIGHTGAIN.whereField("ownerUid", isEqualTo: uid).getDocuments { snapshot, error in
            
            guard let documents = snapshot?.documents else {return}
            
            documents.forEach { docs in
                let dictionary = docs.data()
                guard let ownerUid = dictionary["ownerUid"] as? String else {return}
              
        
                UserServices.fetchUser(withCurrentUser: ownerUid) { user in
                    
                    let posts = TextPost(user: user, postID: docs.documentID, dictionary: dictionary)
                    
                    textPost.append(posts)
                    
                    textPost.sort { post1, post2 in
                        
                        return post1.timeStamp.seconds > post2.timeStamp.seconds
                    }
                    
                    completion(textPost)
                }
               
                
            }
            
           
        }
        
        
        
    }
    
}


