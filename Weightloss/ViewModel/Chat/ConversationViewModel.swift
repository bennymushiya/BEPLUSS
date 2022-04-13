//
//  ConversationViewModel.swift
//  Weightloss
//
//  Created by benny mushiya on 26/05/2021.
//

import UIKit


struct ConversationViewModel {
    
    let conversations: Conversations
    
    var profileImage: URL? {
        
        return URL(string: conversations.user.profileImage)
    }
    
    var username: String {
        
        return conversations.user.name
    }
    
    var message: String {
        
        return conversations.messages.text
    }
    
    var timeStamp: String? {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.second, .minute, .hour, .day, . weekOfMonth]
        formatter.maximumUnitCount = 1
        return formatter.string(from: conversations.messages.timeStamp.dateValue(), to: Date())
    }
    
    
    init(conversations: Conversations) {
        self.conversations = conversations
        
    }
}
