//
//  ImageUploader.swift
//  Weightloss
//
//  Created by benny mushiya on 28/04/2021.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage



struct ImageUploader {
    
    
    
    static func uploadImage(image: UIImage, completion: @escaping(String) -> Void) {
        
        guard let imageData = image.jpegData(compressionQuality: 0.75) else {return}
        
        let fileName = NSUUID().uuidString
        
        let refStorage = Storage.storage().reference(withPath: "profileImage \(fileName)")
        
        refStorage.putData(imageData, metadata: nil) { snapshot, error in
            
            if let error = error {
                
                print("failed to upload your image \(error.localizedDescription)")
                return
            }
            
            refStorage.downloadURL { url, error in
                if let error = error {
                    
                    print("failed tp downlond url")
                    return
                }
                
                guard let imageUrl = url?.absoluteString else {return}
                
                completion(imageUrl)
                
            }
        }
        
        
    }
    
}
