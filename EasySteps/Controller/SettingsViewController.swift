//
//  SettingsViewController.swift
//  EasySteps
//
//  Created by Jigar on 16/10/21.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet var viewSettings: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        viewSettings.roundCorners(.allCorners, radius: 15)
    }
    
    @IBAction func btnProfileClick(sender: UIButton) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }

    @IBAction func btnRegionClick(sender: UIButton) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "RegionLanguageViewController") as! RegionLanguageViewController
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    @IBAction func btnDeleteAccountClick(sender: UIButton) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "DeletePopupViewController") as! DeletePopupViewController
        nextViewController.modalPresentationStyle = .overCurrentContext
        self.present(nextViewController, animated: true, completion: nil)
    }
    
    @IBAction func btnChangePwdClick(sender: UIButton) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ChangePasswordViewController") as! ChangePasswordViewController
        nextViewController.modalPresentationStyle = .overCurrentContext
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    //MARK: Logount click
    @IBAction func btnLogoutClick(sender: UIButton) {
        let alert = UIAlertController.init(title: App_Title, message: "Are you sure to make logout?", preferredStyle: .alert)
        let yesAction = UIAlertAction.init(title: "Yes", style: .default) { (action) in
            //self.LogoutAPI()
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            let navigationController = UINavigationController(rootViewController: nextViewController)
            navigationController.navigationBar.isHidden = true
            self.view.window!.rootViewController = navigationController
        }
        let noAction = UIAlertAction.init(title: "No", style: .cancel, handler: nil)
        alert.addAction(yesAction)
        alert.addAction(noAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK:- Logout API
    /*func LogoutAPI(){
        startAnimating(Loadersize, message: "", type: NVActivityIndicatorType.ballSpinFadeLoader)
        let param : NSMutableDictionary =  NSMutableDictionary()
        if let uid: String = Defaults.value(forKey: "user_id") as? String {
            param.setValue(uid, forKey: "user_id")
        }
        if let token: String = Defaults.value(forKey: "token") as? String {
            param.setValue(token, forKey: "user_token")
        }
        let successed = {(responseObject: AnyObject) -> Void in
        self.stopAnimating()
            if responseObject != nil{
                       let dataObj : JSON = JSON.init(responseObject)
                       if(dataObj["status"].stringValue == "1") {
                            self.clearAllUserDefault()
                            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                            let navigationController = UINavigationController(rootViewController: nextViewController)
                            navigationController.navigationBar.isHidden = true
                            self.view.window!.rootViewController = navigationController
                       }else{
                           self.showAlert(title: App_Title, msg: responseObject.value(forKeyPath: "message") as! String)
                       }
                   }
        }
        let failure = {(error: AnyObject) -> Void in
            self.stopAnimating()
            self.showAlert(title: App_Title, msg: WrongMsg)
        }
        service.PostWithAlamofire(Parameters: param as? [String : AnyObject], action: LOGOUTAPI as NSString, success: successed, failure: failure)
    } */
    
    func clearAllUserDefault() {
        Defaults.removeObject(forKey: "user_type")
        Defaults.removeObject(forKey: "user_id")
        Defaults.removeObject(forKey: "user_email")
        Defaults.removeObject(forKey: "user_name")
        Defaults.setValue(false, forKey: "is_logged_in")
        Defaults.removeObject(forKey: "user_city")
        Defaults.removeObject(forKey: "deviceId")
        Defaults.removeObject(forKey: "profile_pic")
        Defaults.synchronize()
    }
}
