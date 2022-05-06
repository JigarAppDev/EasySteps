//
//  SignUpViewController.swift
//  BeerElite
//
//  Created by Jigar on 13/01/20.
//  Copyright © 2020 Jigar. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import SwiftyJSON

class SignUpViewController: UIViewController, NVActivityIndicatorViewable {
    
    @IBOutlet var txtFullname: UITextField!
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var txtPassword: UITextField!
    @IBOutlet var txtPhoneNumber: UITextField!
    @IBOutlet var registerTopView: UIView!
    @IBOutlet var lblRegister: UILabel!
    @IBOutlet var btnRegister: UIButton!
    @IBOutlet var lblAlreadyAC: UILabel!
    @IBOutlet var btnLogin: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setLocalUI()
    }
    
    func setLocalUI() {
        self.lblRegister.text = LocalizationSystem.sharedLocal().localizedString(forKey: "Register", value: "")
        self.btnRegister.setTitle(LocalizationSystem.sharedLocal().localizedString(forKey: "Register", value: ""), for: .normal)
        self.lblAlreadyAC.text = LocalizationSystem.sharedLocal().localizedString(forKey: "Already.a.member?", value: "")
        self.btnLogin.setTitle(LocalizationSystem.sharedLocal().localizedString(forKey: "Login", value: ""), for: .normal)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //self.registerTopView.roundCorners(.bottomLeft, radius: 75)
    }
    
    // MARK: - Back Click
    @IBAction func btnBackClick(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: Login Click
    @IBAction func btnLoginClick(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        //let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        //self.navigationController?.pushViewController(loginVC, animated: true)
    }
    
    //MARK: Sign Up Click
    @IBAction func btnSignUpClick(sender: UIButton) {
        if self.validateUser() {
            self.makeSignUp()
        }
    }
    
    //MARK: - Validate Signup Data Method
    func validateUser() -> Bool {
        var boolVal : Bool = true
        if txtFullname.text?.trimmingCharacters(in: .whitespaces).isEmpty == true {
            showAlert(title: App_Title, msg: "Please Enter FullName")
            boolVal = false
        }else if txtEmail.text?.trimmingCharacters(in: .whitespaces).isEmpty == true {
            showAlert(title: App_Title, msg: "Please Enter Email Address")
            boolVal = false
        }else if AppUtilities.sharedInstance.isValidEmail(emailAddressString: txtEmail.text!) == false {
            showAlert(title: App_Title, msg: "Please Enter Valid Email")
            boolVal = false
        }else if txtPhoneNumber.text?.trimmingCharacters(in: .whitespaces).isEmpty == true {
            showAlert(title: App_Title, msg: "Please Enter Phone Number")
            boolVal = false
        }else if txtPassword.text?.trimmingCharacters(in: .whitespaces).isEmpty == true {
            showAlert(title: App_Title, msg: "Please Enter Password")
            boolVal = false
        }else if txtPassword.text!.count < 6 {
            showAlert(title: App_Title, msg: "Password must be at least 6 characters")
            boolVal = false
        }else if DEVICETOKEN == "" {
            showAlert(title: App_Title, msg: "DeviceToken is not generated so kindly try it later or  by refreshing app!")
            boolVal = false
        }
        return boolVal
    }
    
    //MARK: - Make SignUp Method
    func makeSignUp(){
        startAnimating(Loadersize, message: "", type: NVActivityIndicatorType.ballSpinFadeLoader)
        let identifier = UUID()
        let param : NSMutableDictionary =  NSMutableDictionary()
        param.setValue(txtFullname.text!, forKey: "userName")
        param.setValue(txtEmail.text!, forKey: "userEmail")
        param.setValue(txtPassword.text!, forKey: "userPassword")
        param.setValue(txtPhoneNumber.text!, forKey: "userPhone")
        param.setValue(DEVICETOKEN, forKey: "userDeviceToken")
        param.setValue("2", forKey: "userDevice")
        param.setValue(identifier.uuidString, forKey: "userDeviceId")
        param.setValue("0", forKey: "userLatitude")
        param.setValue("0", forKey: "userLongitude")
        
        let successed = {(responseObject: AnyObject) -> Void in
            self.stopAnimating()
            if responseObject != nil {
                let dataObj : JSON = JSON.init(responseObject)
                if(dataObj["status"].stringValue == "1") {
                    if (responseObject.value(forKeyPath: "data")) != nil {
                        self.setDefaultData(responseObject: responseObject)
                    }
                }else{
                    if dataObj["message"].stringValue == "Unauthorised" {
                        self.showAlert(title: App_Title, msg: "Invalid email or password.")
                    } else {
                        self.showAlert(title: App_Title, msg: dataObj["message"].stringValue)
                    }
                }
            }
        }
        let failure = {(error: AnyObject) -> Void in
            self.stopAnimating()
           //self.showAlert(title: App_Title, msg: WrongMsg)
        }
        service.PostWithAlamofire(Parameters: param as? [String : AnyObject], action: SIGNAPI as NSString, success: successed, failure: failure)
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
        let deviceId = uData["userDeviceId"].stringValue
        Defaults.setValue(deviceId, forKey: "deviceId")
        let deviceToken = uData["userDeviceToken"].stringValue
        Defaults.setValue(deviceToken, forKey: "deviceToken")
        Defaults.setValue(uData["userPhone"].stringValue, forKey: "userPhone")
        Defaults.synchronize()
        
        let tabVC = self.storyboard?.instantiateViewController(withIdentifier: "TabViewController") as! TabViewController
        self.navigationController?.pushViewController(tabVC, animated: true)
        
    }
}

