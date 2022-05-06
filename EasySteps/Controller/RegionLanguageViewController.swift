//
//  RegionLanguageViewController.swift
//  EasySteps
//
//  Created by Jigar on 17/10/21.
//

import UIKit
import NVActivityIndicatorView
import SwiftyJSON
import SwiftUI

class RegionLanguageViewController: UIViewController, CountryDelegate, LanguageDelegate, NVActivityIndicatorViewable {

    @IBOutlet var lblRegion: UILabel!
    @IBOutlet var lblLanguage: UILabel!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var txtCountry: UITextField!
    @IBOutlet var txtLanguage: UITextField!
    @IBOutlet var btnSave: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //Set Values
        if let uname: String = Defaults.value(forKey: "user_lang") as? String {
            self.txtLanguage.text = uname
        }
        if let city: String = Defaults.value(forKey: "user_region") as? String {
            self.txtCountry.text = city
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setLocalUI()
    }
    
    func setLocalUI() {
        self.lblTitle.text = LocalizationSystem.sharedLocal().localizedString(forKey: "Region.&.Language", value: "")
        self.lblRegion.text = LocalizationSystem.sharedLocal().localizedString(forKey: "Region", value: "")
        self.lblLanguage.text = LocalizationSystem.sharedLocal().localizedString(forKey: "Language", value: "")
        self.btnSave.setTitle(LocalizationSystem.sharedLocal().localizedString(forKey: "Save", value: ""), for: .normal)
    }

    @IBAction func btnBackClick(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func selectRegionClick(sender: UIButton) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SelectCountryViewController") as! SelectCountryViewController
        nextViewController.isFrom = "Region"
        nextViewController.delegate = self
        nextViewController.modalPresentationStyle = .overCurrentContext
        self.present(nextViewController, animated: true, completion: nil)
    }
    
    @IBAction func selectLanguageClick(sender: UIButton) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SelectLanguageViewController") as! SelectLanguageViewController
        nextViewController.delegate = self
        nextViewController.modalPresentationStyle = .overCurrentContext
        self.present(nextViewController, animated: true, completion: nil)
    }
    
    func getSelectedCountry(name: String) {
        self.txtCountry.text = name
        //Defaults.setValue(self.txtCountry.text!, forKey: "user_region")
        //Defaults.synchronize()
    }
    
    func getSelectedLanguage(name: String) {
        self.txtLanguage.text = name
        //Defaults.setValue(self.txtLanguage.text!, forKey: "user_lang")
        //Defaults.synchronize()
              
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
        if txtCountry.text?.trimmingCharacters(in: .whitespaces).isEmpty == true {
            showAlert(title: App_Title, msg: "Please Select Region")
            boolVal = false
        }else if txtLanguage.text?.trimmingCharacters(in: .whitespaces).isEmpty == true {
            showAlert(title: App_Title, msg: "Please Select Language")
            boolVal = false
        }
        return boolVal
    }
    
    //MARK: - Make API Call
    func updateUserData(){
        startAnimating(Loadersize, message: "", type: NVActivityIndicatorType.ballSpinFadeLoader)
        let param : NSMutableDictionary =  NSMutableDictionary()
        param.setValue(txtCountry.text!, forKey: "userRegion")
        param.setValue(txtLanguage.text!, forKey: "userRegion")
        
        let successed = {(responseObject: AnyObject) -> Void in
            self.stopAnimating()
            if responseObject != nil {
                let dataObj : JSON = JSON.init(responseObject)
                if(dataObj["status"].stringValue == "1") {
                    Defaults.setValue(self.txtLanguage.text!, forKey: "user_lang")
                    Defaults.setValue(self.txtCountry.text!, forKey: "user_region")
                    Defaults.synchronize()
                    
                    if self.txtLanguage.text?.lowercased() == "arabic" {
                        LocalizationSystem.sharedLocal().setLanguage("ar")
                    } else if self.txtLanguage.text?.lowercased() == "english" {
                        LocalizationSystem.sharedLocal().setLanguage("en")
                    } else if self.txtLanguage.text?.lowercased() == "portuguese" {
                        LocalizationSystem.sharedLocal().setLanguage("pt")
                    } else if self.txtLanguage.text?.lowercased() == "spanish" {
                        LocalizationSystem.sharedLocal().setLanguage("es")
                    }
                    UIView.appearance().semanticContentAttribute = .forceLeftToRight
                    //self.view.semanticContentAttribute = .forceLeftToRight
                    
                    /*let alert = UIAlertController.init(title: App_Title, message: "Do you want to exit the app to reflect new language?", preferredStyle: .alert)
                    let okAction = UIAlertAction.init(title: "Yes", style: .default) { action in
                        exit(0)
                    }
                    let noAction = UIAlertAction.init(title: "No", style: .default) { action in
                    }
                    alert.addAction(okAction)
                    alert.addAction(noAction)
                    self.present(alert, animated: true, completion: nil)*/
                    
                    DispatchQueue.main.async(execute: {
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        //let sb = UIStoryboard.init(name: "Main", bundle: nil)
                        //appDelegate.window!.rootViewController = sb.instantiateInitialViewController()
                        let vc = appDelegate.window!.rootViewController
                        vc?.view.setNeedsDisplay()
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "ReloadViewController"), object: nil)
                        self.setLocalUI()
                        //self.navigationController?.popViewController(animated: true)
                        
                        //let tabVC = sb.instantiateViewController(withIdentifier: "TabViewController") as! TabViewController
                        //let navigationController = UINavigationController(rootViewController: tabVC)
                        //navigationController.navigationBar.isHidden = true
                        //appDelegate.window!.rootViewController = navigationController
                        //appDelegate.window!.makeKeyAndVisible()
                    })
                    
                    
                } else {
                    self.showAlert(title: App_Title, msg: dataObj["message"].stringValue)
                }
            }
        }
        let failure = {(error: AnyObject) -> Void in
            self.stopAnimating()
            //self.showAlert(title: App_Title, msg: WrongMsg)
        }
        service.PostWithAlamofireHeader(Parameters: param as? [String : AnyObject], action: UPDATELANGUAGE as NSString, success: successed, failure: failure)
    }
    
    func changeDeviceLanguage() {
        if let uname: String = Defaults.value(forKey: "user_lang") as? String {
            if uname == "English" {
                
            }
        }
    }
    
}
