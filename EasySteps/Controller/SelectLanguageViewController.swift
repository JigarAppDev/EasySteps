//
//  SelectLanguageViewController.swift
//  EasySteps
//
//  Created by Jigar on 30/12/21.
//

import UIKit

protocol LanguageDelegate {
    func getSelectedLanguage(name: String)
}

class SelectLanguageViewController: UIViewController {

    var selectedLanguage = ""
    var delegate: LanguageDelegate!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblEnglish: UILabel!
    @IBOutlet var lblArabic: UILabel!
    @IBOutlet var lblPortu: UILabel!
    @IBOutlet var lblSpanish: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setLocalUI()
    }
    
    func setLocalUI() {
        self.lblTitle.text = LocalizationSystem.sharedLocal().localizedString(forKey: "Select.Language", value: "")
        self.lblEnglish.text = LocalizationSystem.sharedLocal().localizedString(forKey: "English", value: "")
        self.lblArabic.text = LocalizationSystem.sharedLocal().localizedString(forKey: "Arabic", value: "")
        self.lblPortu.text = LocalizationSystem.sharedLocal().localizedString(forKey: "Portuguese", value: "")
        self.lblSpanish.text = LocalizationSystem.sharedLocal().localizedString(forKey: "Spanish", value: "")
    }

    @IBAction func selectLanguage(sender: UIButton) {
        if sender.tag == 101 {
            self.selectedLanguage = "English"
        } else if sender.tag == 102 {
            self.selectedLanguage = "Arabic"
        } else if sender.tag == 103 {
            self.selectedLanguage = "Portuguese"
        } else if sender.tag == 104 {
            self.selectedLanguage = "Spanish"
        }
        self.delegate.getSelectedLanguage(name: self.selectedLanguage)
        self.dismiss(animated: true, completion: nil)
    }
}
