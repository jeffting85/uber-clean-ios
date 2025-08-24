//
//  AppDelegate.swift
//  TowRoute User
//
//  Created by Admin on 04/06/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift
import SlideMenuControllerSwift
import Alamofire
import CoreLocation
import GoogleMaps
import SVProgressHUD
import Crashlytics
import FloatRatingView
import Stripe
import FBSDKLoginKit
import FBSDKCoreKit
//import GoogleSignIn

import Firebase
import FirebaseInstanceID
import FirebaseMessaging
import GooglePlaces
import UserNotifications
import FirebaseAuth

enum tripstatus: String {
    case tripSendRequest = "1"
    case tripAccept = "2"
    case tripStart = "3"
    case tripComplete = "4"
    case payConfirm = "Service Paid"
}
enum pushNotification: String {
    case tripSendRequest = "Service Request"
    case tripAccept = "Service Accept"
    case tripStart = "Service Start"
    case tripComplete = "Service Complete"
    case payConfirm = "Service Paid"
}

@UIApplicationMain
class AppDelegate: UIResponder,UIApplicationDelegate,MessagingDelegate {

    var device_token = "123"
     var locationManager: CLLocationManager!
    
      var tripStatus: pushNotification!
    
    var pickupLocation: CLLocation!
    var dropLocation: CLLocation!
    var currentLocation: CLLocation!
    var bearerToken = ""
    var window: UIWindow?
    var slideMenuController: SlideMenuController!
    let USERDEFAULTS = UserDefaults.standard
   
    let googleApiKey = "AIzaSyDuQY-uO9-GbTMztijC72zp4JS8l7-7nQg" //***** TowRoute
    
    
     let STORYBOARD = UIStoryboard(name: "Main", bundle: nil)
    
    var selectedCat = ""
    var selectedCatInSpanish = ""
    var selectedService = ""
    var selectedServiceInSpanish = ""
    
    var selectedCatID = ""
    var selectedServiceID = ""
    
    var servicePrice = "0"
    var driverName = ""
    var driverID = ""
    var bookingAddress = ""
    
    var pickupLoationAddress = ""
    
    var showRequest = false
    
    var stripToken = ""
    
    var isBookLater = false
    
    var schedulTime = ""
    var schedulDate = ""
    
    var isFromImg = false
    
    var userRating = "0.0"
    
    var isShowLogin = false
    
    var dropLoationAddress = "NoDrop"
    
    var isdroplocationcategory = true
       // private var reachability : Reachability!
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        appearance()
  
        UIViewController.swizzlePresentationStyle()

        LanguageManager.shared.defaultLanguage = .en
        
        FirebaseApp.configure()
        
        Auth.auth().signInAnonymously() { (authResult, error) in
          
            guard let user = authResult else { return }
            let isAnonymous = user.user.isAnonymous  // true
            let uid = user.user.uid
            
        }
    
        //Stripe.setDefaultPublishableKey("pk_test_WDP0fwVbtyJzXdGucvd901EJ")
        IQKeyboardManager.shared.enable = true
     
       // IQKeyboardManager.sharedManager().enable = true
        
        GMSServices.provideAPIKey(googleApiKey)
     
        GMSPlacesClient.provideAPIKey(googleApiKey)
        
        application.applicationIconBadgeNumber = 0
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            // For iOS 10 data message (sent via FCM
            Messaging.messaging().delegate = self
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        if let lang = USERDEFAULTS.value(forKey: "Language") {
            
            userlang = "\(lang)"
            
        }
        
     /*   if USERDEFAULTS.bool(forKey: "login already") {

            let accesstoken = USERDEFAULTS.value(forKey: "access_token")
            APPDELEGATE.bearerToken = accesstoken as! String

            let userdict = USERDEFAULTS.getLoggedUserDetails()
            
            if let invite_code = userdict["invite_code"] {
                
                invitecode = "\(invite_code)"
                
            }
            
            updateHomeView()

        }
        else {

        //SVProgressHUD.show()

        updateLoginView()

        }*/
        
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        
//        GIDSignIn.sharedInstance().clientID = "183986829626-r102vu9que8sln1vfbu4qlji51vfm7in.apps.googleusercontent.com"
        
       
   //     TWTRTwitter.sharedInstance().start(withConsumerKey: "RpRgLtHDWcMG70WIELyV2Gc4j", consumerSecret: "ToTWuX1eUw0yhskZd5XsLVPgJRvYR2wtUsJE7TtWpe8Cdt4IFL")
        return true
    }
    
    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        let sourceApplication =  options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String
        let annotation = options[UIApplicationOpenURLOptionsKey.annotation]
        
        let handle = ApplicationDelegate.shared.application(app, open: url, sourceApplication: sourceApplication, annotation: annotation)
        
   //     let GIDhandle = GIDSignIn.sharedInstance().handle(url, sourceApplication: sourceApplication, annotation: annotation)
        
    //    let twitterhandle = TWTRTwitter.sharedInstance().application(app, open: url, options: options)
        
        return handle //|| GIDhandle //|| twitterhandle
        
        
    }


    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
  
    
    
    
    func updateLoginView(){
        
        USERDEFAULTS.set(false, forKey: "login already")
        
        if userstatusRef != nil {
            
            userstatusRef.removeAllObservers()
            
        }
        
        userstatusRef = nil
        
        if userwalletRef != nil {
        
            if querywallethandle != nil {
                
                userwalletRef.removeObserver(withHandle: querywallethandle)
                
            }
            
            userwalletRef.removeAllObservers()
            
            userwalletRef = nil
            
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
        
        let loginVC = STORYBOARD.instantiateViewController(withIdentifier: "view")
        self.window?.rootViewController = loginVC
        window?.makeKeyAndVisible()
    }
    
    var userstatusRef: DatabaseReference! = nil
    
    var querywallethandle: UInt! = nil
    
    var userwalletRef: DatabaseReference! = nil
    
    var querycurrencyhandle: UInt! = nil
    
    var usercurrencyRef: DatabaseReference! = nil
    
    var querycurrencySymhandle: UInt! = nil
    
    var usercurrencySymRef: DatabaseReference! = nil
    
    var queryratinghandle: UInt! = nil
    
    var userratingtRef: DatabaseReference! = nil
    
    var userWallet = "0"
    
    var ispayonline = false
    
    func updateHomeView() {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        SlideMenuOptions.contentViewScale = 1.0
        let menuPage = storyBoard.instantiateViewController(withIdentifier: "menuvc") as! MenuViewController
        let mainPage = storyBoard.instantiateViewController(withIdentifier:"home")
         let isarabic = LanguageManager.shared.currentLanguage == .ar
      //  slideMenuController = SlideMenuController(mainViewController: mainPage, leftMenuViewController: menuPage)
        print("chk_isarabic\(isarabic)")
       slideMenuController = isarabic ? SlideMenuController(mainViewController: mainPage, rightMenuViewController: menuPage) : SlideMenuController(mainViewController: mainPage, leftMenuViewController: menuPage)
        window?.rootViewController = slideMenuController
        window?.makeKeyAndVisible()
    
        //// update firebase
        
        let userdict = USERDEFAULTS.getLoggedUserDetails()
        
        let userid = userdict["id"] as! String
        
        let fireRef = Database.database().reference()
        
        userwalletRef = fireRef.child("users").child(userid).child("wallet")
        
        querywallethandle = userwalletRef.observe(DataEventType.value) { (SnapShot: DataSnapshot) in
            print("SnapShot Wallet \(SnapShot.value)")
            
            if let statusval = SnapShot.value {
                
                self.userWallet = "\(statusval)"
                print(self.userWallet)
                var userInfo = [AnyHashable: Any]()
                userInfo["wallet"] = "\(statusval)"
                let nc = NotificationCenter.default
                nc.post(name: NSNotification.Name("userwallet"), object: self, userInfo: userInfo)
                
            }
            
        }
        
        userratingtRef = fireRef.child("users").child(userid).child("rating")
        
        queryratinghandle = userratingtRef.observe(DataEventType.value) { (SnapShot: DataSnapshot) in
            print("SnapShot \(SnapShot.value)")
            
            if let statusval = SnapShot.value {
                
                self.userRating = "\(statusval)"
                
                let nc = NotificationCenter.default
                nc.post(name: NSNotification.Name("ratingUpdate"), object: self, userInfo: nil)
                
            }
            
        }
        
        usercurrencyRef = fireRef.child("users").child(userid).child("currency")
        
        querycurrencyhandle = usercurrencyRef.observe(DataEventType.value) { (SnapShot: DataSnapshot) in
            print("Currency SnapShot \(SnapShot.value)")
            
            if let statusval = SnapShot.value {
                
                let currencyVal = "\(statusval)"
                
                let splitcur = currencyVal.components(separatedBy: ":")
                
                if splitcur.count > 0 {
                    currenc = splitcur[0]
                    
print("Currency Value \(currenc)")
                    if self.usercurrencySymRef != nil {
                        
                        if self.querycurrencySymhandle != nil {
                            
                            self.usercurrencySymRef.removeObserver(withHandle: self.querycurrencySymhandle)
                            
                        }
                        
                        self.usercurrencySymRef.removeAllObservers()
                        
                        self.usercurrencySymRef = nil
                        
                    }
                    
                   if currenc != "" && currenc != nil {
            
                    
                    print("Currency In Firebase \(currenc)")
                        self.usercurrencySymRef = fireRef.child("currency").child(currenc!)
                        print("self.usercurrencySymRef\(self.usercurrencySymRef)")

                        self.querycurrencySymhandle = self.usercurrencySymRef.observe(DataEventType.value) { (SnapShot: DataSnapshot) in
                            print("Currency Value SnapShot \(SnapShot.value)")
                            

                            if let statusval = SnapShot.value {
                                
                                let statusString = "\(statusval)"
                               
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
                                currencymul = "\(statusval)"
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
        
        if userstatusRef == nil {
            
            userstatusRef = fireRef.child("users").child(userid).child("trips")
            userstatusRef.observe(DataEventType.value) { (SnapShot: DataSnapshot) in
                print("SnapShot \(SnapShot.value)")
                
                if let dict = SnapShot.value as? NSDictionary {
                    
                    if let title = dict["accept_status"] {
                        
                        let state = "\(dict["accept_status"]!)"
                        
                        if state == "yes" {
                            
                            NotificationCenter.default.post(name: Notification.Name("AcceptTrip"), object: nil)
                            
                        }
                        
                        else if state == "1" {
                            
                            NotificationCenter.default.post(name: Notification.Name("RejectTrip"), object: nil)
                            
                            
                        }
                        
                        Database.database().reference().child("users").child(userid).child("trips").child("accept_status").setValue("")
                        
                    }
                    
                }
                
            }
            
        }
        
        
        
        
        
        
    }
        
        
    
    
    func appearance() {
        let navappearance = UINavigationBar.appearance()
        navappearance.tintColor = UIColor.black
      //  navappearance.barTintColor = UIColor(hexString: "#e04f00")
        navappearance.isTranslucent = false
        navappearance.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black]
        let attrs = [
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: UIFont(name: "Calibri", size: 17)!
        ]
        
        let nav =  hasTopNotch
        print(nav)
        UINavigationBar.appearance().titleTextAttributes = attrs
        
        let gradient = CAGradientLayer()
        let sizeLength = UIScreen.main.bounds.size.height * 2
        var defaultNavigationBarFrame = CGRect()
        if nav ==  true
        {
        defaultNavigationBarFrame = CGRect(x: 0, y: 0, width: sizeLength, height: 98)
        }
        else
        {
        defaultNavigationBarFrame = CGRect(x: 0, y: 0, width: sizeLength, height: 78)
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

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "TOWROUTE USER")
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
    

    

    
}

    extension AppDelegate {
        
        
        
        func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//            if let refreshedToken = InstanceID.instanceID().token() {
//                      print("InstanceID token: \(refreshedToken)")
//                      self.device_token = refreshedToken
//                  }
                  
            
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
                  
//                  let firebaseAuth = Auth.auth()
//
//                  //At development time we use .sandbox
//                  firebaseAuth.setAPNSToken(deviceToken, type: AuthAPNSTokenType.sandbox)
                  
        }
        var applicationStateString: String {
            if UIApplication.shared.applicationState == .active {
                return "active"
            } else if UIApplication.shared.applicationState == .background {
                return "background"
            }else {
                return "inactive"
            }
        }
        func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
            print("Firebase registration token: \(fcmToken)")
            
            let dataDict:[String: String] = ["token": fcmToken]
            NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
            // TODO: If necessary send token to application server.
            // Note: This callback is fired at each app startup and whenever a new token is generated.
        }
        
        func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
            NSLog("[RemoteNotification] didRefreshRegistrationToken: \(fcmToken)")
            self.device_token = fcmToken
            print("checkktokenns\(fcmToken)")
            
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
        
        
        
        
        
    }
  extension AppDelegate {
      
      
      
      
      func application(_ application: UIApplication,
                       didReceiveRemoteNotification notification: [AnyHashable : Any],
                       fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
          print("Notification  :  ", notification)
          if #available(iOS 10.0, *) {
              let content = UNMutableNotificationContent()
            content.sound = UNNotificationSound.default()
          }
          
          
          else {
              // Fallback on earlier versions
          }
          
          completionHandler(.newData)
          
      }
      
      
      func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
          
          print("Error in Notification  \(error.localizedDescription)")
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
        
        if UIApplication.shared.applicationState == .active {
            //TODO: Handle foreground notification
        } else {
            //TODO: Handle background notification
        }
        
        // driverRequest(userInfo: userInfo)
        
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
//func extractUserInfo(userInfo: [AnyHashable : Any]) -> (title: String, body: String) {
//    var info = (title: "", body: "")
//    guard let aps = userInfo["aps"] as? [String: Any] else { return info }
//    guard let alert = aps["alert"] as? [String: Any] else { return info }
//    let title = alert["title"] as? String ?? ""
//    let body = alert["body"] as? String ?? ""
//    info = (title: title, body: body)
//    return info
//}
//
var hasTopNotch: Bool {
    if #available(iOS 11.0, tvOS 11.0, *) {
        // with notch: 44.0 on iPhone X, XS, XS Max, XR.
        // without notch: 24.0 on iPad Pro 12.9" 3rd generation, 20.0 on iPhone 8 on iOS 12+.
        return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 24
    }
    return false
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
