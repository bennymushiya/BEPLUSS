//
//  NewGoalFooter.swift
//  Weightloss
//
//  Created by benny mushiya on 19/10/2021.
//

import UIKit

protocol NewGoalFooterDelegate: class {
    func updateInfo()
    func cancel()
    
}

class NewGoalFooter: UIView {
    
    //MARK: - PROPERTIES
    
    weak var delegate: NewGoalFooterDelegate?
    
     lazy var updateButton: AuthButton = {
        let button = AuthButton(title: "Update", type: .system)
        button.backgroundColor = #colorLiteral(red: 0.6148123741, green: 0.1017967239, blue: 0.1002308354, alpha: 1)
        button.layer.cornerRadius = 20
        button.isEnabled = false
        
        button.addTarget(self, action: #selector(handleUpdate), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var cancelButton: AuthButton = {
        let button = AuthButton(title: "Cancel", type: .system)
        button.backgroundColor = #colorLiteral(red: 0.1598605525, green: 0.9373220266, blue: 0.7734893539, alpha: 1)
        button.layer.cornerRadius = 20
        button.isEnabled = true
        
       button.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)

        return button
    }()
    
    
    
    //MARK: - LIFECYCLE

    override init(frame: CGRect) {
        super.init(frame: frame)

        configureUI()
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - HELPERS

    func configureUI() {
        
        backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        let buttonStack = UIStackView(arrangedSubviews: [cancelButton, updateButton])
        buttonStack.axis = .horizontal
        buttonStack.spacing = 20
        buttonStack.distribution = .fillEqually
        
        addSubview(buttonStack)
        buttonStack.centerX(inView: self)
        buttonStack.anchor(top: topAnchor , left: leftAnchor, right: rightAnchor, paddingTop: 20, paddingLeft: 10, paddingRight: 10)
        
    }
    
    //MARK: - SELECTORS
    
    @objc func handleUpdate() {
        
        delegate?.updateInfo()
        
    }
    
    
    @objc func handleCancel() {
        
        delegate?.cancel()
        
    }
    
    //MARK: - ACTION

    
}

