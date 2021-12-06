//
//  ProfileTableViewController.swift
//  IdeaCards
//
//  Created by Владимир Рябов on 05.12.2021.
//

import UIKit

class ProfileTableViewController: UITableViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var profileCellBackground: UIView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameAgeLabel: UILabel!
    @IBOutlet weak var cityCountryLabel: UILabel!
    @IBOutlet weak var aboutMeTextField: UITextView!
    @IBOutlet weak var aboutMeTextView: UIView!
    @IBOutlet weak var jobTextField: UITextField!
    @IBOutlet weak var educationTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var lookingForTextField: UITextField!
    
    
    //MARK: - Vars
    var editingMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackgrounds()
        updateEditingMode()
        
        
        
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
    
    @objc func editUserData() {
        print("fuck you")
        
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
    
    //MARK: - Editing Mode
    private func updateEditingMode() {
        aboutMeTextField.isUserInteractionEnabled = editingMode
        aboutMeTextView.isUserInteractionEnabled = editingMode
        jobTextField.isUserInteractionEnabled = editingMode
        educationTextField.isUserInteractionEnabled = editingMode
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
    
    //MARK: - AlertController
    private func showPictureOptions() {
        let alertController = UIAlertController(title: "Upload picture", message: "You can change your avatar or upload more pictures", preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Change avatar", style: .default, handler: { (alert) in
            print("changeavatar")
        }))
        alertController.addAction(UIAlertAction(title: "Upload pictures", style: .default, handler: { (alert) in
            print("uploadPictures")
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
