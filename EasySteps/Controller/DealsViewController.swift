//
//  DealsViewController.swift
//  EasySteps
//
//  Created by Jigar on 16/10/21.
//

import UIKit

class DealsCell: UITableViewCell {
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblNew: UILabel!
    @IBOutlet var lblLeft: UILabel!
    @IBOutlet var lblTotalCoins: UILabel!
    @IBOutlet var imgBG: UIImageView!
}

class DealsViewController: UIViewController {

    @IBOutlet var tblDeals: UITableView!
    @IBOutlet var tblView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tblView.roundCorners(.topLeft, radius: 50)
    }

}

extension DealsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblDeals.dequeueReusableCell(withIdentifier: "DealsCell") as! DealsCell
        cell.imgBG.roundCorners(.allCorners, radius: 25)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}
