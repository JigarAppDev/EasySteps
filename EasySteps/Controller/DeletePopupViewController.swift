//
//  DeletePopupViewController.swift
//  EasySteps
//
//  Created by Jigar on 17/10/21.
//

import UIKit

protocol DeleteAccountDelegate {
    func deleteClick()
}

class DeletePopupViewController: UIViewController {

    var delegate: DeleteAccountDelegate!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblText: UILabel!
    @IBOutlet var btnDelete: UIButton!
    @IBOutlet var btnCancel: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setLocalUI()
    }
    
    func setLocalUI() {
        self.lblTitle.text = LocalizationSystem.sharedLocal().localizedString(forKey: "Delete.Account", value: "")
        self.lblText.text = LocalizationSystem.sharedLocal().localizedString(forKey: "Delete.Account.Msg", value: "")
        self.btnCancel.setTitle(LocalizationSystem.sharedLocal().localizedString(forKey: "Cancel.and.go.back", value: ""), for: .normal)
        self.btnDelete.setTitle(LocalizationSystem.sharedLocal().localizedString(forKey: "Confirm.and.Delete", value: ""), for: .normal)
    }
    
    @IBAction func btnDeleteClick(sender: UIButton) {
        delegate.deleteClick()
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func btnCancelClick(sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
