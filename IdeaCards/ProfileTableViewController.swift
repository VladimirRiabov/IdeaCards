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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackgrounds()
        //от меня строчка. закрывает черную полоску в статус баре
        navigationController?.navigationBar.subviews[0].backgroundColor = UIColor().primary()
    }
    
    //MARK: - IBActions
    @IBAction func settingsButtonPressed(_ sender: UIButton) {
    }
    @IBAction func cameraButtonPressed(_ sender: UIButton) {
    }
    @IBAction func editButtonPressed(_ sender: UIButton) {
    }
    
    //MARK: - Setup
    
    private func setupBackgrounds() {
        profileCellBackground.clipsToBounds = true
        profileCellBackground.layer.cornerRadius = 100
        profileCellBackground.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        
        aboutMeTextView.layer.cornerRadius = 10
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    

}
