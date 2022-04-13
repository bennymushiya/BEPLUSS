//
//  QuotesHeader.swift
//  Weightloss
//
//  Created by benny mushiya on 07/02/2022.
//

import UIKit


class QuotesHeader: UICollectionReusableView {
    
    //MARK: - PROPERTIES
    
    private let headerLineLabel: DynamicLabels = {
        let label = DynamicLabels(title: "Daily Quotes")
        label.font = .systemFont(ofSize: 45, weight: .black)
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
        
        backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        addSubview(headerLineLabel)
        headerLineLabel.anchor(top: topAnchor, left: leftAnchor, paddingTop: 20, paddingLeft: 30)
        
        
        
    }
    
    
    
    //MARK: - ACTION
    
    
    
}
