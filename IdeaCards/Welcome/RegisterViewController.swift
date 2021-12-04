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
    var datePicker = UIDatePicker()
    
    //MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDatePicker()
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
    private func setupDatePicker() {
        datePicker.datePickerMode = .date
        //We want to take that date from the date picker and put it in our date of birth text field.
        //self this is the RegisterView the target is going to be.
        //every time a value on the spinner changes(.valueChanged), we want these handle peaker to be called.
        datePicker.addTarget(self, action: #selector(handleDatePicker), for: .valueChanged)
        //by default, if you select any textfield, the keyboard will appear.
        //Instead, the input view is going to be a date peaker.
        dateOfBirthTextField.inputView = datePicker
        
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        //поставил стандартные цвета путем расширения стандартного UIColor. см файл Extensions
        toolBar.tintColor = UIColor().primary()
        //depending on the screen size, we want to put everything on a screen size.
        toolBar.sizeToFit()
        //whenever a user clicks on these Kinsel, we have this function. dismissKeyboard
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(dismissKeyboard))
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneClicked))
        
        //It's flexible and it pushes everything left and the right maximum possible.
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: true)
        toolBar.isUserInteractionEnabled = true
        
        dateOfBirthTextField.inputAccessoryView = toolBar
    }
    
    private func setupBackgroundTouch() {
        backgroundImageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTap))
        backgroundImageView.addGestureRecognizer(tapGesture)
    }
    
    @objc func backgroundTap() {
        dismissKeyboard()
    }
    
    //MARK: - Helpers
    @objc func dismissKeyboard() {
        self.view.endEditing(false)
    }
    @objc func handleDatePicker() {
        
    }
    @objc func doneClicked() {
        
    }
    
    
    
    private func isTextDataImputet () -> Bool {
        return usernameTextField.text != "" && emailTextField.text != "" && cityTextField.text != "" && dateOfBirthTextField.text != "" && passwordTextField.text != "" && confirmPasswordTextField.text != ""
    }
    
    //MARK: - Register User
    private func registerUser() {
        //loading spinning indicator
        ProgressHUD.show()
        FUser.registerUserWith(email: emailTextField.text!, password: passwordTextField.text!, username: usernameTextField.text!, city: cityTextField.text!, isMale: isMale, dateOfBirth: Date()) { error in

            if error == nil {
                ProgressHUD.showSuccess("Verification email sent!")
                self.dismiss(animated: true, completion: nil)
                
            } else {
                ProgressHUD.showError(error!.localizedDescription)
            }
        }
    }
}
