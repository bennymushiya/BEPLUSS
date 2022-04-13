//
//  TermsAndCondHeader.swift
//  Weightloss
//
//  Created by benny mushiya on 10/12/2021.
//

import UIKit


class TermsAndCondHeader: UICollectionReusableView {
    
    //MARK: - PROPERTIES
    
    private let titleLabel: AuthLabels = {
        let label = AuthLabels(title: "Terms and Conditions")
        label.font = UIFont.systemFont(ofSize: 35, weight: .heavy)
        label.textAlignment = .center
        label.textColor = .black
        
        return label
    }()
    
    private let descriptionLabel: AuthLabels = {
        let label = AuthLabels(title: "Please read carefully the following Terms of Use relating to the Trainer Swipe Service ('the Service') - which includes the Trainer Swipe App and Trainer Swipe Landing page. By ticking the box to complete your registration in the Trainer Swipe App or on the Trainer Swipe landing page (or by signing in with a previously registered email and password), you agree to be bound by these Terms of Use. If you do not agree to be bound by these Terms of Use, you should stop using the service immediately and uninstall the App. Features available as part of the Trainer Swipe remains the same in all country of use. For more information, please contact our Customer service Team. Trainer Swipe Service is owned and operated by Trainer Swipe Limited, a company registered in England, No. 12750598.")
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.textAlignment = .center
        label.textColor = .black
        
        return label
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
        
        backgroundColor = .white
                
        let stack = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel])
        stack.axis = .vertical
        stack.spacing = 10
        
        addSubview(stack)
        stack.centerX(inView: self)
        stack.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 20, paddingLeft: 10, paddingRight: 10 )
        
    }
    
    
    //MARK: - ACTION

    
    
    
}
