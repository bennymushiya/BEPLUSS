//
//  TextPostViewModel.swift
//  Weightloss
//
//  Created by benny mushiya on 06/05/2021.
//

import UIKit
import Firebase


struct TextPostViewModel {
    
    var posts: TextPost
    let user: User
    
    var post: String {
        
        return posts.post
    }
    
    var profileImage: URL? {
        
        return URL(string: user.profileImage)
    }
    
    var fullname: String {
        
        return user.name
    }
    
    
    var ownerUid: String {
        
        return posts.ownerUid
    }
    
    var numberOfRelatable: String {
        
        return "\(posts.relatables)"
            
    }
    
    var commentStats: String {
        
        return "\(posts.commentStat.numberOfComments)"
        
    }
        
    var timeStamp: String? {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .full
        return formatter.string(from: posts.timeStamp.dateValue(), to: Date())
        
    }
    
    var relatableButtonImage: UIImage? {
        
        let image = posts.didRelate ? "circles.hexagongrid.fill" : "circles.hexagongrid"
        
        return UIImage(systemName: image)
        
    }
    
    var relatableButtontintColor: UIColor {
        
        return posts.didRelate ? .systemPink : .white
        
    }
    
    var likeButtonImage: UIImage? {
        
        let image = posts.didLike ? "heart.circle.fill" : "suit.heart"
        
        return UIImage(systemName: image)
        
    }
    
    var likeButtonTintColor: UIColor {
        
        return posts.didLike ? .red : .white
        
    }
    
    var numberOfLikes: String {
        
        return "\(posts.likes)"
    }
    
    
    init(posts: TextPost) {
        self.posts = posts
        self.user = posts.user
        
    }
    
    func size(forWidth width: CGFloat) -> CGSize {
        let measurementLabel = UILabel()
        measurementLabel.text = posts.post
        measurementLabel.numberOfLines = 0
        measurementLabel.lineBreakMode = .byWordWrapping
        measurementLabel.translatesAutoresizingMaskIntoConstraints = false
        measurementLabel.widthAnchor.constraint(equalToConstant: width).isActive = true
        
        return measurementLabel.systemLayoutSizeFitting(UICollectionViewCell.layoutFittingCompressedSize)

    }
    
}
