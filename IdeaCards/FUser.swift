//
//  FUser.swift
//  IdeaCards
//
//  Created by Владимир Рябов on 03.12.2021.
//

import Foundation
import Firebase
import UIKit

class FUser: Equatable {
    //сравнивает два пользователя
    static func == (lhs: FUser, rhs: FUser) -> Bool {
        lhs.objectId == rhs.objectId
    }
    
    let objectId: String
    var email: String
    var username: String
    var dateOfBirth: Date
    var isMale: Bool
    var avatar: UIImage?
    var profession: String
    var jobTitle: String
    var about: String
    var city: String
    var country: String
    var height: Double
    var lookingFor: String
    var avatarLink: String
    
    var likedIdArray: [String]?
    var imageLinks: [String]?
    let registeredDate = Date()
    var pushId: String?
    
    var userDictionary: NSDictionary {
        return NSDictionary(
            objects:[
                self.objectId,
                self.email,
                self.username,
                self.dateOfBirth,
                self.isMale,
                self.profession,
                self.jobTitle,
                self.about,
                self.city,
                self.country,
                self.height,
                self.lookingFor,
                self.avatarLink,
                self.likedIdArray ?? [],
                self.imageLinks ?? [],
                self.registeredDate,
                self.pushId],
            forKeys:[
                kOBJECTID as NSCopying,
                kEMAIL as NSCopying,
                kUSERNAME as NSCopying,
                kDATEOFBIRTH as NSCopying,
                kISMALE as NSCopying,
                kPROFESSION as NSCopying,
                kJOBTITLE as NSCopying,
                kABOUT as NSCopying,
                kCITY as NSCopying,
                kCOUNTRY as NSCopying,
                kHEIGHT as NSCopying,
                kLOOKINGFOR as NSCopying,
                kAVATARLINK as NSCopying,
                kLIKEDIDARRAY as NSCopying,
                kIMAGELINKS as NSCopying,
                kREGISTEREDDATE as NSCopying,
                kPUSHID as NSCopying]
                )
    }
    
   
    
    //MARK: - Inits
    init(_objectId: String, _email: String, _username: String, _city: String, _dateOfBirth: Date, _isMale: Bool, _avatarLink: String = "") {
        objectId = _objectId
        email = _email
        username = _username
        dateOfBirth = _dateOfBirth
        isMale = _isMale
        profession = ""
        jobTitle = ""
        about = ""
        city = _city
        country = ""
        height = 0.0
        lookingFor = ""
        avatarLink = _avatarLink
        likedIdArray = []
        imageLinks = []
    }
    
    //причина почему это классовая функция в том, что я смогу ее вызвать без обязательной инициализации FUser
    class func registerUserWith(email: String, password: String, username: String, city: String, isMale: Bool, dateOfBirth: Date, completion: @escaping (_ error: Error?) -> Void) {
        
        Auth.auth().createUser(withEmail: email, password: password) { authData, error in
            completion(error)
            if error == nil {
                //email authentication form
                authData!.user.sendEmailVerification { (error) in
                    print("auth email verification sent", error?.localizedDescription)
                }
                //create user in database
                //auth.user = userUID
                if authData?.user != nil {
                    let user = FUser(_objectId: authData!.user.uid, _email: email, _username: username, _city: city, _dateOfBirth: dateOfBirth, _isMale: isMale)
                    user.saveUserLocally()
                }
            }
        }
    }
    func saveUserLocally() {
        
    }
    
}
