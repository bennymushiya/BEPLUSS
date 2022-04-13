//
//  TweetServices.swift
//  Weightloss
//
//  Created by benny mushiya on 05/05/2021.
//

import UIKit
import Firebase
import FirebaseAuth



struct WeightLossServices {
    

    
    static func uploadWeightLossPost(post: String, completion: @escaping(FirestoreCompletion)) {
        
        guard let currentUser = Auth.auth().currentUser?.uid else {return}
        
        let data = ["post": post,
                    "timeStamp": Timestamp(date: Date()),
                    "ownerUid": currentUser,
                    "relatables": 0,
                    "likes": 0,
                    "numberOfComments": 0,
                    "type": "weightLoss"] as [String: Any]
        
        COLLECTION_TEXTPOST.addDocument(data: data, completion: completion)
        
    }
    
   static func deleteWeightLossPost(post: TextPost, completion: @escaping(FirestoreCompletion)) {
        
        guard let currentUser = Auth.auth().currentUser?.uid else {return}
        
    COLLECTION_TEXTPOST.document(post.postID).delete(completion: completion)
        
    }
    
    static func paginateHomePage(completion: @escaping([TextPost]) -> Void) {
        
        var lastDoc = [QueryDocumentSnapshot?]()
        var textPosts = [TextPost]()

        
        let query = COLLECTION_TEXTPOST.limit(to: 3).order(by: "timeStamp", descending: true)
        
        query.getDocuments { snapshot, _ in
            guard let documents = snapshot?.documents else {return}
            
            documents.forEach { docs in
              
                let dictionary = docs.data()
                guard let ownerUid = dictionary["ownerUid"] as? String else {return}
                
                UserServices.fetchUser(withCurrentUser: ownerUid) { user in
                    
                    let posts = TextPost(user: user, postID: docs.documentID, dictionary: dictionary)
                    
                    textPosts.append(posts)
                   
                    textPosts += [posts]
                    lastDoc += [docs]
                    
                    completion(textPosts)
                }
            }
            
        }
        
        
        
    }
    
    static func fetchExplorePagePosts(completion: @escaping([TextPost]) -> Void) {
        
        var posts = [TextPost]()
        var lastDoc: QueryDocumentSnapshot?

        
        let query = COLLECTION_TEXTPOST.limit(to: 3).order(by: "timeStamp", descending: true)
        
        if let last = lastDoc {
            let next = query.start(afterDocument: last)
            next.getDocuments { snapshot, _ in
                guard let documents = snapshot?.documents else { return }
                lastDoc = snapshot?.documents.last
                
                documents.forEach { docs in
                    let dictionary = docs.data()
                    guard let ownerUid = dictionary["ownerUid"] as? String else {return}
                    
                    UserServices.fetchUser(withCurrentUser: ownerUid) { user in
                        
                        let post = TextPost(user: user, postID: docs.documentID, dictionary: dictionary)
                        
                        posts.append(post)
                        
                        posts.sort { post1, post2 in
                            
                            return post1.timeStamp.seconds > post2.timeStamp.seconds
                            
                        }
                        
                    }
                }
                
               
            }
        } else {
            query.getDocuments { snapshot, _ in
                guard let documents = snapshot?.documents else { return }
                lastDoc = snapshot?.documents.last
                
                documents.forEach { docs in
                    let dictionary = docs.data()
                    guard let ownerUid = dictionary["ownerUid"] as? String else {return}
                    
                    UserServices.fetchUser(withCurrentUser: ownerUid) { user in
                        
                        let post = TextPost(user: user, postID: docs.documentID, dictionary: dictionary)
                        
                        posts.append(post)
                        
                        posts.sort { post1, post2 in
                            
                            return post1.timeStamp.seconds > post2.timeStamp.seconds
                            
                        }
                        
                        completion(posts)
                    }
                }
            }
        }
    }
    
    
    
    static func fetchWeightLossPostsWithPagination(completion: @escaping([TextPost]) -> Void) {
        
        //guard let currentUser = Auth.auth().currentUser?.uid else {return}
        var textPosts = [TextPost]()

        
        let query = COLLECTION_TEXTPOST.order(by: "timeStamp").limit(to: 2)
                
        query.getDocuments { snapshot, error in
            
            
            guard let documents = snapshot?.documents else {return}
            
            documents.forEach { docs in
                let dictionary = docs.data()
                guard let ownerUid = dictionary["ownerUid"] as? String else {return}
                
                UserServices.fetchUser(withCurrentUser: ownerUid) { user in
                    
                    let posts = TextPost(user: user, postID: docs.documentID, dictionary: dictionary)
                
                    textPosts.append(posts)
                    
                    textPosts.sort { post1, post2 in
                        
                        return post1.timeStamp.seconds > post2.timeStamp.seconds
                        
                    }
                    
                    completion(textPosts)
                }
            }
        }
        
    }
    
    
    static func fetchWeightLossPost(completion: @escaping([TextPost]) -> Void) {
        
        var textPosts = [TextPost]()
                
        COLLECTION_TEXTPOST.order(by: "timeStamp", descending: true).getDocuments { snapshot, error in
            
            guard let documents = snapshot?.documents else {return}
            
            documents.forEach { docs in
                let dictionary = docs.data()
                guard let ownerUid = dictionary["ownerUid"] as? String else {return}
                
                UserServices.fetchUser(withCurrentUser: ownerUid) { user in
                    
                    let posts = TextPost(user: user, postID: docs.documentID, dictionary: dictionary)
                
                    textPosts.append(posts)
                    
                    textPosts.sort { post1, post2 in
                        
                        return post1.timeStamp.seconds > post2.timeStamp.seconds
                    }
                    
                    completion(textPosts)
                }
            }
        }
    }
    
    
    static func fetchWeightLossPostForCurrentUser(withUid uid: String, completion: @escaping([TextPost]) -> Void) {
            
        var textPosts = [TextPost]()
        
        COLLECTION_TEXTPOST.whereField("ownerUid", isEqualTo: uid).getDocuments { snapshot, error in
            
            guard let documents = snapshot?.documents else {return}
            
            documents.forEach { docs in
                let dictionary = docs.data()
                guard let ownerUid = dictionary["ownerUid"] as? String else {return}
              
                UserServices.fetchUser(withCurrentUser: ownerUid) { user in
                    
                    let post = TextPost(user: user, postID: docs.documentID, dictionary: dictionary)
                    
                    textPosts.append(post)
                    
                    textPosts.sorted(by: { $0.timeStamp.seconds > $1.timeStamp.seconds })
                    
                    completion(textPosts)
                }
               
            }
            
        } 
    }
    
    
    static func relateToWeightLossPost(post: TextPost, completion: @escaping(FirestoreCompletion)) {
        
        guard let currentUser = Auth.auth().currentUser?.uid else {return}
        
        COLLECTION_TEXTPOST.document(post.postID).updateData(["relatables": post.relatables + 1])
        
        COLLECTION_TEXTPOST.document(post.postID).collection("post-relatables").document(currentUser).setData([:]) { _ in
            
            COLLECTION_USERS.document(currentUser).collection("user-relatables").document(post.postID).setData([:], completion: completion)
        }
        
    }
    
    
    static func unrelateWeightLossPost(post: TextPost, completion: @escaping(FirestoreCompletion)) {
        
        guard let currentUser = Auth.auth().currentUser?.uid else {return}

        guard post.relatables > 0 else {return}
        
        COLLECTION_TEXTPOST.document(post.postID).updateData(["relatables": post.relatables - 1])
        
        COLLECTION_TEXTPOST.document(post.postID).collection("post-relatables").document(currentUser).delete { _ in
            
            COLLECTION_USERS.document(currentUser).collection("user-relatables").document(post.postID).delete(completion: completion)
        }
        
    }
    
    
    static func checkIfUserRelatedWeightLossPost(post: TextPost, completion: @escaping(Bool) -> Void) {
        
        guard let currentUser = Auth.auth().currentUser?.uid else {return}
        
        COLLECTION_USERS.document(currentUser).collection("user-relatables").document(post.postID).getDocument { snapshot, error in
            
            guard let didLike = snapshot?.exists else {return}
            
            completion(didLike)
        }
        
    }
    
    
    static func likedWeightLossPost(post: TextPost, completion: @escaping(FirestoreCompletion)) {
        
        guard let currentUser = Auth.auth().currentUser?.uid else {return}
        
        COLLECTION_TEXTPOST.document(post.postID).updateData(["likes": post.likes + 1])
        
        COLLECTION_TEXTPOST.document(post.postID).collection("post-likes").document(currentUser).setData([:]) { _ in
            
            COLLECTION_USERS.document(currentUser).collection("user-likes").document(post.postID).setData([:], completion: completion)
        }
        
    }
    
    static func dislikeWeightLossPost(post: TextPost, completion: @escaping(FirestoreCompletion)) {
        
        
        guard let currentUser = Auth.auth().currentUser?.uid else {return}
        
        guard post.likes > 0 else {return}

        
        COLLECTION_TEXTPOST.document(post.postID).updateData(["likes": post.likes - 1])
        
        COLLECTION_TEXTPOST.document(post.postID).collection("post-likes").document(currentUser).delete { _ in
            
            COLLECTION_USERS.document(currentUser).collection("user-likes").document(post.postID).delete(completion: completion)
        }
        
    }
    
    static func checkIfUserlikedPost(post: TextPost, completion: @escaping(Bool) -> Void) {
        
        guard let currentUser = Auth.auth().currentUser?.uid else {return}
        
        COLLECTION_USERS.document(currentUser).collection("user-likes").document(post.postID).getDocument { snapshot, error in
            
            guard let didLike = snapshot?.exists else {return}
            
            completion(didLike)
        }
        
        
    }
    
    
   static func fetchCommentCount(forPost post: TextPost, completion: @escaping(commentStats) -> Void) {
        
    COLLECTION_TEXTPOST.document(post.postID).collection("comments").getDocuments { snapshot, error in
            if let error = error {
                
                print("failed to grab all the documents \(error.localizedDescription)")
                return
            }
            
            let numberOfComments = snapshot?.documents.count ?? 0
            
            completion(commentStats(numberOfComments: numberOfComments))
            
        }
        
    }
    
    
}
