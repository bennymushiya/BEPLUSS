//
//  SearchCollectionCell.swift
//  Weightloss
//
//  Created by benny mushiya on 17/10/2021.
//

import UIKit
import SDWebImage


class SearchCollectionCell: UICollectionViewCell {
    
    //MARK: - PROPERTIES
    
   var viewModel: ProgressPostViewModel? {
        didSet{configureViewModel()}
        
    }
    
    private let postImages: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        iv.setDimensions(height: 70, width: 70)
        iv.layer.cornerRadius = 20
        iv.layer.borderColor = #colorLiteral(red: 0.1598605525, green: 0.9373220266, blue: 0.7734893539, alpha: 1)
        iv.layer.borderWidth = 1.0
        
        return iv
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
        
        addSubview(postImages)
        postImages.fillSuperview()
        
    }
    
    
    //MARK: - ACTION

    func configureViewModel() {
        
        guard let viewModels = viewModel else {return}
        
        postImages.sd_setImage(with: viewModels.postImage)
        
    }
    
}
