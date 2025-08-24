//
//  JobProgressViewController.swift
//  TowRoute Provider
//
//  Created by Uplogic Technologies on 03/07/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import HCSStarRatingView
import GoogleMaps
import JVFloatLabeledTextField
import Firebase
import MessageUI
import SVProgressHUD
import Alamofire

class JobProgressViewController: UIViewController,UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate, MFMessageComposeViewControllerDelegate,CLLocationManagerDelegate,ARCarMovementDelegate{
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet var tableview: UITableView!
    @IBOutlet var progressTable: UITableView!
    @IBOutlet var starrating: HCSStarRatingView!
    
    @IBOutlet weak var mapviewTop: NSLayoutConstraint!
    @IBOutlet weak var finishBtn: UIButton!
    var menustr = ["Call".localized,"Message".localized,"View User".localized,"Cancel Job".localized]
    
    var msgstr = [] as [String]
    
    @IBOutlet var menuview: UIView!

    var cusname = ""
    let locationManager = CLLocationManager()
    var pickuploc = ""
    
    var customer_lat = "0.0"
    var customer_lon = "0.0"
    
    var customer_id = ""
    
    var payment_type = ""
    
    var booking_id = ""
    
     
    
    var request_status = ""
    var dropLocation = ""
    @IBOutlet var jobloclab: UILabel!
    @IBOutlet var mapview: GMSMapView!
    
    var carmarker = GMSMarker()
    var moveMent: ARCarMovement!
    var peoplemarker = GMSMarker()
    
    @IBOutlet var joblocback: UILabel!
    @IBOutlet var jobloclab1: UILabel!
    
    var service_status = ""
    var cardstate = ""
    @IBOutlet var beginview1: UIView!
    @IBOutlet var beginview2: UIView!
    
    @IBOutlet var usernamelab: UILabel!
    @IBOutlet var loclab: UILabel!
    
    var accept_time = ""
    var reach_time = ""
    var start_time = ""
    var service_start_time = ""
    
    var category = ""
    
    var unit_price = ""
    
    var promocodeval = ""
    var cardStatus = ""
    @IBOutlet var calview: UIView!
    
    @IBOutlet var chargelab: UILabel!
    @IBOutlet var totallab: UILabel!
    
    @IBOutlet weak var driverDiscountLbl: UILabel!
    @IBOutlet var matfeetxt: JVFloatLabeledTextField!
    @IBOutlet var miscfeetxt: JVFloatLabeledTextField!
    @IBOutlet var discountfeetxt: JVFloatLabeledTextField!
    @IBOutlet var userimg: UIImageView!
    @IBOutlet var username: UILabel!
    @IBOutlet var bookingid: UILabel!
    @IBOutlet var mobile: UILabel!
    
    @IBOutlet var cusview: UIView!
    @IBOutlet weak var retryview: UIView!
    @IBOutlet weak var waitingview: UIView!
    
    var startLocation: CLLocation!
    var lastLocation: CLLocation!
    var startDate: Date!
    var traveledDistance: Double = 0
    var traveledDistanceInKm = "0.0km"
    
    @IBOutlet weak var userimage: UIImageView!
    
    var visit_fare = "0"
    var price_per_km = "0"
    var sub_level_amount = "0"
    var mat_fee = "0"
    var mis_fee = "0"
    var discount_fee = "0"
    var distance = ""
    var address = ""
    
    var oldCoordinate: CLLocationCoordinate2D!
    
    @IBOutlet weak var currentchargelabel: UILabel!
    @IBOutlet weak var distanceview: UIView!
    @IBOutlet weak var materialtopcons: NSLayoutConstraint!
    @IBOutlet weak var fareDistanceTitle: UILabel!
    @IBOutlet weak var fareDistanceValue: UILabel!
    @IBOutlet weak var heightcons: NSLayoutConstraint!
    
    @IBOutlet weak var waitingviewTxt: UILabel!
    var drop_lat = ""
    var drop_lon = ""
    @IBOutlet weak var stackviewoutlet: UIStackView!
    
    @IBOutlet weak var livetrackBtnOutlet: UIButton!
    
    @IBOutlet weak var tabView: UIView!
    @IBOutlet weak var jobinprogressoutlet: UIButton!
    
    @IBOutlet weak var jobdroplab: UILabel!
    @IBOutlet weak var jobdroploclab_ht: NSLayoutConstraint!
    
    @IBOutlet weak var nav_backView_width: NSLayoutConstraint!
    @IBOutlet weak var navLbl: UILabel!
    @IBOutlet weak var navBtn: UIButton!
    @IBOutlet weak var navBtn_img: UIButton!
    
   
    var timer: Timer?
    var firsttime = true

    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        print("textField \(textField.text!)")
        
        var mainfee = matfeetxt.text!
        var miscfee = miscfeetxt.text!
        var discountfee = discountfeetxt.text!
        var chargefee = chargelab.text!.replacingOccurrences(of: "\(currency_symbol!)", with: "")
        
        if mainfee == "" {
            
            mainfee = "0"
            
        }
        
        if miscfee == "" {
            
            miscfee = "0"
            
        }
        
        if discountfee == "" {
            
            discountfee = "0"
            
        }
        
        if chargefee == "" {
            
            chargefee = "0"
            
        }
        
        print("chargefee \(chargefee)")
        
        let total = Double("\(chargefee)")! + Double(mainfee)! + Double(miscfee)! - Double(discountfee)!
        
        totallab.text = "\(currency_symbol!)" + "\(total)"
        
        if sub_level_amount != ""{
            if visit_fare != "0"{
                
                if dropLocation == "NoDrop"
                {
                    let total1 = Double("\(chargefee)")! + Double(mainfee)! + Double(miscfee)! - Double(discountfee)!
                    totallab.text = "\(currency_symbol!)" + String(format: "%.2f", (Double("\(total1)")!))
                }
                    
                else
                {
                let total1 = Double("\(chargefee)")! + Double(mainfee)! + Double(miscfee)! - Double(discountfee)! + (Double(price_per_km)! * Double(String(format: "%.2f", (Double("\(self.traveledDistance)")!)))!)
                totallab.text = "\(currency_symbol!)" + String(format: "%.2f", (Double("\(total1)")!))
                }
            }
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
    }
    
    @IBAction func alertAct(_ sender: Any) {
        
        print("alertact")
        
        getContact()
        
    }
    
    @IBAction func finshBtnActn(_ sender: Any) {
        
        if cardStatus == "0"
        {
           self.showAlertView(message: "Wait a moment!User can able to pay with card on current job".localized)
        }
            
        else if cardStatus == "1"
        
        {
            var params = [String:Any]()
            print(dropLocation)
            if dropLocation == "NoDrop"
            {
                params = ["mode":"finish_service",
                          "driver_id":driver_id,
                          "booking_id":self.booking_id,
                          "material_fee":mat,
                          "misc_charge":misc,
                          "driver_discount":discounttext,
                          "payment_type":"card",
                          "customer_id":self.customer_id,
                          "distance":distancetext,
                          "promocode":self.promocodeval,
                          "drop_lat":"\(APPDELEGATE.driverLocation.coordinate.latitude)",
                    "drop_lon":"\(APPDELEGATE.driverLocation.coordinate.longitude)",
                    "drop_location":"NoDrop"] as [String : Any]
            }
            else
            {
                params = ["mode":"finish_service",
                          "driver_id":driver_id,
                          "booking_id":self.booking_id,
                          "material_fee":mat,
                          "misc_charge":misc,
                          "driver_discount":discounttext,
                          "payment_type":"card",
                          "customer_id":self.customer_id,
                          "distance":distancetext,
                          "promocode":self.promocodeval,
                          "drop_lat":"\(APPDELEGATE.driverLocation.coordinate.latitude)",
                    "drop_lon":"\(APPDELEGATE.driverLocation.coordinate.longitude)",
                    "drop_location":addresstext] as [String : Any]
            }
       
        
        print("params \(params)")
        
        self.complete(params: params as [String : AnyObject])
        }
            
            
        else
        {
            self.showAlertView(message: "Wait for customer payment".localized)
        }
        
        
    }
    var contactcat = NSMutableArray()
    
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
                    
                    if (MFMessageComposeViewController.canSendText()) {
                        let controller = MFMessageComposeViewController()
                        controller.body = "Please Help!! My location for TOWROUTE PROVIDER App https://www.google.co.in/maps/dir/?saddr=&daddr=\(APPDELEGATE.driverLocation.coordinate.latitude),\(APPDELEGATE.driverLocation.coordinate.longitude)&directionsmode=driving"
                        controller.recipients = contactnumbers
                        controller.messageComposeDelegate = self
                        self.present(controller, animated: true, completion: nil)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
     //   tabView.isHidden = false
        
        self.miscfeetxt.delegate = self
        self.discountfeetxt.delegate = self
        self.matfeetxt.delegate = self
        
        driverDiscountLbl.text = "Driver Discount".localized
        moveMent = ARCarMovement()
        moveMent.delegate = self
        
        oldCoordinate = CLLocationCoordinate2DMake(APPDELEGATE.driverLocation.coordinate.latitude, APPDELEGATE.driverLocation.coordinate.longitude)

        
        livetrackBtnOutlet.layer.cornerRadius = 0
        livetrackBtnOutlet.layer.borderWidth = 1
        livetrackBtnOutlet.layer.borderColor = UIColor.init(hexString: "00d5ff")?.cgColor
        
        // jobinprogressoutlet.backgroundColor = UIColor.clear
        jobinprogressoutlet.layer.cornerRadius = 0
        jobinprogressoutlet.layer.borderWidth = 1
        jobinprogressoutlet.layer.borderColor = UIColor.init(hexString: "00d5ff")?.cgColor
        
        
        
        matfeetxt.setBottomBorder()
        miscfeetxt.setBottomBorder()
        discountfeetxt.setBottomBorder()
        matfeetxt.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        miscfeetxt.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        discountfeetxt.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        msgstr = ["You have accepted the request".localized]//,"You have started the trip to User location".localized,"You have arrived at job location".localized]
        
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "dropmenucell")
        
        tableview.rowHeight = UITableViewAutomaticDimension;
        tableview.estimatedRowHeight = 44.0;
        
        starrating.backgroundColor = UIColor.clear
        starrating.emptyStarColor = UIColor.white
        starrating.starBorderColor = UIColor(hex: "F2963C")
        starrating.tintColor = UIColor(hex: "F2963C")
        
        starrating.isEnabled = false
        
        let fireRef = Database.database().reference()
        
        fireRef.child("users").child(customer_id).child("rating").observeSingleEvent(of: DataEventType.value) { (SnapShot: DataSnapshot) in
            
            if let statusval = SnapShot.value {
                
                let rating = "\(statusval)"
                
                print("rating \(rating)")
                
                if rating != "<null>" {
                    
                    self.starrating.value = CGFloat(Double(rating)!)
                    
                }
                
            }
            
        }
        
        if dropLocation == "NoDrop"
        {
        
        jobloclab.text = pickuploc
        jobloclab1.text = pickuploc
        loclab.text = pickuploc
        jobdroploclab_ht.constant = 0
        }
       
        else
        {
            jobloclab.text = "Job Location :- " + pickuploc
            //jobdroplab.text = "Drop Location :- " + dropLocation
            jobloclab1.text = dropLocation
            loclab.text = pickuploc
        }
        print ("Check Customer Name : \(cusname)")
        usernamelab.text = cusname
        
        
        print("unitprice viewdid load \(unit_price)")
        chargelab.text = "\(currency_symbol!)" + unit_price.convertCur()
        totallab.text = "\(currency_symbol!)" + unit_price.convertCur()
        
        dol1.text = "\(currency_symbol!)"
        dol2.text = "\(currency_symbol!)"
        dol3.text = "-\(currency_symbol!)"
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.locationNotification(notification:)), name: Notification.Name("DriverLocationUpdate"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.locationNotification1(notification:)), name: Notification.Name("CancelTrip"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.locationNotificationcard(notification:)), name: Notification.Name("status5.1"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.getWallet1), name: NSNotification.Name(rawValue: "currencySymUpdate"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.getWallet1), name: NSNotification.Name(rawValue: "currencyUpdate"), object: nil)
        
        if APPDELEGATE.driverLocation.coordinate.latitude != 0.0 {
            
            let cameras = GMSCameraPosition.camera(withLatitude: APPDELEGATE.driverLocation.coordinate.latitude, longitude: APPDELEGATE.driverLocation.coordinate.longitude, zoom: 16.0)
            
            mapview.camera = cameras
            
            self.carmarker.position = CLLocationCoordinate2DMake(APPDELEGATE.driverLocation.coordinate.latitude, APPDELEGATE.driverLocation.coordinate.longitude)
            self.carmarker.icon = #imageLiteral(resourceName: "mapCarIcon64").resize(toWidth: 30)
            self.carmarker.icon = #imageLiteral(resourceName: "mapCarIcon64").resize(toHeight: 60)
            self.carmarker.map = self.mapview
            
        }
        
        if customer_lat != "" {
            
            self.peoplemarker.position = CLLocationCoordinate2DMake(Double(customer_lat)!, Double(customer_lon)!)
            self.peoplemarker.icon = #imageLiteral(resourceName: "pd")
            self.peoplemarker.map = self.mapview
            
        }
        
        print("Check Service Status: \(service_status)")
        
        if service_status == "3" {
            if dropLocation == "NoDrop"
            {
            
            jobloclab.text = "Job Location :- " + pickuploc
            jobloclab1.text = pickuploc
            loclab.text = pickuploc
            jobdroploclab_ht.constant = 0
            }
           
            else
            {
  
                jobdroploclab_ht.constant = 0
                jobloclab.text = "Job Location :- " + pickuploc
                jobloclab1.text = pickuploc
                loclab.text = pickuploc
                jobdroplab.text = "Drop Location :- " + dropLocation
            }
            self.firsttime = true
            tableview.reloadData()
            self.statelab.text = "SLIDE TO ARRIVE JOB LOCATION"//"SLIDE TO ARRIVE JOB".localized
            //self.tripbtn.backgroundColor = UIColor.orange
            msgstr = ["You have accepted the request".localized,"You gets started to Customer Location".localized]
            let toadd = CLLocationCoordinate2DMake(Double(customer_lat)!, Double(customer_lon)!)
            
            let fromadd = CLLocationCoordinate2DMake(APPDELEGATE.driverLocation.coordinate.latitude, APPDELEGATE.driverLocation.coordinate.longitude)

            //let toadd = CLLocationCoordinate2DMake(9.926072, 78.121521)
            
            calculateRoutes(from: fromadd, to: toadd)

           // self.joblocback.isHidden = false
           // self.jobloclab1.isHidden = false
            
        }
        
        if service_status == "4" {
            
            if dropLocation == "NoDrop"
            {
            
            jobloclab.text = "Job Location :- " + pickuploc
            jobloclab1.text = pickuploc
            loclab.text = pickuploc
            jobdroploclab_ht.constant = 0
            }
           
            else
            {

                jobdroploclab_ht.constant = 40
                jobloclab.text = "Job Location :- " + pickuploc
                jobloclab1.text = pickuploc
                loclab.text = pickuploc
                jobdroplab.text = "Drop Location :- " + dropLocation
            }
            self.firsttime = true
            self.nav_backView_width.constant = 0
            self.navLbl.isHidden = true
            self.navBtn.isHidden = true
            self.navBtn_img.isHidden = true

            menustr = ["Call".localized,"Message".localized,"View User".localized,"Cancel Job".localized]
            
         //   self.heightcons.constant = 225
            
            tableview.reloadData()
            msgstr = ["You have accepted the request".localized,"You gets started to Customer Location".localized,"You have arrived at job location".localized]
            
            self.statelab.text = "SLIDE TO BEGIN JOB".localized
            
            if request_status == "0" || request_status == "3" || request_status == ""{
                waitingview.isHidden = false
                retryview.isHidden = true
            }
            
            else if request_status == "2"{
                waitingview.isHidden = true
                retryview.isHidden = false
            }
//            jobinprogressoutlet.setTitleColor(UIColor.white, for: .normal)
//            jobinprogressoutlet.backgroundColor = UIColor.init(hexString: "#393939")
//            livetrackBtnOutlet.backgroundColor = UIColor.white
//            livetrackBtnOutlet.setTitleColor(UIColor.black, for: .normal)
//            self.beginview1.isHidden = false
//            self.beginview2.isHidden = false
            self.tabView.isHidden = false
            //mapviewTop.constant = 37
            
            
        }
        
        if service_status == "5" {
            
            if dropLocation == "NoDrop"
            {
            
            jobloclab.text = "Job Location :- " + pickuploc
            jobloclab1.text = pickuploc
            loclab.text = pickuploc
            jobdroploclab_ht.constant = 0
                
            }
           
            else
            {

                jobdroploclab_ht.constant = 0
                jobloclab.text = "Drop Location :- " + dropLocation
                jobloclab1.text = pickuploc
                loclab.text = pickuploc
                //jobdroplab.text = "Drop Location :- " + dropLocation
            }
            

            menustr = ["Call".localized,"Message".localized,"View User".localized]
            
            self.heightcons.constant = 150
            
            tableview.reloadData()
            
            if drop_lat != ""{
                
                self.peoplemarker.position = CLLocationCoordinate2DMake(Double(drop_lat)!, Double(drop_lon)!)
                self.peoplemarker.icon = #imageLiteral(resourceName: "pd")
                self.peoplemarker.map = self.mapview
                
                let fromadd = CLLocationCoordinate2DMake(Double(drop_lat)!, Double(drop_lon)!)
                
                let toadd = CLLocationCoordinate2DMake(APPDELEGATE.driverLocation.coordinate.latitude, APPDELEGATE.driverLocation.coordinate.longitude)

                //let toadd = CLLocationCoordinate2DMake(9.926072, 78.121521)
                
                calculateRoutes(from: fromadd, to: toadd)
            }
            
            self.statelab.text = "SLIDE TO END JOB".localized
            
           // self.beginview1.isHidden = false
           // self.beginview2.isHidden = false
            self.tabView.isHidden = false
            //mapviewTop.constant = 37
            msgstr = ["You have accepted the request".localized,"You gets start to the job location".localized,"You have arrived to job location".localized,"You have started the job".localized]
            
            if cardstate == "5.1"
            {
                cardstates()
            }
            
        }
        
        
        
        
        self.userimg.layer.cornerRadius = (self.userimg.frame.size.width) / 2
        self.userimg.layer.masksToBounds = true
        
        self.userimage.layer.cornerRadius = (self.userimage.frame.size.width) / 2
        self.userimage.layer.masksToBounds = true
        
        if !(customer_avatar == "") {
            
            var imageUrl: String? = BASEAPI.PRFIMGURL+customer_avatar
            self.userimg.sd_setImage(with: URL(string: imageUrl!), placeholderImage: #imageLiteral(resourceName: "user(1)"))
            self.userimage.sd_setImage(with: URL(string: imageUrl!), placeholderImage: #imageLiteral(resourceName: "user(1)"))
            
        }
            
        else {
            self.userimg.sd_setImage(with: URL(string: ""), placeholderImage: #imageLiteral(resourceName: "user(1)"))
            self.userimage.sd_setImage(with: URL(string: ""), placeholderImage: #imageLiteral(resourceName: "user(1)"))
        }
        
        username.text = customer_name
        bookingid.text = "Booking Id \(booking_id)"
        mobile.text = "Mobile \(customer_phone_number)"
        
        
        if sub_level_amount != ""{
            
            if visit_fare != "0"{
                currentchargelabel.text = "Current Charges".localized+"(\(sub_level_amount.convertCur()))+"+"Visit Price".localized+"(\(visit_fare.convertCur()))"
                chargelab.text = String(format: "%.2f", (Double(sub_level_amount.convertCur())! + Double(visit_fare.convertCur())!))
                let total1 = Double("\(chargelab.text!)")!
                chargelab.text = "\(currency_symbol!)" + String(format: "%.2f", (Double(sub_level_amount.convertCur())! + Double(visit_fare.convertCur())!))
                totallab.text = "\(currency_symbol!)" + String(format: "%.2f", (Double("\(total1)")!))
                distanceview.isHidden = false
            }
            
            else {
                materialtopcons.constant = -41
                distanceview.isHidden = true
            }
        }
        
        
        
        // Do any additional setup after loading the view.
    }
    @IBAction func liveTrackBtnActn(_ sender: Any) {
        
        livetrackBtnOutlet.setTitleColor(UIColor.white, for: .normal)
        livetrackBtnOutlet.backgroundColor = UIColor.init(hexString: "#393939")
        jobinprogressoutlet.backgroundColor = UIColor.white
        jobinprogressoutlet.setTitleColor(UIColor.black, for: .normal)
        
        beginview1.isHidden = true
        beginview2.isHidden = true
        //tabView.isHidden = false
       // self.heightcons.constant = 225
        
       
        
        
        
    }
    
    
    @IBAction func jobinprogressBtnTctn(_ sender: Any) {
        
        jobinprogressoutlet.setTitleColor(UIColor.white, for: .normal)
        jobinprogressoutlet.backgroundColor = UIColor.init(hexString: "#393939")
        livetrackBtnOutlet.backgroundColor = UIColor.white
        livetrackBtnOutlet.setTitleColor(UIColor.black, for: .normal)
        beginview1.isHidden = false
        beginview2.isHidden = false
      //  tabView.isHidden = true
        //beginview2.isHidden = false
        
    }
    
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            
            
//            let text = (textField.text! as NSString).replacingCharacters(in: range, with: string)
//            let Regex = "[0-9]"
//            let predicate = NSPredicate.init(format: "SELF MATCHES %@", Regex)
//
//            if textField == matfeetxt || textField == miscfeetxt || textField == discountfeetxt {
//
//                if predicate.evaluate(with: text) || string == ""
//                {
//                    return true
//                }
//                else
//                {
//                    return false
//                }
//            }
    //        else if textField == passwordTxt{
    //
    //            guard let textFieldText = passwordTxt.text,
    //                let rangeOfTextToReplace = Range(range, in: textFieldText) else {
    //                    return false
    //            }
    //            let substringToReplace = textFieldText[rangeOfTextToReplace]
    //            let count = textFieldText.count - substringToReplace.count + string.count
    //            return count <= 6
    //
    //        }
                
                
//            else
//            {
//                return true
//            }
     return (string.containsValidCharacter)
          }
    
    func calculateRoutes(from f: CLLocationCoordinate2D, to t: CLLocationCoordinate2D)  {
        
        var dis = ""
        var dur = ""
        let saddr = "\(f.latitude),\(f.longitude)"
        let daddr = "\(t.latitude),\(t.longitude)"
        let url = "https://maps.googleapis.com/maps/api/directions/json?&origin=\(saddr)&destination=\(daddr)&mode=driving&key=\(googleApiKey)"
        
        print("url route \(url)")
        
        Alamofire.request(url).responseJSON { response in
            
            do {
                let json = try JSONSerialization.jsonObject(with: response.data!, options: .mutableContainers) as! NSDictionary
                
                //We need to get to the points key in overview_polyline object in order to pass the points to GMSPath.
                
                let routes = (json.object(forKey: "routes") as! NSArray)
                
                let status = (json.object(forKey: "status") as! NSString)
                
                if status == "OVER_QUERY_LIMIT" {
                    
                }
                    
                else if routes.count > 0 {
                    
                    //updated directions firebase  json
                    do {
                                      let jsonData = try JSONSerialization.data(withJSONObject: json)
                                      if let jsonString = String(data: jsonData, encoding: .utf8) {
                                          print("jsonvalue\(jsonString)")
                                        //Database.database().reference().child("booking_trips").child(self.booking_id).child("direction").setValue(jsonString)
                                        
                                        Database.database().reference().child("direction").child(driver_id).child("direction").setValue(jsonString)
                                          
                                      }
                                  }
                                  
                                  catch
                                  {
                                      print("something went wrong with parsing json")

                                  }
                    //
                    
                    if let route = ((routes.object(at: 0) as? NSDictionary)?.object(forKey: "overview_polyline") as? NSDictionary)?.value(forKey: "points") as? String {
                        
                        self.mapview.clear()
                        
                        if let routes = json["routes"] as? [Any] {
                            
                            if let route = routes[0] as? [String:Any] {
                                
                                if let legs = route["legs"] as? [Any] {
                                    
                                    if let leg = legs[0] as? [String:Any] {
                                        
                                        if let steps = leg["distance"] as? [String:Any] {
                                            
                                            if let distancetext = steps["text"] as? String {
                                                
                                                    dis = distancetext
                                                
                                            }
                                            
                                        }
                                        else{
                                            dis = "0"
                                        }
                                        
                                        if let steps = leg["duration"] as? [String:Any] {
                                                                              
                                                                              if let durationtext = steps["text"] as? String {
                                                                                 
                                                                            dur = durationtext
                                                                                  
                                                                              }
                                                                              
                                                                          }
                                        else{
                                            dur = "0"
                                        }
                                        
                                        
                                        if self.carmarker != nil{
                                            
                                            print("\(dis) chkhere \(dur)")
                                           
                                         self.carmarker.title = dis + "," + dur
                                          //  self.carmarker.showAlertView()
                                        }
                                        
                                        Database.database().reference().child("providers").child(driver_id).child("est_distance").setValue(dis)
                                        Database.database().reference().child("providers").child(driver_id).child("est_duration").setValue(dur)
                                        
                                        
                                        if let steps = leg["steps"] as? [Any] {
                                            
                                            for step in steps {
                                                
                                                if let step = step as? [String:Any] {
                                                    
                                                    if let polyline = step["polyline"] as? [String:Any] {
                                                        
                                                        if let points = polyline["points"] as? String {
                                                            
                                                            let path  = GMSPath(fromEncodedPath:points)!
                                                            let polyline  = GMSPolyline(path: path)
                                                            polyline.strokeColor = UIColor.black
                                                            polyline.strokeWidth = 5.0
                                                            
                                                            //mapView is your GoogleMaps Object i.e. _mapView in your case
                                                            polyline.map = self.mapview
                                                            
                                                        }
                                                    }
                                                }
                                                
                                            }
                                            
                                            
                                            self.firsttime = false
                                            
                                            self.carmarker.position = CLLocationCoordinate2DMake(f.latitude, f.longitude)
                                            self.carmarker.icon = #imageLiteral(resourceName: "mapCarIcon64").resize(toWidth: 30)
                                             self.carmarker.icon = #imageLiteral(resourceName: "mapCarIcon64").resize(toHeight: 60)
                                            self.carmarker.map = self.mapview
                                            
                                            
                                            self.peoplemarker.position = CLLocationCoordinate2DMake(t.latitude, t.longitude)
                                            self.peoplemarker.icon = #imageLiteral(resourceName: "pd")
                                            self.peoplemarker.map = self.mapview
                                            
                                            let currentZoom = self.mapview.camera.zoom
                                            
                                            let camera = GMSCameraPosition.camera(withLatitude: f.latitude, longitude: f.longitude, zoom: 16)
                                            
                                            self.mapview.camera = camera
                                            
                                        }
                                    }
                                }
                            }
                        }
                        
                    }
                    
                }
                
            } catch {
            }
            
        }
    }

    @objc func getWallet1(_ notification: Notification) {
        
        print("unitprice getWallet1 \(unit_price)")

        chargelab.text = "\(currency_symbol!)" + unit_price.convertCur()
        totallab.text = "\(currency_symbol!)" + unit_price.convertCur()
        
        dol1.text = "\(currency_symbol!)"
        dol2.text = "\(currency_symbol!)"
        dol3.text = "-\(currency_symbol!)"
        
    }
    
    @objc func locationNotification1(notification: Notification){
        
        Database.database().reference().child("providers").child(driver_id).child("trips").child("service_status").setValue("0")
        
        NotificationCenter.default.removeObserver(self)
        
        self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
        
        self.showAlertView(title: "TOWROUTE PROVIDER", message: "Customer Cancel the Service".localized)
  
        

//        self.showAlertView(title: "TowRoute".localized, message: "Customer cancel the service".localized, callback: { (check) in
//
//            // Database.database().reference().child("providers").child(driver_id).child("trips").removeValue()
//            Database.database().reference().child("providers").child(driver_id).child("trips").child("service_status").setValue("0")
//
//            NotificationCenter.default.removeObserver(self)
//
//            self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
//
//        })
        
        
        
        
        
    }
    @objc func locationNotificationcard(notification: Notification){
        
        
        if cardStatus == "1"
        {
            self.calview.isHidden = true
            self.waitingviewTxt.numberOfLines = 2
            self.waitingviewTxt.text = "User paid with current job.Please click finish button to finish the current job services".localized
            self.waitingviewTxt.numberOfLines = 2
            self.waitingview.isHidden = false
            self.finishBtn.isHidden =  false
            
        }
        else
        {
        self.calview.isHidden = true
        self.waitingviewTxt.numberOfLines = 0
        self.waitingviewTxt.text = "Wait a moment! User can able to pay with card on current job".localized
        self.waitingview.isHidden = false
        self.finishBtn.isHidden =  false
            
        }
    }
    
    func cardstates()
    {
        if cardStatus == "1"
        {
            self.calview.isHidden = true
            self.waitingviewTxt.numberOfLines = 2
            self.waitingviewTxt.text = "User paid with current job.Please click finish button to finish the current job services".localized
            self.waitingview.isHidden = false
            self.finishBtn.isHidden =  false
           
        }
        else
        {
            self.calview.isHidden = true
            self.waitingviewTxt.numberOfLines = 0
            self.waitingviewTxt.text = "Wait a moment!User can able to pay with card on current job".localized
            self.waitingview.isHidden = false
            self.finishBtn.isHidden =  false
            
        }
    }
    
    @IBAction func addressAct(_ sender: Any) {
        
        
        var actionSheets: UIAlertController!
        
        let alert = UIAlertController(title: nil, message: "Choose Navigation Option".localized, preferredStyle: .actionSheet)
        alert.modalPresentationStyle = .popover
        
        
        let image = #imageLiteral(resourceName: "waze-3")
        let imageView = UIImageView()
        imageView.image = image
        imageView.frame =  CGRect(x: 25, y: 60, width: 24, height: 24)
        alert.view.addSubview(imageView)
        
        let image1 = #imageLiteral(resourceName: "google")
        let imageView1 = UIImageView()
        imageView1.image = image1
        alert.view.addSubview(imageView1)
        imageView1.frame = CGRect(x: 25, y: 117, width: 24, height: 24)
        
        let image2 = #imageLiteral(resourceName: "Map")
        let imageView2 = UIImageView()
        imageView2.image = image2
        alert.view.addSubview(imageView2)
        imageView2.frame = CGRect(x: 25, y: 177, width: 24, height: 24)
        
        
        
        
        let mylat = customer_lat
        let mylong = customer_lon
        
        let openWaze = UIAlertAction(title: "Waze Navigation".localized, style: .default)   {
            action in
            if UIApplication.shared.canOpenURL(URL(string: "waze://")!) {
                // Waze is installed. Launch Waze and start navigation
                var urlStr: String = "waze://?ll=\(mylat),\(mylong)&navigate=yes"
                
                if self.statelab.text == "SLIDE TO END JOB".localized {
                    if self.drop_lat != ""{
                        urlStr = "waze://?ll=\(self.drop_lat),\(self.drop_lon)&navigate=yes"
                    }
                }
                
                UIApplication.shared.openURL(URL(string: urlStr)!)
            }
            else {
                // Waze is not installed. Launch AppStore to install Waze app
                UIApplication.shared.openURL(URL(string: "http://itunes.apple.com/us/app/id323229106")!)
            }
        }
        
        let openGoogle = UIAlertAction(title: NSLocalizedString("Google map navigation".localized, comment: ""), style: .default) { action in
            
            if (UIApplication.shared.canOpenURL(NSURL(string:"comgooglemaps://")! as URL)) {
                
                if self.statelab.text == "SLIDE TO END JOB".localized {
                    if self.drop_lat != ""{
                        UIApplication.shared.openURL(NSURL(string:
                            "comgooglemaps://?saddr=&daddr=\(self.drop_lat),\(self.drop_lon)&directionsmode=driving")! as URL)
                    }else {
                        UIApplication.shared.openURL(NSURL(string:
                            "comgooglemaps://?saddr=&daddr=\(mylat),\(mylong)&directionsmode=driving")! as URL)
                    }
                }else {
                    UIApplication.shared.openURL(NSURL(string:
                        "comgooglemaps://?saddr=&daddr=\(mylat),\(mylong)&directionsmode=driving")! as URL)
                }
                
            } else
            {
                if self.statelab.text == "SLIDE TO END JOB".localized {
                    if self.drop_lat != ""{
                        if let urlDestination = URL.init(string: "https://www.google.co.in/maps/dir/?saddr=&daddr=\(self.drop_lat),\(self.drop_lon)&directionsmode=driving") {
                            UIApplication.shared.openURL(urlDestination)
                        }
                    }else {
                        if let urlDestination = URL.init(string: "https://www.google.co.in/maps/dir/?saddr=&daddr=\(mylat),\(mylong)&directionsmode=driving") {
                            UIApplication.shared.openURL(urlDestination)
                        }
                    }
                }else {
                    if let urlDestination = URL.init(string: "https://www.google.co.in/maps/dir/?saddr=&daddr=\(mylat),\(mylong)&directionsmode=driving") {
                        UIApplication.shared.openURL(urlDestination)
                    }
                }
                
            }
            
        }
        
        
        
        
        let openInApp = UIAlertAction(title: "InApp".localized, style: .default)   {
            action in
            
    
        }
        
        let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel) { action in
            
            
        }
        
        alert.addAction(openWaze)
        alert.addAction(openGoogle)
        alert.addAction(openInApp)
        alert.addAction(cancelAction)
        
        if let presenter = alert.popoverPresentationController
        {
            presenter.sourceView = sender as! UIButton
            presenter.sourceRect = (sender as! UIButton).bounds
        }
        
        present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func retryAct(_ sender: Any) {
        
        waitingview.isHidden = false
        retryview.isHidden = true
        
        Database.database().reference().child("booking_trips").child(self.booking_id).child("request_status").setValue("3")
        Database.database().reference().child("providers").child(driver_id).child("trips").child("request_status").setValue("3")
        
    }
    
    @IBAction func cancelAct(_ sender: Any) {
    
        cancelTripAct()
        
    }
    
    @objc func locationNotification(notification: Notification){
        
         let userloc = notification.object as! CLLocation
        
        if APPDELEGATE.driverLocation.coordinate.latitude != 0.0 {
            
          //  self.carmarker.position = CLLocationCoordinate2DMake(APPDELEGATE.driverLocation.coordinate.latitude, APPDELEGATE.driverLocation.coordinate.longitude)
            
            
            if statelab.text == "SLIDE TO END JOB".localized && calview.isHidden == true {
                
                if startDate == nil {
                    startDate = Date()
                } else {
                    print("elapsedTime:", String(format: "%.0fs", Date().timeIntervalSince(startDate)))
                }
                if startLocation == nil {
                    startLocation = CLLocation(latitude: APPDELEGATE.driverLocation.coordinate.latitude, longitude: APPDELEGATE.driverLocation.coordinate.longitude)
                }
                
                
                else {
                    let location = CLLocation(latitude: APPDELEGATE.driverLocation.coordinate.latitude, longitude: APPDELEGATE.driverLocation.coordinate.longitude)
                    traveledDistance += (lastLocation.distance(from: location)/1000)
                    print("Traveled Distance:",  traveledDistance)
                    print("Straight Distance:", startLocation.distance(from: location))
                    
                    // Database.database().reference().child("drivers_status").child(driver_id).child("distance").setValue(traveledDistance)
                    
                    traveledDistanceInKm = String(format: "%.01fkm", traveledDistance)
                }
                
                lastLocation = CLLocation(latitude: APPDELEGATE.driverLocation.coordinate.latitude, longitude: APPDELEGATE.driverLocation.coordinate.longitude)
                let locationarray = [CLLocation(latitude: APPDELEGATE.driverLocation.coordinate.latitude, longitude: APPDELEGATE.driverLocation.coordinate.longitude)] as [CLLocation]
                self.locationManager(self.locationManager, didUpdateLocations: locationarray)
                
                
                let fromadd = CLLocationCoordinate2DMake(APPDELEGATE.driverLocation.coordinate.latitude, APPDELEGATE.driverLocation.coordinate.longitude)
                
                let toadd = CLLocationCoordinate2DMake(Double(self.drop_lat)!, Double(self.drop_lon)!)
                
                //let toadd = CLLocationCoordinate2DMake(9.926072, 78.121521)
                
                
                if self.firsttime == true
                {
                  print("FirstimeCalled SLIDE TO END JOB")
                    self.calculateRoutes(from: fromadd, to: toadd)

                    self.timer?.invalidate()
                    self.timer = Timer.scheduledTimer(timeInterval: 90.0, target: self, selector:#selector(self.timerCall(_:)), userInfo: nil, repeats: true)
                }
                
                
               // self.calculateRoutes(from: fromadd, to: toadd)
                
                
            }
            
            if statelab.text == "SLIDE TO START".localized || statelab.text == "SLIDE TO ARRIVE JOB LOCATION".localized  {
                
                
                
                let fromadd = CLLocationCoordinate2DMake(APPDELEGATE.driverLocation.coordinate.latitude, APPDELEGATE.driverLocation.coordinate.longitude)
                
                let toadd = CLLocationCoordinate2DMake(Double(self.customer_lat)!, Double(self.customer_lon)!)
                
                //let toadd = CLLocationCoordinate2DMake(9.926072, 78.121521)
                
                if self.firsttime == true
                {
                  print("FirstimeCalled SLIDE TO START AND SLIDE TO ARRIVE")
                    self.calculateRoutes(from: fromadd, to: toadd)

                    self.timer?.invalidate()
                    self.timer = Timer.scheduledTimer(timeInterval: 90.0, target: self, selector:#selector(self.timerCall(_:)), userInfo: nil, repeats: true)
                }
                
                
                
            }
            
            
            let newCoordinate: CLLocationCoordinate2D = userloc.coordinate
            
            moveMent.arCarMovement(carmarker, withOldCoordinate: oldCoordinate, andNewCoordinate: newCoordinate, inMapview: mapview, withBearing: 0)
            oldCoordinate = newCoordinate
        }
        
        
    }
    
    
    @objc func timerCall(_ timer: Timer)
    {
        
        
        let currentDateTime = Date()

        
        if statelab.text == "SLIDE TO START".localized || statelab.text == "SLIDE TO ARRIVE JOB LOCATION".localized  {

            print("Timer Call BEFORE START\(currentDateTime)")

        let fromadd = CLLocationCoordinate2DMake(APPDELEGATE.driverLocation.coordinate.latitude, APPDELEGATE.driverLocation.coordinate.longitude)
        
        let toadd = CLLocationCoordinate2DMake(Double(self.customer_lat)!, Double(self.customer_lon)!)

        self.calculateRoutes(from: fromadd, to: toadd)
        }
        
        else if statelab.text == "SLIDE TO END JOB".localized && calview.isHidden == true
        {
            
            print("Timer Call AFTER START\(currentDateTime)")

            
            let fromadd = CLLocationCoordinate2DMake(APPDELEGATE.driverLocation.coordinate.latitude, APPDELEGATE.driverLocation.coordinate.longitude)
            
            let toadd = CLLocationCoordinate2DMake(Double(self.drop_lat)!, Double(self.drop_lon)!)
            self.calculateRoutes(from: fromadd, to: toadd)

        }
        
//        let fromadd = CLLocationCoordinate2DMake(Double(d_lat)!, Double(d_long)!)
//
//        let toadd = dropLocation

      //  calculateRoutes(from: fromadd, to: toadd)

        
    }

    func arCarMovement(_ movedMarker: GMSMarker) {
        carmarker = movedMarker
        carmarker.map = mapview
        
        //animation to make car icon in center of the mapview
        //
        
        let currentZoom = self.mapview.camera.zoom
        
        let updatedCamera = GMSCameraUpdate.setTarget(carmarker.position, zoom: 16)
        mapview.animate(with: updatedCamera)
    }
    
    func getlocation() {
        
       // self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == progressTable {
        
            return msgstr.count
            
        }
        
        return menustr.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == progressTable {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "jobCell", for: indexPath) as! jobCell
            
            cell.countlab.text = "\(indexPath.row + 1)"
            
            cell.msglab.text = msgstr[indexPath.row]
            
            if indexPath.row == 0 {
                
                cell.timelab.text = accept_time
                
            }
                
            else if indexPath.row == 1 {
                
                cell.timelab.text = start_time
                
            }
            else if indexPath.row == 2 {
                
                cell.timelab.text = reach_time
                
            }
            else if indexPath.row == 3 {
                
                cell.timelab.text = service_start_time
                
            }
            
            cell.lasttimelab.text = "4 min ago"
            
            cell.selectionStyle = .none
            
            return cell
            
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "dropmenucell", for: indexPath)
        
        cell.textLabel?.text = menustr[indexPath.row]
        
        cell.selectionStyle = .none
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == tableview {
            
            menuview.isHidden = true
            
            if indexPath.row == 0 {
                
                guard let number = URL(string: "tel://" + customer_phone_number) else { return }
                UIApplication.shared.open(number)
                
            }
            else if indexPath.row == 1 {
                
                if (MFMessageComposeViewController.canSendText()) {
                    let controller = MFMessageComposeViewController()
                    controller.body = ""
                    controller.recipients = [customer_phone_number]
                    controller.messageComposeDelegate = self
                    self.present(controller, animated: true, completion: nil)
                }
                
            }
            else if indexPath.row == 2 {
                
                if !(customer_avatar == "") {
                    
                    var imageUrl: String? = BASEAPI.PRFIMGURL+customer_avatar
                    self.userimg.sd_setImage(with: URL(string: imageUrl!), placeholderImage: #imageLiteral(resourceName: "user(1)"))
                    
                }
                else {
                    self.userimg.sd_setImage(with: URL(string: ""), placeholderImage: #imageLiteral(resourceName: "user(1)"))
                }
                
                self.userimg.layer.cornerRadius = (self.userimg.frame.size.width) / 2
                self.userimg.layer.masksToBounds = true
                
                username.text = customer_name
                bookingid.text = "Booking Id \(booking_id)"
                mobile.text = "Mobile \(customer_phone_number)"
                
                cusview.isHidden = false
                
            }
//            else if menustr.count == 5 && indexPath.row == 3{
//
//                if menustr[indexPath.row] == "Live Track".localized {
//                    menustr[indexPath.row] = "Job InProgress".localized
//                    beginview1.isHidden = true
//                    beginview2.isHidden = true
//                    self.heightcons.constant = 225
//                }
//
//                else {
//                    menustr[indexPath.row] = "Live Track".localized
//                    beginview1.isHidden = false
//                    beginview2.isHidden = false
//                    self.heightcons.constant = 225
//                }
//                tableview.reloadData()
//            }
            else if indexPath.row == 3 {
                
                cancelTripAct()
                
            }
            
  //         else if menustr.count == 5 && indexPath.row == 4
//            {
//                 cancelTripAct()
//            }
            
        }
        
    }
    
    func cancelTripAct() {
        
        var alert = UIAlertController(title: "", message: "Cancel Job".localized, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addTextField(configurationHandler: configurationTextField)
        alert.addTextField(configurationHandler: configurationTextField1)
        
        alert.addAction(UIAlertAction(title: "CONTINUE JOB".localized, style: UIAlertActionStyle.default, handler:{ (UIAlertAction)in
            print("User click Ok button")
        }))
        alert.addAction(UIAlertAction(title: "CANCEL JOB".localized, style: UIAlertActionStyle.cancel, handler:handleCancel))
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
        
    }
    
    var textField = UITextField()
    
    func configurationTextField(textField: UITextField!)
    {
        print("configurat hire the TextField")
        
        if let tField = textField {
            
            self.textField = textField!        //Save reference to the UITextField
            self.textField.placeholder = "Enter your reason".localized
        }
        
    }
    
    var textField1 = UITextField()
    
    func configurationTextField1(textField: UITextField!)
    {
        print("configurat hire the TextField1 ")
        
        if let tField = textField {
            
            self.textField1 = textField!        //Save reference to the UITextField
            self.textField1.placeholder = "Enter your comment".localized
        }
        
    }
    
    func handleCancel(alertView: UIAlertAction!)
    {
        print("User click Cancel button")
        print(self.textField.text)
        print(self.textField1.text)
        
        if self.textField.text == "" {
            
            self.showAlertView(title: "TOWROUTE PROVIDER".localized, message: "Please enter your reason!".localized, callback: { (check) in
                
                var alert = UIAlertController(title: "", message: "Cancel Job".localized, preferredStyle: UIAlertControllerStyle.alert)
                
                alert.addTextField(configurationHandler: self.configurationTextField)
                alert.addTextField(configurationHandler: self.configurationTextField1)
                
                alert.addAction(UIAlertAction(title: "CONTINUE JOB".localized, style: UIAlertActionStyle.default, handler:{ (UIAlertAction)in
                    print("User click Ok button")
                }))
                alert.addAction(UIAlertAction(title: "CANCEL JOB".localized, style: UIAlertActionStyle.cancel, handler:self.handleCancel))
                self.present(alert, animated: true, completion: {
                    print("completion block")
                })
                
            })
            return
            
        }
        if self.textField1.text == "" {
            
            self.showAlertView(title: "TOWROUTE PROVIDER".localized, message: "Please enter your comment!".localized, callback: { (check) in
                
                var alert = UIAlertController(title: "", message: "Cancel Job", preferredStyle: UIAlertControllerStyle.alert)
                
                alert.addTextField(configurationHandler: self.configurationTextField)
                alert.addTextField(configurationHandler: self.configurationTextField1)
                
                alert.addAction(UIAlertAction(title: "CONTINUE JOB".localized, style: UIAlertActionStyle.default, handler:{ (UIAlertAction)in
                    print("User click Ok button")
                }))
                alert.addAction(UIAlertAction(title: "CANCEL JOB".localized, style: UIAlertActionStyle.cancel, handler:self.handleCancel))
                self.present(alert, animated: true, completion: {
                    print("completion block")
                })
                
            })
            
            return
            
        }
        
        let params = ["mode":"driver",
                      "reason":self.textField.text! + "-" + self.textField1.text!,
                      "booking_id":self.booking_id] as [String : Any]
        
        print("params \(params)")
        
        APIManager.shared.cancelJobs(params: params as [String : AnyObject]) { (response) in
            
            if case let msg as String = response?["message"], msg == "Unauthenticated." {
                
                APIManager.shared.refreshToken(params: params as [String : AnyObject]) { (response) in
                    
                    if case let access_token as String = response?["access_token"] {
                        
                        APPDELEGATE.bearerToken = access_token
                        
                        USERDEFAULTS.set(access_token, forKey: "access_token")
                        
                        self.handleCancel(alertView: alertView)
                        
                    }
                        
                    else {
                        
                        self.showAlertView(title: "TOWROUTE PROVIDER".localized, message: "Your session has expired. Please log in again", callback: { (check) in
                            
                            NotificationCenter.default.removeObserver(self)
                            
                            APPDELEGATE.updateLoginView()
                            
                        })
                        
                    }
                    
                }
                
            }
                
            else if case let msg as String = response?["message"], msg == "Request status updated successfully." {
                
                
                
            }
            
        }
    }
    
    @IBAction func closeAct1(_ sender: Any) {
    
        cusview.isHidden = true
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
        
    }
    
    @IBAction func menuAct(_ sender: Any) {
    
        if menuview.isHidden == true {
            
            menuview.isHidden = false
            
        }
        else {
            
            menuview.isHidden = true
            
        }
        
    }
    
    
    @IBOutlet var statelab: UILabel!
    
    @IBAction func tripAct(_ sender: Any) {
    
        if statelab.text == "SLIDE TO START".localized {
            
     //       let alert = UIAlertController(title: "TowRoute".localized, message: "Are you sure you have started at your location? If yes click OK else cancel".localized, preferredStyle: .alert)
            
      //      let okAction = UIAlertAction(title: "OK".localized, style: .default, handler: { (check) in
                
                let params = ["mode":"start_driver",
                              "driver_id":driver_id,
                              "booking_id":self.booking_id] as [String : Any]
                
                print("params \(params)")
                
                APIManager.shared.acceptService(params: params as [String : AnyObject]) { (response) in
                    
                    if case let msg as String = response?["message"], msg == "Unauthenticated." {
                        
                        APIManager.shared.refreshToken(params: params as [String : AnyObject]) { (response) in
                            
                            if case let access_token as String = response?["access_token"] {
                                
                                APPDELEGATE.bearerToken = access_token
                                
                                USERDEFAULTS.set(access_token, forKey: "access_token")
                                
                                self.tripAct(self)
                                
                            }
                                
                            else {
                                
                                self.showAlertView(title: "TOWROUTE PROVIDER".localized, message: "Your session has expired. Please log in again", callback: { (check) in
                                    
                                    NotificationCenter.default.removeObserver(self)
                                    
                                    APPDELEGATE.updateLoginView()
                                    
                                })
                                
                            }
                            
                        }
                        
                    }
                    
                    else if case let msg as String = response?["message"], msg == "Request status updated successfully." {
                        
                        self.firsttime = true

                        self.statelab.text = "SLIDE TO ARRIVE JOB LOCATION".localized
                        
                        //self.joblocback.isHidden = false
                       // self.jobloclab1.isHidden = false
                        
                    }
                    
                }
                
         //   })
            
//            let cancel = UIAlertAction(title: "CANCEL".localized, style: .cancel) { (action) in
//
//            }
//
//            alert.addAction(okAction)
//
//            alert.addAction(cancel)
//
//            self.present(alert, animated: true, completion: nil)
//
        }
        
        else if statelab.text == "SLIDE TO ARRIVE JOB LOCATION".localized {
            
         //   let alert = UIAlertController(title: "TowRoute".localized, message: "Are you sure you have arrived at job location of user? If yes click OK else cancel".localized, preferredStyle: .alert)
            
    //        let okAction = UIAlertAction(title: "OK".localized, style: .default, handler: { (check) in
                
                let params = ["mode":"reached",
                              "driver_id":driver_id,
                              "booking_id":self.booking_id] as [String : Any]
                
                print("params \(params)")
                
                APIManager.shared.acceptService(params: params as [String : AnyObject]) { (response) in
                    
                    if case let msg as String = response?["message"], msg == "Unauthenticated." {
                        
                        APIManager.shared.refreshToken(params: params as [String : AnyObject]) { (response) in
                            
                            if case let access_token as String = response?["access_token"] {
                                
                                APPDELEGATE.bearerToken = access_token
                                
                                USERDEFAULTS.set(access_token, forKey: "access_token")
                                
                                self.tripAct(self)
                                
                            }
                                
                            else {
                                
                                self.showAlertView(title: "TOWROUTE PROVIDER".localized, message: "Your session has expired. Please log in again", callback: { (check) in
                                    
                                    NotificationCenter.default.removeObserver(self)
                                    
                                    APPDELEGATE.updateLoginView()
                                    
                                })
                                
                            }
                            
                        }
                        
                    }
                        
                    else if case let msg as String = response?["message"], msg == "Request status updated successfully." {
                        
                        self.waitingview.isHidden = false
                        self.retryview.isHidden = true
                        
                        self.firsttime = true

                        self.statelab.text = "SLIDE TO BEGIN JOB".localized
                        
                        //self.beginview1.isHidden = false
                        //self.beginview2.isHidden = false
                        
                    }
                    
                }
                
    //        })
            
//            let cancel = UIAlertAction(title: "CANCEL".localized, style: .cancel) { (action) in
//                
//            }
//            
//            alert.addAction(okAction)
//            
//            alert.addAction(cancel)
//            
//            self.present(alert, animated: true, completion: nil)
            
        }
        else if statelab.text == "SLIDE TO BEGIN JOB".localized {
            
            if request_status != "1"{
                return
            }
            
            let params = ["mode":"start_service",
                          "driver_id":driver_id,
                          "booking_id":self.booking_id] as [String : Any]
            
            print("params \(params)")
            
            APIManager.shared.acceptService(params: params as [String : AnyObject]) { (response) in
                
                if case let msg as String = response?["message"], msg == "Unauthenticated." {
                    
                    APIManager.shared.refreshToken(params: params as [String : AnyObject]) { (response) in
                        
                        if case let access_token as String = response?["access_token"] {
                            
                            APPDELEGATE.bearerToken = access_token
                            
                            USERDEFAULTS.set(access_token, forKey: "access_token")
                            
                            self.tripAct(self)
                            
                        }
                            
                        else {
                            
                            self.showAlertView(title: "TOWROUTE PROVIDER".localized, message: "Your session has expired. Please log in again", callback: { (check) in
                                
                                NotificationCenter.default.removeObserver(self)
                                
                                APPDELEGATE.updateLoginView()
                                
                            })
                            
                        }
                        
                    }
                    
                }
                    
                else if case let msg as String = response?["message"], msg == "Request status updated successfully." {
                    
                    if self.drop_lat != ""{
                        
                        self.peoplemarker.position = CLLocationCoordinate2DMake(Double(self.drop_lat)!, Double(self.drop_lon)!)
                        self.peoplemarker.icon = #imageLiteral(resourceName: "pd")
                        self.peoplemarker.map = self.mapview
                       
                        let fromadd = CLLocationCoordinate2DMake(Double(self.drop_lat)!, Double(self.drop_lon)!)
                        
                        let toadd = CLLocationCoordinate2DMake(APPDELEGATE.driverLocation.coordinate.latitude, APPDELEGATE.driverLocation.coordinate.longitude)
                        
                        //let toadd = CLLocationCoordinate2DMake(9.926072, 78.121521)
                        
                        self.calculateRoutes(from: fromadd, to: toadd)
                        
                    }
                    
                    self.firsttime = true

                    self.statelab.text = "SLIDE TO END JOB".localized
                    
                    //self.beginview1.isHidden = false
                    //self.beginview2.isHidden = false
                    
                }
                
            }
            
        }
        
        else if statelab.text == "SLIDE TO END JOB".localized {
            
            if sub_level_amount != ""{
                if visit_fare != "0"{

                    var mainfee = matfeetxt.text!
                    var miscfee = miscfeetxt.text!
                    var discountfee = discountfeetxt.text!
                    var chargefee = chargelab.text!.replacingOccurrences(of: "\(currency_symbol!)", with: "")
                    
                    if mainfee == "" {
                        mainfee = "0"
                    }
                    
                    if miscfee == "" {
                        miscfee = "0"
                    }
                    
                    if discountfee == "" {
                        discountfee = "0"
                    }
                    
                    if chargefee == "" {
                        chargefee = "0"
                    }
                    
                    let distances = self.traveledDistance
                  
                    if dropLocation != "NoDrop"
                    {
                        fareDistanceTitle.text = "Price per KM".localized+" "+"\(price_per_km) * \(String(format: "%.2f", (Double("\(distances)")!))) KM = "
                        fareDistanceValue.text = "\(currency_symbol!) " + String(format: "%.2f", (Double(price_per_km)! * Double(String(format: "%.2f", (Double("\(distances)")!)))!))
                        
                        let total = Double("\(chargefee)")! + Double(mainfee)! + Double(miscfee)! - Double(discountfee)! + Double(String(format: "%.2f", (Double(price_per_km)! * Double(String(format: "%.2f", (Double("\(distances)")!)))!)))!
                        totallab.text = "\(currency_symbol!)" + String(format: "%.2f", (Double("\(total)")!))
                    }
                  
                    
                    if dropLocation == "NoDrop"
                    {
                        fareDistanceTitle.text = ""
                        fareDistanceValue.text = "0.0"
                        
                        let total = Double("\(chargefee)")! + Double(mainfee)! + Double(miscfee)! - Double(discountfee)!
                        totallab.text = "\(currency_symbol!)" + String(format: "%.2f", (Double("\(total)")!))
                    }
                    
                }
            }
            matfeetxt.becomeFirstResponder()
            calview.isHidden = false
            
        }
        
    }
    
    
    
    @IBAction func closeAct(_ sender: Any) {
        
        matfeetxt.resignFirstResponder()
        miscfeetxt.resignFirstResponder()
        discountfeetxt.resignFirstResponder()
        calview.isHidden = true
        
    }
    
    @IBOutlet var dol1: UILabel!
    @IBOutlet var dol2: UILabel!
    @IBOutlet var dol3: UILabel!
    
    @IBAction func skipAct(_ sender: Any) {
    
        var mainfee = matfeetxt.text!
        var miscfee = miscfeetxt.text!
        var discountfee = discountfeetxt.text!
        
        let cur =  chargelab.text!
        
        
        if mainfee == "" {
            
            mainfee = "0.0"
            
        }
        
        if miscfee == "" {
            
            miscfee = "0.0"
            
        }
        
        if discountfee == "" {
            
            discountfee = "0.0"
            
        }
        
//        if cur <= discountfee
//        {
//            self.showAlertView(message: "Enter Valid Discount Fee")
//        }
        
        //updated for alert .. valid discount fee alert //ref shuuv app
        
        print("cehckcur\(cur)")
        print("checkdiscountfee\(discountfee)")
        
        let chargevalue = Float((unit_price as! NSString).doubleValue)
        let discountvalue = Float((discountfee as! NSString).doubleValue)
        
        print("cehckcurfloat\(chargevalue)")
        print("checkdiscountvalue\(discountvalue)")
        
        if discountvalue > chargevalue{
        self.showAlertView(message: "Enter Valid Discount Fee")

        return
        }
        
        
        
//        mainfee = String(format: "%.2f", (Double("\(Float((mainfee as! NSString).doubleValue / (currencymul as! NSString).doubleValue))")!))
//        miscfee = String(format: "%.2f", (Double("\(Float((miscfee as! NSString).doubleValue / (currencymul as! NSString).doubleValue))")!))
//        discountfee = String(format: "%.2f", (Double("\(Float((discountfee as! NSString).doubleValue / (currencymul as! NSString).doubleValue))")!))
        
        mainfee = String(format: "%.2f", (Double(mainfee.convertCurToDollar())!))
        miscfee = String(format: "%.2f", (Double(miscfee.convertCurToDollar())!))
        discountfee = String(format: "%.2f", (Double(discountfee.convertCurToDollar())!))
        
        mat = mainfee
        misc = miscfee
        discounttext = discountfee
        
        mat_fee = mat
        mis_fee = miscfee
        discount_fee = discounttext
        
        
        let mydistance = String(format: "%.2f", (Double("\(self.traveledDistance)")!))
        distance = mydistance
        distancetext = mydistance
        
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.clear)
        SVProgressHUD.setContainerView(topMostViewController().view)
        SVProgressHUD.show()
        
        let loc: CLLocation = CLLocation(latitude:APPDELEGATE.driverLocation.coordinate.latitude, longitude: APPDELEGATE.driverLocation.coordinate.longitude)
        
        let ceo: CLGeocoder = CLGeocoder()
        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
                    SVProgressHUD.dismiss()
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                
                guard placemarks != nil else {
                    SVProgressHUD.dismiss()
                    return
                }
                
                let pm = placemarks! as [CLPlacemark]
                
                if pm.count > 0 {
                    let pm = placemarks![0]
                    
                    var addressString : String = ""
                    if pm.subLocality != nil {
                        addressString = addressString + pm.subLocality! + ", "
                    }
                    if pm.thoroughfare != nil {
                        addressString = addressString + pm.thoroughfare! + ", "
                    }
                    if pm.locality != nil {
                        addressString = addressString + pm.locality! + ", "
                    }
                    if pm.country != nil {
                        addressString = addressString + pm.country! + ", "
                    }
                    if pm.postalCode != nil {
                        addressString = addressString + pm.postalCode! + " "
                    }
                    
                    print(addressString)
                    addresstext = addressString
                    if self.payment_type == "wallet" {
                        
                        let fireRef = Database.database().reference()
                        
                        let userwalletRef = fireRef.child("users").child(self.customer_id).child("wallet")
                        
                        userwalletRef.observeSingleEvent(of: DataEventType.value, with: { (SnapShot: DataSnapshot) in
                            
                            print("SnapShot \(SnapShot.value)")
                            
                            if let statusval = SnapShot.value {
                                
                                let userWallet = "\(statusval)"
                                
                                let wallet = (userWallet as! NSString).doubleValue // Double(Int(userWallet))
                                
                                let totaltxt = self.totallab.text!.replacingOccurrences(of: "\(currency_symbol!)", with: "")
                                
                                let total = (totaltxt as! NSString).doubleValue / (currencymul as! NSString).doubleValue
                                
                                let convertFloat = "\(Float(total))"
                                
                                if total > wallet {
                                    
                                    let params = ["mode":"finish_service",
                                                  "driver_id":driver_id,
                                                  "booking_id":self.booking_id,
                                                  "material_fee":mainfee,
                                                  "misc_charge":miscfee,
                                                  "driver_discount":discountfee,
                                                  "payment_type":"both",
                                                  "customer_id":self.customer_id,
                                                  "total_amount":convertFloat,
                                                  "wallet_amount":userWallet,
                                                  "distance":mydistance,
                                        "promocode":self.promocodeval,
                                        "drop_lat":"\(APPDELEGATE.driverLocation.coordinate.latitude)",
                                        "drop_lon":"\(APPDELEGATE.driverLocation.coordinate.longitude)",
                                        "drop_location":addressString] as [String : Any]
                                    
                                    print("params \(params)")
                                    
                                    self.complete(params: params as [String : AnyObject])
                                    
                                }
                               
                                
                                else {
                                    
                                    let params = ["mode":"finish_service",
                                                  "driver_id":driver_id,
                                                  "booking_id":self.booking_id,
                                                  "material_fee":mainfee,
                                                  "misc_charge":miscfee,
                                                  "driver_discount":discountfee,
                                                  "payment_type":"wallet",
                                                  "customer_id":self.customer_id,
                                                  "distance":mydistance,
                                        "promocode":self.promocodeval,
                                        "drop_lat":"\(APPDELEGATE.driverLocation.coordinate.latitude)",
                                        "drop_lon":"\(APPDELEGATE.driverLocation.coordinate.longitude)",
                                        "drop_location":addressString] as [String : Any]
                                    
                                    print("params \(params)")
                                    
                                    self.complete(params: params as [String : AnyObject])
                                    
                                }
                                
                            }
                            
                        })
                        
                    }
                        
                    else if self.payment_type == "card" {
                        
                        let totaltxt = self.totallab.text!.replacingOccurrences(of: "\(currency_symbol!)", with: "")
                        let total = (totaltxt as! NSString).doubleValue / (currencymul as! NSString).doubleValue
                        
                        let convertFloat = "\(Float(total))"
                        
                        let params = ["mode":"0",
                                      "driver_id":driver_id,
                                      "booking_id":self.booking_id,
                                      "material_fee":mainfee,
                                      "misc_charge":miscfee,
                                      "driver_discount":discountfee,
                                      "customer_id":self.customer_id,
                                      "distance":mydistance,"amount":convertFloat] as [String : Any]
                       
                        print("params \(params)")
                        
                        APIManager.shared.StripeacceptService(params: params as [String : AnyObject]) { (response) in
                            
                            
                            if case let msg as String = response?["message"], msg == "Unauthenticated." {
                                
                                APIManager.shared.refreshToken(params: params as [String : AnyObject]) { (response) in
                                    
                                    if case let access_token as String = response?["access_token"] {
                                        
                                        APPDELEGATE.bearerToken = access_token
                                        
                                        USERDEFAULTS.set(access_token, forKey: "access_token")
                                        
                                        self.skipAct(self)
                                        
                                    }
                                        
                                    else {
                                        
                                        self.showAlertView(title: "TOWROUTE PROVIDER".localized, message: "Your session has expired. Please log in again", callback: { (check) in
                                            
                                            NotificationCenter.default.removeObserver(self)
                                            
                                            APPDELEGATE.updateLoginView()
                                            
                                        })
                                        
                                    }
                                    
                                }
                                
                            }
                                
                            else if case let msg = "message"
                            {
                                
                                
                            }
                            
                        }
                        
                        
                        
                    }
                    else{
                        
                        //print("\()")
                        print("insiecashtypeapp")
                        
                        let params = ["mode":"finish_service",
                                      "driver_id":driver_id,
                                      "booking_id":self.booking_id,
                                      "material_fee":mainfee,
                                      "misc_charge":miscfee,
                                      "driver_discount":discountfee,
                                      "payment_type":"cash",
                                      "customer_id":self.customer_id,
                                      "distance":mydistance,
                            "promocode":self.promocodeval,
                            "drop_lat":"\(APPDELEGATE.driverLocation.coordinate.latitude)",
                            "drop_lon":"\(APPDELEGATE.driverLocation.coordinate.longitude)",
                            "drop_location":addressString] as [String : Any]
                        
                        print("params \(params)")
                        
                        self.complete(params: params as [String : AnyObject])

                        
                        
                        
                        
                    }
                    
                }
                
        })
        
    }
    
    func complete(params: [String : AnyObject]) {
        
        APIManager.shared.acceptService(params: params as [String : AnyObject]) { (response) in
            
            if case let msg as String = response?["message"], msg == "Unauthenticated." {
                
                
                APIManager.shared.refreshToken(params: params as [String : AnyObject]) { (response) in
                    
                    if case let access_token as String = response?["access_token"] {
                        
                        APPDELEGATE.bearerToken = access_token
                        
                        USERDEFAULTS.set(access_token, forKey: "access_token")
                        
                        self.tripAct(self)
                        
                    }
                        
                    else {
                        
                        self.showAlertView(title: "TOWROUTE PROVIDER".localized, message: "Your session has expired. Please log in again", callback: { (check) in
                            
                            NotificationCenter.default.removeObserver(self)
                            
                            APPDELEGATE.updateLoginView()
                            
                        })
                        
                    }
                    
                }
                
            }
                
            else if case let msg as String = response?["message"], msg == "Request status updated successfully." {
                
                //self.beginview1.isHidden = false
                
            }
            
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        self.timer?.invalidate()

        NotificationCenter.default.removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
      
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
extension String {

var containsValidCharacter: Bool {
    guard self != "" else { return true }
    let hexSet = CharacterSet(charactersIn: "1234567890ABCDEFabcdef")
    let newSet = CharacterSet(charactersIn: self)
    return hexSet.isSuperset(of: newSet)
  }
}
class jobCell: UITableViewCell {
    
    @IBOutlet var countlab: UILabel!
    @IBOutlet var msglab: UILabel!
    @IBOutlet var timelab: UILabel!
    @IBOutlet var lasttimelab: UILabel!
    
    
    
    override func awakeFromNib() {
    
        countlab.layer.cornerRadius = 20
        countlab.layer.masksToBounds = true
        
    }
    
}

extension UITextField {
    func setBottomBorder() {
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.init(hex: "ffd204").cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
}
