//
//  HomeHeader.swift
//  Weightloss
//
//  Created by benny mushiya on 30/04/2021.
//

import UIKit
import SDWebImage

//protocol HomeHeaderDelegate: class {
//    func filter(_ filter: HomeFilterOptions)
//}

class HomeHeader: UICollectionReusableView {
    
    //MARK: - PROPERTIES
    
//    weak var delegate: HomeHeaderDelegate?
//
    var viewModel: QuotesViewModel? {
        didSet{configureViewModel()}

    }
    
    private let Label: SmallFontLabel = {
        let label = SmallFontLabel(title: "Daily Quote")
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.textAlignment = .left

        return label
    }()
    
    
    private let quotesLabel: DynamicLabels = {
        let label = DynamicLabels(title: "  i gave you two weeks o lets me know broso you sdww n hjjdhjsdhjhdjhdjhdjhdjsh  ")
        label.font = .systemFont(ofSize: 20, weight: .black)
        label.textAlignment = .center
        label.numberOfLines = 0
       
        return label
    }()
    

    private let dateLabel: DynamicLabels = {
        let label = DynamicLabels(title: " 10/03/22")
        
        return label
    }()
    
    private let titleLabel: SmallFontLabel = {
        let label = SmallFontLabel(title: "Feed")
        label.font = UIFont.systemFont(ofSize: 15, weight: .black)
        label.textAlignment = .left

        return label
    }()

    
//    private let filterView = HomeFilterView()


    //MARK: - LIFEYCLE
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    //MARK: - HELPERS

    func configureUI() {
        
        backgroundColor = #colorLiteral(red: 0.1019607843, green: 0.1019607843, blue: 0.1019607843, alpha: 0.5)
        //filterView.delegate = self
        
        layer.cornerRadius = 20
        layer.borderColor = #colorLiteral(red: 0.1598605525, green: 0.9373220266, blue: 0.7734893539, alpha: 1)
        layer.borderWidth = 5
        
        addSubview(Label)
        Label.anchor(top: topAnchor, left: leftAnchor, paddingTop: 10, paddingLeft: 10)
        
        addSubview(quotesLabel)
        quotesLabel.centerX(inView: self)
        quotesLabel.centerY(inView: self)
        quotesLabel.anchor(left: leftAnchor, right: rightAnchor, paddingLeft: 10, paddingRight: 10)
        
        addSubview(dateLabel)
        dateLabel.anchor(bottom: bottomAnchor, right: rightAnchor, paddingBottom: 10, paddingRight: 15)

        addSubview(titleLabel)
        titleLabel.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingLeft: 0, paddingBottom: -46, paddingRight: 0)


    }
    
    //MARK: - ACTION

    func configureViewModel() {

        guard let viewModels = viewModel else {return}
        
        quotesLabel.text = viewModels.quoteText
        dateLabel.text = viewModels.timeStamp

        
    }
  }

//MARK: - HomeFilterViewDelegate

//extension HomeHeader: HomeFilterViewDelegate {
//
//    func filterView(_ view: HomeFilterView, didSelect index: Int) {
//
//        guard let filter = HomeFilterOptions(rawValue: index) else {return}
//
//        delegate?.filter(filter)
//
//    }
//}
