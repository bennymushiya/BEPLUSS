//
//  ProfileFilterCell.swift
//  Weightloss
//
//  Created by benny mushiya on 30/04/2021.
//

import UIKit


class ProfileFilterCell: UICollectionViewCell {
    
    //MARK: - PROPERTIES
    
    var viewModel: ProfileFilterCellViewModel? {
        didSet{configureViewModel()}

    }

     let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.1598605525, green: 0.9373220266, blue: 0.7734893539, alpha: 1)
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        
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
        
        addSubview(titleLabel)
        //titleLabel.centerX(inView: self)
        titleLabel.centerY(inView: self)
        titleLabel.textAlignment = .center
        
    }
    
    //MARK: - ACTION
    
    func configureViewModel() {
        
        guard let viewModels = viewModel else {return}
        
        titleLabel.text = viewModels.text
        
        
    }
    
}

