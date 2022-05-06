//
//  LoginViewController.swift
//  BeerElite
//
//  Created by Jigar on 13/01/20.
//  Copyright © 2020 Jigar. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import SwiftyJSON

class LoginViewController: UIViewController, NVActivityIndicatorViewable {
    
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var txtPassword: UITextField!
    @IBOutlet var loginTopView: UIView!
    @IBOutlet var imgRemember: UIImageView!
    @IBOutlet var btnRemember: UIButton!
    @IBOutlet var btnForgotPwd: UIButton!
    @IBOutlet var lblLogin: UILabel!
    @IBOutlet var btnLogin: UIButton!
    @IBOutlet var lblDontAC: UILabel!
    @IBOutlet var btnRegister: UIButton!
    
    var isFrom = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set Values if remember
        if let mail: String = Defaults.value(forKey: "loginMail") as? String {
            self.txtEmail.text = mail
            self.imgRemember.image = UIImage(named: "ic_checked")
            self.btnRemember.isSelected = true
        }
        if let pwd: String = Defaults.value(forKey: "loginPwd") as? String {
            self.txtPassword.text = pwd
            self.imgRemember.image = UIImage(named: "ic_checked")
            self.btnRemember.isSelected = true
        }
        
        self.btnRemember.titleLabel?.numberOfLines = 0
        self.btnForgotPwd.titleLabel?.numberOfLines = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setLocalUI()
    }
    
    func setLocalUI() {
        self.lblLogin.text = LocalizationSystem.sharedLocal().localizedString(forKey: "Login", value: "")
        self.btnLogin.setTitle(LocalizationSystem.sharedLocal().localizedString(forKey: "Login", value: ""), for: .normal)
        self.lblDontAC.text = LocalizationSystem.sharedLocal().localizedString(forKey: "Don't.account?", value: "")
        self.btnRegister.setTitle(LocalizationSystem.sharedLocal().localizedString(forKey: "Register", value: ""), for: .normal)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //self.loginTopView.roundCorners(.bottomLeft, radius: 75)
    }
    
    //MARK: Sign Up Click
    @IBAction func btnSignUpClick(sender: UIButton) {
        let signupVC = self.storyboard?.instantiateViewController(withIdentifier:"SignUpViewController") as! SignUpViewController
        self.navigationController?.pushViewController(signupVC, animated: true)
    }
    
    //MARK: Forgot Password Click
    @IBAction func btnForgotClick(sender: UIButton) {
        let forgotVC = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordViewController") as! ForgotPasswordViewController
        self.navigationController?.pushViewController(forgotVC, animated: true)
    }
    
    @IBAction func btnRememberMeClick(sender: UIButton) {
        if sender.isSelected == false {
            self.imgRemember.image = UIImage(named: "ic_checked")
            sender.isSelected = true
        } else {
            sender.isSelected = false
            self.imgRemember.image = UIImage(named: "ic_check")
        }
    }
    
    //MARK: Login Click
    @IBAction func btnLoginClick(sender: UIButton) {
        if self.validateUser() {
            if self.btnRemember.isSelected {
                Defaults.setValue(self.txtEmail.text!, forKey: "loginMail")
                Defaults.setValue(self.txtPassword.text!, forKey: "loginPwd")
                Defaults.synchronize()
            }
            self.makeLogin()
        }
    }
    
    //MARK: - Validate Login Data Method
    func validateUser() -> Bool {
        var boolVal : Bool = true
        if txtEmail.text?.trimmingCharacters(in: .whitespaces).isEmpty == true {
            showAlert(title: App_Title, msg: "Please Enter Email")
            boolVal = false
        }else if AppUtilities.sharedInstance.isValidEmail(emailAddressString: txtEmail.text!) == false {
            showAlert(title: App_Title, msg: "Please Enter Valid Email")
            boolVal = false
        }else if txtPassword.text?.trimmingCharacters(in: .whitespaces).isEmpty == true {
            showAlert(title: App_Title, msg: "Please Enter Password")
            boolVal = false
        }else if DEVICETOKEN == "" {
            showAlert(title: App_Title, msg: "DeviceToken is not generated so kindly try it later or  by refreshing app!")
            boolVal = false
        }
        return boolVal
    }
    
    //MARK: - Make User Login Method
    func makeLogin(){
        startAnimating(Loadersize, message: "", type: NVActivityIndicatorType.ballSpinFadeLoader)
        let identifier = UUID()
        let param : NSMutableDictionary =  NSMutableDictionary()
        param.setValue(txtEmail.text!, forKey: "userEmail")
        param.setValue(txtPassword.text!, forKey: "userPassword")
        param.setValue(DEVICETOKEN, forKey: "userDeviceToken")
        param.setValue("2", forKey: "userDevice")
        param.setValue(identifier.uuidString, forKey: "userDeviceId")
        param.setValue("0", forKey: "userLatitude")
        param.setValue("0", forKey: "userLongitude")
        
        let successed = {(responseObject: AnyObject) -> Void in
            self.stopAnimating()
            
            if responseObject != nil{
                let dataObj : JSON = JSON.init(responseObject)
                if(dataObj["status"].stringValue == "1") {
                    if (responseObject.value(forKeyPath: "data")) != nil{
                        self.setDefaultData(responseObject: responseObject)
                    }
                }else if(dataObj["status"].stringValue == "11") {
                    if dataObj["message"].stringValue == "Unauthorised" {
                        self.showAlert(title: App_Title, msg: "Invalid email or password.")
                    } else {
                        self.showAlert(title: App_Title, msg: dataObj["message"].stringValue)
                    }
                }else if(dataObj["status"].stringValue == "0") {
                    if dataObj["message"].stringValue == "Unauthorised" {
                        self.showAlert(title: App_Title, msg: "Invalid email or password.")
                    } else {
                        self.showAlert(title: App_Title, msg: dataObj["message"].stringValue)
                    }
                } else {
                    if dataObj["error"].stringValue == "Unauthorised" {
                        self.showAlert(title: App_Title, msg: "Invalid email or password.")
                    } else {
                        self.showAlert(title: App_Title, msg: dataObj["error"].stringValue)
                    }
                    //self.showAlert(title: App_Title, msg: responseObject.value(forKeyPath: "error") as! String)
                }
                
            }
        }
        let failure = {(error: AnyObject) -> Void in
            self.stopAnimating()
            //self.showAlert(title: App_Title, msg: WrongMsg)
        }
        service.PostWithAlamofire(Parameters: param as? [String : AnyObject], action: LOGINAPI as NSString, success: successed, failure: failure)
    }
    
    func setDefaultData(responseObject : AnyObject) {
        
        let dataFull : JSON = JSON.init(responseObject)
        let data : JSON = JSON.init(dataFull["data"])
        Defaults.setValue(data["userToken"].stringValue, forKey: "token")
        let uData = data
        userData = data
        let user_ID = uData["userId"].stringValue
        let user_Email = uData["userEmail"].stringValue
        Defaults.setValue(user_ID, forKey: "user_id")
        Defaults.setValue(user_Email, forKey: "user_email")
        let user_Name = uData["userName"].stringValue
        Defaults.setValue(user_Name, forKey: "user_name")
        Defaults.setValue(true, forKey: "is_logged_in")
        Defaults.setValue(uData["userCity"].stringValue, forKey: "user_city")
        Defaults.setValue(uData["userState"].stringValue, forKey: "userState")
        Defaults.setValue(uData["userCountry"].stringValue, forKey: "userCountry")
        Defaults.setValue(uData["userAddress"].stringValue, forKey: "userAddress")
        Defaults.setValue(uData["userPostCode"].stringValue, forKey: "userPostCode")
        let deviceId = uData["userDeviceToken"].stringValue
        Defaults.setValue(deviceId, forKey: "deviceId")
        Defaults.setValue(uData["userPhone"].stringValue, forKey: "userPhone")
        Defaults.synchronize()
        
        let tabVC = self.storyboard?.instantiateViewController(withIdentifier: "TabViewController") as! TabViewController
        self.navigationController?.pushViewController(tabVC, animated: true)
        
    }
}

extension UIViewController {
    func showAlert(title: String, msg: String)    {
        let alert = UIAlertController.init(title: title, message: msg, preferredStyle: .alert)
        let okAction = UIAlertAction.init(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}
