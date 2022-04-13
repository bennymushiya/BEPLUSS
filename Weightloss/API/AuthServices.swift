//
//  AuthServices.swift
//  Weightloss
//
//  Created by benny mushiya on 28/04/2021.
//

import UIKit
import Firebase
import FirebaseAuth

typealias FirestoreCompletion = (Error?) -> Void

struct AuthCredentials {
    
    let name: String
    let email: String
    let password: String
    let chosenCommunity: String
    let profileImage: UIImage
    let fitnessGoals: String
    let backgroundImage: UIImage
    let currentWeight: Int
    let futureGoal: Int
    let pushID: String
    
}

struct AuthServices {
    
    
    static func logUserIn(withEmail email: String, password: String, completion: (AuthDataResultCallback?)) {
        
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)

    }
    
    static func createUser(withCredentials credentials: AuthCredentials, completion: @escaping(FirestoreCompletion)) {
        
        ImageUploader.uploadImage(image: credentials.profileImage) { imageUrl in
            
            ImageUploader.uploadImage(image: credentials.backgroundImage) { backgroundImageUrl in
                
                Auth.auth().createUser(withEmail: credentials.email, password: credentials.password) { results, error in
                    
                    if let error = error {
                        
                        print("failed to upload data \(error.localizedDescription)")
                        
                        return
                    }
                    
                    guard let uid = Auth.auth().currentUser?.uid else {return}
                    
                    let data = ["name": credentials.name,
                                "email": credentials.email,
                                "uid": uid,
                                "chosenCommunity": credentials.chosenCommunity,
                                "profileImage": imageUrl,
                                "fitnessGoals": credentials.fitnessGoals,
                                "currentWeight": credentials.currentWeight,
                                "futureGoal": credentials.futureGoal,
                                "pushID": credentials.pushID,
                                "backgroundImage": backgroundImageUrl] as [String: Any]
                    
                    
                    COLLECTION_USERS.document(uid).setData(data, completion: completion)
                }
            }
        }
            
    }
    
    
    
    static func resetPassword(withEmail email: String, completion: SendPasswordResetCallback?) {
        
        Auth.auth().sendPasswordReset(withEmail: email, completion: completion)
    }
    
    
}
