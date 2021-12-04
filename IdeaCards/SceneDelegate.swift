//
//  SceneDelegate.swift
//  IdeaCards
//
//  Created by Владимир Рябов on 08.11.2021.
//

import UIKit
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    //So if he logs in, if he logs out, we will be notified.
    var authListener: AuthStateDidChangeListenerHandle?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        
        //мы запускаем эту функцию здесь, т.к эта функция это первое что запуститься в приложении
//        autoLogin()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    //MARK: - Auto Login
    
    //функция проверяет входили ли мы в аккаунт на этом устройстве и если входили то направляет на с другой экран
    func autoLogin() {
        authListener = Auth.auth().addStateDidChangeListener({ auth, user in
            //And then we need to provide the name of the listener we want to remove, which is our authentication
            //So once we are notified that we logged out, we don't want to be notified next time our user logs in
            Auth.auth().removeStateDidChangeListener(self.authListener!)
            //We also want to make sure that a user object in our user defaults exist as well.
            if user != nil && userDefaults.object(forKey: kCURRENTUSER) != nil {
                //We want to get on a main threat because we are going to change the user interface
                //So we better be on a main threat because the UI changes happening.
                DispatchQueue.main.async {
                    //So we have a user and the current user saved on user defaults. Please go to the application and go to up function.
                    self.goToApp()
                }
                
            }
        })
    }
    private func goToApp() {
        //OK, so we have initialized these Tabbar controller.
        let mainView = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainView") as! UITabBarController
        //And what we need to do now is to set this as the root view of our application.
        // var window: UIWindow? наверху отвечает за первое и главное окно
        self.window?.rootViewController = mainView
        
    }
}

