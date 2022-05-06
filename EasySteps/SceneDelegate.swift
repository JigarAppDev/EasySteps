//
//  SceneDelegate.swift
//  EasySteps
//
//  Created by Jigar on 02/10/21.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private let biometricIDAuth = BiometricIDAuth()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
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
        if (Defaults.value(forKey: "is_logged_in") != nil) {
            
            if !Defaults.bool(forKey: "FaceID_Enabled_Flag") {
                let isLoggedIn = Defaults.value(forKey: "is_logged_in") as! Bool
                if isLoggedIn {
                    if Defaults.bool(forKey: "FaceID_Enabled") {
                        
                        biometricIDAuth.canEvaluate { (canEvaluate, _, canEvaluateError) in
                            guard canEvaluate else {
                                self.alert(title: "Error",
                                           message: canEvaluateError?.localizedDescription ?? "Face ID/Touch ID may not be configured",
                                           okActionTitle: "Cancel")
                                return
                            }
                            
                            biometricIDAuth.evaluate { [weak self] (success, error) in
                                guard success else {
                                    self?.alert(title: "Error",
                                                message: error?.localizedDescription ?? "Face ID/Touch ID may not be configured",
                                                okActionTitle: "Cancel")
                                    return
                                }
                                
                                
                                    
                                    //Success Code here
                                    let sb = UIStoryboard.init(name: "Main", bundle: nil)
                                    let tabVC = sb.instantiateViewController(withIdentifier: "TabViewController") as! TabViewController
                                    let navigationController = UINavigationController(rootViewController: tabVC)
                                    navigationController.navigationBar.isHidden = true
                                    self?.window!.rootViewController = navigationController
                                    self?.window!.makeKeyAndVisible()
                                
                            }
                        }
                    } else {
                        // Show Login Again
                    }
                }
            } else {
                Defaults.set(false, forKey: "FaceID_Enabled_Flag")
                Defaults.synchronize()
            }
            
        }
    }
    
    func alert(title: String, message: String, okActionTitle: String) {
        let alertView = UIAlertController(title: title,
                                          message: message,
                                          preferredStyle: .alert)
        let okAction = UIAlertAction(title: okActionTitle, style: .default)
        alertView.addAction(okAction)
        self.window?.rootViewController?.present(alertView, animated: true, completion: nil)
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


}

