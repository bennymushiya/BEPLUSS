//
//  QuotesModel.swift
//  Weightloss
//
//  Created by benny mushiya on 07/02/2022.
//

import UIKit
import Firebase


struct Quotes {
    
    let quote: String
    let date: Timestamp
    
    
    init(dictionary: [String: Any]) {
        self.quote = dictionary["quote"] as? String ?? ""
        self.date = dictionary["date"] as? Timestamp ?? Timestamp(date: Date())
        
        
    }
}
