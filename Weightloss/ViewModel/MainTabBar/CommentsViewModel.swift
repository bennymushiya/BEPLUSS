//
//  CommentsViewModel.swift
//  Weightloss
//
//  Created by benny mushiya on 10/05/2021.
//

import UIKit

struct CommentsViewModel {
    
    let comments: Comments
    
    var profileImage: URL? {
        
        return URL(string: comments.profileImage)
    }
    
    var commentText: String {
        
        return comments.commentText
    }
    
    var name: String {
        
        return comments.name
        
    }
    
    var timeStamp: String? {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .full
        
        return formatter.string(from: comments.timeStamp.dateValue(), to: Date())
        
    }
    
    
    init(comments: Comments) {
        self.comments = comments
        
    }
}
