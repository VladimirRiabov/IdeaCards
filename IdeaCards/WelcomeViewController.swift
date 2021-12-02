//
//  WelcomeViewController.swift
//  IdeaCards
//
//  Created by Владимир Рябов on 02.12.2021.
//

import UIKit
import ProgressHUD

class WelcomeViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var backgroundImageView: UIView!
    
    //MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBackgroundTouch()

    }
 
    //MARK: - IBActions
    
    @IBAction func forgotPasswordButtonPressed(_ sender: UIButton) {
        if emailTextField.text != "" {
            //reset password
        } else {
            ProgressHUD.showError("Please insert your email adress.")
            
        }
    }
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        if emailTextField.text != "" && passwordTextField.text != "" {
            //login
        } else {
            ProgressHUD.showError("All fields are requaired!")
            
        }
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
    
    
}
