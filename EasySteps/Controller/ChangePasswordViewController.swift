//
//  ChangePasswordViewController.swift
//  EasySteps
//
//  Created by Jigar on 17/10/21.
//

import UIKit
import NVActivityIndicatorView
import SwiftyJSON

class ChangePasswordViewController: UIViewController, NVActivityIndicatorViewable {
    
    @IBOutlet var txtPassword: UITextField!
    @IBOutlet var txtNewPassword: UITextField!
    @IBOutlet var txtConfirmPassword: UITextField!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblCurrPwd: UILabel!
    @IBOutlet var lblNewPwd: UILabel!
    @IBOutlet var lblConPwd: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setLocalUI()
    }
    
    func setLocalUI() {
        self.lblTitle.text = LocalizationSystem.sharedLocal().localizedString(forKey: "Change.Password", value: "")
        self.lblCurrPwd.text = LocalizationSystem.sharedLocal().localizedString(forKey: "Current.Password", value: "")
        self.lblNewPwd.text = LocalizationSystem.sharedLocal().localizedString(forKey: "New.Password", value: "")
        self.lblConPwd.text = LocalizationSystem.sharedLocal().localizedString(forKey: "Confirm.Password", value: "")
    }
    
    // MARK: - Back Click
    @IBAction func btnBackClick(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: Submit Click
    @IBAction func btnSubmitClick(sender: UIButton) {
        if self.validateUser() {
            self.changePassword()
        }
    }
    
    //MARK: - Validate Data Method
    func validateUser() -> Bool {
        var boolVal : Bool = true
        if txtPassword.text?.trimmingCharacters(in: .whitespaces).isEmpty == true {
            showAlert(title: App_Title, msg: "Please Enter Current Password")
            boolVal = false
        }else if txtNewPassword.text?.trimmingCharacters(in: .whitespaces).isEmpty == true {
            showAlert(title: App_Title, msg: "Please Enter New Password")
            boolVal = false
        }else if txtNewPassword.text!.count < 6 {
            showAlert(title: App_Title, msg: "New Password must be at least 6 characters")
            boolVal = false
        }else if txtNewPassword.text != txtConfirmPassword.text {
            showAlert(title: App_Title, msg: "Confirm Password must be match")
            boolVal = false
        }
        return boolVal
    }
    
    //MARK: - Make Reset Method
    func changePassword(){
        startAnimating(Loadersize, message: "", type: NVActivityIndicatorType.ballSpinFadeLoader)
        let param : NSMutableDictionary =  NSMutableDictionary()
        param.setValue(txtPassword.text!, forKey: "CurrentPassword")
        param.setValue(txtNewPassword.text!, forKey: "NewPassword")
        
        let successed = {(responseObject: AnyObject) -> Void in
            self.stopAnimating()
            if responseObject != nil{
                let dataObj : JSON = JSON.init(responseObject)
                if(dataObj["status"].stringValue == "1") {
                    self.showAlertNavigate(title: "OK", msg: dataObj["message"].stringValue)
                }else{
                    self.showAlert(title: App_Title, msg: dataObj["message"].stringValue)
                }
            }
        }
        let failure = {(error: AnyObject) -> Void in
            self.stopAnimating()
            self.showAlert(title: App_Title, msg: WrongMsg)
        }
        service.PostWithAlamofireHeader(Parameters: param as? [String : AnyObject], action: CHANGEPASSWORD as NSString, success: successed, failure: failure)
    }
    
    //MARK: - Navigate to Login Screen
    func showAlertNavigate(title: String, msg: String){
        let alert = UIAlertController.init(title: title, message: msg, preferredStyle: .alert)
        let okAction = UIAlertAction.init(title: "OK", style: .default) { (UIAlertAction) in
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            let navigationController = UINavigationController(rootViewController: nextViewController)
            navigationController.navigationBar.isHidden = true
            self.view.window!.rootViewController = navigationController
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
}
