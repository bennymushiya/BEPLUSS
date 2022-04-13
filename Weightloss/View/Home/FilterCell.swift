//
//  FilterCell.swift
//  Weightloss
//
//  Created by benny mushiya on 30/04/2021.
//

import UIKit


class FilterCell: UICollectionViewCell {
    
    //MARK: - LIFEYCLE
    
    var viewModel: HomeFilterOptions? {
        didSet{configureFilterModel()}
        
    }

    private let titleLabel: SmallFontLabel = {
        let label = SmallFontLabel(title: "")
        
        return label
    }()
    
    override var isSelected: Bool {
        didSet {
            titleLabel.textColor = isSelected ? #colorLiteral(red: 0.1598605525, green: 0.9373220266, blue: 0.7734893539, alpha: 1) : .white
            titleLabel.font = isSelected ? UIFont.boldSystemFont(ofSize: 16) : UIFont.systemFont(ofSize: 14)
        }
        
    }
    
    
    //MARK: - LIFEYCLE
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - LIFEYCLE

    func configureUI() {
        
        backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)

        addSubview(titleLabel)
        titleLabel.centerX(inView: self)
        titleLabel.centerY(inView: self)
        
    }
    
    
    //MARK: - ACTION
    
    func configureFilterModel() {
        
        guard let viewModels = viewModel else {return}
        
        titleLabel.text = viewModels.description
        
    }

    
    
    
}


