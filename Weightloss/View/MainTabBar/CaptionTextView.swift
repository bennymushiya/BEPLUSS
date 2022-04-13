//
//  CaptionTextView.swift
//  Weightloss
//
//  Created by benny mushiya on 05/05/2021.
//

import UIKit


class CaptionTextView: UITextView {
    
    
    //MARK: - PROPERTIES
    
    let placeholderLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .darkGray
        label.text = "what do you want to post?"
        
        return label
    }()
    
    
    //MARK: - LIFECYCLE
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - HELPERS

    func configureUI() {
        
        backgroundColor = .white
        font = UIFont.systemFont(ofSize: 16)
        heightAnchor.constraint(equalToConstant: 300).isActive = true
        textColor = .black
        
        addSubview(placeholderLabel)
        placeholderLabel.anchor(top: topAnchor, left: leftAnchor, paddingTop: 8, paddingLeft: 4)
        
        // lets us know when theres a change in the textView
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextInputChange), name: UITextView.textDidChangeNotification, object: nil)
        
    }
    
    
    //MARK: - ACTION

    @objc func handleTextInputChange() {
        
        // if text is empty we show the placeholder label, else we hide it 
       placeholderLabel.isHidden = !text.isEmpty
        
        
    }
    
    
}
