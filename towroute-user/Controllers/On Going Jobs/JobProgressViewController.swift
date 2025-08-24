//
//  JobProgressViewController.swift
//  TowRoute User
//
//  Created by Uplogic Technologies on 03/07/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import GoogleMaps
import JVFloatLabeledTextField
import Firebase
import FloatRatingView
import Stripe
import SVProgressHUD
import MessageUI
import GoogleMaps
import Alamofire

class JobProgressViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,STPPaymentCardTextFieldDelegate, UITextFieldDelegate, MFMessageComposeViewControllerDelegate, ARCarMovementDelegate {
    
    @IBOutlet var tableview: UITableView!
    @IBOutlet var progressTable: UITableView!
    
    @IBOutlet weak var menuviewheight: NSLayoutConstraint!
    var menustr = ["Call".localized,"Message".localized,"SOS".localized,"Cancel Job".localized]
    
    var msgstr = [] as [String]
    
    @IBOutlet var menuview: UIView!
    
    var cusname = ""
    
    var pickuploc = ""
    
    var customer_lat = ""
    var customer_lon = ""
    
    var booking_id = ""
    
    var carmarker = GMSMarker()
    
    var peoplemarker = GMSMarker()
    
    var moveMent: ARCarMovement!
    var oldCoordinate: CLLocationCoordinate2D!
    
    var service_status = ""
    
    var dis = ""
    var dur = ""
    
    @IBOutlet var beginview1: UIView!
    @IBOutlet var beginview2: UIView!
    
    @IBOutlet var usernamelab: UILabel!
    @IBOutlet var loclab: UILabel!
    
    var accept_time = ""
    var reach_time = ""
    var start_time = ""
    var service_start_time = ""
    
    var category = ""
    
    var driverid = ""
    
    var unit_price = ""
    
    var balance_amount = ""
    var total_amount = ""
    
    var driver_phone_number = ""
    var dropCheck = ""
    var cusCheck = ""
    @IBOutlet var driverimg: UIImageView!
    
    @IBOutlet var rating: FloatRatingView!
    @IBOutlet var ratingview: UIView!
    @IBOutlet var rateDriver: FloatRatingView!
    @IBOutlet var commentText: JVFloatLabeledTextField!
    @IBOutlet var paymentview: UIView!
    
    @IBOutlet weak var paymentRemainingView: UIView!
    @IBOutlet weak var paymentRemainingLbl: UILabel!
    @IBOutlet var paymentCardTextField: STPPaymentCardTextField!
    @IBOutlet var paybtn: UIButton!
    
    @IBOutlet var mapview: GMSMapView!
    
    var contactcat = NSMutableArray()
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    var driverstatusRef: DatabaseReference! = nil
    var driverstatusRef1: DatabaseReference! = nil
    var driverstatusRef2: DatabaseReference! = nil
    var firestatusRef: DatabaseReference! = nil
    
    @IBOutlet weak var currentchargeLbl: UILabel!
    @IBOutlet weak var materialfeeLbl: UILabel!
    @IBOutlet weak var promoCodeLbl: UILabel!
    @IBOutlet weak var MiscFeeLbl: UILabel!
    @IBOutlet weak var provideDiscountLbl: UILabel!
    @IBOutlet weak var TotalDistanceLbl: UILabel!
    @IBOutlet weak var totalLbl: UILabel!
    
    @IBOutlet weak var currentcharge: UILabel!
    @IBOutlet weak var materialFee: UILabel!
    @IBOutlet weak var miscfee: UILabel!
    @IBOutlet weak var providerDiscount: UILabel!
    @IBOutlet weak var totalDistance: UILabel!
    @IBOutlet weak var total: UILabel!
    
    var sublevelamount = "0"
    var visitfare = "0"
    var priceperkm = "0"
    var promocode = "0"
    var totaldistance = ""
    var drop_location = ""
    
    var paymentDict = NSDictionary()
    
    @IBOutlet weak var stackviewoutlet: UIStackView!
    
    @IBOutlet weak var livetrackBtnOutlet: UIButton!
    
    @IBOutlet weak var jobinprogressoutlet: UIButton!
    
    
    var timer: Timer?
    var firsttime = true
    var driverlocString = ""

    var d_lat = ""
    var d_long = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        moveMent = ARCarMovement()
        moveMent.delegate = self
        
         paymentCardTextField.postalCodeEntryEnabled = false
        //livetrackBtnOutlet.backgroundColor = UIColor.clear
        livetrackBtnOutlet.layer.cornerRadius = 0
        livetrackBtnOutlet.layer.borderWidth = 1
        livetrackBtnOutlet.layer.borderColor = UIColor.init(hexString: "#00d5ff")?.cgColor
        
       // jobinprogressoutlet.backgroundColor = UIColor.clear
        jobinprogressoutlet.layer.cornerRadius = 0
        jobinprogressoutlet.layer.borderWidth = 1
        jobinprogressoutlet.layer.borderColor = UIColor.init(hexString: "#00d5ff")?.cgColor
        
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "dropmenucell")
        
        tableview.rowHeight = UITableViewAutomaticDimension;
        tableview.estimatedRowHeight = 44.0;
        
        usernamelab.text = cusname
        loclab.text = pickuploc
        
        paymentCardTextField.delegate = self
        
        paybtn.isEnabled = false
        
        commentText.placeholder = "Enter your comment".localized
        
        firestatusRef = Database.database().reference().child("booking_trips").child(booking_id)
        firestatusRef.observe(DataEventType.value) { (SnapShot: DataSnapshot) in
            print("SnapShot \(SnapShot.value)")
            
            if let dict = SnapShot.value as? NSDictionary {
                
                self.paymentDict = dict
                
                if let title = dict["service_status"] {
                    
                    let state = "\(dict["service_status"]!)"
                     var category = "\(dict["category"]!)"
                    
                    if LanguageManager.shared.currentLanguage == .ar{
                        category = "\(dict["category_ar"]!)"
                        
                        
                    }
                   
                    
                   
                    
                    if let accept_time = dict["accept_time"] {
                        
                        self.accept_time = "\(dict["accept_time"]!)"
                        
                    }
                    
                    if let reach_time = dict["reach_time"] {
                        
                        self.reach_time = "\(dict["reach_time"]!)"
                        
                    }
                    
                    if let start_time = dict["start_time"] {
                        
                        self.start_time = "\(dict["start_time"]!)"
                        
                    }
                    
                    if let service_start_time = dict["service_start_time"] {
                        
                        self.service_start_time = "\(dict["service_start_time"]!)"
                        
                    }
                    
                    if let total_amount = dict["total_amount"] {
                        
                        self.total_amount = "\(dict["total_amount"]!)"
                        
                    }
                    
                    if let balance_amount = dict["balance_amount"] {
                        
                        self.balance_amount = "\(dict["balance_amount"]!)"
                        
                    }
                    
                    if let driver_phone_number = dict["driver_phone_number"] {
                        
                        self.driver_phone_number = "\(dict["driver_phone_number"]!)"
                        
                    }
                    
                    if let driver_avatar = dict["driver_avatar"] {
                        
                        let img = "\(dict["driver_avatar"]!)"
                        
                        if (img != nil) && !(img == "") {
                            
                            var imageUrl: String? = BASEAPI.IMGURL+img
                            self.driverimg.sd_setImage(with: URL(string: imageUrl!), placeholderImage: #imageLiteral(resourceName: "user(1)"))
                            
                        }
                        else {
                            self.driverimg.sd_setImage(with: URL(string: ""), placeholderImage: #imageLiteral(resourceName: "user(1)"))
                        }
                        
                        self.driverimg.layer.cornerRadius = (self.driverimg.frame.size.width) / 2
                        self.driverimg.layer.masksToBounds = true
                        
                    }
                    
                    if let driver_first_name = dict["driver_first_name"] {
                        
                        self.usernamelab.text = "\(dict["driver_first_name"]!)"
                        
                    }
                    
                    if let driver_last_name = dict["driver_last_name"] {
                        
                        self.usernamelab.text = self.usernamelab.text! + " " + "\(dict["driver_last_name"]!)"
                        
                    }
                    
                    if let customer_location = dict["customer_location"] {
                        
                        self.cusCheck = "\(dict["customer_location"]!)"
                        
                        }
                   
                    if let drop_location = dict["drop_location"] {
                        
                        self.dropCheck = "\(dict["drop_location"]!)"
                        
                    }
                    
                    self.droploc()
                    
                    if state == "2" || state == "3" {
                        
                        if let customer_lat = dict["customer_lat"] {
                            
                            if let customer_lon = dict["customer_lon"] {
                                
                                if "\(dict["customer_lat"]!)" != "" {
                                    
                                    self.peoplemarker.position = CLLocationCoordinate2DMake(Double("\(dict["customer_lat"]!)")!, Double("\(dict["customer_lon"]!)")!)
                                    self.peoplemarker.icon = #imageLiteral(resourceName: "pd")
                                    self.peoplemarker.map = self.mapview
                                    
                                    self.dropLocation = CLLocationCoordinate2DMake(Double("\(dict["customer_lat"]!)")!, Double("\(dict["customer_lon"]!)")!)
                                    
                                }
                                
                            }
                            
                        }
                        
                    }
                        
                        
                    else {
                        
                        if let drop_lat = dict["drop_lat"] {
                            
                            if let drop_lon = dict["drop_lon"] {
                                
                                if "\(dict["drop_lat"]!)" != "" {
                                    
                                    self.peoplemarker.position = CLLocationCoordinate2DMake(Double("\(dict["drop_lat"]!)")!, Double("\(dict["drop_lon"]!)")!)
                                    self.peoplemarker.icon = #imageLiteral(resourceName: "pd")
                                    self.peoplemarker.map = self.mapview
                                    
                                    self.dropLocation = CLLocationCoordinate2DMake(Double("\(dict["drop_lat"]!)")!, Double("\(dict["drop_lon"]!)")!)
                                    
                                }
                                
                            }
                            
                        }
                        
                    }
                    
                    if let driver_id = dict["driver_id"] {
                        
                        self.driverid = "\(dict["driver_id"]!)"
                        
                    }
                    
                    let fireRef = Database.database().reference()
                    let driverratingtRef = fireRef.child("providers").child(self.driverid).child("rating")
                    
                    driverratingtRef.observeSingleEvent(of: DataEventType.value) { (SnapShot: DataSnapshot) in
                        
                        if let statusval = SnapShot.value {
                            
                            let rating = "\(statusval)"
                            
                            print("rating \(rating)")
                            
                            if rating != "<null>" {
                                
                                self.rating.rating = Double(rating)!
                                
                            }
                            
                        }
                        
                    }
                    
                    self.driverstatusRef = fireRef.child("drivers_location").child(self.driverid).child("l")
                    
                    self.driverstatusRef.observe(DataEventType.value) { (SnapShot:DataSnapshot) in
                        
                        let valuearr = SnapShot.value as? NSArray
                        
                        let lat = valuearr?.object(at: 0)
                        
                        let long = valuearr?.object(at: 1)
                        
                        if lat != nil && long != nil {
                            
                            self.updateLoc(driver_lat: "\(lat!)", driver_long: "\(long!)")
                            
                        }
                        
                    }
                    
//                    self.peoplemarker.position = CLLocationCoordinate2DMake(APPDELEGATE.pickupLocation.coordinate.latitude, APPDELEGATE.pickupLocation.coordinate.longitude)
//                    self.peoplemarker.icon = #imageLiteral(resourceName: "pd")
//                    self.peoplemarker.map = self.mapview
                    
                    var requestState = ""
                    
                    if dict["request_status"] != nil {
                        requestState = "\(dict["request_status"]!)"
                    }
                    
                    if state == "2" {
                        
                        self.msgstr = ["Provider accepted the request".localized]
                        
                    }
                    
                    else if state == "3" {
                        
         //           self.showAlertView(message: "Driver started the trip to your location".localized)
                        
                        self.msgstr = ["Provider accepted the request".localized,"Provider gets started to your location".localized]
                        
                    }
                    
                    else if state == "4" {
                        print ("Check Request Status: \(requestState)")
                        
                        if requestState == "0" || requestState == "3" || requestState == ""{
                            self.showAlertView(title: "TowRoute".localized, message: "Provider has arrived to your job location. Click OK to start the job".localized, title1: "CANCEL".localized, title2: "OK".localized, callback: { (check) in
                                if check == false{
                                    self.msgstr = ["Provider accepted the request".localized,"Provider gets started to your location".localized, "Provider has arrived to job location".localized]
                                    
                                    Database.database().reference().child("booking_trips").child(self.booking_id).child("request_status").setValue("1")
                                    Database.database().reference().child("providers").child(self.driverid).child("trips").child("request_status").setValue("1")
                                    
                                }else {
                                    self.msgstr = ["Provider accepted the request".localized, "Provider gets started to your location".localized]
                                    
                                    Database.database().reference().child("booking_trips").child(self.booking_id).child("request_status").setValue("2")
                                    Database.database().reference().child("providers").child(self.driverid).child("trips").child("request_status").setValue("2")
                                    
                                }
                            })
                        }
                        
                        else if requestState == "2" {
                            self.msgstr = ["Provider accepted the request".localized, "Provider gets started to your location".localized]
                        }else {
                            self.msgstr = ["Provider accepted the request".localized,"Provider gets started to your location".localized, "Provider has arrived to job location".localized]
                        }
                        
                    }
                    
                    else if state == "5" {
                        
             //           self.showAlertView(message: "Your job has begun".localized)
                        
                        self.msgstr = ["Provider accepted the request".localized,"Provider gets started to your location".localized, "Provider has arrived to job location".localized,"Provider has started the job".localized]
                        
                        self.menuviewheight.constant = 150
                        self.menustr = ["Call".localized,"Message".localized,"SOS".localized]

                        self.tableview.reloadData()
                        
                    }
                 
                    else if state == "5.1"
                    {
                        self.menuviewheight.constant = 150

                        self.menustr = ["Call".localized,"Message".localized,"SOS".localized]

                      self.tableview.reloadData()

                        self.paymentview.isHidden = false
                        
                        if let unit_price = dict["unit_price"] {
                            
                            let amnt = "\(dict["unit_price"]!)"
                            self.currentcharge.text = " \(currency_symbol!) \(amnt.convertCur())"
                            
                        }
                        if let drop = dict["unit_price"] {
                            
                            self.drop_location = "\(dict["drop_location"]!)"
                            
                        }
                        
                        if let extra_charge = dict["extra_charge"] {
                            
                            let amnt = "\(dict["extra_charge"]!)"

                            self.materialFee.text = "\(currency_symbol!) \(amnt.convertCur())"
                            
                        }
                        
                        if let misc_charge = dict["misc_charge"] {
                            let amnt = "\(dict["misc_charge"]!)"

                            self.miscfee.text = " \(currency_symbol!) \(amnt.convertCur())"
                            
                        }
                        
                        if let driver_discount = dict["driver_discount"] {
                            
                            let amnt = "\(dict["driver_discount"]!)"

                            self.providerDiscount.text = " \(currency_symbol!) \(amnt.convertCur())"
                            
                        }
                        
                        if let visit_fare = dict["visit_fare"] {
                            
                            self.visitfare = "\(dict["visit_fare"]!)"
                            
                        }
                        
                        
                        if let sub_level_amount = dict["sub_level_amount"] {
                            
                            self.sublevelamount = "\(dict["sub_level_amount"]!)"
                            
                            if self.sublevelamount != ""{
                                self.currentchargeLbl.text = "Current Charges".localized+"(\(self.sublevelamount.convertCur()))+"+"Visit Price".localized+"(\(self.visitfare.convertCur()))"
                                if self.visitfare == "0"{
                                   self.currentchargeLbl.text = "Current Charges".localized
                                }
                                self.currentcharge.text = "\(currency_symbol!) " + String(format: "%.2f", (Double(self.sublevelamount.convertCur())! + Double(self.visitfare.convertCur())!))
                                
                            }
                            
                        }
                        
                        
                        if let total_distance = dict["total_distance"] {
                            
                            self.totalDistance.text = " \(dict["total_distance"]!)"
                            self.totaldistance = "\(dict["total_distance"]!)"
                            
                        }
                        
                        if self.drop_location != "NoDrop"
                        {
                        
                        if let price_per_km = dict["price_per_km"] {
                            
                            self.priceperkm = "\(dict["price_per_km"]!)"
                            
                            if self.priceperkm != "" && self.totaldistance != "" && self.priceperkm != "0"{
                                self.TotalDistanceLbl.text = "Total Distance".localized+" "+"("+"Price per KM".localized+" "+"\(self.priceperkm.convertCur()) * \(String(format: "%.2f", (Double(self.totaldistance)!))) KM ) "
                                self.totalDistance.text = "\(currency_symbol!) " + String(format: "%.2f", (Double(self.priceperkm.convertCur())! * Double(self.totaldistance)!))
                               
                            }
                            
                        }
                            
                        }
                       
                        if self.drop_location == "NoDrop"
                        {
                            
                            self.TotalDistanceLbl.text = "Total Distance".localized
                            self.totalDistance.text = "0.0"
                        }
                        
                        
                        if let total_amount = dict["total_amount"] {
                            
                            
                            let total = "\(dict["total_amount"]!)"
                            
                            self.total.text = "\(currency_symbol!)" + String(format: "%.2f", (Double(total.convertCur())!))
                            
                        }
                        
                        
                        if let promo =  dict["promo_value"]
                        {
                            self.promocode = "\(dict["promo_value"]!)"
                            
                            if self.promocode != "" && self.promocode != "0" && self.promocode != "0.0"
                            {
                                self.promoCodeLbl.isHidden = false
                                self.promoCodeLbl.text = " PROMO CODE \(self.promocode)%"
                                
                            }
                        }
                        
                        
                        
                        
                        }
                        
                        
                        
                  
                        
                    
                    else if state == "6" || state == "5.2" {
        
                            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                            let requestPage = storyBoard.instantiateViewController(withIdentifier:"summary") as! SummaryPageViewController
                            
                            
                            
                            if state == "10" {
                                
                                requestPage.showBalAlert = true
                                
                            }
                        
                        
                        if let driver = dict["driver_id"] {
                            
                            requestPage.driver_id = "\(dict["driver_id"]!)"
                            
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
                            
                       
//                        self.showAlertView(title: "Confirm".localized, message: "Your job service has successfully completed!".localized, callback: { (check) in
//
//
//                          let forgot = STORYBOARD.instantiateViewController(withIdentifier: "faresummary1")
//                          self.navigationController?.pushViewController(forgot, animated: true)
//
//                            self.present(forgot, animated: true, completion: nil)
//
//
//                         //   self.ratingview.isHidden = false
//
//                            // self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
//
//                        })
                        
                        
                    }
                    
                    else if state == "8" {
                        
                        self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
                        self.showAlertView(title: "TowRoute", message: "Your job service has been canceled!")
                        
//                        self.showAlertView(title: "Alert".localized, message: "Your job service has been canceled!".localized, callback: { (check) in
//
//                            self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
//
//                        })
                        
                    }
                        
                    else if state == "9" {
                        
                        
                        self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
                        self.showAlertView(title: "TowRoute", message: "Your job service has been canceled!")
//                        self.showAlertView(title: "Alert".localized, message: "Your job service has been canceled!".localized, callback: { (check) in
//
//                            self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
//
//                        })
                        
                    }
                        
                    else if state == "10" {
                        
                        
                       
                        
                        self.paymentview.isHidden = false
                        self.paymentRemainingView.isHidden = false
                
                        
                        if let total_amount = dict["total_amount"] {
                            
                            self.total_amount = "\(dict["total_amount"]!)"
                            
                        }
                        
                        
                        if let total_amount = dict["balance_amount"] {
                            
                            self.balance_amount = "\(dict["balance_amount"]!)"
                            self.paymentRemainingLbl.text = "\(currency_symbol!)" + String(format: "%.2f", (Double(self.balance_amount.convertCur())!))
                            
                        }
                        
                        
                        
                        
                   
                      
                        
                        
                    }
                    
                    print("state \(state) \(self.msgstr)")
                    
                    DispatchQueue.main.async {
                        self.progressTable.reloadData()
                    }
                    
                }
                
            }
            
        }
        
        // Do any additional setup after loading the view.
    }
    
    func arCarMovement(_ movedMarker: GMSMarker) {
        carmarker = movedMarker
        carmarker.map = mapview
        
        //animation to make car icon in center of the mapview
        //
        
        let currentZoom = self.mapview.camera.zoom
        
        let updatedCamera = GMSCameraUpdate.setTarget(carmarker.position, zoom: currentZoom)
        mapview.animate(with: updatedCamera)
    }
    
    func droploc()
    {
        if dropCheck == "NoDrop"
        {
            self.loclab.text = cusCheck
        }
        else
        {
            self.loclab.text = dropCheck
        }
    }
    var dropLocation = CLLocationCoordinate2DMake(0.0, 0.0)
    
    var driverlat: Double?
    var driverlong: Double?
 
    func updateLoc(driver_lat: String, driver_long: String) {
        
        
        if driver_lat != "" {
            
            d_lat = driver_lat
            d_long = driver_long
            
            driverlat = Double((driver_lat))
            
            driverlong = Double((driver_long))
            let cameras = GMSCameraPosition.camera(withLatitude: Double(driver_lat)!, longitude: Double(driver_long)!, zoom: 16.0)
            
            mapview.camera = cameras
            
            self.carmarker.position = CLLocationCoordinate2DMake(Double(driver_lat)!, Double(driver_long)!)
            self.carmarker.icon = #imageLiteral(resourceName: "mapCarIcon64").resize(toWidth: 30)
            self.carmarker.icon = #imageLiteral(resourceName: "mapCarIcon64").resize(toHeight: 60)
            self.carmarker.map = self.mapview
            
            let fromadd = CLLocationCoordinate2DMake(Double(driver_lat)!, Double(driver_long)!)
            
            let toadd = dropLocation
            
            //let toadd = CLLocationCoordinate2DMake(9.926072, 78.121521)
            
            
            if self.firsttime == true
            {
              print("FirstimeCalled")
                calculateRoutes(from: fromadd, to: toadd)

                self.timer?.invalidate()
                self.timer = Timer.scheduledTimer(timeInterval: 90.0, target: self, selector:#selector(self.timerCall(_:)), userInfo: APPDELEGATE.tripStatus, repeats: true)
            }
            
        }
        
        if self.oldCoordinate == nil {
            
            self.oldCoordinate = CLLocationCoordinate2D(latitude: driverlat!, longitude: driverlong!)
            
        }
            
            let newCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: driverlat!, longitude: driverlong!)
            
            self.moveMent.arCarMovement(self.carmarker, withOldCoordinate: self.oldCoordinate, andNewCoordinate: newCoordinate, inMapview: self.mapview, withBearing: 0)
            self.oldCoordinate = newCoordinate
        
        
    }
    
    
    @objc func timerCall(_ timer: Timer)
    {
        
        
        let currentDateTime = Date()

        print("Timer Call \(currentDateTime)")
        
        let fromadd = CLLocationCoordinate2DMake(Double(d_lat)!, Double(d_long)!)
        
        let toadd = dropLocation

        calculateRoutes(from: fromadd, to: toadd)

        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        if driverstatusRef != nil {
            
            driverstatusRef.removeAllObservers()
            
        }
        
        if firestatusRef != nil {
            
            firestatusRef.removeAllObservers()
            
        }
        
        driverstatusRef = nil
        
        firestatusRef = nil
        
    }
    
    
    @IBAction func liveTrackBtnActn(_ sender: Any) {
        
        livetrackBtnOutlet.setTitleColor(UIColor.white, for: .normal)
        livetrackBtnOutlet.backgroundColor = UIColor.init(hexString: "#393939")
        jobinprogressoutlet.backgroundColor = UIColor.white
        jobinprogressoutlet.setTitleColor(UIColor.black, for: .normal)
        beginview2.isHidden = true
        
        
        
    }
    
    
    @IBAction func jobinprogressBtnTctn(_ sender: Any) {
        
       jobinprogressoutlet.setTitleColor(UIColor.white, for: .normal)
       jobinprogressoutlet.backgroundColor = UIColor.init(hexString: "#393939")
       livetrackBtnOutlet.backgroundColor = UIColor.white
       livetrackBtnOutlet.setTitleColor(UIColor.black, for: .normal)
        beginview2.isHidden = false
        
    }
    
    
    func paymentCardTextFieldDidChange(_ textField: STPPaymentCardTextField) {
        // Toggle buy button state
        
        paybtn.isEnabled = textField.isValid
        let toolbarDone = UIToolbar.init()
        toolbarDone.sizeToFit()
        let barBtnDone = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.done,target: self, action: #selector(self.doneButton_Clicked))
        toolbarDone.items = [barBtnDone]
        // You can even add cancel button too
        textField.inputAccessoryView = toolbarDone
    }
    
    @objc func doneButton_Clicked() {
        self.paymentCardTextField.resignFirstResponder()
    
    }
    
    @IBAction func payAct(_ sender: Any) {
        
//        self.view.endEditing(true)
//
//        SVProgressHUD.setContainerView(topMostViewController().view)
//        SVProgressHUD.show()
//
//        let cardParams = paymentCardTextField.cardParams
//        let paymentconfig = STPPaymentConfiguration()
//        paymentconfig.requiredBillingAddressFields = .none
//        paymentconfig.publishableKey = "pk_test_WDP0fwVbtyJzXdGucvd901EJ"
//
//        STPAPIClient.shared().createToken(withCard: cardParams) { (token: STPToken?, error: Error?) in
//
//            SVProgressHUD.dismiss()
//
//            guard let token = token, error == nil else {
//                // Present error to user...
//                return
//            }
//
//            // let stripToken = (token.tokenId)
//            self.view.endEditing(true)
//            let cardno = cardParams.number!
//
//            if self.paymentRemainingView.isHidden
//            {
//            self.payment(token: token, cardnumber: cardno)
//            }
//
//            else
//            {
//                self.postStripeToken(token: token, cardnumber: cardno)
//            }
//        }
        
        self.view.endEditing(true)
            //
                    if paymentCardTextField.cardNumber == "" || paymentCardTextField.cardNumber == nil {
                     
                        self.showAlertView(message: "Please enter card number")
                    } else if paymentCardTextField.expirationMonth == 0 {
                        self.showAlertView(message: "Please enter expire month")
                    } else if paymentCardTextField.expirationYear == 0 {
                    self.showAlertView(message: "Please enter expire year")
                    } else if paymentCardTextField.cvc == ""{
                        self.showAlertView(message: "Please enter cvc")
                    }  else if paymentCardTextField.isValid == false {
                        self.showAlertView(message: "Please enter valid card details")
                    }
                        
                        
                        else {
                        
                        
                        SVProgressHUD.setContainerView(topMostViewController().view)
                        SVProgressHUD.show()

                         let cardParams = paymentCardTextField.cardParams
                        
                        let stripCard = STPCardParams()
                        
                        stripCard.number = cardParams.number
                        stripCard.cvc = cardParams.cvc
                        stripCard.expMonth = UInt(truncating: cardParams.expMonth!)
                        stripCard.expYear = UInt(truncating: cardParams.expYear!)
                        
                        print("carddetails \(stripCard)")
                            STPAPIClient.shared.createToken(withCard: stripCard) { (token: STPToken?, error: Error?) in
                            
                            
                                            guard let token = token, error == nil else {
                                                // self.showAlertView(message: (error?.localizedDescription)!)
                                                SVProgressHUD.dismiss()
                                                self.showAlertView(message: error!.localizedDescription)
                                               
                                                
                                                return
                                            }
                            

                          //  self.payment(token: token, cardnumber: "1234")
                           
                                     if self.paymentRemainingView.isHidden
                                        {
                                        self.payment(token: token, cardnumber: "1234")
                                        }
                            
                                        else
                                        {
                                            self.postStripeToken(token: token, cardnumber: "1234")
                                        }

                            
                        }
                        
                    }
        
        
        
        
        
        
        
        
    }
    
    func payment(token: STPToken, cardnumber: String)
    {
        
        
        
        
        let params = ["strip_token": token.tokenId,
                      "booking_id": booking_id,
                      "amount": total_amount,
                      "card_number": cardnumber] as [String : Any]
        
        print("params \(params)")
        
        APIManager.shared.customerTripPayment(params: params as [String : AnyObject]) { (response) in
            
            if case let msg as String = response?["message"], msg == "Unauthenticated." {
                
                APIManager.shared.refreshToken(params: params as [String : AnyObject]) { (response) in
                    
                    if case let access_token as String = response?["access_token"] {
                        
                        APPDELEGATE.bearerToken = access_token
                        
                        USERDEFAULTS.set(access_token, forKey: "access_token")
                        
                        self.payment(token: token, cardnumber: cardnumber)
                        
                    }
                        
                    else {
                        
                        self.showAlertView(title: "TowRoute".localized, message: "Your session has expired. Please log in again", callback: { (check) in
                            
                            APPDELEGATE.updateLoginView()
                            
                        })
                        
                    }
                    
                }
                
            }
                
            else if case let msg as String = response?["message"], msg == "Money debited successfully."
            {
                
                self.showAlertView(message: "Your Payment has been completed. Wait a moment! Provider Finish the Service".localized)
                self.paymentview.isHidden = true
               

                
            }
                
            else
                
            {
                if case let msg as String = response?["message"] {
                
                self.showAlertView(message: msg.localized)
                
            }
                
            }
            
        }
        
    }
    
    func postStripeToken(token: STPToken, cardnumber: String) {
        
        print("poststripe")
        
        let userdict = USERDEFAULTS.getLoggedUserDetails()
        
        let userid = userdict["id"] as! String
        
        let params = ["driver_id": self.driverid,
                      "customer_id": userid,
                      "transaction_token": token.tokenId,
                      "booking_id": booking_id,
                      "balance_amount": balance_amount,
                      "total_amount": total_amount,
                      "card_number": cardnumber] as [String : Any]
        
        print("params \(params)")
        
        APIManager.shared.customerBalancePayment(params: params as [String : AnyObject]) { (response) in
            
            if case let msg as String = response?["message"], msg == "Unauthenticated." {
                
                APIManager.shared.refreshToken(params: params as [String : AnyObject]) { (response) in
                    
                    if case let access_token as String = response?["access_token"] {
                        
                        APPDELEGATE.bearerToken = access_token
                        
                        USERDEFAULTS.set(access_token, forKey: "access_token")
                        
                        self.postStripeToken(token: token, cardnumber: cardnumber)
                        
                    }
                        
                    else {
                        
                        self.showAlertView(title: "TowRoute".localized, message: "Your session has expired. Please log in again", callback: { (check) in
                            
                            APPDELEGATE.updateLoginView()
                            
                        })
                        
                    }
                    
                }
                
            }
            else if case let msg as String = response?["message"], msg == "Request status updated successfully." {
                
                self.paymentRemainingView.isHidden = true
                self.paymentview.isHidden = true
                
                
                self.showAlertView(title: "Confirm".localized, message: "Your job service has successfully completed!".localized, callback: { (check) in
                
                    
                    
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                    
                let requestPage = storyBoard.instantiateViewController(withIdentifier:"summary") as! SummaryPageViewController
                
                
                    if let driver = self.paymentDict["driver_id"] {
                        
                        requestPage.driver_id = "\(self.paymentDict["driver_id"]!)"
                        
                    }
                
                if let customer_location = self.paymentDict["customer_location"] {
                    
                    requestPage.customer_location = "\(self.paymentDict["customer_location"]!)"
                    
                }
                
                if let extra_charge = self.paymentDict["extra_charge"] {
                    
                    requestPage.extra_charge = "\(self.paymentDict["extra_charge"]!)"
                    
                }
                
               
                if let misc_charge = self.paymentDict["misc_charge"] {
                    
                    requestPage.misc_charge = "\(self.paymentDict["misc_charge"]!)"
                    
                }
                
                
                if let driver_discount = self.paymentDict["driver_discount"] {
                    
                    requestPage.driver_discount = "\(self.paymentDict["driver_discount"]!)"
                    
                }
                
                    
                if let drop_location = self.paymentDict["drop_location"] {
                    
                    requestPage.drop_location = "\(self.paymentDict["drop_location"]!)"
                    
                }
                
                if let sub_level_amount = self.paymentDict["sub_level_amount"] {
                    
                    requestPage.sub_level_amount = "\(self.paymentDict["sub_level_amount"]!)"
                    
                }
                
                if let visit_fare = self.paymentDict["visit_fare"] {
                    
                    requestPage.visit_fare = "\(self.paymentDict["visit_fare"]!)"
                    
                }
                
                if let price_per_km = self.paymentDict["price_per_km"] {
                    
                    requestPage.price_per_km = "\(self.paymentDict["price_per_km"]!)"
                    
                }
                
                if let total_distance = self.paymentDict["total_distance"] {
                    
                    requestPage.total_distance = "\(self.paymentDict["total_distance"]!)"
                    
                }
                
                if let total_amount = self.paymentDict["total_amount"] {
                    
                    requestPage.total_amount = "\(self.paymentDict["total_amount"]!)"
                    
                }
                
                if let total_amount = self.paymentDict["total_amount"] {
                    
                    requestPage.totalval = "\(self.paymentDict["total_amount"]!)"
                    
                }
                
                if let job_date = self.paymentDict["job_date"] {
                    
                    requestPage.jobdate = "\(self.paymentDict["job_date"]!)"
                    
                }
                
                if let driver_discount = self.paymentDict["driver_discount"] {
                    
                    requestPage.discount = "\(self.paymentDict["driver_discount"]!)"
                    
                }
                
                if let payment_type = self.paymentDict["payment_type"] {
                    
                    requestPage.payment = "\(self.paymentDict["payment_type"]!)"
                    
                }
                
                if let category = self.paymentDict["category"] {
                    
                    requestPage.cat = "\(self.paymentDict["category"]!)"
                    
                    if LanguageManager.shared.currentLanguage == .ar{
                        requestPage.cat = "\(self.paymentDict["category_ar"]!)"
                    }
                    
                    
                    
                }
                
                if let unit_price = self.paymentDict["unit_price"] {
                    
                    requestPage.cur = "\(self.paymentDict["unit_price"]!)"
                    
                }
                
                if let total_amount = self.paymentDict["total_amount"] {
                    
                    requestPage.tot = "\(self.paymentDict["total_amount"]!)"
                    
                }
                
                if let customer_id = self.paymentDict["customer_id"] {
                    
                    requestPage.customer_id = "\(self.paymentDict["customer_id"]!)"
                    
                }
                
                if let booking_id = self.paymentDict["booking_id"] {
                    
                    requestPage.booking_id = "\(self.paymentDict["booking_id"]!)"
                    
                }
                
                if let booking_id = self.paymentDict["booking_id"] {
                    
                    requestPage.booking_id = "\(self.paymentDict["booking_id"]!)"
                    
                }
                
                if let booking_id = self.paymentDict["booking_id"] {
                    
                    requestPage.booking_id = "\(self.paymentDict["booking_id"]!)"
                    
                }
                
                if let booking_id = self.paymentDict["booking_id"] {
                    
                    requestPage.booking_id = "\(self.paymentDict["booking_id"]!)"
                    
                }
                
                if let promo = self.paymentDict["site_commission"] {
                    
                    requestPage.prmocode = "\(self.paymentDict["site_commission"]!)"
                    
                }
                
                if let promocode = self.paymentDict["promocode"] {
                    
                    requestPage.promocode = "\(self.paymentDict["promocode"]!)"
                    
                }
                
                if let promovalue = self.paymentDict["promo_value"] {
                    
                    requestPage.promovalue = "\(self.paymentDict["promo_value"]!)"
                    
                }
                    if let servicestatus = self.paymentDict["service_stautus"] {
                        
                        let servicestatus = "\(self.paymentDict["service_stautus"]!)"
                        
                    }
             
                    // The below firebase update hide for PartialPayment alert show issue on Provider Side and Cash Status Label. Its handled by constraint work on Summary Page - yas.
//                    Database.database().reference().child("providers").child("\(self.paymentDict["driver_id"]!)").child("trips").child("cash_status").setValue("1")
//                    Database.database().reference().child("booking_trips").child("\(self.paymentDict["booking_id"]!)").child("cash_status").setValue("1")
//                    Database.database().reference().child("providers").child("\(self.paymentDict["driver_id"]!)").child("trips").child("service_status").setValue("6")
//                    Database.database().reference().child("booking_trips").child("\(self.paymentDict["booking_id"]!)").child("service_status").setValue("6")
                
                self.topMostViewController().present(requestPage, animated: false, completion: nil)
                
//                self.showAlertView(title: "Confirm".localized, message: "Your job service has successfully completed!".localized, callback: { (check) in
//
//
//
//
//
//                })
                                            })
                
            }
                
                
            else if case let msg as String = response?["message"] {
                
                self.showAlertView(message: msg.localized)
                
            }
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == progressTable {
            
            print("msgstr \(self.msgstr.count)")
            
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
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == tableview {
            
            menuview.isHidden = true
            
            if indexPath.row == 0 {
                
                guard let number = URL(string: "tel://" + driver_phone_number) else { return }
                UIApplication.shared.open(number)
                
            }
                
            else if indexPath.row == 1 {
                
                if (MFMessageComposeViewController.canSendText()) {
                    let controller = MFMessageComposeViewController()
                    controller.body = ""
                    controller.recipients = [driver_phone_number]
                    controller.messageComposeDelegate = self
                    self.present(controller, animated: true, completion: nil)
                }
                
            }
//            else if indexPath.row == 2 {
                
         //       beginview2.isHidden = false
                
//                if beginview2.isHidden == false {
//
//                    beginview2.isHidden = true
//
//                    menustr[2] = "Job InProgress".localized
//
//                    self.tableview.reloadData()
//
//                }
//                else {
//
//                    beginview2.isHidden = false
//
//                    menustr[2] = "Live Track".localized
//
//                    self.tableview.reloadData()
//
//                }
                
      //      }
            else if indexPath.row == 2 {
            
                self.getContact()
                
            }
            else if indexPath.row == 3 {
                //when no reason needed
//                let alertMessage = UIAlertController(title: "Cancel Job!".localized, message: "Are you sure you want to cancel your job?".localized, preferredStyle: .alert)
//                let okAction = UIAlertAction(title: "CONTINUE JOB".localized, style: .default, handler: nil)
//                let cancelAction = UIAlertAction(title: "CANCEL JOB NOW".localized, style: .default, handler: { (UIAlertAction)in
//                    print("User click Cancel button")
//                    self.handleCancel()
//                })
//                alertMessage.addAction(okAction)
//                alertMessage.addAction(cancelAction)
//                self.present(alertMessage, animated: true, completion: nil)
                
                //when reason needed.
                cancelTripAct()
                
            }
            
        }
        
    }
    //reason updated here
    
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
    
    
    
    
    
    
    
    
    
    
    
    @IBAction func livetrack(_ sender: Any) {
        
        
        beginview2.isHidden = true
        
//        if beginview2.isHidden == false {
//
//            beginview2.isHidden = true
//
//           // menustr[2] = "Job InProgress".localized
//
//          //  self.tableview.reloadData()
//
//        }
//
//        else {
//
//            beginview2.isHidden = false
//
//        //    menustr[2] = "Live Track".localized
//
//         //   self.tableview.reloadData()
//
//        }
        
    }
    @IBAction func alertAct(_ sender: Any) {
    
        self.getContact()
        
    }
    
    func getContact() {
        
        let userdict = USERDEFAULTS.getLoggedUserDetails()
        
        let userid = userdict["id"] as! String
        
        let params = ["customer_id":userid]
        
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
                        
                        self.showAlertView(title: "TowRoute".localized, message: "Your session has expired. Please log in again", callback: { (check) in
                            
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
                        controller.body = "Please Help!! My location for TowRoute App https://www.google.co.in/maps/dir/?saddr=&daddr=\(APPDELEGATE.currentLocation.coordinate.latitude),\(APPDELEGATE.currentLocation.coordinate.longitude)&directionsmode=driving"
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
    
    func handleCancel(alertView: UIAlertAction!)
    {
       // when reason needed!
        print("User click Cancel button")
        print(self.textField.text)
        print(self.textField1.text)
        
        if self.textField.text == "" {
            
            self.showAlertView(title: "TowRoute".localized, message: "Please enter your reason!".localized, callback: { (check) in
                
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
            
            self.showAlertView(title: "TowRoute".localized, message: "Please enter your comment!".localized, callback: { (check) in
                
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
        
        
        
        let params = ["mode":"customer",
                      "reason": self.textField.text! + "-" + self.textField1.text!,
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
                        
                        self.showAlertView(title: "TowRoute".localized, message: "Your session has expired. Please log in again", callback: { (check) in
                            
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backAct(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func cancelAct(_ sender: Any) {
    
        self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
        
    }
    
    @IBAction func rateAct(_ sender: Any) {
        
        let userdict = USERDEFAULTS.getLoggedUserDetails()
        
        let userid = userdict["id"] as! String
        
        let comment = commentText.text!
        
        if comment == "" {
            
            self.showAlertView(message: "Please enter your comments".localized)
            return
            
        }
        
        let params = ["from_id": userid,
                      "to_id": driverid,
                      "job_id": booking_id,
                      "rating": Int(rateDriver.rating),
                      "status": "0",
                      "feedback": comment,
                      ] as [String : Any]
        
        print("params \(params)")
        
        APIManager.shared.driverFeedbackStore(params: params as [String : AnyObject]) { (response) in
            print("responsese\(response)")
            
            if case let msg as String = response?["message"], msg == "Unauthenticated." {
                
                APIManager.shared.refreshToken(params: params as [String : AnyObject]) { (response) in
                    
                    if case let access_token as String = response?["access_token"] {
                        
                        APPDELEGATE.bearerToken = access_token
                        
                        USERDEFAULTS.set(access_token, forKey: "access_token")
                        
                        self.rateAct(self)
                        
                    }
                        
                    else {
                        
                        self.showAlertView(title: "TowRoute".localized, message: "Your session has expired. Please log in again", callback: { (check) in
                            
                            APPDELEGATE.updateLoginView()
                            
                        })
                        
                    }
                    
                }
                
            }
                
            else if case let msg as String = response?["message"], msg == "Feedback received" {
                
                self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
                
            }
            
        }
        
    }
    
    func calculateRoutes(from f: CLLocationCoordinate2D, to t: CLLocationCoordinate2D)  {
        
        var data = ""
     //   let saddr = "\(f.latitude),\(f.longitude)"
      //  let daddr = "\(t.latitude),\(t.longitude)"
       // let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(saddr)&destination=\(daddr)&mode=driving&key=\(googleApiKey)"
        
      //  print("url route \(url)")
        
       // Alamofire.request(url).responseJSON { response in
         let fireRef = Database.database().reference()
        
        self.driverstatusRef1 = fireRef.child("providers").child(self.driverid).child("est_distance")
        self.driverstatusRef2 = fireRef.child("providers").child(self.driverid).child("est_duration")
        
        self.driverstatusRef1.observe(DataEventType.value) { (SnapShot:DataSnapshot) in
            
            if let statusval = SnapShot.value{
               // let valuearr = SnapShot.value as! String
                 
                self.dis = "\(statusval)"
                print("chkvaluearr1 estdis\(self.dis)")
                self.carmarker.title = self.dis //+ "," + dur
            }
                   
 
            
        }
        self.driverstatusRef2.observe(DataEventType.value) { (SnapShot:DataSnapshot) in
                   
            if let statusval = SnapShot.value{
                
               // let valuearr = SnapShot.value as! String
                self.dur = "\(statusval)"
                print("chkvaluearr1 estdur\(self.dur)")
                self.carmarker.title = self.carmarker.title! + "," + self.dur
            }
        
        }
        
        print("checkdis\(dis)dur \(dur)")
       
             
       
        
       
        
        self.driverstatusRef = fireRef.child("direction").child(self.driverid).child("direction")
        
        self.driverstatusRef.observe(DataEventType.value) { (SnapShot:DataSnapshot) in
            
            let valuearr = SnapShot.value as? String
            
            print("chk_valuearr\(valuearr)")
        
            if valuearr != nil && valuearr != "" {
                
                data = valuearr!
                
                            do {
                               // let json = try JSONSerialization.jsonObject(with: response.data!, options: .mutableContainers) as! NSDictionary
                                
                                //We need to get to the points key in overview_polyline object in order to pass the points to GMSPath.
                                
                                
                                
                        
                                let datas = "{\"geocoded_waypoints\":[{\"place_id\":\"ChIJa4dtMXLPADsRQI7MNy4qrjU\",\"geocoder_status\":\"OK\",\"types\":[\"street_address\"]},{\"place_id\":\"ChIJNRp7gbDPADsRrgncZrDIh1A\",\"geocoder_status\":\"OK\",\"types\":[\"street_address\"]}],\"routes\":[{\"bounds\":{\"northeast\":{\"lat\":9.9206415,\"lng\":78.0987916},\"southwest\":{\"lat\":9.8930125,\"lng\":78.0763564}},\"copyrights\":\"Map data ©2021\",\"legs\":[{\"distance\":{\"text\":\"5.2 km\",\"value\":\"5201\"},\"duration\":{\"text\":\"12 mins\",\"value\":\"696\"},\"end_address\":\"187, Kala Malai, Pasumalai, Madurai, Tamil Nadu 625004, India\",\"end_location\":{\"lat\":9.8968074,\"lng\":78.0768154},\"start_address\":\"204, Jai Nagar Main Rd, Ponmeni, Chandragandhi Nagar, Tamil Nadu 625016, India\",\"start_location\":{\"lat\":9.9206415,\"lng\":78.09272229999999},\"steps\":[{\"distance\":{\"text\":\"77 m\",\"value\":\"77\"},\"duration\":{\"text\":\"1 min\",\"value\":\"24\"},\"end_location\":{\"lat\":9.9204645,\"lng\":78.0934013},\"html_instructions\":\"Head \\u003cb\\u003eeast\\u003c/b\\u003e on \\u003cb\\u003ePonemeni Muniandi Kovil St\\u003c/b\\u003e/\\u003cwbr/\\u003e\\u003cb\\u003ePonmeni Main Rd\\u003c/b\\u003e toward \\u003cb\\u003eW Service Rd\\u003c/b\\u003e\\u003cdiv style\\u003d\\\"font-size:0.9em\\\"\\u003ePass by M S Logistics (on the left)\\u003c/div\\u003e\",\"polyline\":{\"points\":\"_sp{@ons{MH_@DQDQFe@D]\"},\"start_location\":{\"lat\":9.9206415,\"lng\":78.09272229999999},\"travel_mode\":\"DRIVING\"},{\"distance\":{\"text\":\"1.7 km\",\"value\":\"1735\"},\"duration\":{\"text\":\"4 mins\",\"value\":\"246\"},\"end_location\":{\"lat\":9.9058583,\"lng\":78.0986753},\"html_instructions\":\"Turn \\u003cb\\u003eright\\u003c/b\\u003e at Dr AQUA SOLUTIONS - Experts in Water Treatment onto \\u003cb\\u003e9th St\\u003c/b\\u003e/\\u003cwbr/\\u003e\\u003cb\\u003eBypass Rd\\u003c/b\\u003e\\u003cdiv style\\u003d\\\"font-size:0.9em\\\"\\u003eContinue to follow Bypass Rd\\u003c/div\\u003e\\u003cdiv style\\u003d\\\"font-size:0.9em\\\"\\u003ePass by Vocational Training And Rehabilitation Centre (on the left)\\u003c/div\\u003e\",\"maneuver\":\"turn-right\",\"polyline\":{\"points\":\"{qp{@wrs{M@Ur@?fAGhASh@Qv@S`Cu@xC{@NGbAUh@MhBk@^MvBi@hAYxDgAtBi@n@STGxBk@RChA[RIvGqBjF_BRG@?ZIzGmBfCq@JCf@KZEPEDAVCl@E\\\\CnAW\"},\"start_location\":{\"lat\":9.9204645,\"lng\":78.0934013},\"travel_mode\":\"DRIVING\"},{\"distance\":{\"text\":\"2.8 km\",\"value\":\"2811\"},\"duration\":{\"text\":\"6 mins\",\"value\":\"348\"},\"end_location\":{\"lat\":9.8932098,\"lng\":78.0776379},\"html_instructions\":\"At the roundabout, take the \\u003cb\\u003e3rd\\u003c/b\\u003e exit onto \\u003cb\\u003eMadurai -Thirumangalam Rd\\u003c/b\\u003e/\\u003cwbr/\\u003e\\u003cb\\u003eTenkasi - Madurai Rd\\u003c/b\\u003e/\\u003cwbr/\\u003e\\u003cb\\u003eTirupparankunram Rd\\u003c/b\\u003e\\u003cdiv style\\u003d\\\"font-size:0.9em\\\"\\u003ePass by Lakshmana Hospital (on the left in 1.3\\u0026nbsp;km)\\u003c/div\\u003e\",\"maneuver\":\"roundabout-left\",\"polyline\":{\"points\":\"svm{@wst{M@??A?A@A?A@A@??ADEFABAD?F?@@@?@?@@@??@@?@@@@@@@@?@@??@p@^JHFD`@Xd@Zt@f@RPDBXRPPDDHDLLXTd@^p@n@\\\\XTZV`@RZFJRXXd@Zl@Xb@Zd@X\\\\`@b@dAbAdAbA~@`An@f@f@^HNj@x@l@bAf@t@BBr@jAVb@HLPNRVX`@R\\\\JXBHFNH\\\\Lh@Vz@HTBJLXVf@BD`@~@n@tAHPjAvBl@fAlAxAf@l@TT|@`AX`@HL@@`DpET`@L\\\\LZ@DFTBLPvALv@JbALhAFr@PxBJv@Hp@PnAh@bDJj@Lp@F^^zBDNH`@PdA@JHn@Ft@LdA@DBXDTFZ\\\\nA@D\"},\"start_location\":{\"lat\":9.9058583,\"lng\":78.0986753},\"travel_mode\":\"DRIVING\"},{\"distance\":{\"text\":\"0.1 km\",\"value\":\"149\"},\"duration\":{\"text\":\"1 min\",\"value\":\"25\"},\"end_location\":{\"lat\":9.8930125,\"lng\":78.0763564},\"html_instructions\":\"Turn \\u003cb\\u003eright\\u003c/b\\u003e onto \\u003cb\\u003eVilachery Main Rd\\u003c/b\\u003e\\u003cdiv style\\u003d\\\"font-size:0.9em\\\"\\u003ePass by Mannar College Entrance (on the right)\\u003c/div\\u003e\",\"maneuver\":\"turn-right\",\"polyline\":{\"points\":\"qgk{@gpp{MKFEDRtBd@zB\"},\"start_location\":{\"lat\":9.8932098,\"lng\":78.0776379},\"travel_mode\":\"DRIVING\"},{\"distance\":{\"text\":\"0.4 km\",\"value\":\"422\"},\"duration\":{\"text\":\"1 min\",\"value\":\"49\"},\"end_location\":{\"lat\":9.8967722,\"lng\":78.07676769999999},\"html_instructions\":\"Turn \\u003cb\\u003eright\\u003c/b\\u003e to stay on \\u003cb\\u003eVilachery Main Rd\\u003c/b\\u003e\\u003cdiv style\\u003d\\\"font-size:0.9em\\\"\\u003ePass by Karupusamil Kovil (on the left in 400\\u0026nbsp;m)\\u003c/div\\u003e\",\"maneuver\":\"turn-right\",\"polyline\":{\"points\":\"ifk{@ghp{MQCI?K?q@CoDYwBOaEUaBMa@AM?I?GBG@\"},\"start_location\":{\"lat\":9.8930125,\"lng\":78.0763564},\"travel_mode\":\"DRIVING\"},{\"distance\":{\"text\":\"7 m\",\"value\":\"7\"},\"duration\":{\"text\":\"1 min\",\"value\":\"4\"},\"end_location\":{\"lat\":9.8968074,\"lng\":78.0768154},\"html_instructions\":\"Turn \\u003cb\\u003eright\\u003c/b\\u003e at Best Aqua Water Purifier Sales \\u0026amp; Service in Madurai | RO Water Plant in Madurai onto \\u003cb\\u003eOld vilaachery main Rd\\u003c/b\\u003e\",\"maneuver\":\"turn-right\",\"polyline\":{\"points\":\"y}k{@yjp{MCAAA?AAA?A\"},\"start_location\":{\"lat\":9.8967722,\"lng\":78.07676769999999},\"travel_mode\":\"DRIVING\"}],\"via_waypoint\":[]}],\"overview_polyline\":{\"points\":\"_sp{@ons{M\\\\iBFs@r@?fAGhASh@QxDiAhDcAlBc@hCy@`EcAnHqBdA[lCo@|Ae@xOyEvHwBrCu@zAYdAI\\\\CnAW@A@CBEVIRDHHdAp@pCnBnCxBnAhAl@|@hAfBt@pAt@bAlFlFvAfAt@hAlChE`@p@d@f@l@~@Nb@v@rCL`@d@`A~AlDxB~DtBfCvBfCbDrEb@~@ZdA^nCXlCXlDThBtApIf@zCNp@RpAPdBXzBd@jB@DKFEDRtBd@zBQCU?aF]}Lu@W?ODEEAC\"},\"summary\":\"Bypass Rd and Madurai -Thirumangalam Rd/Tenkasi - Madurai Rd/Tirupparankunram Rd\",\"warnings\":[],\"waypoint_order\":[]}],\"status\":\"OK\"}"
                                
                               let jsonData = data.data(using: .utf8)!
                                let json = try! JSONSerialization.jsonObject(with: jsonData, options: .allowFragments)

                                if let str = json as? String {
                                    print("chkstr123\(str)") // 3
                                }
                                
                                
                                let routes = ((json as AnyObject).object(forKey: "routes") as! NSArray)
                                 print("routes123\(routes)")
                                let status = ((json as AnyObject).object(forKey: "status") as! NSString)
                                 print("status123\(status)")
                                if status == "OK" {
                                     if let route = routes[0] as? [String:Any] {
                                    
                                                                    if let legs = route["legs"] as? [Any] {
                                    
                                                                        if let leg = legs[0] as? [String:Any] {
                                    
                                                                            if let steps = leg["distance"] as? [String:Any] {
                                    
                                                                                if let distancetext = steps["text"] as? String {
                                    
                                                                                    if self.carmarker != nil{
                                                                                        //self.carmarker.title = distancetext
                                                                                    }
                                    
                                                                                }
                                    
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
                                    
                                    
                                }
                                
                                                           }
                                                   }
                                        }
                                    }
                                }
                                //polyline
                                
                                
                                
                                
                                //estdi dur
                                
                                //marker label
                                
                                
                                    
                //                else if routes.count > 0 {
                //
                //                    if let route = ((routes.object(at: 0) as? NSDictionary)?.object(forKey: "overview_polyline") as? NSDictionary)?.value(forKey: "points") as? String {
                //
                //                        self.mapview.clear()
                //
                //                        if let routes = (json as AnyObject)["routes"]! as? String {
                //
                //                            if let route = routes[0] as? [String:Any] {
                //
                //                                if let legs = route["legs"] as? [Any] {
                //
                //                                    if let leg = legs[0] as? [String:Any] {
                //
                //                                        if let steps = leg["distance"] as? [String:Any] {
                //
                //                                            if let distancetext = steps["text"] as? String {
                //
                //                                                if self.carmarker != nil{
                //                                                    //self.carmarker.title = distancetext
                //                                                }
                //
                //                                            }
                //
                //                                        }
                //
                ////                                        let fireRef = Database.database().reference()
                ////                                        let driverratingtRef = fireRef.child("providers").child(driver_id)
                ////
                ////                                        driverratingtRef.observe(DataEventType.value) { (SnapShot: DataSnapshot) in
                ////
                //////                                            if let statusval = SnapShot.value {
                //////
                //////
                //////                                            }
                ////                                            if let dict = SnapShot.value as? NSDictionary {
                ////
                ////                                                if let dis_title = dict["est_distance"] {
                ////                                                        print("chk_dis_title\(dis_title)")
                ////                                                    dis = dis_title as! String
                ////                                                }
                ////                                                else{
                ////                                                    dis = "loading"
                ////                                                }
                ////                                                if let dur_title = dict["est_duration"] {
                ////                                                           print("chk_dur_title\(dur_title)")
                ////
                ////                                                    dur = dur_title as! String
                ////                                                }
                ////                                                else{
                ////                                                    dur = "loading"
                ////                                                }
                ////
                ////
                ////                                                if self.carmarker != nil{
                ////                                                self.carmarker.title = dis + "," + dur
                ////                                                }
                ////                                            }
                ////
                ////                                        }
                //
                //
                //                                        if let steps = leg["steps"] as? [Any] {
                //
                //                                            for step in steps {
                //
                //                                                if let step = step as? [String:Any] {
                //
                //                                                    if let polyline = step["polyline"] as? [String:Any] {
                //
                //                                                        if let points = polyline["points"] as? String {
                //
                //                                                            let path  = GMSPath(fromEncodedPath:points)!
                //                                                            let polyline  = GMSPolyline(path: path)
                //                                                            polyline.strokeColor = UIColor.black
                //                                                            polyline.strokeWidth = 5.0
                //
                //                                                            //mapView is your GoogleMaps Object i.e. _mapView in your case
                //                                                            polyline.map = self.mapview
                //
                //                                                        }
                //                                                    }
                //                                                }
                //
                //                                            }
                //
                //
                //                                            self.firsttime = false
                //
                //                                            self.carmarker.position = CLLocationCoordinate2DMake(f.latitude, f.longitude)
                //                                            self.carmarker.icon = #imageLiteral(resourceName: "mapCarIcon64").resize(toWidth: 30)
                //                                            self.carmarker.icon = #imageLiteral(resourceName: "mapCarIcon64").resize(toHeight: 60)
                //                                            self.carmarker.map = self.mapview
                //
                //
                //                                            self.peoplemarker.position = CLLocationCoordinate2DMake(t.latitude, t.longitude)
                //                                            self.peoplemarker.icon = #imageLiteral(resourceName: "pd")
                //                                            self.peoplemarker.map = self.mapview
                //
                //                                            let currentZoom = self.mapview.camera.zoom
                //
                //                                            let camera = GMSCameraPosition.camera(withLatitude: f.latitude, longitude: f.longitude, zoom: currentZoom)
                //
                //                                            self.mapview.camera = camera
                //
                //                                        }
                //                                    }
                //                                }
                //                            }
                //                        }
                //
                //                    }
                //
                //                }
                                
                            } catch {
                            }

                
            }
            
        }
            
            
       // }
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

class jobCell: UITableViewCell {
    
    @IBOutlet var countlab: UILabel!
    @IBOutlet var msglab: UILabel!
    @IBOutlet var timelab: UILabel!
    @IBOutlet var lasttimelab: UILabel!
    
    
    
    override func awakeFromNib() {
        
        countlab.layer.cornerRadius = 25
        countlab.layer.masksToBounds = true
        
    }
    
}

