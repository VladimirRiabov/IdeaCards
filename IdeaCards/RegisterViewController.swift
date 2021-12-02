//
//  RegisterViewController.swift
//  IdeaCards
//
//  Created by Владимир Рябов on 02.12.2021.
//

import UIKit
import ProgressHUD

class RegisterViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var dateOfBirthTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var genderSegmentOutlet: UISegmentedControl!
    @IBOutlet weak var backgroundImageView: UIView!
    
    //MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

     setupBackgroundTouch()
    }
    
    //MARK: - IBActions
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        if isTextDataImputet() {
            //register the user
        } else {
            ProgressHUD.showError("All fields are required!")
        }
        
    }
    @IBAction func logInButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: - Setup
    
    private func setupBackgroundTouch() {
        backgroundImageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTap))
        backgroundImageView.addGestureRecognizer(tapGesture)
    }
    
    @objc func backgroundTap() {
        dismissKeyboard()
    }
    
    //MARK: - Helpers
    private func dismissKeyboard() {
        self.view.endEditing(false)
    }
    
    private func isTextDataImputet () -> Bool {
        return usernameTextField.text != "" && emailTextField.text != "" && cityTextField.text != "" && dateOfBirthTextField.text != "" && passwordTextField.text != "" && confirmPasswordTextField.text != ""
    }
}
