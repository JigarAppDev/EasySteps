//
//  DeletePopupViewController.swift
//  EasySteps
//
//  Created by Jigar on 17/10/21.
//

import UIKit

class DeletePopupViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnDeleteClick(sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func btnCancelClick(sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
