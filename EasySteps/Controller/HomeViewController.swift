//
//  HomeViewController.swift
//  EasySteps
//
//  Created by Jigar on 16/10/21.
//

import UIKit
import SwiftUI
import CoreMotion
import NVActivityIndicatorView
import SwiftyJSON
import HealthKit

class HomeRewardCell: UICollectionViewCell {
    @IBOutlet var iconView: UIView!
    @IBOutlet var imgIcon: UIImageView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblPoints: UILabel!
    @IBOutlet var lblSteps: UILabel!
}

class HomeViewController: UIViewController, NVActivityIndicatorViewable {

    @IBOutlet var rewardCollectionView: UICollectionView!
    @IBOutlet weak var gradientCircularProgressBar: GradientCircularProgressBar!
    
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var lblSteps: UILabel!
    @IBOutlet weak var lblTodayCoin: UILabel!
    @IBOutlet weak var lblTotalCoin: UILabel!

    let activityManager = CMMotionActivityManager()
    let pedoMeter = CMPedometer()
    let healthStore = HKHealthStore()
    var selectedIndex = -1
    var totalSteps = 20000
    var currSteps = 0
    var currCoin = 0
    var timer = Timer()
    let notificationCenter = NotificationCenter.default
    var rewardData = [JSON]()
    var isInviteFriend = false
    var isSaveAPICalling = false
    
    //Pulse - Reward View
    @IBOutlet var iconView1: UIView!
    @IBOutlet var imgIcon1: UIImageView!
    @IBOutlet var lblTitle1: UILabel!
    @IBOutlet var lblCoin1: UILabel!
    @IBOutlet var lblPoints1: UILabel!
    @IBOutlet var lblSteps1: UILabel!
    @IBOutlet var btn1: UIButton!
    
    @IBOutlet var iconView2: UIView!
    @IBOutlet var imgIcon2: UIImageView!
    @IBOutlet var lblTitle2: UILabel!
    @IBOutlet var lblCoin2: UILabel!
    @IBOutlet var lblPoints2: UILabel!
    @IBOutlet var lblSteps2: UILabel!
    @IBOutlet var btn2: UIButton!
    
    @IBOutlet var iconView3: UIView!
    @IBOutlet var imgIcon3: UIImageView!
    @IBOutlet var lblTitle3: UILabel!
    @IBOutlet var lblCoin3: UILabel!
    @IBOutlet var lblPoints3: UILabel!
    @IBOutlet var lblSteps3: UILabel!
    @IBOutlet var btn3: UIButton!
    
    @IBOutlet var iconView4: UIView!
    @IBOutlet var imgIcon4: UIImageView!
    @IBOutlet var lblTitle4: UILabel!
    @IBOutlet var lblCoin4: UILabel!
    @IBOutlet var lblPoints4: UILabel!
    @IBOutlet var lblSteps4: UILabel!
    @IBOutlet var btn4: UIButton!
    
    @IBOutlet var iconView5: UIView!
    @IBOutlet var imgIcon5: UIImageView!
    @IBOutlet var lblTitle5: UILabel!
    @IBOutlet var lblCoin5: UILabel!
    @IBOutlet var lblPoints5: UILabel!
    @IBOutlet var lblSteps5: UILabel!
    @IBOutlet var btn5: UIButton!
    
    @IBOutlet var iconView6: UIView!
    @IBOutlet var imgIcon6: UIImageView!
    @IBOutlet var lblTitle6: UILabel!
    @IBOutlet var lblCoin6: UILabel!
    @IBOutlet var lblPoints6: UILabel!
    @IBOutlet var lblSteps6: UILabel!
    @IBOutlet var btn6: UIButton!
    
    @IBOutlet var iconView7: UIView!
    @IBOutlet var imgIcon7: UIImageView!
    @IBOutlet var lblTitle7: UILabel!
    @IBOutlet var lblCoin7: UILabel!
    @IBOutlet var lblPoints7: UILabel!
    @IBOutlet var lblSteps7: UILabel!
    @IBOutlet var btn7: UIButton!
    
    @IBOutlet var lblStepsTxt: UILabel!
    @IBOutlet var lblDistTxt: UILabel!
    @IBOutlet var lblTodayTxt: UILabel!
    @IBOutlet var lblBalTxt: UILabel!
    @IBOutlet var lblKmTxt: UILabel!
    @IBOutlet var lblCoins1Txt: UILabel!
    @IBOutlet var lblCoins2Txt: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        gradientCircularProgressBar.progress = 0.0 //0.36 -> 50%
        
        self.timer = Timer.scheduledTimer(timeInterval: 30.0, target: self, selector: #selector(self.updateSteps), userInfo: nil, repeats: true)
            
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.resetMyCoinsSteps), name: NSNotification.Name("ResetSteps"), object: nil)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        UserDefaults.lastAccessDate = Date()
        self.getAllSteps()
        
        self.setLocalUI()
    }
    
    func setLocalUI() {
        self.lblStepsTxt.text = LocalizationSystem.sharedLocal().localizedString(forKey: "Steps", value: "")
        self.lblDistTxt.text = LocalizationSystem.sharedLocal().localizedString(forKey: "Distance", value: "")
        self.lblTodayTxt.text = LocalizationSystem.sharedLocal().localizedString(forKey: "Today", value: "")
        self.lblBalTxt.text = LocalizationSystem.sharedLocal().localizedString(forKey: "Balance", value: "")
        self.lblKmTxt.text = LocalizationSystem.sharedLocal().localizedString(forKey: "km", value: "")
        self.lblCoins1Txt.text = LocalizationSystem.sharedLocal().localizedString(forKey: "Coins", value: "")
        self.lblCoins2Txt.text = LocalizationSystem.sharedLocal().localizedString(forKey: "Coins", value: "")
        self.lblTitle1.text = LocalizationSystem.sharedLocal().localizedString(forKey: "Daily.Reward", value: "")
        self.lblTitle2.text = LocalizationSystem.sharedLocal().localizedString(forKey: "Invite.Friends", value: "")
        self.lblTitle3.text = LocalizationSystem.sharedLocal().localizedString(forKey: "Coins", value: "")
        self.lblTitle4.text = LocalizationSystem.sharedLocal().localizedString(forKey: "Coins", value: "")
        self.lblTitle5.text = LocalizationSystem.sharedLocal().localizedString(forKey: "Coins", value: "")
        self.lblTitle6.text = LocalizationSystem.sharedLocal().localizedString(forKey: "Coins", value: "")
        self.lblTitle7.text = LocalizationSystem.sharedLocal().localizedString(forKey: "Coins", value: "")
    }
    
    @objc func updateSteps() {
        self.checkHealthKitPermission()
    }
    
    @objc func appMovedToBackground() {
        DispatchQueue.global(qos: .background).async {
            if self.isSaveAPICalling == false {
                self.saveAllSteps()
            }
        }
    }
    
    func loadAllViews() {
        self.lblPoints1.text = "4"
        self.imgIcon1.image = #imageLiteral(resourceName: "ic_play").withRenderingMode(.alwaysTemplate)
        self.lblSteps1.text = ""
        self.iconView1.backgroundColor = #colorLiteral(red: 0.2059197426, green: 0.4806417823, blue: 0.6017761827, alpha: 1)
        self.imgIcon1.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.lblSteps1.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        if self.rewardData.count == 0 { return }
        if self.rewardData[0]["is_performed"].stringValue == "0" {
            self.lblTitle1.textColor = #colorLiteral(red: 0.07843137255, green: 0.2352941176, blue: 0.3333333333, alpha: 1)
            self.lblCoin1.textColor = #colorLiteral(red: 0.07843137255, green: 0.2352941176, blue: 0.3333333333, alpha: 1)
            //Cell Animation
            self.stopAnimation(viewName: iconView1)
            self.beginAnimation(viewName: iconView1)
        } else {
            self.imgIcon1.tintColor = #colorLiteral(red: 0.2059197426, green: 0.4806417823, blue: 0.6017761827, alpha: 1)
            self.iconView1.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.lblTitle1.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            self.lblCoin1.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            self.stopAnimation(viewName: iconView1)
        }
        
        self.lblPoints2.text = "12"
        self.imgIcon2.image = #imageLiteral(resourceName: "exp_Invite Friends").withRenderingMode(.alwaysTemplate)
        self.lblSteps2.text = ""
        self.iconView2.backgroundColor = #colorLiteral(red: 0.1311548948, green: 0.561168611, blue: 0.7693722844, alpha: 1)
        self.imgIcon2.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.lblSteps2.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        if self.isInviteFriend == false {
            self.lblTitle2.textColor = #colorLiteral(red: 0.07843137255, green: 0.2352941176, blue: 0.3333333333, alpha: 1)
            self.lblCoin2.textColor = #colorLiteral(red: 0.07843137255, green: 0.2352941176, blue: 0.3333333333, alpha: 1)
            //Cell Animation
            self.stopAnimation(viewName: iconView2)
            self.beginAnimation(viewName: iconView2)
        } else {
            self.imgIcon2.tintColor = #colorLiteral(red: 0.1294117647, green: 0.5607843137, blue: 0.768627451, alpha: 1)
            self.iconView2.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.lblTitle2.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            self.lblCoin2.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            self.stopAnimation(viewName: iconView2)
        }
        
        self.lblPoints3.text = "1"
        self.imgIcon3.image = #imageLiteral(resourceName: "exp_Shoes").withRenderingMode(.alwaysTemplate)
        self.lblSteps3.text = "1 000"
        self.iconView3.backgroundColor = #colorLiteral(red: 0.1476515234, green: 0.5281654596, blue: 0.6371568441, alpha: 1)
        self.imgIcon3.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.lblSteps3.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        if self.rewardData[2]["is_performed"].stringValue == "0" && self.currSteps >= 1000 {
            self.lblTitle3.textColor = #colorLiteral(red: 0.07843137255, green: 0.2352941176, blue: 0.3333333333, alpha: 1)
            self.lblCoin3.textColor = #colorLiteral(red: 0.07843137255, green: 0.2352941176, blue: 0.3333333333, alpha: 1)
            //Cell Animation
            self.stopAnimation(viewName: iconView3)
            self.beginAnimation(viewName: iconView3)
        } else {
            self.imgIcon3.tintColor = #colorLiteral(red: 0.1476515234, green: 0.5281654596, blue: 0.6371568441, alpha: 1)
            self.iconView3.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.lblSteps3.textColor = #colorLiteral(red: 0.1476515234, green: 0.5281654596, blue: 0.6371568441, alpha: 1)
            self.lblTitle3.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            self.lblCoin3.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            self.stopAnimation(viewName: iconView3)
        }
        
        self.lblPoints4.text = "3"
        self.imgIcon4.image = #imageLiteral(resourceName: "exp_Shoes").withRenderingMode(.alwaysTemplate)
        self.lblSteps4.text = "3 000"
        self.iconView4.backgroundColor = #colorLiteral(red: 0.01099429373, green: 0.1628586352, blue: 0.25848037, alpha: 1)
        self.imgIcon4.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.lblSteps4.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        if self.rewardData[3]["is_performed"].stringValue == "0" && self.currSteps >= 3000 {
            self.lblTitle4.textColor = #colorLiteral(red: 0.07843137255, green: 0.2352941176, blue: 0.3333333333, alpha: 1)
            self.lblCoin4.textColor = #colorLiteral(red: 0.07843137255, green: 0.2352941176, blue: 0.3333333333, alpha: 1)
            //Cell Animation
            self.stopAnimation(viewName: iconView4)
            self.beginAnimation(viewName: iconView4)
        } else {
            self.imgIcon4.tintColor = #colorLiteral(red: 0.01099429373, green: 0.1628586352, blue: 0.25848037, alpha: 1)
            self.iconView4.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.lblSteps4.textColor = #colorLiteral(red: 0.01099429373, green: 0.1628586352, blue: 0.25848037, alpha: 1)
            self.lblTitle4.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            self.lblCoin4.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            self.stopAnimation(viewName: iconView4)
        }
        
        self.lblPoints5.text = "4"
        self.imgIcon5.image = #imageLiteral(resourceName: "exp_Shoes").withRenderingMode(.alwaysTemplate)
        self.lblSteps5.text = "9 000"
        self.iconView5.backgroundColor = #colorLiteral(red: 0.4380103946, green: 0.5097800493, blue: 0.1806749403, alpha: 1)
        self.imgIcon5.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.lblSteps5.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        if self.rewardData[4]["is_performed"].stringValue == "0" && self.currSteps >= 9000 {
            self.lblTitle5.textColor = #colorLiteral(red: 0.07843137255, green: 0.2352941176, blue: 0.3333333333, alpha: 1)
            self.lblCoin5.textColor = #colorLiteral(red: 0.07843137255, green: 0.2352941176, blue: 0.3333333333, alpha: 1)
            //Cell Animation
            self.stopAnimation(viewName: iconView5)
            self.beginAnimation(viewName: iconView5)
        } else {
            self.imgIcon5.tintColor = #colorLiteral(red: 0.6259584427, green: 0.719085753, blue: 0.260977596, alpha: 1)
            self.iconView5.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.lblSteps5.textColor = #colorLiteral(red: 0.6259584427, green: 0.719085753, blue: 0.260977596, alpha: 1)
            self.lblTitle5.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            self.lblCoin5.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            self.stopAnimation(viewName: iconView5)
        }
        
        self.lblPoints6.text = "5"
        self.imgIcon6.image = #imageLiteral(resourceName: "exp_Shoes").withRenderingMode(.alwaysTemplate)
        self.lblSteps6.text = "14 000"
        self.iconView6.backgroundColor = #colorLiteral(red: 0.6259584427, green: 0.719085753, blue: 0.260977596, alpha: 1)
        self.imgIcon6.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.lblSteps6.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        if self.rewardData[5]["is_performed"].stringValue == "0" && self.currSteps >= 14000 {
            self.lblTitle6.textColor = #colorLiteral(red: 0.07843137255, green: 0.2352941176, blue: 0.3333333333, alpha: 1)
            self.lblCoin6.textColor = #colorLiteral(red: 0.07843137255, green: 0.2352941176, blue: 0.3333333333, alpha: 1)
            //Cell Animation
            self.stopAnimation(viewName: iconView6)
            self.beginAnimation(viewName: iconView6)
        } else {
            self.imgIcon6.tintColor = #colorLiteral(red: 0.6259584427, green: 0.719085753, blue: 0.260977596, alpha: 1)
            self.iconView6.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.lblSteps6.textColor = #colorLiteral(red: 0.6259584427, green: 0.719085753, blue: 0.260977596, alpha: 1)
            self.lblTitle6.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            self.lblCoin6.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            self.stopAnimation(viewName: iconView6)
        }
        
        self.lblPoints7.text = "10"
        self.imgIcon7.image = #imageLiteral(resourceName: "exp_Shoes").withRenderingMode(.alwaysTemplate)
        self.lblSteps7.text = "20 000"
        self.iconView7.backgroundColor = #colorLiteral(red: 0.6000000834, green: 0.6000000834, blue: 0.6000000834, alpha: 1)
        self.imgIcon7.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.lblSteps7.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        if self.rewardData[6]["is_performed"].stringValue == "0" && self.currSteps >= 20000 {
            self.lblTitle7.textColor = #colorLiteral(red: 0.07843137255, green: 0.2352941176, blue: 0.3333333333, alpha: 1)
            self.lblCoin7.textColor = #colorLiteral(red: 0.07843137255, green: 0.2352941176, blue: 0.3333333333, alpha: 1)
            //Cell Animation
            self.stopAnimation(viewName: iconView7)
            self.beginAnimation(viewName: iconView7)
        } else {
            self.imgIcon7.tintColor = #colorLiteral(red: 0.6000000834, green: 0.6000000834, blue: 0.6000000834, alpha: 1)
            self.iconView7.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.lblSteps7.textColor = #colorLiteral(red: 0.6000000834, green: 0.6000000834, blue: 0.6000000834, alpha: 1)
            self.lblTitle7.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            self.lblCoin7.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            self.stopAnimation(viewName: iconView7)
        }
    }
    
    @IBAction func btnRewardClick(sender: UIButton) {
        if sender == self.btn1 {
            let dataObj = self.rewardData[0]
            if self.rewardData[0]["is_performed"].stringValue == "0" {
                self.updateCoins(rid: dataObj["RewardedId"].stringValue, coin: dataObj["Coins"].stringValue)
                DispatchQueue.main.async {
                    self.iconView1.removeCurrentAnimations()
                    self.iconView1.transform = .identity
                    self.iconView1.layer.removeAllAnimations()
                }
            }
        } else if sender == self.btn2 {
            let dataObj = self.rewardData[1]
            if self.isInviteFriend == false {
                self.updateCoins(rid: dataObj["RewardedId"].stringValue, coin: dataObj["Coins"].stringValue)
                DispatchQueue.main.async {
                    self.iconView2.removeCurrentAnimations()
                    self.iconView2.transform = .identity
                    self.iconView2.layer.removeAllAnimations()
                }
            }
        } else if sender == self.btn3 {
            let dataObj = self.rewardData[2]
            if self.rewardData[2]["is_performed"].stringValue == "0" && self.currSteps >= 1000 {
                self.updateCoins(rid: dataObj["RewardedId"].stringValue, coin: dataObj["Coins"].stringValue)
                DispatchQueue.main.async {
                    self.iconView3.removeCurrentAnimations()
                    self.iconView3.transform = .identity
                    self.iconView3.layer.removeAllAnimations()
                }
            }
        } else if sender == self.btn4 {
            let dataObj = self.rewardData[3]
            if self.rewardData[3]["is_performed"].stringValue == "0" && self.currSteps >= 3000 {
                self.updateCoins(rid: dataObj["RewardedId"].stringValue, coin: dataObj["Coins"].stringValue)
                DispatchQueue.main.async {
                    self.iconView4.removeCurrentAnimations()
                    self.iconView4.transform = .identity
                    self.iconView4.layer.removeAllAnimations()
                }
            }
        } else if sender == self.btn5 {
            let dataObj = self.rewardData[4]
            if self.rewardData[4]["is_performed"].stringValue == "0" && self.currSteps >= 9000 {
                self.updateCoins(rid: dataObj["RewardedId"].stringValue, coin: dataObj["Coins"].stringValue)
                DispatchQueue.main.async {
                    self.iconView5.removeCurrentAnimations()
                    self.iconView5.transform = .identity
                    self.iconView5.layer.removeAllAnimations()
                }
            }
        } else if sender == self.btn6 {
            let dataObj = self.rewardData[5]
            if self.rewardData[5]["is_performed"].stringValue == "0" && self.currSteps >= 14000 {
                self.updateCoins(rid: dataObj["RewardedId"].stringValue, coin: dataObj["Coins"].stringValue)
                DispatchQueue.main.async {
                    self.iconView6.removeCurrentAnimations()
                    self.iconView6.transform = .identity
                    self.iconView6.layer.removeAllAnimations()
                }
            }
        } else if sender == self.btn7 {
            let dataObj = self.rewardData[6]
            if self.rewardData[6]["is_performed"].stringValue == "0" && self.currSteps >= 20000 {
                self.updateCoins(rid: dataObj["RewardedId"].stringValue, coin: dataObj["Coins"].stringValue)
                DispatchQueue.main.async {
                    self.iconView7.removeCurrentAnimations()
                    self.iconView7.transform = .identity
                    self.iconView7.layer.removeAllAnimations()
                }
            }
        }
    }
    
    func checkHealthKitPermission() {
        let healthKitTypes: Set = [
            // access step count
            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!,
            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning)!
        ]
        healthStore.requestAuthorization(toShare: healthKitTypes, read: healthKitTypes) { (bool, error) in
            if let e = error {
                print("Something went wrong during authorisation \(e.localizedDescription)")
            } else {
                print("User has completed the authorization flow")
                self.getTodaysSteps(completion: { (step)  in
                    DispatchQueue.main.async {
                        self.currSteps = Int(step)
                        if self.currSteps <= self.totalSteps {
                            self.setProgressBar(currSteps: step)
                            self.lblSteps.text = self.df2so(val: step)
                            self.loadAllViews()
                            if self.isSaveAPICalling == false {
                                self.saveAllSteps()
                            }
                        }
                    }
                })
                
                self.getTodayMiles(completion: { (mile)  in
                    DispatchQueue.main.async {
                        self.lblDistance.text = String(format: "%.1f", (mile * 1.609344))
                    }
                })
            }
        }
        
        if HKHealthStore.isHealthDataAvailable() {
            let authorizationStatus = healthStore.authorizationStatus(for: .workoutType())
            
            if authorizationStatus == .notDetermined {
                //
                
            } else if authorizationStatus == .sharingDenied {
                self.showAlert(title: App_Title, msg: "EasySteps doesn't have access to your workout data. You can enable access in the Settings application.")
            }
            
        } else {
            self.showAlert(title: App_Title, msg: "EasySteps doesn't have access to your workout data. You can enable access in the Settings application.")
        }
    }
    
    func getTodaysSteps(completion: @escaping (Double) -> Void) {
        let stepsQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(
            withStart: startOfDay,
            end: now,
            options: .strictStartDate
        )
        
        let query = HKStatisticsQuery(
            quantityType: stepsQuantityType,
            quantitySamplePredicate: predicate,
            options: .cumulativeSum
        ) { _, result, _ in
            guard let result = result, let sum = result.sumQuantity() else {
                completion(0.0)
                return
            }
            completion(sum.doubleValue(for: HKUnit.count()))
        }
        
        healthStore.execute(query)
    }
    
    func getTodayMiles(completion: @escaping (Double) -> Void) {
        let stepsQuantityType = HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!
        
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(
            withStart: startOfDay,
            end: now,
            options: .strictStartDate
        )
        
        let query = HKStatisticsQuery(
            quantityType: stepsQuantityType,
            quantitySamplePredicate: predicate,
            options: .cumulativeSum
        ) { _, result, _ in
            guard let result = result, let sum = result.sumQuantity() else {
                completion(0.0)
                return
            }
            completion(sum.doubleValue(for: HKUnit.mile()))
        }
        
        healthStore.execute(query)
    }
    
    func getAllSteps() {
        startAnimating(Loadersize, message: "", type: NVActivityIndicatorType.ballSpinFadeLoader)
        let param : NSMutableDictionary =  NSMutableDictionary()
        let successed = {(responseObject: AnyObject) -> Void in
            self.stopAnimating()
            if responseObject != nil{
                let dataObj : JSON = JSON.init(responseObject)
                if(dataObj["status"].stringValue == "1") {
                    self.isInviteFriend = dataObj["addedornot"].boolValue
                    let stepsData = dataObj["data"].dictionaryValue
                    self.lblSteps.text = self.df2so(val: stepsData["StepsCount"]?.doubleValue ?? 0.0)
                    self.lblDistance.text = String(format: "%.1f", stepsData["StepsKm"]?.doubleValue ?? 0.0)
                    self.lblTodayCoin.text = self.df2so(val: stepsData["TodayUserCoins"]?.doubleValue ?? 0.0)
                    self.currCoin = stepsData["TodayUserCoins"]?.intValue ?? 0
                    self.lblTotalCoin.text = self.df2so(val: stepsData["UserCoins"]?.doubleValue ?? 0.0)
                    TotalCoinsGL = stepsData["UserCoins"]?.stringValue ?? "0"
                    self.rewardData = stepsData["RewardedData"]!.arrayValue
                    self.checkHealthKitPermission()
                }else{
                    self.showAlert(title: App_Title, msg: responseObject.value(forKeyPath: "message") as! String)
                }
            }
        }
        let failure = {(error: AnyObject) -> Void in
            self.stopAnimating()
            //self.showAlert(title: App_Title, msg: WrongMsg)
        }
        service.PostWithAlamofireHeader(Parameters: param as? [String : AnyObject], action: GETMYSTEPS as NSString, success: successed, failure: failure)
    }
    
    func saveAllSteps() {
        //startAnimating(Loadersize, message: "", type: NVActivityIndicatorType.ballSpinFadeLoader)
        if self.isSaveAPICalling == true { return }
        
        self.isSaveAPICalling = true
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = .current
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        
        let param : NSMutableDictionary =  NSMutableDictionary()
        param.setValue(self.lblSteps.text?.replacingOccurrences(of: " ", with: ""), forKey: "StepsCount")
        param.setValue(self.lblDistance.text, forKey: "StepsKm")
        param.setValue(dateFormatter.string(from: Date()), forKey: "StepsDate")
        param.setValue("0", forKey: "UserCoins")
        
        lastSteps = UserDefaults.standard.value(forKey: "lastSteps") as? Int ?? 0
        var cntCurr = 0
        if currSteps >= 1000 {
            cntCurr = Int("\(currSteps)".dropLast(3))!
        }
        var cntLast = 0
        if lastSteps >= 1000 {
            cntLast = Int("\(lastSteps)".dropLast(3))!
        }
        if currSteps > lastSteps {
            let newSteps = currSteps - lastSteps
            if newSteps >= 1000 {
                let cnt = "\(newSteps)".dropLast(3)
                param.setValue("\(cnt)", forKey: "UserCoins")
            } else if cntCurr > cntLast {
                param.setValue("\(cntCurr - cntLast)", forKey: "UserCoins")
            } else {
                param.setValue("0", forKey: "UserCoins")
            }
        }
        
        /*if currSteps > lastSteps {
            if currSteps >= 1000 {
                let cnt = "\(currSteps)".dropLast(3)
                if Int(cnt)! > self.currCoin {
                    param.setValue("\(cnt)", forKey: "UserCoins")
                } else {
                    param.setValue("0", forKey: "UserCoins")
                }
            }
        }*/
        
        /* //OLD LOGIC
        let newSteps = currSteps - lastSteps
        if newSteps >= 1000 {
            let cnt = "\(newSteps)".dropLast(3)
            param.setValue("\(cnt)", forKey: "UserCoins")
        } else {
            param.setValue("0", forKey: "UserCoins")
        }*/
        
        let successed = { [self](responseObject: AnyObject) -> Void in
            self.stopAnimating()
            if responseObject != nil{
                let dataObj : JSON = JSON.init(responseObject)
                if(dataObj["status"].stringValue == "1") {
                    
                    if currSteps > lastSteps {
                        let newSteps = currSteps - lastSteps
                        if newSteps >= 1000 {
                            //Reset Steps
                            lastSteps = self.currSteps
                            UserDefaults.standard.set(self.currSteps, forKey: "lastSteps")
                            UserDefaults.standard.synchronize()
                            self.getAllSteps()
                        } else if cntCurr > cntLast {
                            //Reset Steps
                            lastSteps = self.currSteps
                            UserDefaults.standard.set(self.currSteps, forKey: "lastSteps")
                            UserDefaults.standard.synchronize()
                            self.getAllSteps()
                        }
                    }
                    
                    /*if self.currSteps > lastSteps {
                        if self.currSteps >= 1000 {
                            let cnt = "\(self.currSteps)".dropLast(3)
                            if Int(cnt)! > self.currCoin {
                                //Reset Steps
                                lastSteps = self.currSteps
                                self.currCoin = Int(cnt)!
                                UserDefaults.standard.set(lastSteps, forKey: "lastSteps")
                                self.getAllSteps()
                            }
                        }
                    }*/
                    
                    /*if newSteps >= 1000 {
                        //Reset Steps
                        lastSteps = self.currSteps
                        UserDefaults.standard.set(lastSteps, forKey: "lastSteps")
                        self.getAllSteps()
                    }*/
                    self.isSaveAPICalling = false
                    
                }else{
                    self.showAlert(title: App_Title, msg: responseObject.value(forKeyPath: "message") as! String)
                }
            }
        }
        let failure = {(error: AnyObject) -> Void in
            self.stopAnimating()
            //self.showAlert(title: App_Title, msg: WrongMsg)
        }
        service.PostWithAlamofireHeader(Parameters: param as? [String : AnyObject], action: ADDSTEPS as NSString, success: successed, failure: failure)
    }
    
    func updateCoins(rid: String, coin: String) {
        startAnimating(Loadersize, message: "", type: NVActivityIndicatorType.ballSpinFadeLoader)
        
        let param : NSMutableDictionary =  NSMutableDictionary()
        param.setValue(rid, forKey: "RewardedId")
        param.setValue(coin, forKey: "RewardedCoins")
        
        let successed = {(responseObject: AnyObject) -> Void in
            self.stopAnimating()
            if responseObject != nil{
                let dataObj : JSON = JSON.init(responseObject)
                if(dataObj["status"].stringValue == "1") {
                    self.getAllSteps()
                }else{
                    self.showAlert(title: App_Title, msg: responseObject.value(forKeyPath: "message") as! String)
                }
            }
        }
        let failure = {(error: AnyObject) -> Void in
            self.stopAnimating()
            //self.showAlert(title: App_Title, msg: WrongMsg)
        }
        service.PostWithAlamofireHeader(Parameters: param as? [String : AnyObject], action: UPDATEREWARDS as NSString, success: successed, failure: failure)
    }
    
    @objc func resetMyCoinsSteps() {
        let param : NSMutableDictionary =  NSMutableDictionary()
        let successed = { [self](responseObject: AnyObject) -> Void in
            self.stopAnimating()
            if responseObject != nil{
                let dataObj : JSON = JSON.init(responseObject)
                if(dataObj["status"].stringValue == "1") {
                    // Reset done
                    print("Reset done!")
                }else{
                    self.showAlert(title: App_Title, msg: responseObject.value(forKeyPath: "message") as! String)
                }
            }
        }
        let failure = {(error: AnyObject) -> Void in
            self.stopAnimating()
            //self.showAlert(title: App_Title, msg: WrongMsg)
        }
        service.PostWithAlamofireHeader(Parameters: param as? [String : AnyObject], action: UPDATEMYSTEPS as NSString, success: successed, failure: failure)
    }
    
    func setProgressBar(currSteps: Double) {
        //0.72 -> 100%
        //10000 -> 100%
        
        let newSteps = currSteps * 0.72
        let finalProgress = newSteps / Double(totalSteps)
        gradientCircularProgressBar.progress = CGFloat(finalProgress)
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
    
    func beginAnimation(viewName: UIView) {
        UIView.animate(withDuration: 1.0, delay:0, options: [.repeat, .autoreverse], animations: {
            //UIView.setAnimationRepeatCount(3)
            viewName.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }, completion: {completion in
            //self.uiViewToPulsate.transform = CGAffineTransform(scaleX: 1, y: 1)
        })
    }
    
    func stopAnimation(viewName: UIView) {
        UIView.animate(withDuration: 0, delay:0, options: [.autoreverse], animations: {
            viewName.transform = CGAffineTransform(scaleX: 1, y: 1)
            
        }, completion: {completion in
            //nil
        })
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.rewardData.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.rewardCollectionView.dequeueReusableCell(withReuseIdentifier: "HomeRewardCell", for: indexPath) as! HomeRewardCell
        
        let dataObj = self.rewardData[indexPath.row]
        
        cell.imgIcon.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        cell.lblSteps.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        if indexPath.row == 0 {
            cell.lblPoints.text = "4"
            cell.imgIcon.image = #imageLiteral(resourceName: "ic_play").withRenderingMode(.alwaysTemplate)
            cell.lblTitle.text = "Daily Reward"
            cell.lblSteps.text = ""
            cell.iconView.backgroundColor = #colorLiteral(red: 0.2059197426, green: 0.4806417823, blue: 0.6017761827, alpha: 1)
            if dataObj["is_performed"].stringValue == "0" {
                //Cell Animation
                DispatchQueue.main.async {
                    cell.iconView.pulse(nil)
                }
            } else {
                cell.imgIcon.tintColor = #colorLiteral(red: 0.2059197426, green: 0.4806417823, blue: 0.6017761827, alpha: 1)
                cell.iconView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                DispatchQueue.main.async {
                    cell.iconView.removeCurrentAnimations()
                }
            }
        } else if indexPath.row == 1 {
            cell.lblPoints.text = "12"
            cell.imgIcon.image = #imageLiteral(resourceName: "exp_Invite Friends").withRenderingMode(.alwaysTemplate)
            cell.lblTitle.text = "Invite Friends"
            cell.lblSteps.text = ""
            cell.iconView.backgroundColor = #colorLiteral(red: 0.1311548948, green: 0.561168611, blue: 0.7693722844, alpha: 1)
            if self.isInviteFriend == false {
                //Cell Animation
                DispatchQueue.main.async {
                    cell.iconView.pulse(nil)
                }
            } else {
                cell.imgIcon.tintColor = #colorLiteral(red: 0.1294117647, green: 0.5607843137, blue: 0.768627451, alpha: 1)
                cell.iconView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                DispatchQueue.main.async {
                    cell.iconView.removeCurrentAnimations()
                }
            }
        } else if indexPath.row == 2 {
            cell.lblPoints.text = "1"
            cell.imgIcon.image = #imageLiteral(resourceName: "exp_Shoes").withRenderingMode(.alwaysTemplate)
            cell.lblTitle.text = "Coins"
            cell.lblSteps.text = "1 000"
            cell.iconView.backgroundColor = #colorLiteral(red: 0.1476515234, green: 0.5281654596, blue: 0.6371568441, alpha: 1)
            if dataObj["is_performed"].stringValue == "0" && self.currSteps >= 1000 {
                //Cell Animation
                DispatchQueue.main.async {
                    cell.iconView.pulse(nil)
                }
            } else {
                cell.imgIcon.tintColor = #colorLiteral(red: 0.1476515234, green: 0.5281654596, blue: 0.6371568441, alpha: 1)
                cell.iconView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                cell.lblSteps.textColor = #colorLiteral(red: 0.1476515234, green: 0.5281654596, blue: 0.6371568441, alpha: 1)
                DispatchQueue.main.async {
                    cell.iconView.removeCurrentAnimations()
                }
            }
        } else if indexPath.row == 3 {
            cell.lblPoints.text = "3"
            cell.imgIcon.image = #imageLiteral(resourceName: "exp_Shoes").withRenderingMode(.alwaysTemplate)
            cell.lblTitle.text = "Coins"
            cell.lblSteps.text = "3 000"
            cell.iconView.backgroundColor = #colorLiteral(red: 0.01099429373, green: 0.1628586352, blue: 0.25848037, alpha: 1)
            if dataObj["is_performed"].stringValue == "0" && self.currSteps >= 3000 {
                //Cell Animation
                DispatchQueue.main.async {
                    cell.iconView.pulse(nil)
                }
            } else {
                cell.imgIcon.tintColor = #colorLiteral(red: 0.01099429373, green: 0.1628586352, blue: 0.25848037, alpha: 1)
                cell.iconView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                cell.lblSteps.textColor = #colorLiteral(red: 0.01099429373, green: 0.1628586352, blue: 0.25848037, alpha: 1)
                DispatchQueue.main.async {
                    cell.iconView.removeCurrentAnimations()
                }
            }
        } else if indexPath.row == 4 {
            cell.lblPoints.text = "4"
            cell.imgIcon.image = #imageLiteral(resourceName: "exp_Shoes").withRenderingMode(.alwaysTemplate)
            cell.lblTitle.text = "Coins"
            cell.lblSteps.text = "9 000"
            cell.iconView.backgroundColor = #colorLiteral(red: 0.4380103946, green: 0.5097800493, blue: 0.1806749403, alpha: 1)
            if dataObj["is_performed"].stringValue == "0" && self.currSteps >= 9000 {
                //Cell Animation
                DispatchQueue.main.async {
                    cell.iconView.pulse(nil)
                }
            } else {
                cell.imgIcon.tintColor = #colorLiteral(red: 0.6259584427, green: 0.719085753, blue: 0.260977596, alpha: 1)
                cell.iconView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                cell.lblSteps.textColor = #colorLiteral(red: 0.6259584427, green: 0.719085753, blue: 0.260977596, alpha: 1)
                DispatchQueue.main.async {
                    cell.iconView.removeCurrentAnimations()
                }
            }
        } else if indexPath.row == 5 {
            cell.lblPoints.text = "5"
            cell.imgIcon.image = #imageLiteral(resourceName: "exp_Shoes").withRenderingMode(.alwaysTemplate)
            cell.lblTitle.text = "Coins"
            cell.lblSteps.text = "14 000"
            cell.iconView.backgroundColor = #colorLiteral(red: 0.6259584427, green: 0.719085753, blue: 0.260977596, alpha: 1)
            if dataObj["is_performed"].stringValue == "0" && self.currSteps >= 14000 {
                //Cell Animation
                DispatchQueue.main.async {
                    cell.iconView.pulse(nil)
                }
            } else {
                cell.imgIcon.tintColor = #colorLiteral(red: 0.6259584427, green: 0.719085753, blue: 0.260977596, alpha: 1)
                cell.iconView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                cell.lblSteps.textColor = #colorLiteral(red: 0.6259584427, green: 0.719085753, blue: 0.260977596, alpha: 1)
                DispatchQueue.main.async {
                    cell.iconView.removeCurrentAnimations()
                }
            }
        } else if indexPath.row == 6 {
            cell.lblPoints.text = "10"
            cell.imgIcon.image = #imageLiteral(resourceName: "exp_Shoes").withRenderingMode(.alwaysTemplate)
            cell.lblTitle.text = "Coins"
            cell.lblSteps.text = "20 000"
            cell.iconView.backgroundColor = #colorLiteral(red: 0.6000000834, green: 0.6000000834, blue: 0.6000000834, alpha: 1)
            if dataObj["is_performed"].stringValue == "0" && self.currSteps >= 20000 {
                //Cell Animation
                DispatchQueue.main.async {
                    cell.iconView.pulse(nil)
                }
            } else {
                cell.imgIcon.tintColor = #colorLiteral(red: 0.6000000834, green: 0.6000000834, blue: 0.6000000834, alpha: 1)
                cell.iconView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                cell.lblSteps.textColor = #colorLiteral(red: 0.6000000834, green: 0.6000000834, blue: 0.6000000834, alpha: 1)
                DispatchQueue.main.async {
                    cell.iconView.removeCurrentAnimations()
                }
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.row
        let dataObj = self.rewardData[indexPath.row]
        self.updateCoins(rid: dataObj["RewardedId"].stringValue, coin: dataObj["Coins"].stringValue)
    }
    
}

extension CGFloat {
  func getMiles() -> CGFloat{
       return self * 0.000621371192
  }
  func getMeters() -> CGFloat {
       return self * 1609.344
  }
}

extension UserDefaults {

    static let defaults = UserDefaults.standard

    static var lastAccessDate: Date? {
        get {
            return defaults.object(forKey: "lastAccessDate") as? Date
        }
        set {
            guard let newValue = newValue else { return }
            guard let lastAccessDate = lastAccessDate else {
                defaults.set(newValue, forKey: "lastAccessDate")
                return
            }
            if !Calendar.current.isDateInToday(lastAccessDate) {
                print("Reset Value")
                NotificationCenter.default.post(name: NSNotification.Name("ResetSteps"), object: nil)
                lastSteps = 0
                defaults.set(0, forKey: "lastSteps")
                defaults.synchronize()
                
            }
//            else {
//                lastSteps = defaults.value(forKey: "lastSteps") as? Int ?? 0
//            }
            defaults.set(newValue, forKey: "lastAccessDate")
        }
    }
}
