//
//  QuotesServices.swift
//  Weightloss
//
//  Created by benny mushiya on 08/02/2022.
//

import UIKit


struct QuotesServices {
    
    
    static func fetchQuotes(completion: @escaping([Quotes]) -> Void) {
                
        let query = COLLECTION_QUOTES.getDocuments { snapshot, error in
            if let error = error {
                
                print("failed to get documents \(error.localizedDescription)")
                return
        }
        
            print("DEBUGG: SUCCESSFULLY GOT QUOTES \(snapshot?.count) ")

            guard let documents = snapshot?.documents else {return}
            
            var quotez = documents.map({Quotes(dictionary: $0.data())})

            completion(quotez)

            }
        }
        
    }
    
    
    
    

