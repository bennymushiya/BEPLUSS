//
//  UserServices.swift
//  Weightloss
//
//  Created by benny mushiya on 28/04/2021.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore


struct EditProfileCredentials {
    
    let name: String
    let fitnessGoals: String
    let profileImage: UIImage
    let backgroundImage: UIImage
    
}

struct UserServices {
    
    
    static func fetchUser(withCurrentUser userID: String, completion: @escaping(User) -> Void) {
                
        COLLECTION_USERS.document(userID).getDocument { snapshot, error in
            
            guard let dictionary = snapshot?.data() else {return}
            
            let user = User(dictionary: dictionary)
            
            completion(user)
        }
    }
    
    static func setUserFCMToken() {
        
        guard let currentUser = Auth.auth().currentUser?.uid else {return}
        guard let fcmToken = Messaging.messaging().fcmToken else {return}
        
        let values = ["pushID": fcmToken]
        
        COLLECTION_USERS.document(currentUser).updateData(values)
        
    }

    
    static func fetchUsers(completion: @escaping(([User]) -> Void)) {
        
        guard let currentUser = Auth.auth().currentUser?.uid else {return}
            
        COLLECTION_USERS.getDocuments { snapshot, error in
            
            guard let documents = snapshot?.documents else {return}
            
            var users = documents.map({User(dictionary: $0.data())})
            
            // represents the first index where the uid of all the users equals our currentUsers uid. and when this condition is met, it will store the value of that index in i.
            if let i = users.firstIndex(where: {$0.uid == currentUser}) {
            
                users.remove(at: i)
            }
            
            completion(users)
        }
        
    }
    
    static func downloadUsersForPushNotifications(withUid: [String], completion: @escaping([User]) -> Void) {
        
        var usersArray: [User] = []
        var counter = 0
        
        for userId in withUid {
            
            COLLECTION_USERS.document(userId).getDocument { (snapshot, error) in
                
                guard let snapshot = snapshot else { return }
                
                if snapshot.exists {
                    
                    usersArray.append(User(dictionary: (snapshot.data()! as NSDictionary) as! [String : Any]))
                    counter += 1
                    
                    if counter == withUid.count {
                        
                        print("DEBUGG: THE AMOUNT OF COUNTER IS \(counter)")
                        
                        completion(usersArray)
                    }
                    
                } else {
                    completion(usersArray)
                }
            }
        }
        
    }
    
    static func fetchUserStats(currentUser: String, completion: @escaping(UserStats) -> Void) {
        
        COLLECTION_TEXTPOST.whereField("ownerUid", isEqualTo: currentUser).getDocuments { snapshot, _ in
            
            let posts = snapshot?.documents.count ?? 0
            
            completion(UserStats(posts: posts))
        }
        
    }
    
    static func fetchWeightGainStats(withUid uid: String, completion: @escaping(weightGainPostStats) -> Void) {
        
        COLLECTION_WEIGHTGAIN.whereField("ownerUid", isEqualTo: uid).getDocuments { snapshot, error in
            
            let posts = snapshot?.documents.count ?? 0
            
            completion(weightGainPostStats(posts: posts))
        }
        
    }
    
  static func updateProfileImage(image: UIImage, completion: @escaping(String) -> Void) {

        guard let imageData = image.jpegData(compressionQuality: 0.3) else {return}
        guard let currentUser = Auth.auth().currentUser?.uid else {return}

        let filename = NSUUID().uuidString
        let ref = Storage.storage().reference(withPath: "profileImage \(filename)")

        ref.putData(imageData, metadata: nil) { meta, error in
            ref.downloadURL { url, error in
                guard let profileImageUrl = url?.absoluteString else {return}

                let snapshot = ["profileImage": profileImageUrl]

                COLLECTION_USERS.document(currentUser).updateData(snapshot) { error in

                    completion(profileImageUrl)
                }
            }
        }
    }
    
    static func updateBackgroundImage(image: UIImage, completion: @escaping(String) -> Void) {

          guard let imageData = image.jpegData(compressionQuality: 0.3) else {return}
          guard let currentUser = Auth.auth().currentUser?.uid else {return}

          let filename = NSUUID().uuidString
          let ref = Storage.storage().reference(withPath: "backgroundImage \(filename)")

          ref.putData(imageData, metadata: nil) { meta, error in
              ref.downloadURL { url, error in
                  guard let backgroundImageUrl = url?.absoluteString else {return}

                  let snapshot = ["backgroundImage": backgroundImageUrl]

                  COLLECTION_USERS.document(currentUser).updateData(snapshot) { error in

                      completion(backgroundImageUrl)
                  }
              }
          }
      }
    
    static func updateUserData(user: User, completion: @escaping(FirestoreCompletion)) {
                        
        let data = ["name": user.name,
                    "uid": user.uid,
                    "fitnessGoals": user.fitnessGoals] as [String: Any]
                
        COLLECTION_USERS.document(user.uid).updateData(data, completion: completion)
        
    }
    
    static func updateUserGoals(user: User, completion: @escaping(FirestoreCompletion)) {
        
        let data = ["currentWeight": user.currentWeight,
                    "futureGoal": user.futureGoal,
                    "uid": user.uid] as [String: Any]
        
        COLLECTION_USERS.document(user.uid).updateData(data, completion: completion)
    
    }
    
    static func updateUserPushID(user: User, completion: @escaping(FirestoreCompletion)) {
        
        let data = ["pushID": user.pushID] as [String: Any]
        
        COLLECTION_USERS.document(user.uid).updateData(data, completion: completion)
        
    }
}
