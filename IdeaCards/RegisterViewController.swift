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
    
    //MARK: - Vars
    var isMale = true
    
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
            //проверка пароля на совпадение
            if passwordTextField.text! == confirmPasswordTextField.text! {
                registerUser()
            } else {
                ProgressHUD.showError("Passwords don't match")
            }
        } else {
            ProgressHUD.showError("All fields are required!")
        }
    }
    @IBAction func logInButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func genderSegmentValueChanged(_ sender: UISegmentedControl) {
                                            //short if/else statement
//        isMale = sender.selectedSegmentIndex == 0 ? true : false
        isMale = sender.selectedSegmentIndex == 0
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
    
    //MARK: - Register User
    private func registerUser() {
        //loading spinning indicator
        ProgressHUD.show()
        FUser.registerUserWith(email: emailTextField.text!, password: passwordTextField.text!, username: usernameTextField.text!, city: cityTextField.text!, isMale: isMale, dateOfBirth: Date()) { error in
            //dismiss progress spining indicator
            ProgressHUD.dismiss()
            if error == nil {
                ProgressHUD.showSuccess("Verification email sent!")
                
            } else {
                ProgressHUD.showError(error!.localizedDescription)
            }
        }
    }
}
