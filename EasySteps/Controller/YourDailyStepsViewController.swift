//
//  YourDailyStepsViewController.swift
//  EasySteps
//
//  Created by Jigar on 16/10/21.
//

import UIKit

class DailyStepsCell: UITableViewCell {
    @IBOutlet var lblTotalSteps: UILabel!
    @IBOutlet var lblTotalKm: UILabel!
    @IBOutlet var lblTotalCoins: UILabel!
    @IBOutlet var lblDate: UILabel!
}

class YourDailyStepsViewController: UIViewController {

    @IBOutlet var tblSteps: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}

extension YourDailyStepsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblSteps.dequeueReusableCell(withIdentifier: "DailyStepsCell") as! DailyStepsCell
        let path = UIBezierPath(roundedRect: cell.lblDate.bounds, byRoundingCorners: [.topLeft, .bottomLeft], cornerRadii: CGSize(width: 15, height: 15))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        cell.lblDate.layer.mask = mask
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
