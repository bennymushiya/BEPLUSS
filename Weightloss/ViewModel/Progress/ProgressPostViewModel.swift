//
//  ProgressPostViewModel.swift
//  Weightloss
//
//  Created by benny mushiya on 24/05/2021.
//

import UIKit
import Firebase


struct ProgressPostViewModel {
    
    var posts: ProgressPost
    let user: User
    
    
    var ownerName: String {
        
        return user.name
        
    }
    
    var ownerProfileImage: URL? {
        
        return URL(string: user.profileImage)
        
    }
    
    var caption: String {
        
        return posts.caption ?? ""
    }
    
    var shouldHideCaptionLabel: Bool {
        
        return posts.caption == ""
    }
    
    var postImage: URL? {
        
        return URL(string: posts.image)
        
    }
    
    var ownerUid: String {
        
        return posts.ownerUid
    }
    
    
    var timeStamp: String? {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .full
        
        return formatter.string(from: posts.timeStamp.dateValue(), to: Date())
        
    }
    
    var numberOfRelatables: NSAttributedString {
        
        if posts.likes != 1 {
            
            return attributedTextll(label: "Relatables", value: posts.likes)
            
        }else{
            
            return attributedTextll(label: "Relatable", value: posts.likes)
        }
    }
    
    var likeButtonImage: UIImage? {
        
        let image = posts.didRelate ? "circles.hexagongrid.fill" : "circles.hexagongrid"
        
        return UIImage(systemName: image)
    }
    
    var likeButtonTintColor: UIColor {
        
        return posts.didRelate ? .red : .white
    }
    
    
    init(posts: ProgressPost) {
        self.posts = posts
        self.user = posts.user
        
    }
    
    func attributedTextll(label: String, value: Int) -> NSAttributedString {
        
        let attributedText = NSMutableAttributedString(string: "\(value)\n", attributes: [.font: UIFont.systemFont(ofSize: 20, weight: .black)])
        
        attributedText.append(NSAttributedString(string: "\(label)", attributes: [.font: UIFont.systemFont(ofSize: 14, weight: .bold), .foregroundColor: UIColor.white]))
        
        return attributedText
        
    }
    
    func size(forWidth width: CGFloat) -> CGSize {
        let measurementLabel = UILabel()
        measurementLabel.text = posts.caption
        measurementLabel.numberOfLines = 0
        measurementLabel.lineBreakMode = .byWordWrapping
        measurementLabel.translatesAutoresizingMaskIntoConstraints = false
        measurementLabel.widthAnchor.constraint(equalToConstant: width).isActive = true
        
        return measurementLabel.systemLayoutSizeFitting(UICollectionViewCell.layoutFittingCompressedSize)
    }
    
}
