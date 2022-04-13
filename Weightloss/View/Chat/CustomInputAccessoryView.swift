//
//  CustomInputAccessoryView.swift
//  Weightloss
//
//  Created by benny mushiya on 24/05/2021.
//

import UIKit


protocol CustomInputAccessoryViewDelegate: class {
    
    func inputView(_ inputView: CustomInputAccessoryView, wantsToSend message: String)
    func inputView(_ inputView: CustomInputAccessoryView)
    
}

// this whole uiview creates the the textview on the chat were people write their messages

class CustomInputAccessoryView: UIView {
    
    
    //MARK: - PROPERTIES
    
    weak var delegate: CustomInputAccessoryViewDelegate?
    
    lazy var messageInputTextView: InputTextView = {
        let tv = InputTextView()
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.isScrollEnabled = true
        tv.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        tv.setHeight(50)
        tv.layer.cornerRadius = 10
        tv.placeHolderShouldCenter = true
        tv.placeHolderText = "Enter Message"
        tv.textColor = .black
        
        return tv
    }()
    
     lazy var sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        button.setDimensions(height: 50, width: 50)
        button.layer.cornerRadius = 50 / 2
        button.isEnabled = false

        button.addTarget(self, action: #selector(handleSendMessage), for: .touchUpInside)
        
        return button
    }()
    
    
    //MARK: - LIFECYCLE
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        // gives it a custom height, if we dont do this then the text thingy will look different in each phone.
        autoresizingMask = .flexibleHeight
        
        backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        layer.shadowOpacity = 0.25
        layer.shadowRadius = 10
        layer.shadowOffset = .init(width: 0, height: -5)
        layer.shadowColor = UIColor.white.cgColor
        
        
        addSubview(sendButton)
        sendButton.anchor(top: topAnchor, right: rightAnchor, paddingTop: 10, paddingRight: 8)
        
        addSubview(messageInputTextView)
        messageInputTextView.anchor(top: topAnchor, left: leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: sendButton.leftAnchor, paddingTop: 12, paddingLeft: 4, paddingBottom: 8, paddingRight: 8)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleEditingDidBegin), name: UITextView.textDidChangeNotification, object: nil)
        
    }
    
    override var intrinsicContentSize: CGSize {
        return .zero
    }
    
    
    //MARK: - SELECTORS
    
    @objc func handleEditingDidBegin() {
        

        delegate?.inputView(self)
        
    }
    
    @objc func handleSendMessage() {
        
        guard let message = messageInputTextView.text else {return}
        delegate?.inputView(self, wantsToSend: message)
        
    }
    
    
    
    //MARK: - HELPERS
    
    func clearMessage() {
        
        messageInputTextView.text = nil
        
        
    }
    
    
    //MARK: - ACTION
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}

