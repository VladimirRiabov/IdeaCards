//
//  ProfileTableViewController.swift
//  IdeaCards
//
//  Created by Владимир Рябов on 05.12.2021.
//

import UIKit
import Gallery
import ProgressHUD

class ProfileTableViewController: UITableViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var profileCellBackground: UIView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameAgeLabel: UILabel!
    @IBOutlet weak var cityCountryLabel: UILabel!
    @IBOutlet weak var aboutMeTextField: UITextView!
    @IBOutlet weak var aboutMeTextView: UIView!
    @IBOutlet weak var jobTextField: UITextField!
    @IBOutlet weak var professionTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var lookingForTextField: UITextField!
    
    
    //MARK: - Vars
    var editingMode = false
    
    var avatarImage: UIImage?
    var gallery: GalleryController!
    var uploadingAvatar = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackgrounds()
        //проверяем а есть ли у нас сейчас пользователь который вошел и загружает данные этого пользователя в экран настроек
        if FUser.currentId() != nil {
            loadUserData()
            updateEditingMode()
        }
        
        
        
        
        
        //от меня строчка. закрывает черную полоску в статус баре
        navigationController?.navigationBar.subviews[0].backgroundColor = UIColor().primary()
        overrideUserInterfaceStyle = .light
    }
    
    //убирает название секций
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    //MARK: - IBActions
    @IBAction func settingsButtonPressed(_ sender: UIButton) {
        showEditOptions()
    }
    @IBAction func cameraButtonPressed(_ sender: UIButton) {
        showPictureOptions()
    }
    @IBAction func editButtonPressed(_ sender: UIButton) {
        //меняет значение переменной на противоположную
        editingMode.toggle()
        
        updateEditingMode()
        editingMode ? showKeyboard() : hideKeyboard()
        showSaveButton()
    }
    //выполняет действие после нажатия всплывающей кнопки save
    @objc func editUserData() {
        let user = FUser.currentUser()!
        user.about = aboutMeTextField.text
        user.jobTitle = jobTextField.text ?? ""
        user.profession = professionTextField.text ?? ""
        user.isMale = genderTextField.text == "Male"
        user.city = cityTextField.text ?? ""
        user.country = countryTextField.text ?? ""
        user.lookingFor = lookingForTextField.text ?? ""
        user.height = Double(heightTextField.text ?? "0") ?? 0
        if avatarImage != nil {
            //upload new avatar
            //save user
        } else {
            //save it
            saveUserData(user: user)
        }
        //выключает editingmode
        editingMode = false
        //выключает текстовые поля от редактирования
        updateEditingMode()
        //убирает кнопку save в соответствиие с editingMode = false
        showSaveButton()
        //обновляет информацию в профайле в приложениие автоматически
        loadUserData()
    }
    private func saveUserData(user: FUser) {
        user.saveUserLocally()
        user.saveUserToFirestore()
    }
    
    //MARK: - Setup
    
    private func setupBackgrounds() {
        profileCellBackground.clipsToBounds = true
        profileCellBackground.layer.cornerRadius = 100
        profileCellBackground.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        
        aboutMeTextView.layer.cornerRadius = 10
    }
    private func showSaveButton() {
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(editUserData))
        //пока editingMode true будет появляться saveButton с функцией editUserData
        navigationItem.rightBarButtonItem = editingMode ? saveButton : nil
    }
    
    //MARK: - Load User Data
    private func loadUserData() {
        let currentUser = FUser.currentUser()!
        nameAgeLabel.text = currentUser.username + ", \(currentUser.dateOfBirth.interval(ofComponent: .year, fromDate: Date()) * -1)"
        cityCountryLabel.text = currentUser.country + ", " + currentUser.city
        aboutMeTextField.text = currentUser.about != "" ? currentUser.about : "A little bit about me"
        jobTextField.text = currentUser.jobTitle
        professionTextField.text = currentUser.profession
        genderTextField.text = currentUser.isMale ? "Male" : "Female"
        cityTextField.text = currentUser.city
        countryTextField.text = currentUser.country
        heightTextField.text = "\(currentUser.height)"
        lookingForTextField.text = currentUser.lookingFor
        avatarImageView.image = UIImage(named: "avatar")
    //TODO: - set avatar picture.
    }
    
    //MARK: - Editing Mode
    private func updateEditingMode() {
        aboutMeTextField.isUserInteractionEnabled = editingMode
        aboutMeTextView.isUserInteractionEnabled = editingMode
        jobTextField.isUserInteractionEnabled = editingMode
        professionTextField.isUserInteractionEnabled = editingMode
        genderTextField.isUserInteractionEnabled = editingMode
        cityTextField.isUserInteractionEnabled = editingMode
        countryTextField.isUserInteractionEnabled = editingMode
        heightTextField.isUserInteractionEnabled = editingMode
        lookingForTextField.isUserInteractionEnabled = editingMode
    }
    private func showKeyboard() {
        //когда я нажимаю кнопку редактирования у меня сразу появится клавиатура и курсор появится в первом текстовом поле
        self.aboutMeTextField.becomeFirstResponder()
    }
    private func hideKeyboard() {
        self.view.endEditing(false)
        
    }
    
    //MARK: - Gallery
    private func showGallery(forAvatar: Bool) {
        uploadingAvatar = forAvatar
        // are creating galleryController
        self.gallery = GalleryController()
        //our view is gonna be our delegate
        self.gallery.delegate = self
        //we are making image and cammer buttons in the buttom
        Config.tabsToShow = [.imageTab, .cameraTab]
        Config.Camera.imageLimit = forAvatar ? 1 : 10
        //когда откроется galleryController первым окном которое откроется будет imagetab
        Config.initialTab = .imageTab
        self.present(gallery, animated: true, completion: nil)
    }
    
    //MARK: - AlertController
    private func showPictureOptions() {
        let alertController = UIAlertController(title: "Upload picture", message: "You can change your avatar or upload more pictures", preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Change avatar", style: .default, handler: { (alert) in
            self.showGallery(forAvatar: true)
        }))
        alertController.addAction(UIAlertAction(title: "Upload pictures", style: .default, handler: { (alert) in
            self.showGallery(forAvatar: false)
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    private func showEditOptions() {
        let alertController = UIAlertController(title: "Edit account", message: "You are about to edit sensetive information about your account", preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Change email", style: .default, handler: { (alert) in
            print("changeemail")
        }))
        alertController.addAction(UIAlertAction(title: "Change name", style: .default, handler: { (alert) in
            print("changename")
        }))
        alertController.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { (alert) in
            print("logout")
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
        
    }

}

extension ProfileTableViewController: GalleryControllerDelegate {
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        if images.count > 0 {
            if uploadingAvatar {
                images.first!.resolve { (icon) in
                    if icon != nil {
                        //the way how we will save our avatar
                        self.editingMode = true
                        self.showSaveButton()
                        self.avatarImageView.image = icon
                        //устанавлеваем глобальную переменную тоже равной айкон
                        self.avatarImage = icon
                    } else {
                        ProgressHUD.showError("Couldn't select image")
                    }
                }
            } else {
                print("we have multiple images")
            }
        }
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryControllerDidCancel(_ controller: GalleryController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
}
