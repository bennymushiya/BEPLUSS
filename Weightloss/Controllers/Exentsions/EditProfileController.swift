//
//  EditProfileController.swift
//  Weightloss
//
//  Created by benny mushiya on 30/05/2021.
//

import UIKit
import Firebase
import FirebaseAuth


protocol EditProfileControllerDelegate: class {
    func controller(_ controller: EditProfileController, wantsToUpdate user: User)
    
}

private let reuseIdentifier = "table cell"

class EditProfileController: UITableViewController {
    
    //MARK: - PROPERTIES
    
    private var user: User
    
    weak var delegate: EditProfileControllerDelegate?
    
    lazy var headerView = EditProfileHeader(frame: .init(x: 0, y: 0, width: view.frame.width, height: 350))
    
    lazy var footerView = EditProfileFooter(frame: .init(x: 0, y: 0, width: view.frame.width, height: 300))
    
    let imagePicker = UIImagePickerController()
    
    private var userInforChanged = false
    
    private var imageChanged: Bool {
        
        return headerView.profileImage.image != nil
        
    }
    
    private var backgroundImageChanged: Bool {
        
        return headerView.backgroundImage.image != nil
        
    }

    //MARK: - LIFECYCLE
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
       navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureImagePicker()
        
    }
    
    //MARK: - HELPERS
    
    func configureUI() {
        
       // navigationController?.navigationBar.isHidden = false
       // navigationController?.navigationBar.barStyle = .black
        
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        tableView.tableHeaderView = headerView
        tableView.tableFooterView = footerView
        headerView.delegate = self
        footerView.delegate = self
        headerView.viewModel = EditProfileCellViewModel(user: user)
        tableView.register(EditProfileCell.self, forCellReuseIdentifier: reuseIdentifier)
        
    }
    
    
    
    func configureImagePicker() {
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
    }

    //MARK: - API
    
    func updateUserEditingData() {
        
        if imageChanged && !userInforChanged && !backgroundImageChanged {
            print("DEBUGG: CHANGED IMAGE AND NOT THE DATA")
            updateProfileImage()
            
        }
        
        else if userInforChanged && !imageChanged && !backgroundImageChanged {
            print("DEBUGG: CHANGED data AND NOT THE image")
            updateTextFieldData()

        }
        
        else if backgroundImageChanged && !userInforChanged && !imageChanged {
            print("DEBUGG: CHANGED only backgroundImage")
            updatebackgroundImage()

        }
        
        else if backgroundImageChanged && imageChanged && !userInforChanged {
            print("DEBUGG: CHANGED only backgroundImage and profileImage")
            updateProfileImage()
            updatebackgroundImage()

        }
        
        else if backgroundImageChanged && userInforChanged && !imageChanged {
            print("DEBUGG: CHANGED only backgroundImage and userData")
            updateTextFieldData()
            updatebackgroundImage()

        }
        
        else if userInforChanged && imageChanged && backgroundImageChanged {
            print("DEBUGG: CHANGED all three")
            updateTextFieldData()
            updateProfileImage()
            updatebackgroundImage()

        }
        
    }
    
    
    func newUpdateMethod() {
        
        switch userInforChanged {
            
        case true:
            updateTextFieldData()
            
        case false:
            print("DEBUGG: NOTHING IS UPDATING ")
        }
        
    }
    
    func updateTextFieldData() {
        
        showLoader(true)
        UserServices.updateUserData(user: user) { error in
            self.showLoader(false)
            if let error = error {
                
                print("DEBUGG: THIS IS THE MOVE \(error.localizedDescription)")
                return
            }
            
            print("DEBUGG: YOUVE SUCCESSFULLY UPDATED THE NAME AND GOALS ")
        }
        
    }
    
    func updateProfileImage() {
        
        guard let image = headerView.profileImage.image else {return}
        
        showLoader(true)

        UserServices.updateProfileImage(image: image) { profileImageUrl in
            self.showLoader(false)

            self.user.profileImage = profileImageUrl
            self.delegate?.controller(self, wantsToUpdate: self.user)
        }
        
    }
    
    func updatebackgroundImage() {
        
        guard let image = headerView.backgroundImage.image else {return}
        
        showLoader(true)

        UserServices.updateBackgroundImage(image: image) { backgroundImageUrl in
            self.showLoader(false)

            self.user.backgroundImage = backgroundImageUrl
            self.delegate?.controller(self, wantsToUpdate: self.user)
        }
        
    }

    
    //MARK: - ACTION
    
    func presentOnboardingController() {
        
        DispatchQueue.main.async {
            let controller = PaperOnboardingController()
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        }
    }
}

//MARK: - UITableViewDataSource

extension EditProfileController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return EditProfileOptions.allCases.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! EditProfileCell
        
        guard let options = EditProfileOptions(rawValue: indexPath.row) else { return cell }
        cell.viewModel = EditProfileViewModel(user: user, options: options)
        
        cell.delegate = self
        
        return cell
    }
    
}

//MARK: - UITableViewDelegate

extension EditProfileController {
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        guard let options = EditProfileOptions(rawValue: indexPath.row) else {return 0}
        
        return options == .fitnessGoals ? 100 : 48
    }
}

//MARK: - UITableViewFooterView

extension EditProfileController {

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {

        return footerView
    }


    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {

        return 80
    }

}

//MARK: - UIImagePickerControllerDelegate

extension EditProfileController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let selectedImage = info[.editedImage] as? UIImage else {return}
        
        headerView.setImages(selectedImage)
                
        dismiss(animated: true, completion: nil)
        footerView.saveButton.isEnabled = true
        footerView.saveButton.backgroundColor = #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1)

    }
}

//MARK: - EditProfileHeaderDelegate

extension EditProfileController: EditProfileHeaderDelegate {
    
    func selectProfilePhoto(_ header: EditProfileHeader) {
        present(imagePicker, animated: true, completion: nil)
        
    }
}

//MARK: - EditProfileCellDelegate

extension EditProfileController: EditProfileCellDelegate {
    
    func updateUserData(_ cell: EditProfileCell, wantsToUpdateUserWith value: String, for section: EditProfileOptions) {
        
        userInforChanged = true
        footerView.saveButton.isEnabled = true
        footerView.saveButton.backgroundColor = #colorLiteral(red: 0.1598605525, green: 0.9373220266, blue: 0.7734893539, alpha: 1)
        
        switch section {
            
        case .name:
            
            user.name = value
            
        case .fitnessGoals:
            
            user.fitnessGoals = value
        }
        
        print("DEBUGG: THE NEW USER IS \(user)")
        
    }
    
}

//MARK: - EditProfileFooterDelegate

extension EditProfileController: EditProfileFooterDelegate {


    func logUserOut() {

        do {
            try Auth.auth().signOut()
            presentOnboardingController()

        }catch {

            showMessage(withTitle: "Error", message: "failed to log you out \(error.localizedDescription)")
        }
    }


    func saveUserChanges() {

        view.endEditing(true)
        guard imageChanged || userInforChanged || backgroundImageChanged else {return}
        updateUserEditingData()
        delegate?.controller(self, wantsToUpdate: user)

    }
    
}




