//
//  ProfileFilterView.swift
//  Weightloss
//
//  Created by benny mushiya on 30/04/2021.
//

import UIKit


private let reuseFilterCell = "homeFilterCell"

protocol ProfileFilterViewDelegate: class {
    func filterView(_ view: ProfileFilterView, didSelect index: Int)
    
}

class ProfileFilterView: UIView {
    
    
    //MARK: - PROPERTIES
    
    weak var delegate: ProfileFilterViewDelegate?
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        cv.dataSource = self
        //cv.delegate = self
        
        return cv
    }()
    
    private let underlineView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.1598605525, green: 0.9373220266, blue: 0.7734893539, alpha: 1)

        return view
    }()
    
   private let array = [
        
    ProfileBottomView(text: "Posts")
    
    ]
    
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
        
        backgroundColor = #colorLiteral(red: 0.1019607843, green: 0.1019607843, blue: 0.1019607843, alpha: 0.5)
        collectionView.register(ProfileFilterCell.self, forCellWithReuseIdentifier: reuseFilterCell)
        
        addSubview(collectionView)
        collectionView.fillSuperview()
        
        // automaticly selects the first item inside the indexPath
//        let selectedIndexPath = IndexPath(row: 0, section: 0)
//        collectionView.selectItem(at: selectedIndexPath, animated: true, scrollPosition: .left)
        
    }
    
  
    override func layoutSubviews() {
        
        addSubview(underlineView)
        underlineView.anchor(left: leftAnchor, bottom: bottomAnchor, width: frame.width, height: 2)
        
    }
    
    //MARK: - ACTION

    
}

//MARK: - UICollectionViewDataSource

extension ProfileFilterView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return array.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseFilterCell, for: indexPath) as! ProfileFilterCell
        
        cell.viewModel = ProfileFilterCellViewModel(bottom: array[indexPath.row])
        cell.titleLabel.textAlignment = .center
                
        return cell
    }
}


//MARK: - UICollectionViewDelegateFlowLayout

extension ProfileFilterView: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: frame.width, height: frame.height)
    }

    // defines the spacing between our cells
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {

        return 0
    }
}


