//
//  FirebaseListener.swift
//  IdeaCards
//
//  Created by Владимир Рябов on 04.12.2021.
//

import Foundation
import Firebase

class FirebaseListener {
    static let shared = FirebaseListener()
    private init() {}
    
    //MARK: - FUser
    func downloadCurrentUserFromFirebase(userId: String, email: String) {
        //проверряет наличие документа на ФБ и если он есть скачивает его локально
        FirebaseReference(.User).document(userId).getDocument { _snapshot, error in
            //если там нил, функция просто прекратит работать
            guard let snapshot = _snapshot else { return }
            if snapshot.exists {
                //создаем нового пользователя из FUser
                //So remember, this case, if snapshot exist, means our user has already created the user object.
                let user = FUser(_dictionary: snapshot.data() as! NSDictionary)
                //So what do we want to do when we download this user? We want to save it locally.
                //So we always whenever our user starts the application, we want to grab the latest version of a fuser object and say with locally. So in case if there were any changes done, let's say user logs in from a different device. And it goes and changes, for example, his avatar image or his age. So as soon as we logging on another device, we want to grab the latest user object from the fireplace and save it locally so we have access to it.
                user.saveUserLocally()
                
            } else {
                //first login. Our user has never created his user object. So this is the first time he logs in after he created his account. But this time, we're going to create it using the user object we have in our user defaults.
                //Remember, when we registered user, we create, uh, user object, which is a dictionary, and we save it in our user default. So that when we log in, we have access to these data.
                //So now we can take that the user that we have locally after our registration and uploaded to Firebase.
                //We are going to first check if we have a user object saved in our user defaults.
                //So we are going to tell our user defaults.Do you have anything for a key current user?
                if let user = userDefaults.object(forKey: kCURRENTUSER) {
                    //И если там есть словарь под этим ключом то мы создаем объект FUser и вставляем туда этот словарь из UserDefaults
                    FUser(_dictionary: user as! NSDictionary).saveUserToFirestore()
                }
            }
        }
    }
}
