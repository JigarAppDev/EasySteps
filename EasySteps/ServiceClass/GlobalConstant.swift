//
//  GlobalConstant.swift
//  BeerElite
//
//  Created by Jigar on 12/06/18.
//  Copyright © 2018 Jigar. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

var BASEURL: String = "http://46.101.95.217/easysteps/api/"
var IMAGEURL: String = "http://46.101.95.217/easysteps/"
let App_Title: String = "EasySteps"

var LoaderType:Int = 14
let Defaults = UserDefaults.standard
let Loadersize = CGSize(width: 40, height: 40)
var ToastDuration:TimeInterval = 2.0
var InternetMessage:String = "No internet connection, please try again later"
var WrongMsg:String = "Something went wrong, please try again"

//MARK: API list
let LOGINAPI                       = "signIn"
let SIGNAPI                        = "registration"
let RESETPASSWORD                  = "ResetPassword"
let FORGOTPASSWORD                 = "ForgotPassword"
let LOGOUT                         = "Logout"
let CHANGEPASSWORD                 = "ChangePassword"
let DELETEACCOUNT                  = "DeleteAccount"
let UPDATEPROFILE                  = "UpdateProfile"
let GETALLDEALS                    = "GetDealsData"
let GETDAILYSTEPS                  = "GetMyStepsHistory"
let GETMYSTEPS                     = "GetMyDailySteps"
let ADDSTEPS                       = "AddMyDailySteps"
let UPDATELANGUAGE                 = "UpdateRegionLang"
let UPDATEREWARDS                  = "AddToAcceptReward"
let UPDATEMYSTEPS                  = "UpdateMyDailySteps"

//MARK: Global Variables
var userType = ""
var userData: JSON = []
var deviceTokenClientGL = ""
var APIdeviceTokenGL = ""
var IsJobFilter = false
var IsUserFilter = false
var filterDistance = "0"
var TotalCoinsGL = "0"
var lastSteps = 0

//MARK:- CHAT
var deviceTokenGL = ""
var fcmTokenGL = ""
var apiTokenGL = ""
var TOTALMESSAGECOUNT = 0
var allUserChatListGL = [JSON]()
var lastUserChatMsgGL: [JSON]!
var lastSentMsgGL: JSON!

var DEVICETOKEN = "123456"

//MARK:- Notification Type
var NOTIFICATION_TYPE = "0"

//MARK:- BADGES COUNT
var badgeCount = 0

//MARK: Web Service Hendler
let service: ServiceCall = ServiceCall()

//MARK: storyBoard Id
let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle:nil)

//MARK: Color
let BACKGROUND_COLOR                =   UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1.0)
let CELL_BORDER_COLOR               =   UIColor(red:0.39, green:0.44, blue:0.69, alpha:0.14)
let CELL_Top_Border                 =   UIColor(red: 239/255, green: 71/255, blue: 159/255, alpha: 1.0)
let CELL_Middle_Border              =   UIColor(red: 31/255, green: 194/255, blue: 235/255, alpha: 1.0)
let CELL_Bottom_Border              =   UIColor(red: 93/255, green: 55/255, blue: 255/255, alpha: 1.0)
