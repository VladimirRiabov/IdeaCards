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
            FUser.resetPasswordFor(email: emailTextField.text!) { (error) in
                if error != nil {
                    ProgressHUD.showError(error!.localizedDescription)
                } else {
                    ProgressHUD.showSuccess("Please check your email!")
                }
            }
        } else {
            ProgressHUD.showError("Please insert your email adress.")
            
        }
    }
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        if emailTextField.text != "" && passwordTextField.text != "" {
            FUser.loginUserWith(email: emailTextField.text!, password: passwordTextField.text!) { (error, isEmailVerified) in
                if error != nil {
                    ProgressHUD.showError(error!.localizedDescription)
                } else if isEmailVerified {
                    //enter the application
                    self.goToApp()
                } else {
                    ProgressHUD.showError("Please verify your email!")
                }
            }
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
    
    //MARK: - Navigation
    private func goToApp() {
        //делает новым главным окном основной вьюконтроллер
        let mainView = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainView") as! UITabBarController
        //делает переход на фулскрин новое главное окно
        mainView.modalPresentationStyle = .fullScreen
        self.present(mainView, animated: true, completion: nil)
    }
    
    
}
