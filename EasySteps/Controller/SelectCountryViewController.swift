//
//  SelectCountryViewController.swift
//  EasySteps
//
//  Created by Jigar on 30/12/21.
//

import UIKit

protocol CountryDelegate {
    func getSelectedCountry(name: String)
}

class SelectCountryViewController: UIViewController {

    @IBOutlet var lblTitle: UILabel!
    var isFrom = ""
    var selectedCountry = ""
    var delegate: CountryDelegate!
    
    @IBOutlet var lblUSA: UILabel!
    @IBOutlet var lblUK: UILabel!
    @IBOutlet var lblBrazil: UILabel!
    @IBOutlet var lblArgentina: UILabel!
    @IBOutlet var lblUAE: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if isFrom == "Region" {
            self.lblTitle.text = "Select Region"
        } else {
            self.lblTitle.text = "Select Country"
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setLocalUI()
    }
    
    func setLocalUI() {
        self.lblTitle.text = LocalizationSystem.sharedLocal().localizedString(forKey: "Select.Region", value: "")
        self.lblUSA.text = LocalizationSystem.sharedLocal().localizedString(forKey: "USA", value: "")
        self.lblUK.text = LocalizationSystem.sharedLocal().localizedString(forKey: "UK", value: "")
        self.lblBrazil.text = LocalizationSystem.sharedLocal().localizedString(forKey: "Brazil", value: "")
        self.lblArgentina.text = LocalizationSystem.sharedLocal().localizedString(forKey: "Argentina", value: "")
        self.lblUAE.text = LocalizationSystem.sharedLocal().localizedString(forKey: "UAE", value: "")
    }
    
    @IBAction func selectCountry(sender: UIButton) {
        if sender.tag == 101 {
            self.selectedCountry = "USA"
        } else if sender.tag == 102 {
            self.selectedCountry = "UK"
        } else if sender.tag == 103 {
            self.selectedCountry = "Brazil"
        } else if sender.tag == 104 {
            self.selectedCountry = "Argentina"
        } else if sender.tag == 105 {
            self.selectedCountry = "United Arab Emirates"
        }
        self.delegate.getSelectedCountry(name: self.selectedCountry)
        self.dismiss(animated: true, completion: nil)
    }

}
