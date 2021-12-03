//
//  FUser.swift
//  IdeaCards
//
//  Created by Владимир Рябов on 03.12.2021.
//

import Foundation
import Firebase

class FUser: Equatable {
    //сравнивает два пользователя
    static func == (lhs: FUser, rhs: FUser) -> Bool {
        lhs.objectId == rhs.objectId
    }
    
    let objectId: String = ""
    
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
            }
        }
    }
    
}
