//
//  DealsViewController.swift
//  EasySteps
//
//  Created by Jigar on 16/10/21.
//

import UIKit
import NVActivityIndicatorView
import SwiftyJSON
import Kingfisher
import AVKit
import AVFoundation
import MediaPlayer
import AudioToolbox
import Lightbox

class DealsCell: UITableViewCell {
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblNew: UILabel!
    @IBOutlet var lblLeft: UILabel!
    @IBOutlet var lblTotalCoins: UILabel!
    @IBOutlet var imgBG: UIImageView!
    @IBOutlet var imgShadowBG: UIImageView!
}

class DealsViewController: UIViewController, NVActivityIndicatorViewable, AVPlayerViewControllerDelegate, LightboxControllerPageDelegate, LightboxControllerDismissalDelegate {

    @IBOutlet var tblDeals: UITableView!
    @IBOutlet var tblView: UIView!
    @IBOutlet var lblBalance: UILabel!
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var lblNoData: UILabel!
    @IBOutlet var lblAvailBal: UILabel!
    
    var dealData = [JSON]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = .current
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        self.lblDate.text = dateFormatter.string(from: Date())
        self.lblBalance.text = TotalCoinsGL
        self.getAllDeals()
        self.setLocalUI()
    }
    
    func setLocalUI() {
        self.lblAvailBal.text = LocalizationSystem.sharedLocal().localizedString(forKey: "Available.Balance", value: "")
        self.lblNoData.text = LocalizationSystem.sharedLocal().localizedString(forKey: "No.Deals.Found", value: "")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tblView.roundCorners(.topLeft, radius: 50)
    }

    func getAllDeals() {
        startAnimating(Loadersize, message: "", type: NVActivityIndicatorType.ballSpinFadeLoader)
        let param : NSMutableDictionary =  NSMutableDictionary()
        if let uid: String = Defaults.value(forKey: "user_id") as? String {
            param.setValue(uid, forKey: "user_id")
        }
        if let did: String = Defaults.value(forKey: "deviceId") as? String {
            param.setValue(did, forKey: "device_id")
        }
        let successed = {(responseObject: AnyObject) -> Void in
            self.stopAnimating()
            if responseObject != nil{
                let dataObj : JSON = JSON.init(responseObject)
                if(dataObj["status"].stringValue == "1") {
                    self.dealData = dataObj["data"].arrayValue
                    self.tblDeals.reloadData()
                    if self.dealData.count > 0 {
                        self.lblNoData.isHidden = true
                        self.tblView.isHidden = false
                    } else {
                        self.lblNoData.isHidden = false
                        self.tblView.isHidden = true
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
        service.PostWithAlamofireHeader(Parameters: param as? [String : AnyObject], action: GETALLDEALS as NSString, success: successed, failure: failure)
    }
    
    func playVideoFile(fileUrl: String) {
        if fileUrl != "" {
            let videoURL = URL(string: fileUrl)
            let player = AVPlayer(url: videoURL!)
            let playervc = AVPlayerViewController()
            playervc.delegate = self
            playervc.player = player
            self.present(playervc, animated: true) {
                playervc.player!.play()
            }
        }
    }
    
    //MARK: Show Full Size Image
    func showFullImage(imgUrl: String) {
        //Show image
        let images = [
            LightboxImage(imageURL: URL(string: imgUrl)!)
        ]
        
        // Create an instance of LightboxController.
        let controller = LightboxController(images: images)
        
        // Set delegates.
        controller.pageDelegate = self
        controller.dismissalDelegate = self
        controller.modalPresentationStyle = .fullScreen
        // Use dynamic background.
        controller.dynamicBackground = true
        
        // Present your controller.
        present(controller, animated: true, completion: nil)
    }
    
    func lightboxController(_ controller: LightboxController, didMoveToPage page: Int) {
        print(page)
    }
    func lightboxControllerWillDismiss(_ controller: LightboxController) {
        print("Dismiss")
    }
}

extension DealsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dealData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblDeals.dequeueReusableCell(withIdentifier: "DealsCell") as! DealsCell
        DispatchQueue.main.async {
            cell.imgBG.roundCorners(.allCorners, radius: 25)
            cell.imgShadowBG.roundCorners(.allCorners, radius: 25)
        }
        let dataObj = self.dealData[indexPath.row]
        cell.lblTitle.text = dataObj["DealTitle"].stringValue
        
        let img = dataObj["DealPicture"].stringValue
        if img != "" {
            let url = URL(string: IMAGEURL + img)
            DispatchQueue.main.async {
                cell.imgBG.kf.setImage(with: url)
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dataObj = self.dealData[indexPath.row]
        
        //"DealFileType" = 1-image, 2-video 3-url
        
        let fileType = dataObj["DealFileType"].stringValue
        if fileType == "1" {
            //Show Image
            self.showFullImage(imgUrl: dataObj["DealLink"].stringValue)
        } else if fileType == "2" {
            self.playVideoFile(fileUrl: dataObj["DealLink"].stringValue)
        } else {
            //Open Browser
            if let url = URL(string: dataObj["DealLink"].stringValue) {
                UIApplication.shared.open(url)
            }
        }
    }
}
