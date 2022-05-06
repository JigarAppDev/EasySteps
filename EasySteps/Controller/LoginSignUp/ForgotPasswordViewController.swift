//
//  ForgotPasswordViewController.swift
//  BeerElite
//
//  Created by Jigar on 13/01/20.
//  Copyright © 2020 Jigar. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import SwiftyJSON

class ForgotPasswordViewController: UIViewController, NVActivityIndicatorViewable {
    
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var forgotTopView: UIView!
    @IBOutlet var btnSubmit: UIButton!
    @IBOutlet var btnCancel: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setLocalUI()
    }
    
    func setLocalUI() {
        self.btnSubmit.setTitle(LocalizationSystem.sharedLocal().localizedString(forKey: "Submit", value: ""), for: .normal)
        self.btnCancel.setTitle(LocalizationSystem.sharedLocal().localizedString(forKey: "Cancel", value: ""), for: .normal)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //self.forgotTopView.roundCorners(.bottomLeft, radius: 75)
    }
    
    // MARK: - Back Click
    @IBAction func btnBackClick(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: Submit Click
    @IBAction func btnSubmitClick(sender: UIButton) {
        if validateUser() {
            self.forgotPasswordAPI()
        }
    }
    
    //MARK: - Validate Email Data
    func validateUser() -> Bool {
        var boolVal : Bool = true
        if txtEmail.text?.trimmingCharacters(in: .whitespaces).isEmpty == true {
            showAlert(title: App_Title, msg: "Please Enter Email Address")
            boolVal = false
        }else if AppUtilities.sharedInstance.isValidEmail(emailAddressString: txtEmail.text!) == false {
            showAlert(title: App_Title, msg: "Please Enter Valid Email")
            boolVal = false
        }
        return boolVal
    }
    
    func forgotPasswordAPI(){
        startAnimating(Loadersize, message: "", type: NVActivityIndicatorType.ballSpinFadeLoader)
        let param : NSMutableDictionary =  NSMutableDictionary()
        param.setValue(txtEmail.text!, forKey: "userEmail")
        let successed = {(responseObject: AnyObject) -> Void in
            self.stopAnimating()
            if responseObject != nil{
                let dataObj : JSON = JSON.init(responseObject)
                if(dataObj["status"].stringValue == "1") {
                    if (responseObject.value(forKeyPath: "message")) != nil{
                        self.showAlertNavigate(title: App_Title, msg:  responseObject.value(forKeyPath: "message") as! String )
                    }
                }else{
                    self.showAlert(title: App_Title, msg: responseObject.value(forKeyPath: "message") as! String)
                }
            }
        }
        let failure = {(error: AnyObject) -> Void in
            self.stopAnimating()
            self.showAlert(title: App_Title, msg: WrongMsg)
        }
        service.PostWithAlamofire(Parameters: param as? [String : AnyObject], action: FORGOTPASSWORD as NSString, success: successed, failure: failure)
    }
    
    func showAlertNavigate(title: String, msg: String){
        let alert = UIAlertController.init(title: title, message: msg, preferredStyle: .alert)
        let okAction = UIAlertAction.init(title: "OK", style: .default) { (UIAlertAction) in
            let resetVC = self.storyboard?.instantiateViewController(withIdentifier:"ResetPasswordViewController") as! ResetPasswordViewController
            resetVC.emailStr = self.txtEmail.text!
            self.navigationController?.pushViewController(resetVC, animated: true)
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}
