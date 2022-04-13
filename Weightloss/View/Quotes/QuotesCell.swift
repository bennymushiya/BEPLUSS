//
//  QuotesCell.swift
//  Weightloss
//
//  Created by benny mushiya on 07/02/2022.
//


//import UIKit
//
//
//class QuotesCell: UICollectionViewCell {
//    
//    
//    //MARK: - PROPERTIES
//    
//    var viewModel: QuotesViewModel? {
//        didSet{configureViewModel()}
//        
//    }
//    
//    private let quotesMarkLabel: DynamicLabels = {
//        let label = DynamicLabels(title: " ''")
//        label.font = .systemFont(ofSize: 50, weight: .black)
//        label.textColor = .white
//        
//        return label
//    }()
//    
//    private let nameLabel: DynamicLabels = {
//        let label = DynamicLabels(title: "")
//        
//        
//        return label
//    }()
//    
//    private let quotesLabel: DynamicLabels = {
//        let label = DynamicLabels(title: "")
//        label.font = .systemFont(ofSize: 30, weight: .black)
//       
//        return label
//    }()
//    
//    private let dateLabel: DynamicLabels = {
//        let label = DynamicLabels(title: "")
//        
//        return label
//    }()
//    
//    
//    //MARK: - LIFECYCLE
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        
//        configureUI()
//        
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    //MARK: - HELPERS
//
//    func configureUI() {
//        
//        backgroundColor = #colorLiteral(red: 0.1019607843, green: 0.1019607843, blue: 0.1019607843, alpha: 0.5)
//        layer.cornerRadius = 40
//        layer.borderWidth = 3
//        layer.borderColor = #colorLiteral(red: 0.1598605525, green: 0.9373220266, blue: 0.7734893539, alpha: 1)
//        
//        addSubview(nameLabel)
//        nameLabel.anchor(top: topAnchor, right: rightAnchor, paddingTop: 10, paddingRight: 30)
//        
//       let stack = UIStackView(arrangedSubviews: [quotesMarkLabel, quotesLabel])
//        stack.axis = .vertical
//        stack.spacing = 2
//        
//        addSubview(stack)
//        stack.centerX(inView: self)
//        stack.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 50, paddingLeft: 30, paddingRight: 10)
//        
//        addSubview(dateLabel)
//        dateLabel.anchor(left: leftAnchor, bottom: bottomAnchor, paddingLeft: 30, paddingBottom: 10)
//        
//    }
//    
//    //MARK: - ACTION
//
//    func configureViewModel() {
//        
//        guard let viewModels = viewModel else {return}
//        
//        quotesLabel.text = viewModels.quote
//        dateLabel.text = viewModels.timeStamp
//        
//    }
//    
//}
