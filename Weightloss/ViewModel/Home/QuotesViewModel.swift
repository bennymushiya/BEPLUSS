//
//  QuotesViewModel.swift
//  Weightloss
//
//  Created by benny mushiya on 08/03/2022.
//

import Foundation


struct QuotesViewModel {
    
    
    let quotes: Quotes
    
    
    var quoteText: String {
        
        
        return quotes.quote
    }
    
    var timeStamp: String? {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.day, .month, .year]
        formatter.maximumUnitCount = 3
        formatter.unitsStyle = .full
        
        return formatter.string(from: quotes.date.dateValue(), to: Date())
        
    }
    
    
    
    init(quotes: Quotes) {
        self.quotes = quotes
        
    }
    
    
    
}
