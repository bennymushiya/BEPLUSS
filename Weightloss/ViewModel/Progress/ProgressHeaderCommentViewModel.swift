//
//  Progress.swift
//  Weightloss
//
//  Created by benny mushiya on 27/05/2021.
//

import UIKit


struct ProgressHeaderCommentViewModel {
    
    var post: ProgressPost
    let user: User
    
    
    var fullname: String {
        
        return user.name
    }
    
    var timeStamp: String? {
        let formmatter = DateComponentsFormatter()
        formmatter.unitsStyle = .full
        formmatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formmatter.maximumUnitCount = 1
        
        return formmatter.string(from: post.timeStamp.dateValue(), to: Date())
        
    }
    
    var profileImage: URL? {
        
        return URL(string: user.profileImage)
        
    }
    
    var ownerUid: String {
        
        return post.ownerUid
    }
    
    var caption: String {
        
        return post.caption ?? ""
    }
    
    var postImage: URL? {
        
        return URL(string: post.image)
        
    }
    
    var numberOfLikes: NSAttributedString {
        
        if post.likes != 1 {
            
            return attributedTextll(label: "Relatables", value: post.likes)
            
        }else{
            
            return attributedTextll(label: "Relatable", value: post.likes)
        }
    }
    
    var likeButtonImage: UIImage? {
        
        let image = post.didRelate ? "circles.hexagongrid.fill" : "circles.hexagongrid"
        
        return UIImage(systemName: image)
    }
    
    var likeButtonTintColor: UIColor {
        
        return post.didRelate ? .red : .black
    }
    
    

    init(post: ProgressPost) {
        self.post = post
        self.user = post.user
        
    }
    
    func attributedTextll(label: String, value: Int) -> NSAttributedString {
        
        let attributedText = NSMutableAttributedString(string: "\(value)\n", attributes: [.font: UIFont.systemFont(ofSize: 20, weight: .black)])
        
        attributedText.append(NSAttributedString(string: "\(label)", attributes: [.font: UIFont.systemFont(ofSize: 14, weight: .bold), .foregroundColor: UIColor.black]))
        
        return attributedText
        
    }
    
    
    func size(forWidth width: CGFloat) -> CGSize {
        let measurementLabel = UILabel()
        measurementLabel.text = post.caption
        measurementLabel.numberOfLines = 0
        measurementLabel.lineBreakMode = .byWordWrapping
        measurementLabel.translatesAutoresizingMaskIntoConstraints = false
        measurementLabel.widthAnchor.constraint(equalToConstant: width).isActive = true
        
        return measurementLabel.systemLayoutSizeFitting(UICollectionViewCell.layoutFittingCompressedSize)

    }
    
    
}
