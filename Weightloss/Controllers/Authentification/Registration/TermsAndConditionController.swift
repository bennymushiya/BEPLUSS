//
//  TermsAndConditionController.swift
//  Weightloss
//
//  Created by benny mushiya on 06/12/2021.
//

import UIKit

private let headerIdentifier = "header id"
private let reuseIdenifier = "cell "

class TermsAndConditionsController: UICollectionViewController {
    
    //MARK: - PROPERTIES

    private var termsAndConditionArray = [
    
    TermsAndCondModel(title: "1. B+", description: "a. To access the content of the Service you must be 16 years of age or over and register with a valid email address, or sign-in with a previously registered email and password. \n b. Newly registered users may use the B+ App, free to download, currently every users has access to all the features of the application. however this is due to change in the near future with the introduction of premium features, after which premium features will apply at a monthly cost of £4. \n c. The Service contains information, software, photos, text, graphics, sounds and other materials that are protected by copyrights, database rights, trademarks, trade secrets and/or other proprietary rights. All content is copyrighted under applicable copyright laws, including the United States, Canada, Australia, United Kingdom, Irish and European Union copyright laws (and, if applicable, similar laws in other jurisdictions). All trademarks that appear within the B+ App are trademarks of their respective owners. B+ is a trade name of B+ Ltd. \n d. With our discretion and without prior notice or liability, we may discontinue, modify or alter any aspect of the Service. \n e. You may not modify, publish, transmit, distribute, perform, participate in the transfer or sale, create derivative works of, or in any way exploit, any of the content, in whole or in part unless you receive our prior written consent. \n f. B+ Ltd reserves the right to vary the Service content by country and device, including (but not limited to) the App and website functionality and (iii) subscription options and pricing."),
    
    TermsAndCondModel(title: "2. User Generated Content", description: "a. When you add or upload your content to the Service, you grant B+ an irrevocable, non-exclusive, royalty-free, sublicensable, worldwide license to use such information for any purpose, subject to our Privacy Policy (tap 'More' in the bottom menu bar). \n b. Forums: You understand and accept that you are solely responsible for all information, data and content that you provide to us via the B+ Service. B+ is not responsible or liable for this information and by using the online community, you agree to be bound by the rules of conduct. You will not post any inappropriate content on the Service. This is defined as material which is offensive, abusive, bullying, threatening, hurtful, illegal, obscene, inflammatory or objectionable. You should always show respect to other members and are solely responsible for your interactions in the community. The forum is moderated and we reserve the right to monitor disputes between you and other members. We reserve the right to remove or edit any content posted in the online community without explanation and at our sole discretion. In the event that you breach the forum conduct, we reserve the right to close your account, and our decision is final. . You should not post material that infringes the copyright or another intellectual property rights of a third party."),
    
    TermsAndCondModel(title: "3. Limitation of Liability", description: "a. You understand and agree (to the fullest extent permitted by law) that B+ Ltd will not be liable for any direct, indirect, incidental, special, consequential, exemplary or punitive damages, or any other damages whatsoever, including but not limited to, damages for loss of profits, goodwill, use, data or other intangible losses, arising out of, or resulting from; i) the use or the inability to use the Service ii) the use of any content or other materials in the Service iii) the cost of buying substitute goods and services resulting from any goods, data, information or services purchased or obtained or messages received or transactions entered into through or from using the Service iv) unauthorized access to or alteration of your transmissions or data v) in no event shall the total liability of us to you for all damages, losses, and causes of action exceed the amount paid by you, if any, for subscribing to the Service. If you are dissatisfied with any portion of the Service, or with any of the provisions of these Terms of Use, your sole and exclusive remedy is to cease using the Service and to uninstall the B+."),
    
    TermsAndCondModel(title: "4. Supplementary charges", description: "a. It is solely your responsibility to check with your network provider about data charges that may arise through use of App features which require mobile data. Mobile data charges will depend on the service agreement you have with your network provider. The charge will be reflected on your mobile tariff or phone bill and we strongly advise you to check what charges will apply to your account BEFORE commencing use of the B+ App. \n b. B+ Ltd cannot be held liable for, and will not pay for or refund any data charges that you may incur through use of B+ app."),
    
    TermsAndCondModel(title: "5. Changes to our Terms of Use", description: "a. We reserve the right to update or change our Terms of Use at any time and it is your responsibility to check back regularly. Any changes posted on this page become effective immediately. Your continued use of the Service after we post any modifications on this page will constitute your acknowledgment of the changes and your consent to abide and be bound by the updated Terms of Use.")
    
    ]
    
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrowshape.turn.up.backward.2.circle.fill"), for: .normal)
        button.setDimensions(height: 56, width: 56)
        button.tintColor = .white
        button.backgroundColor = #colorLiteral(red: 0.1598605525, green: 0.9373220266, blue: 0.7734893539, alpha: 1)
        button.layer.cornerRadius = 20
        button.isEnabled = true
        button.imageView?.setDimensions(height: 30, width: 30)
        
        button.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        
        return button
    }()
    
    
    //MARK: - LIFECYCLE
    
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    
    //MARK: - HELPERS

    func configureUI() {
        
        collectionView.register(TermsAndCondHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        
        collectionView.register(TermsAndCondCell.self, forCellWithReuseIdentifier: reuseIdenifier)
        
        collectionView.addSubview(backButton)
        backButton.anchor(left: collectionView.leftAnchor, bottom: collectionView.safeAreaLayoutGuide.bottomAnchor, paddingLeft: 20, paddingBottom: 40)
        
    }
    
    
    
    //MARK: - ACTION

    @objc func handleBack() {
        
        let controller = ChooseWeightCategoryController()
        navigationController?.pushViewController(controller, animated: true)
            
        
    }
    
    
}


//MARK: - DataSource

extension TermsAndConditionsController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return termsAndConditionArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! TermsAndCondHeader
        
        return header
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdenifier, for: indexPath) as! TermsAndCondCell
        
        cell.viewModel = TermsAndConditionViewModel(models: termsAndConditionArray[indexPath.row])
        
        return cell
    }
}


//MARK: - Delegate

extension TermsAndConditionsController {
    
    
    
    
    
}


//MARK: - UICollectionViewDelegateFlowLayout

extension TermsAndConditionsController: UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        
        return CGSize(width: view.frame.width, height: 400)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width, height: 400)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return .init(top: 20, left: 0, bottom: 0, right: 0)
    }
    
    
}
