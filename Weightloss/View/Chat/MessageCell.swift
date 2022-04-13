//
//  MessageCell.swift
//  Weightloss
//
//  Created by benny mushiya on 24/05/2021.
//

import UIKit
import SDWebImage


class MessageCell: UICollectionViewCell {
    
    
    //MARK: - PROPERTIES
    
    var message: Messages? {
        didSet { configureViewModel() }
        
    }
    
    // create these constraints as class level properties so they can be used by the entire class
    var bubbleLeftAnchor: NSLayoutConstraint!
    var bubbleRightAnchor: NSLayoutConstraint!
    
   
    private let textView: UITextView = {
        let tv = UITextView()
        tv.backgroundColor? = .clear
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.isScrollEnabled = false
        tv.textColor = .white
        
        // prevents users to tap on it and change the messages inside of it
        tv.isEditable = false
        
        return tv
    }()
    
    private var bubbleContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .systemPurple
        
        return view
    }()
    
    //MARK: - LIFECYCLE
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()

    }
    
    //MARK: - HELPERS
    
    func configureUI() {
        
        addSubview(bubbleContainer)
        bubbleContainer.layer.cornerRadius = 12
        bubbleContainer.anchor(top: topAnchor, bottom: bottomAnchor)
        
        //makes sure the max height is equal to 250, if its less than that
        bubbleContainer.widthAnchor.constraint(lessThanOrEqualToConstant: 250).isActive = true
        
        // its storing these two constraints into a property and also setting our constraints for us aswel, thats the reason we dont need to give bubbleContainer any constraints above.
        bubbleLeftAnchor = bubbleContainer.leftAnchor.constraint(equalTo: leftAnchor, constant: 12)
              
        bubbleLeftAnchor.isActive = false
              
        bubbleRightAnchor = bubbleContainer.rightAnchor.constraint(equalTo: rightAnchor, constant: -12)
              
        bubbleRightAnchor.isActive = false
        
        // adds the textView inside the bubble container
        bubbleContainer.addSubview(textView)
        textView.anchor(top: bubbleContainer.topAnchor, left: bubbleContainer.leftAnchor, bottom: bubbleContainer.bottomAnchor, right: bubbleContainer.rightAnchor, paddingTop: 4, paddingLeft: 12, paddingBottom: 4, paddingRight: 12)
        
    }
    
    //MARK: - ACTION
    
    func configureViewModel() {
        
        // we check to make sure the message exists
        guard let messages = message else {return}
        
        let viewModels = MessageViewModel(message: messages)
                
        // we set the backgroundColor of the bubbleContainer, through the viewModel boolean data type we created
        bubbleContainer.backgroundColor = viewModels.messageBackgroundColor
        
        
      // we set the textColor through ViewModel aswel.
        textView.textColor = viewModels.messageTextColor
        textView.text = viewModels.messageText
//        
        bubbleRightAnchor.isActive = viewModels.rightAnchorActive
        bubbleLeftAnchor.isActive = viewModels.leftAnchorActive

    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


