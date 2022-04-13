//
//  EditProfileFooter.swift
//  Weightloss
//
//  Created by benny mushiya on 03/06/2021.
//

import UIKit

protocol EditProfileFooterDelegate: class {
    func logUserOut()
    func saveUserChanges()
}


class EditProfileFooter: UIView {
    
    //MARK: - PROPERTIES
    
    weak var delegate: EditProfileFooterDelegate?
    
    private lazy var logOutButton: AuthButton = {
        let button = AuthButton(title: "Log out", type: .system)
        button.backgroundColor = #colorLiteral(red: 0.1598605525, green: 0.9373220266, blue: 0.7734893539, alpha: 1)
        button.layer.cornerRadius = 20
        button.isEnabled = true
        
        button.addTarget(self, action: #selector(handleLogOut), for: .touchUpInside)
        
        return button
    }()
    
     lazy var saveButton: AuthButton = {
        let button = AuthButton(title: "Save Changes", type: .system)
        button.backgroundColor = .red
        button.layer.cornerRadius = 20
        button.isEnabled = false
        
       button.addTarget(self, action: #selector(handleSaveChanges), for: .touchUpInside)

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
        
        let buttonStack = UIStackView(arrangedSubviews: [logOutButton, saveButton])
        buttonStack.axis = .horizontal
        buttonStack.spacing = 20
        buttonStack.distribution = .fillEqually
        
        addSubview(buttonStack)
        buttonStack.centerX(inView: self)
        buttonStack.anchor(top: topAnchor , left: leftAnchor, right: rightAnchor, paddingTop: 20, paddingLeft: 10, paddingRight: 10)
        
    }
    
    //MARK: - SELECTORS
    
    @objc func handleLogOut() {
        
        delegate?.logUserOut()
    
    }
    
    
    @objc func handleSaveChanges() {
        
        delegate?.saveUserChanges()

    }
    //MARK: - ACTION

    
}
