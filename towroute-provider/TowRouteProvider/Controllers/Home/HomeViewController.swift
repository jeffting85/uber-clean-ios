//
//  HomeViewController.swift
//  TowRoute Provider
//
//  Created by Uplogic Technologies on 08/06/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import Alamofire
import Firebase
import GeoFire
import MessageUI

class HomeViewController: UIViewController, MFMessageComposeViewControllerDelegate {

    @IBOutlet var profileimg: UIImageView!
    @IBOutlet var pendinglab: UILabel!
    @IBOutlet var upcominglab: UILabel!
    
    @IBOutlet var pendingimg: UIImageView!
    @IBOutlet var upcomingimg: UIImageView!
    
    @IBOutlet var menubtn: UIButton!
    
    @IBOutlet var username: UILabel!
    
    @IBOutlet var workloc: UILabel!
    
    var querystatushandle: UInt! = nil
    var queryapprovedhandle: UInt! = nil
    
    var geoFire: GeoFire! = nil
    var geoHash: GFGeoHash!
    
    var geofirechildRef: DatabaseReference!
    var fireRef: DatabaseReference!
     var drivers_statusRef: DatabaseReference!
    var driverstatusRef: DatabaseReference! = nil
    
    var mail = ""
    var fname = ""
    var lname = ""
    
    @IBOutlet var driverSwitch: UISwitch!
    @IBOutlet var driverStatusLab: UILabel!
    @IBOutlet var worklab: UILabel!
    @IBOutlet var noapprovelab: UILabel!
    @IBOutlet var adminlab: UILabel!
    
    @IBOutlet weak var navbackimg: UIImageView!
    var app_title = ""
    
    @IBOutlet weak var Currency_update: UIButton!
    @IBOutlet weak var language_btn: UIButton!

    var langtxt  = ""

    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func alertAct(_ sender: Any) {
        
        getContact()
        
    }
    
    var contactcat = NSMutableArray()
    
    
    
            @IBAction func currency_update(_ sender: Any) {
                
                let changecurrency = STORYBOARD.instantiateViewController(withIdentifier: "Currency")
                changecurrency.modalPresentationStyle = .overCurrentContext
                changecurrency.modalTransitionStyle = .crossDissolve
                (self.slideMenuController()?.mainViewController)?.present(changecurrency, animated: false, completion: nil)
                self.slideMenuController()?.closeLeft()
                self.slideMenuController()?.closeRight()
    //
                
            }
        
        
        @IBAction func language_act(_ sender: Any) {
            
            let changelanguage = STORYBOARD.instantiateViewController(withIdentifier: "language")
            changelanguage.modalPresentationStyle = .overCurrentContext
            changelanguage.modalTransitionStyle = .crossDissolve
            (self.slideMenuController()?.mainViewController)?.present(changelanguage, animated: false, completion: nil)
            self.slideMenuController()?.closeLeft()
            self.slideMenuController()?.closeRight()

            
        }

    func getContact() {
        
        let userdict = USERDEFAULTS.getLoggedUserDetails()
        
        let userid = userdict["id"] as! String
        
        let params = ["driver_id":userid]
        
        print("params \(params)")
        
        APIManager.shared.contactGet(params: params as [String : AnyObject]) { (response) in
            
            print("responseveess\(response)")
            if case let msg as String = response?["message"], msg == "Unauthenticated." {
                
                APIManager.shared.refreshToken(params: params as [String : AnyObject]) { (response) in
                    
                    if case let access_token as String = response?["access_token"] {
                        
                        APPDELEGATE.bearerToken = access_token
                        
                        USERDEFAULTS.set(access_token, forKey: "access_token")
                        
                        
                    }
                        
                    else {
                        
                        self.showAlertView(title: "TOWROUTE PROVIDER".localized, message: "Your session has expired. Please log in again", callback: { (check) in
                            
                            APPDELEGATE.updateLoginView()
                            
                        })
                        
                    }
                    
                }
            }
            else if case let details as NSArray = response?["data"], details.count > 0 {
                
                self.contactcat = details.mutableCopy() as! NSMutableArray
                
                var contactnumbers = [String]()
                
                for con in self.contactcat {
                    
                    let dict = con as!NSDictionary
                    let contactnum = dict.object(forKey: "phone_number") as! String
                    contactnumbers.append(contactnum)
                }
                
                if contactnumbers.count > 0 {
                    
                    if LanguageManager.shared.currentLanguage == .en{
                    if (MFMessageComposeViewController.canSendText()) {
                    let controller = MFMessageComposeViewController()
                    controller.body = "\(msgsubject) \n \(msgcontent) https://www.google.co.in/maps/dir/?saddr=&daddr=\(APPDELEGATE.driverLocation.coordinate.latitude),\(APPDELEGATE.driverLocation.coordinate.longitude)&directionsmode=driving"
                    controller.recipients = contactnumbers
                    controller.messageComposeDelegate = self
                    self.present(controller, animated: true, completion: nil)
                    }
                    }
                    else{
                    if (MFMessageComposeViewController.canSendText()) {
                    let controller = MFMessageComposeViewController()
                    controller.body = "\(msgsubject_ar) \n \(msgcontent_ar) https://www.google.co.in/maps/dir/?saddr=&daddr=\(APPDELEGATE.driverLocation.coordinate.latitude),\(APPDELEGATE.driverLocation.coordinate.longitude)&directionsmode=driving"
                    controller.recipients = contactnumbers
                    controller.messageComposeDelegate = self
                    self.present(controller, animated: true, completion: nil)
                    }
                    }
                    
                }
                
            }
            else if case let details as NSArray = response?["data"], details.count == 0 {
                
                let navview = self.storyboard?.instantiateViewController(withIdentifier: "emergencynav") as! UINavigationController
                let viw = navview.viewControllers[0] as! EmergencycontactViewController
                viw.ispresent = true
                self.present(navview, animated: true, completion: nil)
                
            }
            else if case let message as String = response?["message"], message == "No records Found." {
                
                let navview = self.storyboard?.instantiateViewController(withIdentifier: "emergencynav") as! UINavigationController
                let viw = navview.viewControllers[0] as! EmergencycontactViewController
                viw.ispresent = true
                self.present(navview, animated: true, completion: nil)
                
            }
            // Do any additional setup after loading the view.
        }
        
    }
  var jobRef: DatabaseReference! = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        let fireRefs = Database.database().reference()
        jobRef = fireRefs.child("providers").child(driver_id)
        jobRef.observe(DataEventType.value) { (SnapShot: DataSnapshot) in
            print("SnapShot \(SnapShot.value)")
            
            if let dict = SnapShot.value as? NSDictionary {
                
                if let status = dict["pending"] {
                    
                    let pend = "\(dict["pending"]!)"
                    if pend == ""
                    {
                         self.pendinglab.text = "0"
                    }
                    else
                    {
                    self.pendinglab.text = "\(dict["pending"]!)"
                    }
                }
                
                if let status1 = dict["upcoming"] {
                    
                    let upcom = "\(dict["upcoming"]!)"
                    if upcom == ""
                    {
                        self.upcominglab.text = "0"
                    }
                    else
                    {
                    self.upcominglab.text = "\(dict["upcoming"]!)"
                    }
                }
                
                // Do any additional setup after loading the view.
            }
        }
        
        
        
        
        
        
        
        
        
        
        
        workloc.text = driverAddress
        
        fireRef = Database.database().reference()
        
        geoHash = GFGeoHash()
        
        geofirechildRef = fireRef.child("drivers_location").child(driver_id)
        
        geoFire = GeoFire(firebaseRef: geofirechildRef)
        
        profileimg.layer.addShadow()
        profileimg.layer.roundCorners(radius: 50)
        
        pendingimg.layer.cornerRadius = 35
        pendingimg.layer.borderColor = UIColor(hexString: "00d5ff")?.cgColor
        pendingimg.layer.borderWidth = 1
        
        upcomingimg.layer.cornerRadius = 35
        upcomingimg.layer.borderColor = UIColor(hexString: "00d5ff")?.cgColor
        upcomingimg.layer.borderWidth = 1
        
        menubtn.setImage(#imageLiteral(resourceName: "menu-1").resize(toWidth: 30), for: UIControlState.normal)
        
        refreshData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("ProfileUpdate"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.locationNotification(notification:)), name: Notification.Name("LocationUpdate"), object: nil)
        
       // self.title = "TowRoute"
        
        let imageView = UIImageView()
        imageView.frame.size.width = 150
        imageView.frame.size.height = 100
        imageView.contentMode = .scaleAspectFit
        let images = UIImage(named: "Spotntow_logo_trans")
        imageView.image = images
        navigationItem.titleView = imageView
    

        
        let driverapprovedRef = Database.database().reference().child("providers").child(driver_id).child("approved")
        
        queryapprovedhandle = driverapprovedRef.observe(DataEventType.value) { (SnapShot: DataSnapshot) in
            print("SnapShot \(SnapShot.value)")
            
            if let statusval = SnapShot.value {
                
                let statusvalue = "\(statusval)"
                
                if statusvalue == "1" {
                    
                    Database.database().reference().child("providers").child(driver_id).child("status").setValue("1")
                    APPDELEGATE.driverapproved = true
                    
                    self.driverSwitch.isEnabled = true
                    self.driverSwitch.isOn = true
                    
                    self.workloc.isHidden = false
                    self.worklab.isHidden = false
                    self.noapprovelab.isHidden = true
                    self.adminlab.isHidden = true
                    self.checkAct(self.driverSwitch)
                    
                }
                    
                else {
                    
                    self.driverStatusLab.text = "OFFLINE".localized
                    
                    APPDELEGATE.driverapproved = false
                    
                    self.driverSwitch.isEnabled = false
                    self.driverSwitch.isOn = false
                    
                    self.workloc.isHidden = true
                    self.worklab.isHidden = true
                    self.noapprovelab.isHidden = false
                    self.adminlab.isHidden = false
                    
                }
                
            }
            
        }
        
        
        let driverstatusRef = Database.database().reference().child("providers").child(driver_id).child("status")
        
        querystatushandle = driverstatusRef.observe(DataEventType.value) { (SnapShot: DataSnapshot) in
            print("SnapShot \(SnapShot.value)")
            
            if let statusval = SnapShot.value {
                
                let statusvalue = "\(statusval)"
                
                if statusvalue == "1" {
                    
                    APPDELEGATE.drivercheckin = true
                    
                    self.driverSwitch.isOn = true
                    
                    self.driverStatusLab.text = "ONLINE".localized
                    self.checkAct(self.driverSwitch)
                }
                    
                else {
                    
                    APPDELEGATE.drivercheckin = false
                    
                    self.driverSwitch.isOn = false
                    
                    self.driverStatusLab.text = "OFFLINE".localized
                    
                }
                
            }
            
        }
        
        
        let gradient = CAGradientLayer()
        let sizeLength = UIScreen.main.bounds.size.height * 2
        let defaultNavigationBarFrame = CGRect(x: 0, y: 0, width: sizeLength, height: 150)
        
        gradient.frame = defaultNavigationBarFrame
        let color1 = UIColor.init(hexString: "#00d5ff")
        let color2 = UIColor.init(hexString: "#FFFFFF")
        
        gradient.colors = [color1!.cgColor,color2!.cgColor]//,color3!.cgColor
        
        navbackimg.image = image(fromLayer: gradient)
        navbackimg.transform = navbackimg.transform.rotated(by: CGFloat(Double.pi / 1))
        
       // NotificationCenter.default.addObserver(self, selector: #selector(self.jobnotification(notification:)), name: Notification.Name("jobalert"), object: nil)
        
        self.navigationController?.navigationBar.isTranslucent = false
        // Do any additional setup after loading the view.
    }
    

  
    @objc func jobnotification(notification: Notification){
        
        workloc.text = driverAddress
        
        viewProfile()
        pendingJobs()
        upcomingJobs()
        
    }
    
    
    
    
    
    func viewProfile() {
        
        // profileViewDriver
        
        let userdict = USERDEFAULTS.getLoggedUserDetails()
        
        let userid = userdict["id"] as! String
        
        let params = ["id":userid]
        
        print("params \(params)")
        
        APIManager.shared.profileViewDriver(params: params as [String : AnyObject],showloading: false) { (response) in
            
            if case let msg as String = response?["message"], msg == "Unauthenticated." {
                
                APIManager.shared.refreshToken(params: params as [String : AnyObject]) { (response) in
                    
                    if case let access_token as String = response?["access_token"] {
                        
                        APPDELEGATE.bearerToken = access_token
                        
                        USERDEFAULTS.set(access_token, forKey: "access_token")
                        
                        self.viewProfile()
                        
                    }
                        
                    else {
                        
                        self.showAlertView(title: "TOWROUTE PROVIDER".localized, message: "Your session has expired. Please log in again", callback: { (check) in
                            
                            APPDELEGATE.updateLoginView()
                            
                        })
                        
                    }
                    
                }
                
            }
                
            else if case let msg as String = response?["message"], msg == "Profile listed successfully." {
                
                if case let rating as NSNumber = response?["rating"], "\(rating)" != "" {
                    
                    Database.database().reference().child("providers").child(driver_id).child("rating").setValue(rating)
                    
                }
                
                if let driver_certificate = response?["driver_certificate"] {
                    
                    let driver_cert = "\(driver_certificate)"
                    var myuserinfo = [String: String]()
                    myuserinfo.updateValue(driver_cert, forKey: "driver_cert")
                    
                }
                if case let details as NSDictionary = response?["data"]{
                    
                    if let email = details["email"]{
                          
                        self.mail = "\(email)"
                          print("chkmail\(self.mail)")
                          
                      }
                    if let frstname = details["first_name"]{
                        self.fname = "\(frstname)"
                        print("chkmail\(self.fname)")
                        
                    }
                    if let lstname = details["last_name"]{
                        self.lname = "\(lstname)"
                        print("chkmail\(self.lname)")
                    }
                    
                    

                                        if let selindex1 = details["language"] {
                                            
                                                                self.langtxt = "\(selindex1)"
                                                                
                                                                print("chkself.langtxt\(self.langtxt)")
                                                                
                                                                if self.langtxt == "" {
                                                                    self.language_btn.isHidden = false
                                                                    
                                                                }
                                                                else{
                                                                    self.language_btn.isHidden = true
                                                                }
                                                                
                                            
                                        }
                                        
                                        if case let currency as String = details["currency"] {
                                            
                                            
                                            if currency == ""{
                                                print("chkcurrency1\(currency)")
                                                self.Currency_update.isHidden = false
                                            }
                                            
                                            else{
                                                print("chkcurrency\(currency)")
                                                self.Currency_update.isHidden = true
                                            }
                                            
                                          
                    //                        self.currency.text = currency
                    //                        self.curtxt.text = currency
                                        }
                    
                }
                
                

                
  
                
            }
            
        }
        
    }

    override func viewWillAppear(_ animated: Bool) {
        
        
        
        
        workloc.text = driverAddress
        
        viewProfile()
     //   pendingJobs()
       // upcomingJobs()
        
    }
    
    
    
    func pendingJobs() {
        
        let userdict = USERDEFAULTS.getLoggedUserDetails()
        
        let userid = userdict["id"] as! String
        
        let params = ["user_id": userid,
                      "mode": "driver"]
        
        print("params \(params)")
        
        APIManager.shared.pendingJobs(params: params as [String : AnyObject],showloading: false) { (response) in
            print("responsese\(response)")
            
            if case let msg as String = response?["message"], msg == "Unauthenticated." {
                
                APIManager.shared.refreshToken(params: params as [String : AnyObject]) { (response) in
                    
                    if case let access_token as String = response?["access_token"] {
                        
                        APPDELEGATE.bearerToken = access_token
                        
                        USERDEFAULTS.set(access_token, forKey: "access_token")
                        
                        self.pendingJobs()
                        
                    }
                        
                    else {
                        
                        self.showAlertView(title: "TOWROUTE PROVIDER".localized, message: "Your session has expired. Please log in again", callback: { (check) in
                            
                            APPDELEGATE.updateLoginView()
                            
                        })
                        
                    }
                    
                }
                
            }
                
            else if case let details as NSArray = response?["service_request"] {
                
                self.pendinglab.text = "\(details.count)"
                
            }
            
        }
    }
    
    func upcomingJobs() {
        
        let userdict = USERDEFAULTS.getLoggedUserDetails()
        
        let userid = userdict["id"] as! String
        
        let params = ["user_id": userid,
                      "mode": "driver"]
        
        print("params \(params)")
        
        APIManager.shared.upcomingJobs(params: params as [String : AnyObject],showloading: false) { (response) in
            print("responsese\(response)")
            
            if case let msg as String = response?["message"], msg == "Unauthenticated." {
                
                APIManager.shared.refreshToken(params: params as [String : AnyObject]) { (response) in
                    
                    if case let access_token as String = response?["access_token"] {
                        
                        APPDELEGATE.bearerToken = access_token
                        
                        USERDEFAULTS.set(access_token, forKey: "access_token")
                        
                        self.upcomingJobs()
                        
                    }
                        
                    else {
                        
                        self.showAlertView(title: "TOWROUTE PROVIDER".localized, message: "Your session has expired. Please log in again", callback: { (check) in
                            
                            APPDELEGATE.updateLoginView()
                            
                        })
                        
                    }
                    
                }
                
            }
                
            else if case let details as NSArray = response?["service_request"] {
                
                self.upcominglab.text = "\(details.count)"
                
            }
            
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //self.profileimg.image = nil
    }
    
    @IBAction func showJobsAct(_ sender: UIButton) {
    
        let yourjob = storyboard?.instantiateViewController(withIdentifier:"yourjob") as! YourjobParentViewController
        self.slideMenuController()?.closeLeft()
        self.slideMenuController()?.closeRight()
        
        if sender.tag == 1 {
            
            yourjob.showUpcoming = true
            
        }
        
        
        (self.slideMenuController()?.mainViewController as! UINavigationController).pushViewController(yourjob, animated: true)
        
    }
    
    func displayLocationEnableMessage() {
        
        let alertController = UIAlertController (title: app_title, message: "Location access is currently disable. Turn access on?", preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Yes", style: .default) { (_) -> Void in
            guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        print("Settings opened: \(success)") // Prints true
                    })
                } else {
                    // Fallback on earlier versions
                    UIApplication.shared.openURL(settingsUrl)
                }
            }
        }
        alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: "No", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    @IBAction func checkAct(_ sender: UISwitch) {
        
        
        
        let userdict = USERDEFAULTS.getLoggedUserDetails()
        
        let userid = userdict["id"] as! String
        
        if CLLocationManager.locationServicesEnabled() == false {
            
            if (UIDevice.current.systemVersion as NSString).floatValue >= 8.0 {
                
                APPDELEGATE.getlocation()
                
            }
            
        }
        else {
            
            let status: CLAuthorizationStatus = CLLocationManager.authorizationStatus()
            if status == .denied || status == .restricted
            {
                displayLocationEnableMessage()
            }
            else {
                APPDELEGATE.getlocation()
            }
            
        }
        
        
        if sender.isOn {
            
            print("chkdrivmail1\(mail)")
            print("chkfnam1\(fname)")
            print("chklname1\(lname)")
            
            APPDELEGATE.drivercheckin = true
            
            Database.database().reference().child("providers").child(driver_id).child("status").setValue("1")
            
            fireRef = Database.database().reference()
                   geofirechildRef = fireRef.child("drivers_location").child(driver_id)
                   
                   geoFire = GeoFire(firebaseRef: geofirechildRef)
                   
                   drivers_statusRef = fireRef.child("drivers_status").child(driver_id)
                   
                   driverstatusRef = drivers_statusRef.child("status")
                   
            
            drivers_statusRef.child("categoryid").setValue(driver_id)
            drivers_statusRef.child("category").setValue(driver_car_type)
            drivers_statusRef.child("fname").setValue(fname)
            drivers_statusRef.child("lname").setValue(lname)
            drivers_statusRef.child("email").setValue(mail)
            drivers_statusRef.child("Device").setValue("iOS")
           
            
            let userloc = APPDELEGATE.driverLocation
            
            if geoFire != nil {
                
                geoHash = GFGeoHash(location: userloc.coordinate)
                
                let locarr = [userloc.coordinate.latitude,userloc.coordinate.longitude]
                
                geofirechildRef.updateChildValues(["g": geoHash.geoHashValue,
                                                   "l": locarr])
                
                
            }
            
            /* let params = ["id":userid,
                      "current_lat":APPDELEGATE.driverLocation.coordinate.latitude.toString(),
                      "current_lon":APPDELEGATE.driverLocation.coordinate.longitude.toString(),
                      "status":"1"]
            
            APIManager.shared.checkin(params: params as [String : AnyObject]) { (response) in
                
                if case let msg as String = response?["message"], msg == "Unauthenticated." {
                    
                    APIManager.shared.refreshToken(params: params as [String : AnyObject]) { (response) in
                        
                        if case let access_token as String = response?["access_token"] {
                            
                            APPDELEGATE.bearerToken = access_token
                            
                            USERDEFAULTS.set(access_token, forKey: "access_token")
                            
                            self.checkAct(UISwitch())
                            
                        }
                            
                        else {
                            
                            self.showAlertView(title: "TOWROUTE".localized, message: "Your session has expired. Please log in again", callback: { (check) in
                                
                                NotificationCenter.default.removeObserver(self)
                                
                                APPDELEGATE.updateLoginView()
                                
                            })
                            
                        }
                        
                    }
                    
                }
                
                else if case let msg as String = response?["message"], msg != "Unauthenticated."{
                    
                    self.showAlertView(message: msg)
                    
                }
                
            } */
            
        }
        else {
            
            APPDELEGATE.drivercheckin = false
            
            Database.database().reference().child("providers").child(driver_id).child("status").setValue("0")
            
            let userloc = CLLocation(latitude: 0, longitude: 0)
            
            if geoFire != nil {
                
                geoHash = GFGeoHash(location: userloc.coordinate)
                
                let locarr = [userloc.coordinate.latitude,userloc.coordinate.longitude]
                
                geofirechildRef.updateChildValues(["g": geoHash.geoHashValue,
                                                   "l": locarr])
                
                
            }
            
            /* let params = ["id":userid,
                      "status":"0"]
            
            APIManager.shared.checkout(params: params as [String : AnyObject]) { (response) in
                
                if case let msg as String = response?["message"], msg == "Unauthenticated." {
                    
                    APIManager.shared.refreshToken(params: params as [String : AnyObject]) { (response) in
                        
                        if case let access_token as String = response?["access_token"] {
                            
                            APPDELEGATE.bearerToken = access_token
                            
                            USERDEFAULTS.set(access_token, forKey: "access_token")
                            
                            self.checkAct(UISwitch())
                            
                        }
                            
                        else {
                            
                            self.showAlertView(title: "TowRoute".localized, message: "Your session has expired. Please log in again", callback: { (check) in
                                
                                NotificationCenter.default.removeObserver(self)
                                
                                APPDELEGATE.updateLoginView()
                                
                            })
                            
                        }
                        
                    }
                    
                }
                
                else if case let msg as String = response?["message"], msg != "Unauthenticated."{
                    
                    self.showAlertView(message: msg)
                    
                }
                
            } */
            
        }
        
    }
    
    @objc func methodOfReceivedNotification(notification: Notification){
        
        refreshData()
        
    }
    
    @objc func locationNotification(notification: Notification){
        
        workloc.text = driverAddress
        
    }
    
    func refreshData() {
        
        self.profileimg.layer.cornerRadius = 50
        self.profileimg.layer.masksToBounds = true
        self.profileimg.layer.borderWidth = 3
        self.profileimg.layer.borderColor = UIColor.white.cgColor
        let userdict = USERDEFAULTS.getLoggedUserDetails()
        
        if case let avatar as String = userdict["avatar"] {
            
            if avatar == "uploads/" || avatar == "<null>" {
                self.profileimg.image =  #imageLiteral(resourceName: "user(1)")
            }
            
            else if(!(avatar.isEmpty)){
                
                var newavatar = BASEAPI.IMGURL + avatar
                
                if !newavatar.contains("uploads"){
                    newavatar = BASEAPI.PRFIMGURL + avatar
                }
                
                Alamofire.request(newavatar, method: .get).responseImage { response in
                    guard let image = response.result.value else {
                        // Handle error
                        return
                    }
                    
                    self.profileimg.image = image
                    
//                    self.profileimg.layer.addShadow()
//                    self.profileimg.layer.roundCorners(radius: 50)
                    
                    // Do stuff with your image
                }
                
            }
            
        }
        else {
            self.profileimg.image =  #imageLiteral(resourceName: "user(1)")
        }
        
        if case let first_name as String = userdict["first_name"] {
            
            if(!(first_name.isEmpty)){
                
                username.text = first_name.uppercased() + " "
                
            }
            
        }
        
        if case let last_name as String = userdict["last_name"] {
            
            if(!(last_name.isEmpty)){
                
                username.text = username.text! + last_name.uppercased()
                
            }
            
        }
        
    }
    
    @IBAction func menuAct(_ sender: Any) {
    
        self.slideMenuController()?.openLeft()
        self.slideMenuController()?.openRight()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CALayer {
 
    private func addShadowWithRoundedCorners() {
        if let contents = self.contents {
            masksToBounds = false
            sublayers?.filter{ $0.frame.equalTo(self.bounds) }
                .forEach{ $0.roundCorners(radius: self.cornerRadius) }
            self.contents = nil
            if let sublayer = sublayers?.first,
                sublayer.name == "masklayer" {
                
                sublayer.removeFromSuperlayer()
            }
            let contentLayer = CALayer()
            contentLayer.name = "masklayer"
            contentLayer.contents = contents
            contentLayer.frame = bounds
            contentLayer.cornerRadius = cornerRadius
            contentLayer.masksToBounds = true
            insertSublayer(contentLayer, at: 0)
        }
    }
    
    func addShadow() {
        self.shadowOffset = .zero
        self.shadowOpacity = 0.2
        self.shadowRadius = 10
        self.shadowColor = UIColor.black.cgColor
        self.masksToBounds = false
        if cornerRadius != 0 {
            addShadowWithRoundedCorners()
        }
    }
    func roundCorners(radius: CGFloat) {
        self.cornerRadius = radius
        if shadowOpacity != 0 {
            addShadowWithRoundedCorners()
        }
    }
}

extension String {
    
    func convertCur() -> String {
        
        
      
        print("Currencymul \(currencymul)")
        // currencymul
        
        
        if self != "" && self != nil //currencymulnull
        {
        let convert = (Double(self)!) * (Double(currencymul)!)
        
        let roundedNumber = String(format: "%.2f", Double(convert))
          let conv = Double(roundedNumber)!

        return "\(conv)"
        
        }
        
        else
        {
            return "0"
        }
        
        
        
    }
    
    func convertCurToDollar() -> String {
        
        // currencymul
       
        
        let tot = (Double(self))! / (Double(currencymul)!)
             print("chektoastripe\(tot)")
           let roundedNumber = String(format: "%.2f", Double(tot))
             let conv = Double(roundedNumber)!
        print("chektoastripe\(conv)")

        
        return "\(conv)"
        
//        let convert = Float((self as NSString).doubleValue / (currencymul as NSString).doubleValue)
//
//        if (self as NSString).doubleValue/(currencymul as NSString).doubleValue == (self as NSString).doubleValue{
//            return self
//        }
//
//        else {
//            return "\(convert)"
//        }
        
    }
    
}

