//
//  NewGoalsCell.swift
//  Weightloss
//
//  Created by benny mushiya on 19/10/2021.
//

import UIKit

protocol NewGoalsCellDelegate: class {
    
    func updateUserGoals(_ cell: NewGoalsCell, wantsToUpdate value: String, for section: NewGoalUpdateOptions)
}


class NewGoalsCell: UITableViewCell {
    
    //MARK: - PROPERTIES
    
    weak var delegate: NewGoalsCellDelegate?
    
    var viewModel: NewGoalUpdateCellViewModel? {
        didSet{configureViewModels()}
        
    }
    
    var titleLabel: SmallFontLabel = {
        let label = SmallFontLabel(title: "")
        label.font = UIFont.systemFont(ofSize: 16)
        
        return label
    }()
    
    
   lazy var infoTextField: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .none
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.textAlignment = .left
        tf.backgroundColor = .white
        tf.textColor = .black
        tf.isUserInteractionEnabled = true
    
        tf.addTarget(self, action: #selector(handleEditingChanged), for: .editingDidEnd)
     
         return tf
     }()
    
    
    //MARK: - LIFECYCLE

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - HELPERS

    func configureUI() {
        
        backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        selectionStyle = .none
        
        contentView.addSubview(titleLabel)
        titleLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        titleLabel.anchor(top: topAnchor, left: leftAnchor, paddingTop: 12, paddingLeft: 16)
        
        contentView.addSubview(infoTextField)
        infoTextField.anchor(top: topAnchor, left: titleLabel.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 4, paddingLeft: 16, paddingRight: 8)
        
    }
    
    //MARK: - SELECTORS
    
    @objc func handleEditingChanged(sender: UITextField) {
        
        guard let value = sender.text else {return }
        guard let viewModels = viewModel else {return}
        
        delegate?.updateUserGoals(self, wantsToUpdate: value , for: viewModels.options)
        
    }
   
    
    //MARK: - ACTION

    func configureViewModels() {
        
        guard let viewModels = viewModel else {return}
        
        titleLabel.text = viewModels.titleDescription
        infoTextField.text = viewModels.value
       
        
    }
    

    
}
