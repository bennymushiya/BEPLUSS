//
//  EditProfileCell.swift
//  Weightloss
//
//  Created by benny mushiya on 03/06/2021.
//

import UIKit
import SwiftUI

protocol EditProfileCellDelegate: class {
    
    func updateUserData(_ cell: EditProfileCell, wantsToUpdateUserWith value: String, for section: EditProfileOptions)
    
   // func updateFitnessGoal(_ cell: EditProfileCell, wantsToUpdateFitnessGoalWith value: String, for section: EditProfileOptions)
    
}

class EditProfileCell: UITableViewCell {
    
    //MARK: - PROPERTIES
    
    weak var delegate: EditProfileCellDelegate?
    
    var viewModel: EditProfileViewModel? {
        didSet{configureViewModel()}
        
    }
    
    let titleLabel: SmallFontLabel = {
        let label = SmallFontLabel(title: "")
        label.font = UIFont.systemFont(ofSize: 16)
        
        return label
    }()
    
    
//   lazy var infoTextField: UITextField = {
//        let tf = UITextField()
//        tf.borderStyle = .none
//        tf.font = UIFont.systemFont(ofSize: 14)
//        tf.textAlignment = .left
//        tf.backgroundColor = .white
//        tf.textColor = .black
//        tf.isUserInteractionEnabled = true
//        tf.placeholder = "enter name "
//
//        tf.addTarget(self, action: #selector(handleEditingChanged), for: .editingDidEnd)
//
//         return tf
//     }()
    
    
     var FitnessGoalsTextView: InputTextView = {
        let tv = InputTextView()
        tv.backgroundColor = .systemGroupedBackground
        tv.setHeight(200)
        tv.layer.cornerRadius = 20
        tv.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        tv.placeHolderLabel.text = "enter fitness goals"
        tv.textColor = .white

        return tv
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
        
        FitnessGoalsTextView.delegate = self
        contentView.addSubview(titleLabel)
        titleLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        titleLabel.anchor(top: topAnchor, left: leftAnchor, paddingTop: 12, paddingLeft: 16)
        
        //contentView.addSubview(infoTextField)
        //infoTextField.anchor(top: topAnchor, left: titleLabel.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 4, paddingLeft: 16, paddingRight: 8)
        
        contentView.addSubview(FitnessGoalsTextView)
        FitnessGoalsTextView.anchor(top: topAnchor, left: titleLabel.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 4, paddingLeft: 16, paddingRight: 8)
        
    }
    
    //MARK: - SELECTORS
    

    
    
    //MARK: - ACTION

    func configureViewModel() {
        
        guard let viewModels = viewModel else {return}
        
        //infoTextField.isHidden = viewModels.shouldHideTextField
        //FitnessGoalsTextView.isHidden = viewModels.shouldHideTextView
        
        FitnessGoalsTextView.placeHolderLabel.isHidden = viewModels.shouldHidePlaceHolderLabel
        titleLabel.text = viewModels.titleText
        FitnessGoalsTextView.text = viewModels.value
        FitnessGoalsTextView.placeHolderText = viewModels.placeHolderText
    
    }
    
}

//MARK: - UITextViewDelegate

extension EditProfileCell: UITextViewDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        guard let value = textView.text else {return}
        guard let viewModels = viewModel else {return}
        
        delegate?.updateUserData(self, wantsToUpdateUserWith: value, for: viewModels.options)
        
    }
    
}
