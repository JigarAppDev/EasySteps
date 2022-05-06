//
//  AppDelegate.swift
//  EasySteps
//
//  Created by Jigar on 02/10/21.
//

import UIKit
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        IQKeyboardManager.shared.enable = true
        UIView.appearance().semanticContentAttribute = .forceLeftToRight
        
        if (Defaults.value(forKey: "is_logged_in") != nil) {
            if !Defaults.bool(forKey: "FaceID_Enabled_Flag") {
                let isLoggedIn = Defaults.value(forKey: "is_logged_in") as! Bool
                if isLoggedIn {
                    if Defaults.bool(forKey: "FaceID_Enabled") {
                        Thread.sleep(forTimeInterval: 2.5)
                    } else {
                        Thread.sleep(forTimeInterval: 1.5)
                    }
                } else {
                    Thread.sleep(forTimeInterval: 1.5)
                }
            } else {
                Thread.sleep(forTimeInterval: 1.5)
            }
        } else {
            Thread.sleep(forTimeInterval: 1.5)
        }
        
        if let selectedLanguage = LocalizationSystem.sharedLocal().getLanguage(){
            LocalizationSystem.sharedLocal().setLanguage(selectedLanguage)
        }else{
            let languageCode = Locale.preferredLanguages[0]
            if ["ar,pt_PT","es"].contains(languageCode){
                LocalizationSystem.sharedLocal().setLanguage(languageCode)
            }else{
                LocalizationSystem.sharedLocal().setLanguage("en")
            }
        }
        UIView.appearance().semanticContentAttribute = .forceLeftToRight
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        print("BG")
    }
}

extension UITextField {
    open override func awakeFromNib() {
        super.awakeFromNib()
        if LocalizationSystem.sharedLocal().getLanguage() == "ar" {
            self.textAlignment = .left
        }
    }
}
