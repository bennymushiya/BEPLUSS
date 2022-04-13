//
//  HomeFilterView.swift
//  Weightloss
//
//  Created by benny mushiya on 30/04/2021.
//

//
//  HomeFilterView.swift
//  Updown
//
//  Created by benny mushiya on 31/03/2021.
//

import UIKit


private let reuseFilterCell = "homeFilterCell"

protocol HomeFilterViewDelegate: class {
    func filterView(_ view: HomeFilterView, didSelect index: Int)
}

class HomeFilterView: UIView {
    
    
    //MARK: - PROPERTIES
    
    weak var delegate: HomeFilterViewDelegate?
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.dataSource = self
        cv.delegate = self
        
        return cv
    }()
    
    private let underLineView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.1598605525, green: 0.9373220266, blue: 0.7734893539, alpha: 1)
        
        return view
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
        collectionView.register(FilterCell.self, forCellWithReuseIdentifier: reuseFilterCell)
        
        addSubview(collectionView)
        collectionView.fillSuperview()
        
        // automaticly selects the first item inside the indexPath
        let selectedIndexPath = IndexPath(row: 0, section: 0)
        collectionView.selectItem(at: selectedIndexPath, animated: true, scrollPosition: .left)
        
       
        
    }
    
    
    // this View is initialised without a frame, thus we cant define the width. therefore layout subviews already has a frame and thats why it works. this initialises when all the subviews has been set and put into place.
    override func layoutSubviews() {
        
        addSubview(underLineView)
        underLineView.anchor(left: leftAnchor, bottom: bottomAnchor, width: frame.width / 2, height: 2)
        
    }
    
    //MARK: - ACTION

    
}

//MARK: - UICollectionViewDataSource


extension HomeFilterView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        // automaticly updates the UI, if we modify our enum, rather than it being hard coded
        return HomeFilterOptions.allCases.count
        
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseFilterCell, for: indexPath) as! FilterCell
        
        cell.viewModel = HomeFilterOptions(rawValue: indexPath.row)
        
        return cell
    }
}

//MARK: - UICollectionViewDelegate

extension HomeFilterView: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // we get the specific cell at a indexPath and we downcast it as HomeFilterCell
        let cell = collectionView.cellForItem(at: indexPath)

        // then we get the x position of that selected Cell
        let xPosition = cell?.frame.origin.x ?? 0

        // then we animate the underlineView to follow that selectedCell
        UIView.animate(withDuration: 0.3) {
            self.underLineView.frame.origin.x = xPosition
        }
        
        delegate?.filterView(self, didSelect: indexPath.row)
    }

}

//MARK: - UICollectionViewDelegateFlowLayout

extension HomeFilterView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let count = CGFloat(HomeFilterOptions.allCases.count)
        
        // makes the cells one third of the views width
        return CGSize(width: frame.width / count, height: frame.height)
    }
    
    // defines the spacing between our cells
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
    
}
