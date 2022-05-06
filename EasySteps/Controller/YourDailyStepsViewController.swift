//
//  YourDailyStepsViewController.swift
//  EasySteps
//
//  Created by Jigar on 16/10/21.
//

import UIKit
import NVActivityIndicatorView
import SwiftyJSON

class DailyStepsCell: UITableViewCell {
    @IBOutlet var lblTotalSteps: UILabel!
    @IBOutlet var lblTotalKm: UILabel!
    @IBOutlet var lblTotalCoins: UILabel!
    @IBOutlet var lblDate: UILabel!
}

class YourDailyStepsViewController: UIViewController, NVActivityIndicatorViewable {

    @IBOutlet var tblSteps: UITableView!
    @IBOutlet var lblNoData: UILabel!
    @IBOutlet var lblTitle: UILabel!
    
    var stepsData = [JSON]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.getAllDailySteps()
        
        self.setLocalUI()
    }
    
    func setLocalUI() {
        self.lblTitle.text = LocalizationSystem.sharedLocal().localizedString(forKey: "Your.daily.steps", value: "")
        self.lblNoData.text = LocalizationSystem.sharedLocal().localizedString(forKey: "No.Steps.History", value: "")
    }
    
    func getAllDailySteps() {
        startAnimating(Loadersize, message: "", type: NVActivityIndicatorType.ballSpinFadeLoader)
        let param : NSMutableDictionary =  NSMutableDictionary()
        let successed = {(responseObject: AnyObject) -> Void in
            self.stopAnimating()
            if responseObject != nil{
                let dataObj : JSON = JSON.init(responseObject)
                if(dataObj["status"].stringValue == "1") {
                    self.stepsData = dataObj["data"].arrayValue
                    self.tblSteps.reloadData()
                    if self.stepsData.count > 0 {
                        self.lblNoData.isHidden = true
                        self.tblSteps.isHidden = false
                    } else {
                        self.lblNoData.isHidden = false
                        self.tblSteps.isHidden = true
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
        service.PostWithAlamofireHeader(Parameters: param as? [String : AnyObject], action: GETDAILYSTEPS as NSString, success: successed, failure: failure)
    }

    func df2so(val: Double) -> String{
        let numberFormatter = NumberFormatter()
        numberFormatter.groupingSeparator = " "
        numberFormatter.groupingSize = 3
        numberFormatter.usesGroupingSeparator = true
        //numberFormatter.decimalSeparator = "."
        //numberFormatter.numberStyle = .decimal
        //numberFormatter.maximumFractionDigits = 2
        return numberFormatter.string(from: val as NSNumber)!
    }
}

extension YourDailyStepsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.stepsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblSteps.dequeueReusableCell(withIdentifier: "DailyStepsCell") as! DailyStepsCell
        let path = UIBezierPath(roundedRect: cell.lblDate.bounds, byRoundingCorners: [.topLeft, .bottomLeft], cornerRadii: CGSize(width: 15, height: 15))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        cell.lblDate.layer.mask = mask
        
        let objStep = self.stepsData[indexPath.row]
        let dt = objStep["FormatStepsDate"].stringValue
        let mon = objStep["FormatStepsMonth"].stringValue
        let yr = objStep["FormatStepsYear"].stringValue
        
        let attrStri = NSMutableAttributedString.init(string:"\(dt)\n\(mon)\n\(yr)")
        let nsRange = NSString(string: "\(dt)\n\(mon)\n\(yr)").range(of: "\(mon)\n\(yr)", options: String.CompareOptions.caseInsensitive)
        attrStri.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.white, NSAttributedString.Key.font: UIFont.init(name: "Open Sans Regular", size: 13.0) as Any], range: nsRange)
        cell.lblDate.numberOfLines = 3
        cell.lblDate.attributedText = attrStri
        
        cell.lblTotalKm.text = objStep["StepsKm"].stringValue + " \(LocalizationSystem.sharedLocal().localizedString(forKey: "km", value: "") ?? "km")"
        cell.lblTotalCoins.text = self.df2so(val: objStep["UserCoins"].doubleValue) + " \(LocalizationSystem.sharedLocal().localizedString(forKey: "Coins", value: "") ?? "Coins")"
        cell.lblTotalSteps.text = self.df2so(val: objStep["StepsCount"].doubleValue) + " \(LocalizationSystem.sharedLocal().localizedString(forKey: "Steps", value: "") ?? "Coins")"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
