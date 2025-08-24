//
//  AppDelegate.swift
// TowRoute Provider
//
//  Created by Admin on 04/06/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift
import SlideMenuControllerSwift
import CoreLocation
import GoogleMaps
import Firebase
import FirebaseInstanceID
import FirebaseMessaging
import FBSDKLoginKit
import FBSDKCoreKit
//import GoogleSignIn
import GeoFire
import UserNotifications
import FirebaseAuth
import Stripe
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {

    var window: UIWindow?
    var slideMenuController: SlideMenuController!

    var bearerToken = ""
    
    var locationManager: CLLocationManager!
    
    var driverLocation = CLLocation(latitude: 0.0, longitude: 0.0)
    
    var sendLoc = false
    var locationDisable = true
    var SundaySelectTimeArr = NSMutableArray()
    var MondaySelectTimeArr = NSMutableArray()
    var TuesdaySelectTimeArr = NSMutableArray()
    var WednesdaySelectTimeArr = NSMutableArray()
    var ThurdaySelectTimeArr = NSMutableArray()
    var FridaySelectTimeArr = NSMutableArray()
    var SaturdaySelectTimeArr = NSMutableArray()
    
    var selectedServicesArr = NSMutableArray()
    
    var drivercheckin = false
    var driverapproved = false
    
    var device_token = "123"
    
    var oldtLocation: CLLocation!
    var newLocation: CLLocation!
    
    
    var firsttime = true
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
       
        // Override point for customization after application launch.
        
        
      //  Stripe.setDefaultPublishableKey("pk_test_WDP0fwVbtyJzXdGucvd901EJ")

        UIViewController.swizzlePresentationStyle()

        LanguageManager.shared.defaultLanguage = .en
        
        
        IQKeyboardManager.shared.enable = true
        
       // IQKeyboardManager.sharedManager().enable = true
        
        FirebaseApp.configure()
        
        Auth.auth().signInAnonymously() { (authResult, error) in
           
             guard let user = authResult else { return }
             let isAnonymous = user.user.isAnonymous  // true
             let uid = user.user.uid
             
         }
        
        GMSServices.provideAPIKey(googleApiKey)
        
        application.applicationIconBadgeNumber = 0
        
        
//        do {
//            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, mode: AVAudioSessionModeDefault, options: [.mixWithOthers, .allowAirPlay,.duckOthers])
//            print("Playback OK")
//            try AVAudioSession.sharedInstance().setActive(true)
//            print("Session is Active")
//        } catch {
//            print(error)
//        }
        
        
        
        
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            // For iOS 10 data message (sent via FCM
            Messaging.messaging().delegate = self
        }
        
        else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        
     
        
        
        
        
        
    /*    if USERDEFAULTS.bool(forKey: "login already") {
            let accesstoken = USERDEFAULTS.value(forKey: "access_token")
            APPDELEGATE.bearerToken = accesstoken as! String
            
            var userdict = USERDEFAULTS.getLoggedUserDetails()
            driver_id = (userdict["id"] as? String)!
            
            if let invite_code = userdict["invite_code"] {
            
                print("invite_code \(invite_code)")
                
                invitecode = "\(invite_code)"
                
            }
            
            updateHomeView()
        }
        else {
            updateLoginView()
        }*/
        
        appearance()
        
        
         
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        
     //   GIDSignIn.sharedInstance().clientID = "183986829626-r102vu9que8sln1vfbu4qlji51vfm7in.apps.googleusercontent.com"
        
        
       // TWTRTwitter.sharedInstance().start(withConsumerKey: "4y9Eo5cUuj7oYG1d4I5oOqWKk", consumerSecret: "qUTv70jKg0vqKdXTtp7udRkjB8QfwrP5WEuwGMaer1eShYBsDP")
        return true
    }
    
    var geoFire: GeoFire! = nil
    var geoHash: GFGeoHash!
    
    var geofirechildRef: DatabaseReference!
    var fireRef: DatabaseReference!
    
    var driverstatusRef: DatabaseReference! = nil
    
    var driverStatus = ""
    
    var querywallethandle: UInt! = nil
    
    var driverwalletRef: DatabaseReference! = nil
    
    var driverWallet = ""
    
    var querycurrencyhandle: UInt! = nil
    
    var usercurrencyRef: DatabaseReference! = nil
    
    var querycurrencySymhandle: UInt! = nil
    
    var usercurrencySymRef: DatabaseReference! = nil
    
    var queryratinghandle: UInt! = nil
    
    var userratingtRef: DatabaseReference! = nil
    
    var userRating = "0.0"
    
    var isShowLogin = false
    
    func updateHomeView() {
        
        if self.locationManager == nil {
            
            fireRef = Database.database().reference()
            
            geoHash = GFGeoHash()
            
            geofirechildRef = fireRef.child("drivers_location").child(driver_id)
            
            geoFire = GeoFire(firebaseRef: geofirechildRef)
            
            print("get location")
            
            getlocation()
            
        }
        
        driverwalletRef = fireRef.child("providers").child(driver_id).child("wallet")
        
        querywallethandle = driverwalletRef.observe(DataEventType.value) { (SnapShot: DataSnapshot) in
            print("SnapShot \(SnapShot.value)")
            
            if let statusval = SnapShot.value {
                
                self.driverWallet = "\(statusval)"
                
                var userInfo = [AnyHashable: Any]()
                userInfo["wallet"] = "\(statusval)"
                let nc = NotificationCenter.default
                nc.post(name: NSNotification.Name("driverwallet"), object: self, userInfo: userInfo)
                
            }
            
        }
        
        userratingtRef = fireRef.child("providers").child(driver_id).child("rating")
        
        queryratinghandle = userratingtRef.observe(DataEventType.value) { (SnapShot: DataSnapshot) in
            print("SnapShot \(SnapShot.value)")
            
            if let statusval = SnapShot.value {
                
                self.userRating = "\(statusval)"
                
                let nc = NotificationCenter.default
                nc.post(name: NSNotification.Name("ratingUpdate"), object: self, userInfo: nil)
                
            }
            
        }
        
        usercurrencyRef = fireRef.child("providers").child(driver_id).child("currency")
        
        querycurrencyhandle = usercurrencyRef.observe(DataEventType.value) { (SnapShot: DataSnapshot) in
            print("SnapShot \(SnapShot.value)")
            
            if let statusval = SnapShot.value {
                
                let currencyVal = "\(statusval)"
                
                let splitcur = currencyVal.components(separatedBy: ":")
                
                if splitcur.count > 0 {
                    currenc = splitcur[0]
                    
                    if self.usercurrencySymRef != nil {
                        
                        if self.querycurrencySymhandle != nil {
                            
                            self.usercurrencySymRef.removeObserver(withHandle: self.querycurrencySymhandle)
                            
                        }
                        
                        self.usercurrencySymRef.removeAllObservers()
                        
                        self.usercurrencySymRef = nil
                        
                    }
                    
                  if currenc != "" && currenc != nil {
                        
                    self.usercurrencySymRef = self.fireRef.child("currency").child(currenc!)
                        
                        self.querycurrencySymhandle = self.usercurrencySymRef.observe(DataEventType.value) { (SnapShot: DataSnapshot) in
                            print("SnapShot \(SnapShot.value)")
                            
                            if let statusval1 = SnapShot.value {

                            let statusString = "\(statusval1)"
                                print("chk_appdelegate_statusString\(statusString)")

                            if statusString == "<null>"
                            {
                                if currenc == "GBP"
                                {
                                    currencymul = "1"

                                }

                                else
                                {
                                    currencymul = "1"

                                }
                                
                                print("Currency multiple \(currencymul)")

                            }
                            else
                            {
                            currencymul = "\(statusval1)"
                                print("Currency multiple Value \(currencymul)")

                           }
                            
                            let nc = NotificationCenter.default
                            nc.post(name: NSNotification.Name("currencySymUpdate"), object: self, userInfo: nil)
                            
                        }
                            
                    }
                        
                    }
                    
                }
                
                if splitcur.count > 1 {
                    currency_symbol = splitcur[1]
                }
                
                let nc = NotificationCenter.default
                nc.post(name: NSNotification.Name("currencyUpdate"), object: self, userInfo: nil)
                
            }
            
        }
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        SlideMenuOptions.contentViewScale = 1.0
        let menuPage = storyBoard.instantiateViewController(withIdentifier: "menuvc") as! MenuViewController
        let mainPage = storyBoard.instantiateViewController(withIdentifier:"Home")
      //  slideMenuController = SlideMenuController(mainViewController: mainPage, leftMenuViewController: menuPage)
        // slideMenuController = isArabic() ? SlideMenuController(mainViewController: mainPage, rightMenuViewController: menuPage) : SlideMenuController(mainViewController: mainPage, leftMenuViewController: menuPage)
        let isarabic = LanguageManager.shared.currentLanguage == .ar
        //  slideMenuController = SlideMenuController(mainViewController: mainPage, leftMenuViewController: menuPage)
        slideMenuController = isarabic ? SlideMenuController(mainViewController: mainPage, rightMenuViewController: menuPage) : SlideMenuController(mainViewController: mainPage, leftMenuViewController: menuPage)
        window?.rootViewController = slideMenuController
        window?.makeKeyAndVisible()
        
        //// update firebase
        
        if driverstatusRef == nil {
            
            let fireRef = Database.database().reference()
            driverstatusRef = fireRef.child("providers").child(driver_id).child("trips")
            driverstatusRef.observe(DataEventType.value) { (SnapShot: DataSnapshot) in
                print("SnapShot \(SnapShot.value)")
                
                if let dict = SnapShot.value as? NSDictionary {
                    
                    self.driverStatus = "\(dict["service_status"]!)" // (dict.value(forKey: "service_status") as? String)!
                    
                    if let title = dict["service_status"] {
                        
                        let state = "\(dict["service_status"]!)"
                        
                        print("topmost \(self.topMostViewController())")
                        
                        if let cusname = dict["customer_phone_number"] {
                            
                            customer_phone_number = "\(dict["customer_phone_number"]!)"
                            
                        }
                        
                        if let cusname = dict["customer_avatar"] {
                            
                            customer_avatar = "\(dict["customer_avatar"]!)"
                            
                        }
                        
                        if let cusname = dict["customer_first_name"] {
                            
                            customer_name = "\(dict["customer_first_name"]!)"
                            
                            if let cusname = dict["customer_last_name"] {
                                
                                customer_name = customer_name + " \(dict["customer_last_name"]!)"
                                
                            }
                            
                        }
                        
                        if state == "0"{
                            
                            NotificationCenter.default.post(name: Notification.Name("CancelTrip"), object: nil)
                            
                        }
                        
                        else if state == "1" {
                            
                            let requestPage = storyBoard.instantiateViewController(withIdentifier:"requestvc") as! ServiceRequestViewController
                            
                            if let cusname = dict["customer_name"] {
                                
                                requestPage.cusname = "\(dict["customer_name"]!)"
                                
                            }
                            
                            if let user_pickup = dict["user_pickup"] {
                                
                                requestPage.pickuploc = "\(dict["user_pickup"]!)"
                                
                            }
                            
                            if let special_ins = dict["special_ins"] {
                                
                                requestPage.instru = "\(dict["special_ins"]!)"
                                print("checkrequestPage\(requestPage.instru)")
                            }
                            
                            if let customer_id = dict["customer_id"] {
                                
                                requestPage.customer_id = "\(dict["customer_id"]!)"
                                
                            }
                            
                            if let main_service = dict["main_service"] {
                                
                                
                                 requestPage.main_service = "\(dict["main_service"]!)"
                               
                                   requestPage.main_service_ar = "\(dict["main_service_ar"]!)"
                               
                                
                                
                            }
                            
                            if let sub_service = dict["sub_service"] {
                                
                                requestPage.sub_service = "\(dict["sub_service"]!)"
                                    
                                    requestPage.sub_service_ar = "\(dict["sub_service_ar"]!)"
                                
                                
                            }
                            
                            if let distance = dict["distance"] {
                                
                                requestPage.estimated_distance = "\(dict["distance"]!)"
                                    
                                   // requestPage.estimated_distance = "\(dict["distance"]!)"
                                
                                
                            }
                            
                            if let pickup_lat = dict["pickup_lat"] {
                                
                                requestPage.pickup_lat = "\(dict["pickup_lat"]!)"
                                
                            }
                            
                            if let pickup_lng = dict["pickup_lng"] {
                                
                                requestPage.pickup_lng = "\(dict["pickup_lng"]!)"
                                
                            }
                            
                            if let paymode = dict["paymode"] {
                                
                                requestPage.paymode = "\(dict["paymode"]!)"
                                
                            }
                            
                            if let stripe_token = dict["stripe_token"] {
                                
                                requestPage.stripetoken = "\(dict["stripe_token"]!)"
                                
                            }
                            
                            if let promocode = dict["promocode"] {
                                
                                requestPage.promocode = "\(dict["promocode"]!)"
                                
                            }
                            
                            if let drop_lat = dict["drop_lat"] {
                                
                                requestPage.drop_lat = "\(dict["drop_lat"]!)"
                                
                            }
                            
                            if let drop_lon = dict["drop_lon"] {
                                
                                requestPage.drop_lon = "\(dict["drop_lon"]!)"
                                
                            }
                            
                            if let drop_location = dict["user_drop"] {
                                
                                requestPage.drop_location = "\(dict["user_drop"]!)"
                                
                            }
                            
                            self.topMostViewController().present(requestPage, animated: true, completion: nil)
                            
                            // self.slideMenuController?.changeMainViewController(requestPage, close: true)
                            
                        }
                        
                        else if state == "2" {
                            
                            let requestPage = storyBoard.instantiateViewController(withIdentifier:"JobProgressVC") as! JobProgressViewController
                            
                            if let drop_lat = dict["drop_lat"] {
                                
                                requestPage.drop_lat = "\(dict["drop_lat"]!)"
                                
                            }
                            
                            if let drop_lon = dict["drop_lon"] {
                                
                                requestPage.drop_lon = "\(dict["drop_lon"]!)"
                                
                            }
                            
                            if let cusfirstname = dict["customer_first_name"] {
                                
                                if let cuslastname = dict["customer_last_name"] {
                                    requestPage.cusname = "\(dict["customer_first_name"]!) " + "\(dict["customer_last_name"]!) "
                                    
                                }
                                else {
                                    requestPage.cusname = "\(dict["customer_first_name"]!)"
                                }
                                
                            }
                            
                            
                            if let sub_level_amount = dict["sub_level_amount"] {
                                
                                requestPage.sub_level_amount = "\(dict["sub_level_amount"]!)"
                                
                            }
                            
                            if let visit_fare = dict["visit_fare"] {
                                
                                requestPage.visit_fare = "\(dict["visit_fare"]!)"
                                
                            }
                            
                            if let price_per_km = dict["price_per_km"] {
                                
                                requestPage.price_per_km = "\(dict["price_per_km"]!)"
                                
                            }
                            
                            if let customer_location = dict["customer_location"] {
                                
                                requestPage.pickuploc = "\(dict["customer_location"]!)"
                                
                            }
                            
                            if let request_status = dict["request_status"] {
                                
                                requestPage.request_status = "\(dict["request_status"]!)"
                                
                            }
                            
                            if let customer_lat = dict["customer_lat"] {
                                
                                requestPage.customer_lat = "\(dict["customer_lat"]!)"
                                
                            }
                            
                            if let customer_lon = dict["customer_lon"] {
                                
                                requestPage.customer_lon = "\(dict["customer_lon"]!)"
                                
                            }
                            
                            if let customer_id = dict["customer_id"] {
                                
                                requestPage.customer_id = "\(dict["customer_id"]!)"
                                
                            }
                            
                            if let booking_id = dict["booking_id"] {
                                
                                requestPage.booking_id = "\(dict["booking_id"]!)"
                                
                            }
                            
                            if let promo = dict["promocode"] {
                                
                                requestPage.promocodeval = "\(dict["promocode"]!)"
                                
                            }
                           
                          
                            if let drop_location = dict["drop_location"] {
                                
                                requestPage.dropLocation = "\(dict["drop_location"]!)"
                                
                            }
                            
                            if let unit_price = dict["unit_price"] {
                                
                                requestPage.unit_price = "\(dict["unit_price"]!)"
                                
                            }
                            
                            if let accept_time = dict["accept_time"] {
                                
                                requestPage.accept_time = "\(dict["accept_time"]!)"
                                
                            }

                            
                            self.topMostViewController().present(requestPage, animated: true, completion: nil)
                            
                        }
                        
                        else if state == "3" {
                            
                            let requestPage = storyBoard.instantiateViewController(withIdentifier:"JobProgressVC") as! JobProgressViewController
                            
                            if let drop_lat = dict["drop_lat"] {
                                
                                requestPage.drop_lat = "\(dict["drop_lat"]!)"
                                
                            }
                            
                            if let drop_lon = dict["drop_lon"] {
                                
                                requestPage.drop_lon = "\(dict["drop_lon"]!)"
                                
                            }
                            
                            if let cusfirstname = dict["customer_first_name"] {
                                
                                if let cuslastname = dict["customer_last_name"] {
                                    requestPage.cusname = "\(dict["customer_first_name"]!) " + "\(dict["customer_last_name"]!) "
                                    
                                }
                                else {
                                    requestPage.cusname = "\(dict["customer_first_name"]!)"
                                }
                                
                            }
                            
                            if let sub_level_amount = dict["sub_level_amount"] {
                                
                                requestPage.sub_level_amount = "\(dict["sub_level_amount"]!)"
                                
                            }
                            
                            if let visit_fare = dict["visit_fare"] {
                                
                                requestPage.visit_fare = "\(dict["visit_fare"]!)"
                                
                            }
                            
                            if let price_per_km = dict["price_per_km"] {
                                
                                requestPage.price_per_km = "\(dict["price_per_km"]!)"
                                
                            }
                            
                            if let customer_location = dict["customer_location"] {
                                
                                requestPage.pickuploc = "\(dict["customer_location"]!)"
                                
                            }
                            
                            if let request_status = dict["request_status"] {
                                
                                requestPage.request_status = "\(dict["request_status"]!)"
                                
                            }
                            
                            if let customer_lat = dict["customer_lat"] {
                                
                                requestPage.customer_lat = "\(dict["customer_lat"]!)"
                                
                            }
                            
                            if let customer_lon = dict["customer_lon"] {
                                
                                requestPage.customer_lon = "\(dict["customer_lon"]!)"
                                
                            }
                            
                            if let customer_id = dict["customer_id"] {
                                
                                requestPage.customer_id = "\(dict["customer_id"]!)"
                                
                            }
                            
                            if let booking_id = dict["booking_id"] {
                                
                                requestPage.booking_id = "\(dict["booking_id"]!)"
                                
                            }
                            
                            if let promo = dict["promocode"] {
                                
                                requestPage.promocodeval = "\(dict["promocode"]!)"
                                
                            }
                          
                            if let drop_location = dict["drop_location"] {
                                
                                requestPage.dropLocation = "\(dict["drop_location"]!)"
                                
                            }
                            
                            if let unit_price = dict["unit_price"] {
                                
                                requestPage.unit_price = "\(dict["unit_price"]!)"
                                
                            }
                            
                            if let accept_time = dict["accept_time"] {
                                
                                requestPage.accept_time = "\(dict["accept_time"]!)"
                                
                            }
                            
                            if let start_time = dict["start_time"] {
                                
                                requestPage.start_time = "\(dict["start_time"]!)"
                                
                            }

                            
                            requestPage.service_status = state
                            
                            self.topMostViewController().present(requestPage, animated: false, completion: nil)
                            
                        }
                        
                        else if state == "4" {
                            
                            let requestPage = storyBoard.instantiateViewController(withIdentifier:"JobProgressVC") as! JobProgressViewController
                            
                            if let drop_lat = dict["drop_lat"] {
                                
                                requestPage.drop_lat = "\(dict["drop_lat"]!)"
                                
                            }
                            
                            if let drop_lon = dict["drop_lon"] {
                                
                                requestPage.drop_lon = "\(dict["drop_lon"]!)"
                                
                            }
                            
                            if let sub_level_amount = dict["sub_level_amount"] {
                                
                                requestPage.sub_level_amount = "\(dict["sub_level_amount"]!)"
                                
                            }
                            
                            if let visit_fare = dict["visit_fare"] {
                                
                                requestPage.visit_fare = "\(dict["visit_fare"]!)"
                                
                            }
                            
                            
                            if let unit_price = dict["unit_price"] {
                                
                                requestPage.unit_price = "\(dict["unit_price"]!)"
                                
                            }

                            if let price_per_km = dict["price_per_km"] {
                                
                                requestPage.price_per_km = "\(dict["price_per_km"]!)"
                                
                            }
                            
                            if let customer_location = dict["customer_location"] {
                                
                                requestPage.pickuploc = "\(dict["customer_location"]!)"
                                
                            }
                            
                            if let request_status = dict["request_status"] {
                                
                                requestPage.request_status = "\(dict["request_status"]!)"
                                
                            }
                            
                            if let customer_lat = dict["customer_lat"] {
                                
                                requestPage.customer_lat = "\(dict["customer_lat"]!)"
                                
                            }
                            
                            if let customer_lon = dict["customer_lon"] {
                                
                                requestPage.customer_lon = "\(dict["customer_lon"]!)"
                                
                            }
                            
                            if let customer_id = dict["customer_id"] {
                                
                                requestPage.customer_id = "\(dict["customer_id"]!)"
                                
                            }
                            
                            if let booking_id = dict["booking_id"] {
                                
                                requestPage.booking_id = "\(dict["booking_id"]!)"
                                
                            }
                            
                            if let cusfirstname = dict["customer_first_name"] {
                                
                                if let cuslastname = dict["customer_last_name"] {
                                    requestPage.cusname = "\(dict["customer_first_name"]!) " + "\(dict["customer_last_name"]!) "
                                    
                                }
                                else {
                                    requestPage.cusname = "\(dict["customer_first_name"]!)"
                                }
                                
                            }
                            
                            if let user_pickup = dict["user_pickup"] {
                                
                                requestPage.pickuploc = "\(dict["user_pickup"]!)"
                                
                            }
                            
                            if let start_time = dict["start_time"] {
                                
                                requestPage.start_time = "\(dict["start_time"]!)"
                                
                            }
                            
                            if let accept_time = dict["accept_time"] {
                                
                                requestPage.accept_time = "\(dict["accept_time"]!)"
                                
                            }
                            
                            if let reach_time = dict["reach_time"] {
                                
                                requestPage.reach_time = "\(dict["reach_time"]!)"
                                
                            }
                            
                            if let category = dict["category"] {
                                
                               requestPage.category = "\(dict["category"]!)"
                                if LanguageManager.shared.currentLanguage == .ar{
                                    
                                    requestPage.category = "\(dict["category_ar"]!)"
                                }
                                
                                
                                
                            }
                            
                            if let promo = dict["promocode"] {
                                
                                requestPage.promocodeval = "\(dict["promocode"]!)"
                                
                            }
                           
                            if let drop_location = dict["drop_location"] {
                                
                                requestPage.dropLocation = "\(dict["drop_location"]!)"
                                
                            }
                            
                            requestPage.service_status = state
                            
                            self.topMostViewController().present(requestPage, animated: false, completion: nil)
                            
                        }
                        
                        else if state == "5" || state == "5.1" {
                            
                            let requestPage = storyBoard.instantiateViewController(withIdentifier:"JobProgressVC") as! JobProgressViewController
                            
                           
                            if let drop_lat = dict["drop_lat"] {
                                
                                requestPage.drop_lat = "\(dict["drop_lat"]!)"
                                
                            }
                            
                            if let drop_lon = dict["drop_lon"] {
                                
                                requestPage.drop_lon = "\(dict["drop_lon"]!)"
                                
                            }
                            
                            if let sub_level_amount = dict["sub_level_amount"] {
                                
                                requestPage.sub_level_amount = "\(dict["sub_level_amount"]!)"
                                
                            }
                            
                            if let visit_fare = dict["visit_fare"] {
                                
                                requestPage.visit_fare = "\(dict["visit_fare"]!)"
                                
                            }
                            
                            if let price_per_km = dict["price_per_km"] {
                                
                                requestPage.price_per_km = "\(dict["price_per_km"]!)"
                                
                            }
                            
                            if let customer_location = dict["customer_location"] {
                                
                                requestPage.pickuploc = "\(dict["customer_location"]!)"
                                
                            }
                            
                            if let request_status = dict["request_status"] {
                                
                                requestPage.request_status = "\(dict["request_status"]!)"
                                
                            }
                            
                            if let customer_lat = dict["customer_lat"] {
                                
                                requestPage.customer_lat = "\(dict["customer_lat"]!)"
                                
                            }
                            
                            if let customer_lon = dict["customer_lon"] {
                                
                                requestPage.customer_lon = "\(dict["customer_lon"]!)"
                                
                            }
                            
                            if let booking_id = dict["booking_id"] {
                                
                                requestPage.booking_id = "\(dict["booking_id"]!)"
                                
                            }
                            
                            if let cusfirstname = dict["customer_first_name"] {
                                
                                if let cuslastname = dict["customer_last_name"] {
                                    requestPage.cusname = "\(dict["customer_first_name"]!) " + "\(dict["customer_last_name"]!) "
                                    
                                }
                                else {
                                    requestPage.cusname = "\(dict["customer_first_name"]!)"
                                }
                                
                            }
                            
                            if let user_pickup = dict["user_pickup"] {
                                
                                requestPage.pickuploc = "\(dict["user_pickup"]!)"
                                
                            }
                            
                            if let start_time = dict["start_time"] {
                                
                                requestPage.start_time = "\(dict["start_time"]!)"
                                
                            }
                            
                            if let accept_time = dict["accept_time"] {
                                
                                requestPage.accept_time = "\(dict["accept_time"]!)"
                                
                            }
                            
                            if let reach_time = dict["reach_time"] {
                                
                                requestPage.reach_time = "\(dict["reach_time"]!)"
                                
                            }
                            
                            if let service_start_time = dict["service_start_time"] {
                                
                                requestPage.service_start_time = "\(dict["service_start_time"]!)"
                                
                            }
                            
                            if let category = dict["category"] {
                                requestPage.category = "\(dict["category"]!)"
                                if LanguageManager.shared.currentLanguage == .ar{
                                    
                                    requestPage.category = "\(dict["category_ar"]!)"
                                }
                                
                                
                            }
                            
                            if let unit_price = dict["unit_price"] {
                                
                                requestPage.unit_price = "\(dict["unit_price"]!)"
                                
                            }
                            
                            if let customer_id = dict["customer_id"] {
                                
                                requestPage.customer_id = "\(dict["customer_id"]!)"
                                
                            }
                            
                            if let payment_type = dict["payment_type"] {
                                
                                requestPage.payment_type = "\(dict["payment_type"]!)"
                                
                            }
                            
                            if let promo = dict["promocode"] {
                                
                                requestPage.promocodeval = "\(dict["promocode"]!)"
                                
                            }
                            
                            if let card = dict["card_status"]
                            {
                                let cards = "\(dict["card_status"]!)"
                                print(cards)
                                requestPage.cardStatus = "\(dict["card_status"]!)"
                                
                            }
                           
                            if let drop_location = dict["drop_location"] {
                                
                                requestPage.dropLocation = "\(dict["drop_location"]!)"
                                
                            }
                            
                           
                            if state == "5.1"
                            {
                                NotificationCenter.default.post(name: Notification.Name("status5.1"), object: nil)
                                requestPage.service_status = "5"
                                requestPage.cardstate = "5.1"
                                
                            }
                            else if state == "5"
                            {
                               requestPage.service_status = "5"
                                requestPage.cardstate = ""
                            }
                            
                            
                            
                            
                            self.topMostViewController().present(requestPage, animated: false, completion: nil)
                            
                        }

                        
                        else if state == "6" || state == "10" || state == "5.2" {
                            
                            let requestPage = storyBoard.instantiateViewController(withIdentifier:"FareSummary") as! FareSummaryViewController
                            
                          
                            
                            if state == "10" {
                                 
                                requestPage.showBalAlert = true
                                
                            }
                            
                            if let customer_location = dict["customer_location"] {
                                
                                requestPage.customer_location = "\(dict["customer_location"]!)"
                                
                            }
                                                        
                            if let extra_charge = dict["extra_charge"] {
                                
                                requestPage.extra_charge = "\(dict["extra_charge"]!)"
                                
                            }
                            
                            if let misc_charge = dict["misc_charge"] {
                                
                                requestPage.misc_charge = "\(dict["misc_charge"]!)"
                                
                            }
                            
                            if let driver_discount = dict["driver_discount"] {
                                
                                requestPage.driver_discount = "\(dict["driver_discount"]!)"
                                
                            }
                            
                            if let drop_location = dict["drop_location"] {
                                
                                requestPage.drop_location = "\(dict["drop_location"]!)"
                                
                            }
                            
                            if let sub_level_amount = dict["sub_level_amount"] {
                                
                                requestPage.sub_level_amount = "\(dict["sub_level_amount"]!)"
                                
                            }
                            
                            if let visit_fare = dict["visit_fare"] {
                                
                                requestPage.visit_fare = "\(dict["visit_fare"]!)"
                                
                            }
                            
                            if let price_per_km = dict["price_per_km"] {
                                
                                requestPage.price_per_km = "\(dict["price_per_km"]!)"
                                
                            }
                            
                            if let total_distance = dict["total_distance"] {
                                
                                requestPage.total_distance = "\(dict["total_distance"]!)"
                                
                            }
                            
                            if let total_amount = dict["total_amount"] {
                                
                                requestPage.total_amount = "\(dict["total_amount"]!)"
                                
                            }
                            
                            if let total_amount = dict["total_amount"] {
                                
                                requestPage.totalval = "\(dict["total_amount"]!)"
                                
                            }
                            
                            if let job_date = dict["job_date"] {
                                
                                requestPage.jobdate = "\(dict["job_date"]!)"
                                
                            }
                            
                            if let driver_discount = dict["driver_discount"] {
                                
                                requestPage.discount = "\(dict["driver_discount"]!)"
                                
                            }
                            
                            if let payment_type = dict["payment_type"] {
                                
                                requestPage.payment = "\(dict["payment_type"]!)"
                                
                            }
                            
                            if let category = dict["category"] {
                                
                                 requestPage.cat = "\(dict["category"]!)"
                              
                                
                                if LanguageManager.shared.currentLanguage == .ar{
                                    
                                    requestPage.cat = "\(dict["category_ar"]!)"
                                }
                                
                               
                                
                            }
                            
                            if let unit_price = dict["unit_price"] {
                                
                                requestPage.cur = "\(dict["unit_price"]!)"
                                
                            }
                            
                            if let total_amount = dict["total_amount"] {
                                
                                requestPage.tot = "\(dict["total_amount"]!)"
                                
                            }
                            
                            if let customer_id = dict["customer_id"] {
                                
                                requestPage.customer_id = "\(dict["customer_id"]!)"
                                
                            }
                            
                            if let booking_id = dict["booking_id"] {
                                
                                requestPage.booking_id = "\(dict["booking_id"]!)"
                                
                            }
                            
                            if let booking_id = dict["booking_id"] {
                                
                                requestPage.booking_id = "\(dict["booking_id"]!)"
                                
                            }
                            
                            if let booking_id = dict["booking_id"] {
                                
                                requestPage.booking_id = "\(dict["booking_id"]!)"
                                
                            }
                            
                            if let booking_id = dict["booking_id"] {
                                
                                requestPage.booking_id = "\(dict["booking_id"]!)"
                                
                            }
                            
                            if let promo = dict["site_commission"] {
                                
                                requestPage.prmocode = "\(dict["site_commission"]!)"
                                
                            }
                            
                            if let promocode = dict["promocode"] {
                                
                                requestPage.promocode = "\(dict["promocode"]!)"
                                
                            }
                           
                            if let promovalue = dict["promo_value"] {
                                
                                requestPage.promovalue = "\(dict["promo_value"]!)"
                                
                            }
                            
                            self.topMostViewController().present(requestPage, animated: false, completion: nil)
                            
                        }
                        
                        
                        else if state == "8" {
                            
                            NotificationCenter.default.post(name: Notification.Name("CancelTrip"), object: nil)
                            
                            
                        }
                            
                            
                        else if state == "9" {
                            
                            // Database.database().reference().child("providers").child(driver_id).child("trips").removeValue()
                            Database.database().reference().child("providers").child(driver_id).child("trips").child("service_status").setValue("0")
                            
                            self.window!.rootViewController?.dismiss(animated: false, completion: nil)
                            
                        }
                        
                    }
                    
                }
                
            }
            
        }
    }
    
    var timer: Timer?
    var sec = 90
    
    func getlocation() {
        
        let status  = CLLocationManager.authorizationStatus()
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        if status == .notDetermined {
            self.locationManager.requestAlwaysAuthorization()
            self.locationManager.allowsBackgroundLocationUpdates = true
            self.locationManager.pausesLocationUpdatesAutomatically = false
            self.locationManager.startUpdatingLocation()
            self.timer?.invalidate()
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector:#selector(self.locUpdate(_:)), userInfo: nil, repeats: true)
            return
        }
        if status == .denied || status == .restricted {
            locationDisable = true
            return
        }
            
        else {
            locationDisable = false
        }
        self.locationManager.allowsBackgroundLocationUpdates = true
        self.locationManager.pausesLocationUpdatesAutomatically = false
//        self.locationManager.requestWhenInUseAuthorization()
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector:#selector(self.locUpdate(_:)), userInfo: nil, repeats: true)
        self.locationManager.startUpdatingLocation()
        
    }
    
    @objc func locUpdate(_ timer: Timer) {
        self.locationManager.stopUpdatingLocation()
        sec -= 1
        print("Check Seconds: \(sec)")
        
        if sec == 0 {
            self.timer?.invalidate()
            self.sec = 90
            self.getlocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        NotificationCenter.default.post(name: Notification.Name("LocationUpdate"), object: nil)
      
        if driver_id != "" {
            
            print("location \(locations) driver_id \(driver_id)")
            
            let userloc = locations[0] as CLLocation
            
            APPDELEGATE.driverLocation = userloc
            
            if firsttime == true
            {
                firsttime = false
            let geocoder = GMSGeocoder()
            
            geocoder.reverseGeocodeCoordinate(userloc.coordinate) { response, error in
                if let address = response?.firstResult() {
                    
                    // 3
                    let lines = address.lines!
                    driverAddress = lines.joined(separator: ", ")
                    
                    print("address \(driverAddress)")
                    
                }
            }
            
            }
            else
            {
                
            }
            /// update location
            
            newLocation = userloc
            
            if oldtLocation == nil {
                
                let value = 0
                
                if geoFire != nil {
                    
                    if self.drivercheckin == true {
                        
                        geoHash = GFGeoHash(location: userloc.coordinate)
                        
                        let locarr = [userloc.coordinate.latitude,userloc.coordinate.longitude]
                        
                         var driverState = "0"
                        if self.drivercheckin == true{
                            driverState = "1"
                        }
                        
                       
                        
                        geofirechildRef.updateChildValues(["bearing" : value,
                                                                            "g": geoHash.geoHashValue,
                                                                            "l": locarr,
                                                                            "status":driverState])
                        
                    }
                    
                    
                }
                
                oldtLocation = userloc
            }
            else {
                let value = getBearingBetweenTwoPoints1(point1: oldtLocation, point2: newLocation)
                
                if geoFire != nil {
                    
                    if self.drivercheckin == true {
                        
                        geoHash = GFGeoHash(location: userloc.coordinate)
                        
                        let locarr = [userloc.coordinate.latitude,userloc.coordinate.longitude]
                        
                        var driverState = "0"
                        
                        if self.drivercheckin == true{
                            driverState = "1"
                        }
                        
                        geofirechildRef.updateChildValues(["bearing" : value,
                                                                            "g": geoHash.geoHashValue,
                                                                            "l": locarr,
                                                                            "status":driverState])
                        
                    }
                    
                    
                }
                
            }
            
            oldtLocation = userloc
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DriverLocationUpdate"), object: userloc)
            self.locationManager.stopUpdatingLocation()
            
        }
            
        else {
            
            self.locationManager.stopUpdatingLocation()
            
        }
        
    }
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//
//        let userloc = locations[0] as CLLocation
//
//        APPDELEGATE.driverLocation = userloc
//
//        NotificationCenter.default.post(name: Notification.Name("DriverLocationUpdate"), object: nil)
//
//        if drivercheckin == true {
//
//            if geoFire != nil {
//
//                geoHash = GFGeoHash(location: userloc.coordinate)
//
//                let locarr = [userloc.coordinate.latitude,userloc.coordinate.longitude]
//
//                geofirechildRef.updateChildValues(["g": geoHash.geoHashValue,
//                                                   "l": locarr])
//
//
//            }
//
//        }
//
//        let geocoder = GMSGeocoder()
//
//        geocoder.reverseGeocodeCoordinate(userloc.coordinate) { response, error in
//            if let address = response?.firstResult() {
//
//                // 3
//                let lines = address.lines!
//                driverAddress = lines.joined(separator: ", ")
//                print("address \(driverAddress)")
//
//                if self.sendLoc == false {
//
//                    NotificationCenter.default.post(name: Notification.Name("LocationUpdate"), object: nil)
//
//                    // self.sendLoc = true
//
//                }
//
//            }
//        }
//
//    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        print("error \(error)")
        
        self.locationManager.stopUpdatingLocation()
        
    }
    
    func updateLoginView() {
        
        USERDEFAULTS.set(false, forKey: "login already")
        
        if driverstatusRef != nil {
            
            driverstatusRef.removeAllObservers()
            
        }
        
        driverstatusRef = nil
        
        if driverwalletRef != nil {
            
            if querywallethandle != nil {
                
                driverwalletRef.removeObserver(withHandle: querywallethandle)
                
            }
            
            driverwalletRef.removeAllObservers()
            
            driverwalletRef = nil
            
        }
        
        if usercurrencyRef != nil {
            
            if querycurrencyhandle != nil {
                
                usercurrencyRef.removeObserver(withHandle: querycurrencyhandle)
                
            }
            
            usercurrencyRef.removeAllObservers()
            
            usercurrencyRef = nil
            
        }
        
        if usercurrencySymRef != nil {
            
            if querycurrencySymhandle != nil {
                
                usercurrencySymRef.removeObserver(withHandle: querycurrencySymhandle)
                
            }
            
            usercurrencySymRef.removeAllObservers()
            
            usercurrencySymRef = nil
            
        }
        
        if userratingtRef != nil {
            
            if queryratinghandle != nil {
                
                userratingtRef.removeObserver(withHandle: queryratinghandle)
                
            }
            
            userratingtRef.removeAllObservers()
            
            userratingtRef = nil
            
        }
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let mainPage = storyBoard.instantiateViewController(withIdentifier:"view")
        window?.rootViewController = mainPage
        window?.makeKeyAndVisible()
    }
    
//    func appearance() {
//        let navappearance = UINavigationBar.appearance()
//        navappearance.tintColor = UIColor.white
//        navappearance.barTintColor = UIColor(hexString: "F2963C")
//        navappearance.isTranslucent = false
//        navappearance.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
//    }
    
    func appearance() {
        let navappearance = UINavigationBar.appearance()
        navappearance.tintColor = UIColor.white
        //  navappearance.barTintColor = UIColor(hexString: "#e04f00")
        navappearance.isTranslucent = false
        navappearance.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black]
        let attrs = [
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: UIFont(name: "Calibri", size: 17)!
        ]
        
        let nav = hasTopNotch
        print(nav)
        UINavigationBar.appearance().titleTextAttributes = attrs
        let gradient = CAGradientLayer()
        let sizeLength = UIScreen.main.bounds.size.height * 2
        var defaultNavigationBarFrame = CGRect()
        if nav == true
        {
            defaultNavigationBarFrame = CGRect(x: 0, y: 0, width: sizeLength, height: 88)
        }
        else
        {
            defaultNavigationBarFrame = CGRect(x: 0, y: 0, width: sizeLength, height: 64)
        }
        gradient.frame = defaultNavigationBarFrame
       let color1 = UIColor.init(hexString: "00d5ff")
        let color2 = UIColor.init(hexString: "00d5ff")
        //let color3 = UIColor.init(hexString: "81223d")
        
        gradient.colors = [color1!.cgColor,color2!.cgColor]//,color3!.cgColor
        
        UINavigationBar.appearance().setBackgroundImage(self.image(fromLayer: gradient), for: .default)
        
    }
    
    
    func image(fromLayer layer: CALayer) -> UIImage {
        
        UIGraphicsBeginImageContext(layer.frame.size)
        
        layer.render(in: UIGraphicsGetCurrentContext()!)
        
        let outputImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return outputImage!
        
        
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        let sourceApplication =  options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String
        let annotation = options[UIApplicationOpenURLOptionsKey.annotation]
        
        let handle = ApplicationDelegate.shared.application(app, open: url, sourceApplication: sourceApplication, annotation: annotation)
        
       // let GIDhandle = GIDSignIn.sharedInstance().handle(url, sourceApplication: sourceApplication, annotation: annotation)
        
       // let twitterhandle = TWTRTwitter.sharedInstance().application(app, open: url, options: options)
        
        return handle
        
        
    }
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "TOWROUTE PROVIDER")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    var applicationStateString: String {
        if UIApplication.shared.applicationState == .active {
            return "active"
        }else if UIApplication.shared.applicationState == .background {
            return "background"
        }else {
            return "inactive"
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
      //  if let refreshedToken = InstanceID.instanceID().token() {
       //     print("InstanceID token: \(refreshedToken)")
        //    self.device_token = refreshedToken
       // }
        
        InstanceID.instanceID().instanceID { (result, error) in
               if let error = error {
                   print("Error fetching remote instance ID: \(error)")
               } else if let result = result {
                   print("Remote instance ID token: \(result.token)")
                   let tokens = result.token
                   self.device_token = tokens
                   print("checkktokenns\(tokens)")
               }
           }
        
        
        Messaging.messaging().apnsToken = deviceToken
        
        let firebaseAuth = Auth.auth()
        
        //At development time we use .sandbox
        firebaseAuth.setAPNSToken(deviceToken, type: AuthAPNSTokenType.sandbox)
        
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        
    }

}

@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    // iOS10+, called when presenting notification in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let userInfo = notification.request.content.userInfo

        NSLog("[UserNotificationCenter] applicationState: \(applicationStateString) willPresentNotification: \(userInfo)")
        //TODO: Handle foreground notification
        completionHandler([.alert])
    }
    
    // iOS10+, called when received response (default open, dismiss or custom action) for a notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        NSLog("[UserNotificationCenter] applicationState: \(applicationStateString) didReceiveResponse: \(userInfo)")
        //TODO: Handle background notification
        completionHandler()
        
        let info = extractUserInfo(userInfo: userInfo)
        print(info.title)
        print(info.body)
      
     
       
        if info.title != "TowRoute Provider"
        {
            
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "notification") as? NotificationParentViewController
            self.topMostViewController().navigationController?.pushViewController(vc!, animated: false)
            
            
//            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//
//            let profilePage = mainStoryboard.instantiateViewController(withIdentifier:"notification")
//            (slideMenuController.mainViewController as! UINavigationController).pushViewController(profilePage, animated: true)
//            window?.rootViewController = slideMenuController
//            window?.makeKeyAndVisible()
            
        }
        
        if info.title == "TowRoute Provider" && info.body == "You have new schedule job request"
        {
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "yourjob") as? YourjobParentViewController
            self.topMostViewController().navigationController?.pushViewController(vc!, animated: false)
            
//            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//            let profilePage = mainStoryboard.instantiateViewController(withIdentifier:"yourjob")
//            (slideMenuController.mainViewController as! UINavigationController).pushViewController(profilePage, animated: true)
//            window?.rootViewController = slideMenuController
//            window?.makeKeyAndVisible()
          
            
        }
        
        
        
        
    }
    
}

extension AppDelegate : MessagingDelegate {
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        NSLog("[RemoteNotification] didRefreshRegistrationToken: \(fcmToken)")
        self.device_token = fcmToken
    }
    
    // iOS9, called when presenting notification in foreground
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        NSLog("[RemoteNotification] applicationState: \(applicationStateString) didReceiveRemoteNotification for iOS9: \(userInfo)")
        if UIApplication.shared.applicationState == .active {
            //TODO: Handle foreground notification
        } else {
            //TODO: Handle background notification
        }
    }
   
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification notification: [AnyHashable : Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("Notification  :  ", notification)
        if #available(iOS 10.0, *) {
            let content = UNMutableNotificationContent()
            content.sound = UNNotificationSound.default()
        } else {
            // Fallback on earlier versions
        }
        
        completionHandler(.newData)
        
    }
    
}




extension AppDelegate {
    
    // MARK:- Register Push
    private func registerPush(forApp application : UIApplication){
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options:[.alert, .sound]) { (granted, error) in
                
                if granted {
                    DispatchQueue.main.async {
                        application.registerForRemoteNotifications()
                    }
                }
            }
        } else {
            // Fallback on earlier versions
        }
        
    }
}
    

var hasTopNotch: Bool {
    if #available(iOS 11.0, tvOS 11.0, *) {
        // with notch: 44.0 on iPhone X, XS, XS Max, XR.
        // without notch: 24.0 on iPad Pro 12.9" 3rd generation, 20.0 on iPhone 8 on iOS 12+.
        return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 24
    }
    return false
}
func extractUserInfo(userInfo: [AnyHashable : Any]) -> (title: String, body: String) {
    var info = (title: "", body: "")
    guard let aps = userInfo["aps"] as? [String: Any] else { return info }
    guard let alert = aps["alert"] as? [String: Any] else { return info }
    let title = alert["title"] as? String ?? ""
    let body = alert["body"] as? String ?? ""
    info = (title: title, body: body)
    return info
}

@objc public extension UIViewController {

    private func swizzled_present(_ viewControllerToPresent: UIViewController, animated: Bool, completion: (() -> Void)?) {

        if #available(iOS 13.0, *) {
            if viewControllerToPresent.modalPresentationStyle == .automatic || viewControllerToPresent.modalPresentationStyle == .pageSheet {
                viewControllerToPresent.modalPresentationStyle = .fullScreen
            }
        }

        self.swizzled_present(viewControllerToPresent, animated: animated, completion: completion)
    }

    @nonobjc private static let _swizzlePresentationStyle: Void = {
        let instance: UIViewController = UIViewController()
        let aClass: AnyClass! = object_getClass(instance)

        let originalSelector = #selector(UIViewController.present(_:animated:completion:))
        let swizzledSelector = #selector(UIViewController.swizzled_present(_:animated:completion:))

        let originalMethod = class_getInstanceMethod(aClass, originalSelector)
        let swizzledMethod = class_getInstanceMethod(aClass, swizzledSelector)

        if let originalMethod = originalMethod, let swizzledMethod = swizzledMethod {
            if !class_addMethod(aClass, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod)) {
                method_exchangeImplementations(originalMethod, swizzledMethod)
            } else {
                class_replaceMethod(aClass, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
            }
        }
    }()

    @objc static func swizzlePresentationStyle() {
        _ = self._swizzlePresentationStyle
    }
}
