//
//  SettingsViewController.swift
//  EasySteps
//
//  Created by Jigar on 16/10/21.
//

import UIKit
import NVActivityIndicatorView
import SwiftyJSON
import MessageUI
import StoreKit

class SettingsViewController: UIViewController, NVActivityIndicatorViewable, DeleteAccountDelegate, MFMailComposeViewControllerDelegate {
    
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblProfile: UILabel!
    @IBOutlet var lblRegion: UILabel!
    @IBOutlet var lblEnableID: UILabel!
    @IBOutlet var lblLearn: UILabel!
    @IBOutlet var lblContact: UILabel!
    @IBOutlet var lblRateApp: UILabel!
    @IBOutlet var lblTerms: UILabel!
    @IBOutlet var lblPolicy: UILabel!
    @IBOutlet var lblChangePwd: UILabel!
    @IBOutlet var lblDeleteAC: UILabel!
    @IBOutlet var lblLogout: UILabel!

    @IBOutlet var viewSettings: UIView!
    @IBOutlet var faceIdSwitch: UISwitch!
    
    private let biometricIDAuth = BiometricIDAuth()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if Defaults.bool(forKey: "FaceID_Enabled") {
            self.faceIdSwitch.setOn(true, animated: true)
        } else {
            self.faceIdSwitch.setOn(false, animated: true)
        }
        
        self.setLocalUI()
    }
    
    func setLocalUI() {
        self.lblTitle.text = LocalizationSystem.sharedLocal().localizedString(forKey: "Settings", value: "")
        self.lblProfile.text = LocalizationSystem.sharedLocal().localizedString(forKey: "Profile", value: "")
        self.lblRegion.text = LocalizationSystem.sharedLocal().localizedString(forKey: "Region.&.Language", value: "")
        self.lblEnableID.text = LocalizationSystem.sharedLocal().localizedString(forKey: "Face.ID", value: "")
        self.lblLearn.text = LocalizationSystem.sharedLocal().localizedString(forKey: "Learn.ES", value: "")
        self.lblContact.text = LocalizationSystem.sharedLocal().localizedString(forKey: "Contact.Us", value: "")
        self.lblRateApp.text = LocalizationSystem.sharedLocal().localizedString(forKey: "Rate.the.App", value: "")
        self.lblTerms.text = LocalizationSystem.sharedLocal().localizedString(forKey: "Terms.of.Use", value: "")
        self.lblPolicy.text = LocalizationSystem.sharedLocal().localizedString(forKey: "Policy", value: "")
        self.lblChangePwd.text = LocalizationSystem.sharedLocal().localizedString(forKey: "Change.Password", value: "")
        self.lblDeleteAC.text = LocalizationSystem.sharedLocal().localizedString(forKey: "Delete.account", value: "")
        self.lblLogout.text = LocalizationSystem.sharedLocal().localizedString(forKey: "Logout", value: "")
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
        nextViewController.delegate = self
        self.present(nextViewController, animated: true, completion: nil)
    }
    
    @IBAction func btnChangePwdClick(sender: UIButton) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ChangePasswordViewController") as! ChangePasswordViewController
        nextViewController.modalPresentationStyle = .overCurrentContext
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    @IBAction func btnConactUs(sender: UIButton) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["info@easystepsco.com"])
            mail.setSubject("")
            //mail.setMessageBody("<b>Blabla</b>", isHTML: true)
            present(mail, animated: true, completion: nil)
        } else {
            print("Cannot send mail")
            // give feedback to the user
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?){
        switch result.rawValue {
        case MFMailComposeResult.cancelled.rawValue:
            print("Cancelled")
        case MFMailComposeResult.saved.rawValue:
            print("Saved")
        case MFMailComposeResult.sent.rawValue:
            print("Sent")
        case MFMailComposeResult.failed.rawValue:
            print("Error: \(String(describing: error?.localizedDescription))")
        default:
            break
        }
        controller.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func rateTheApp(sender: UIButton) {
        guard let url = URL(string : "itms-apps://itunes.apple.com/app/id1445178269?mt=8&action=write-review") else { return }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    @IBAction func showPolicy(sender: UIButton) {
        guard let url = URL(string : "http://46.101.95.217/easysteps/privacy-policy") else { return }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    @IBAction func showTerms(sender: UIButton) {
        guard let url = URL(string : "http://46.101.95.217/easysteps/terms-condition") else { return }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    @IBAction func enableFaceIDClick(sender: UISwitch) {
        if sender.isOn {
            biometricIDAuth.canEvaluate { (canEvaluate, _, canEvaluateError) in
                guard canEvaluate else {
                    self.showAlert(title: App_Title, msg: canEvaluateError?.localizedDescription ?? "Face ID/Touch ID may not be configured")
                    self.faceIdSwitch.setOn(false, animated: true)
                    return
                }
                
                biometricIDAuth.evaluate { [weak self] (success, error) in
                    guard success else {
                        self?.showAlert(title: App_Title, msg: error?.localizedDescription ?? "Face ID/Touch ID may not be configured")
                        self?.faceIdSwitch.setOn(false, animated: true)
                        return
                    }
                    
                    //Success Code here
                    Defaults.set(true, forKey: "FaceID_Enabled")
                    Defaults.set(true, forKey: "FaceID_Enabled_Flag")
                    Defaults.synchronize()
                }
            }
        } else {
            self.faceIdSwitch.setOn(false, animated: true)
            Defaults.set(false, forKey: "FaceID_Enabled")
            Defaults.synchronize()
        }
    }
    
    //Delete Account click
    func deleteClick() {
        startAnimating(Loadersize, message: "", type: NVActivityIndicatorType.ballSpinFadeLoader)
        let param : NSMutableDictionary =  NSMutableDictionary()
        if let uid: String = Defaults.value(forKey: "user_id") as? String {
            param.setValue(uid, forKey: "user_id")
        }
        if let did: String = Defaults.value(forKey: "deviceId") as? String {
            param.setValue(did, forKey: "device_id")
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
        service.PostWithAlamofireHeader(Parameters: param as? [String : AnyObject], action: DELETEACCOUNT as NSString, success: successed, failure: failure)
    }
    
    //MARK: Logount click
    @IBAction func btnLogoutClick(sender: UIButton) {
        let alert = UIAlertController.init(title: App_Title, message: LocalizationSystem.sharedLocal().localizedString(forKey: "Logout.Msg", value: ""), preferredStyle: .alert)
        let yesAction = UIAlertAction.init(title:  LocalizationSystem.sharedLocal().localizedString(forKey: "Yes", value: ""), style: .default) { (action) in
            self.LogoutAPI()
        }
        let noAction = UIAlertAction.init(title:  LocalizationSystem.sharedLocal().localizedString(forKey: "No", value: ""), style: .cancel, handler: nil)
        alert.addAction(yesAction)
        alert.addAction(noAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK:- Logout API
    func LogoutAPI(){
        startAnimating(Loadersize, message: "", type: NVActivityIndicatorType.ballSpinFadeLoader)
        let param : NSMutableDictionary =  NSMutableDictionary()
        if let uid: String = Defaults.value(forKey: "user_id") as? String {
            param.setValue(uid, forKey: "user_id")
        }
        if let did: String = Defaults.value(forKey: "deviceId") as? String {
            param.setValue(did, forKey: "device_id")
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
        service.PostWithAlamofireHeader(Parameters: param as? [String : AnyObject], action: LOGOUT as NSString, success: successed, failure: failure)
    }
    
    func clearAllUserDefault() {
        Defaults.set(false, forKey: "FaceID_Enabled")
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
