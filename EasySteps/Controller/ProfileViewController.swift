//
//  ProfileViewController.swift
//  EasySteps
//
//  Created by Jigar on 16/10/21.
//

import UIKit
import NVActivityIndicatorView
import SwiftyJSON

class ProfileViewController: UIViewController, CountryDelegate, NVActivityIndicatorViewable {

    @IBOutlet var txtCountry: UITextField!
    @IBOutlet var txtName: UITextField!
    @IBOutlet var txtAddress: UITextField!
    @IBOutlet var txtState: UITextField!
    @IBOutlet var txtCity: UITextField!
    @IBOutlet var txtPostcode: UITextField!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblAddress: UILabel!
    @IBOutlet var lblCountry: UILabel!
    @IBOutlet var lblState: UILabel!
    @IBOutlet var lblCity: UILabel!
    @IBOutlet var lblPostCode: UILabel!
    @IBOutlet var btnSave: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //Set Values
        if let uname: String = Defaults.value(forKey: "user_name") as? String {
            self.txtName.text = uname
        }
        if let city: String = Defaults.value(forKey: "user_city") as? String {
            self.txtCity.text = city
        }
        if let state: String = Defaults.value(forKey: "userState") as? String {
            self.txtState.text = state
        }
        if let country: String = Defaults.value(forKey: "userCountry") as? String {
            self.txtCountry.text = country
        }
        if let addr: String = Defaults.value(forKey: "userAddress") as? String {
            self.txtAddress.text = addr
        }
        if let code: String = Defaults.value(forKey: "userPostCode") as? String {
            self.txtPostcode.text = code
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setLocalUI()
    }
    
    func setLocalUI() {
        self.lblTitle.text = LocalizationSystem.sharedLocal().localizedString(forKey: "Profile", value: "")
        self.btnSave.setTitle(LocalizationSystem.sharedLocal().localizedString(forKey: "Save", value: ""), for: .normal)
        self.lblName.text = LocalizationSystem.sharedLocal().localizedString(forKey: "Name", value: "")
        self.lblAddress.text = LocalizationSystem.sharedLocal().localizedString(forKey: "Address", value: "")
        self.lblCountry.text = LocalizationSystem.sharedLocal().localizedString(forKey: "Country", value: "")
        self.lblState.text = LocalizationSystem.sharedLocal().localizedString(forKey: "State", value: "")
        self.lblCity.text = LocalizationSystem.sharedLocal().localizedString(forKey: "City", value: "")
        self.lblPostCode.text = LocalizationSystem.sharedLocal().localizedString(forKey: "Post.Code", value: "")
    }

    @IBAction func btnBackClick(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func selectCountryClick(sender: UIButton) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SelectCountryViewController") as! SelectCountryViewController
        nextViewController.delegate = self
        nextViewController.modalPresentationStyle = .overCurrentContext
        self.present(nextViewController, animated: true, completion: nil)
    }
    
    func getSelectedCountry(name: String) {
        self.txtCountry.text = name
    }
    
    //MARK: Save Click
    @IBAction func btnSaveClick(sender: UIButton) {
        if self.validateUser() {
            self.updateUserData()
        }
    }
    
    //MARK: - Validate Data Method
    func validateUser() -> Bool {
        var boolVal : Bool = true
        if txtName.text?.trimmingCharacters(in: .whitespaces).isEmpty == true {
            showAlert(title: App_Title, msg: "Please Enter FullName")
            boolVal = false
        }else if txtAddress.text?.trimmingCharacters(in: .whitespaces).isEmpty == true {
            showAlert(title: App_Title, msg: "Please Enter Address")
            boolVal = false
        }else if txtCountry.text?.trimmingCharacters(in: .whitespaces).isEmpty == true {
            showAlert(title: App_Title, msg: "Please Select Country")
            boolVal = false
        }else if txtState.text?.trimmingCharacters(in: .whitespaces).isEmpty == true {
            showAlert(title: App_Title, msg: "Please Enter State")
            boolVal = false
        }else if txtCity.text?.trimmingCharacters(in: .whitespaces).isEmpty == true {
            showAlert(title: App_Title, msg: "Please Enter City")
            boolVal = false
        }else if txtPostcode.text?.trimmingCharacters(in: .whitespaces).isEmpty == true {
            showAlert(title: App_Title, msg: "Please Enter Post Code")
            boolVal = false
        }
        return boolVal
    }
    
    //MARK: - Make API Call
    func updateUserData(){
        startAnimating(Loadersize, message: "", type: NVActivityIndicatorType.ballSpinFadeLoader)
        let param : NSMutableDictionary =  NSMutableDictionary()
        param.setValue(txtName.text!, forKey: "userName")
        param.setValue(txtAddress.text!, forKey: "userAddress")
        param.setValue(txtState.text!, forKey: "userCity")
        param.setValue(txtCity.text!, forKey: "userState")
        param.setValue(txtCountry.text!, forKey: "userCountry")
        param.setValue(txtPostcode.text!, forKey: "userPostCode")
        if let mail: String = Defaults.value(forKey: "user_email") as? String {
            param.setValue(mail, forKey: "userEmail")
        }
        
        let successed = {(responseObject: AnyObject) -> Void in
            self.stopAnimating()
            if responseObject != nil {
                let dataObj : JSON = JSON.init(responseObject)
                
                self.showAlert(title: App_Title, msg: dataObj["message"].stringValue)
                if(dataObj["status"].stringValue == "1") {
                    Defaults.setValue(self.txtName.text!, forKey: "user_name")
                    Defaults.setValue(self.txtCity.text!, forKey: "user_city")
                    Defaults.setValue(self.txtState.text!, forKey: "userState")
                    Defaults.setValue(self.txtCountry.text!, forKey: "userCountry")
                    Defaults.setValue(self.txtAddress.text!, forKey: "userAddress")
                    Defaults.setValue(self.txtPostcode.text!, forKey: "userPostCode")
                    Defaults.synchronize()
                }
            }
        }
        let failure = {(error: AnyObject) -> Void in
            self.stopAnimating()
            self.showAlert(title: App_Title, msg: WrongMsg)
        }
        service.PostWithAlamofireHeader(Parameters: param as? [String : AnyObject], action: UPDATEPROFILE as NSString, success: successed, failure: failure)
    }
}
