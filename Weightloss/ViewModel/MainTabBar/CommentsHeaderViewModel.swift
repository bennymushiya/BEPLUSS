//
//  CommentsHeaderViewModel.swift
//  Weightloss
//
//  Created by benny mushiya on 10/05/2021.
//

import UIKit
import Firebase


struct CommentsHeaderViewModel  {
    
    var post: TextPost
    let user: User
    
    var profileImage: URL? {
        
        return URL(string: user.profileImage)
    
    }
    
    var textPost: String {
        
        return post.post
    }
    
    var fullname: String {
        
        return user.name
        
    }
    
    var uid: String {
        
        return post.ownerUid
    }
    
    var timeStamp: String? {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .full
        
        return formatter.string(from: post.timeStamp.dateValue(), to: Date())
    }
    
    var ownerUid: String {
        
        return post.ownerUid
    }
    
    var relateButtonImage: UIImage? {
        
        let image = post.didRelate ? "circles.hexagongrid.fill" : "circles.hexagongrid"
        
        return UIImage(systemName: image)
    }
    
    var relateButtonColor: UIColor {
        
        return post.didRelate ? .systemPink : .black
    }
    
    var relateLabel: String {
        
        return "\(post.relatables)"
    }
    
    var likeButtonImage: UIImage? {
        
        let image = post.didLike ? "heart.circle.fill" : "suit.heart"
        
        return UIImage(systemName: image)
        
    }
    
    var likeButtonTintColor: UIColor {
        
        return post.didLike ? .systemPurple : .black
        
    }
    
    var likeLabel: String {
        
        return "\(post.likes)"
    }
    
    
    
    init(post: TextPost) {
        self.post = post
        self.user = post.user
        
    }
    
    
    
    
}
