//
//  PaymentmodeViewController.swift
//  TowRoute User
//
//  Created by Admin on 04/07/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import Firebase
import Stripe
import SVProgressHUD

class PaymentmodeViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,STPPaymentCardTextFieldDelegate {
    
    
    var dist = ""//APPDELEGATE.distance
                   
    var selectedStr = ""
    var selectedArray = NSMutableArray()
    var pay = ["My Wallet".localized,"Pay via Debit card / Credit card".localized,"Cash on Hand".localiz()]
    @IBOutlet var bookbtn: UIButton!
    
    @IBOutlet var bottomview: UIView!
    
    @IBOutlet var paymentCardTextField: STPPaymentCardTextField!
    @IBOutlet var paybtn: UIButton!
    
    var promocodetxt = ""
    var specialIns = ""
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pay.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "paymentmenu", for: indexPath) as! paymentmenucell
        
        cell.paylabel.text = pay[indexPath.row]
        if selectedArray.contains(indexPath.row) {
            cell.img.image = #imageLiteral(resourceName: "dot-and-circle")
        }
        else {
            cell.img.image = #imageLiteral(resourceName: "circle-shape-outline")
        }
        
        cell.selectionStyle = .none
        
        return cell
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
        
        SVProgressHUD.setContainerView(topMostViewController().view)
        SVProgressHUD.show()
        
        let cardParams: STPCardParams = STPCardParams()
                                      cardParams.number = paymentCardTextField!.cardNumber
                                      cardParams.expMonth = UInt(paymentCardTextField!.expirationMonth)
                                      cardParams.expYear = UInt(paymentCardTextField!.expirationYear)
                                      cardParams.cvc = paymentCardTextField!.cvc
        STPAPIClient.shared.createToken(withCard: cardParams, completion: { (token, error) -> Void in
                       if error == nil {}
                       else {
                           
                           APPDELEGATE.stripToken = (token!.tokenId)
                           
                           self.view.endEditing(true)
                           self.showAlertView(message: "Add card successfully!".localized)
                           
                   }
                   })
        
        
        
        
        
        
//        let cardParams = paymentCardTextField.cardParams
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
//            APPDELEGATE.stripToken = (token.tokenId)
//
//            self.view.endEditing(true)
//            self.showAlertView(message: "Add card successfully!".localized)
//
//        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedArray.removeAllObjects()
        print("valuews\(pay[indexPath.row])")
        selectedStr = "\(pay[indexPath.row])"
        selectedArray.add(indexPath.row)
        
        tableView.reloadData()
        
//        if indexPath.row == 1 {
//
//            bottomview.isHidden = false
//
//        }
//        else {
//
//            bottomview.isHidden = false
//
//        }
        
    }
    
    @IBOutlet var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if APPDELEGATE.isBookLater == true {
            
            bookbtn.setTitle("BOOK LATER".localized, for: UIControlState.normal)
            
        }
        
        print("insidepaymentmodepage\(APPDELEGATE.dropLoationAddress)")
        
        paymentCardTextField.delegate = self
        
        paybtn.isEnabled = false
        
        bottomview.isHidden = true
        
        self.title = "CHOOSE PAYMENT MODE".localized
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func back_act(_ sender: Any) {
        
        APPDELEGATE.stripToken = ""
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func bookingAct(_ sender: Any) {
        
        if selectedArray.count == 0 {
            
            self.showAlertView(message: "Please select payment mode!".localized)
            
        }
        else {
            
            let firedata = Database.database().reference().child("providers").child(APPDELEGATE.driverID).child("trips")
            
            print("firedata \(APPDELEGATE.driverID)")
            
            let userdict = USERDEFAULTS.getLoggedUserDetails()
            
            let userid = userdict["id"] as! String
            
            var username = ""
            
            if case let first_name as String = userdict["first_name"] {
                
                if(!(first_name.isEmpty)){
                    
                    username = first_name.uppercased() + " "
                    
                }
                
            }
            
            if case let last_name as String = userdict["last_name"] {
                
                if(!(last_name.isEmpty)){
                    
                    username = username + ":" + " " + "\(last_name.uppercased())"
                    
                }
                
            }
            
                        if selectedStr == "My Wallet"  {
                            //selectedArray[0] as! Int == 0
                            if APPDELEGATE.userWallet.convertCur() != "" && Double(APPDELEGATE.userWallet.convertCur())! < 5.0{
                                
                               // self.showAlertView(message: "Minimum Wallet amount should be 100,kindly recharge your wallet before proceeding".localized)
                                
                                self.showAlertView(title: "TOWROUTE", message: "Kindly recharge your wallet before proceeding.Your wallet amount is below or equal to \(currency_symbol!)5.0".localized) { (true) in
                                    let VC1 = self.storyboard!.instantiateViewController(withIdentifier: "wallet") as! WalletViewController
                                    self.navigationController!.pushViewController(VC1, animated: true)
                                }
                                return
                            }
                            
                            if APPDELEGATE.isBookLater == true {
                                
                                booklaterAct(iswallet: "Wallet")
                                
                                return
                                
                            }
                            var userdrop = ""
                           //Towing Flat Tire
            //                if APPDELEGATE.selectedCat == "Tow Truck Service" || APPDELEGATE.selectedCat == "Taxi Service" || APPDELEGATE.selectedCat == "Recovery Truck" || APPDELEGATE.selectedCat == "Towing" || APPDELEGATE.selectedCat == "Flat Tire"
            //                {
            //
            //                   userdrop = APPDELEGATE.dropLoationAddress
            //                }
                            
                            var dist = "" // APPDELEGATE.distance
                            
                            if dist == "" {
                                
                                dist = "NoDistance"
                                
                            }
                            
                            var droplat = APPDELEGATE.dropLocation
                            
                            var droplatstr = "0.0"
                            var droplongstr = "0.0"
                            
                            if APPDELEGATE.isdroplocationcategory == false {//nodropissue
                                print("inside 1 isdroplocationcategory == false")
                                userdrop = "NoDrop"
                            }
                            else{
                                print("inside 1 isdroplocationcategory == true")
                                userdrop = APPDELEGATE.dropLoationAddress
                            }
                            
                            if APPDELEGATE.dropLocation != nil {
                                
                                droplatstr = "\(APPDELEGATE.dropLocation.coordinate.latitude)"
                                droplongstr = "\(APPDELEGATE.dropLocation.coordinate.longitude)"
                                
                            }
                            print("chkuserdrop\(userdrop)")
                            print("chkdroplatstr\(droplatstr)")
                            print("chkdroplongstr\(droplongstr)")
                            
                            let dict = ["base_fare" : APPDELEGATE.servicePrice,
                                        "customer_id" : userid,
                                        "customer_name" : username,
                                        "main_service" : APPDELEGATE.selectedCatID+":"+APPDELEGATE.selectedCat,
                                        "paymode" : "wallet",
                                        "pickup_lat" : "\(APPDELEGATE.pickupLocation.coordinate.latitude)",
                                "pickup_lng" : "\(APPDELEGATE.pickupLocation.coordinate.longitude)",
                                "drop_lat" : droplatstr,
                                "drop_lon" : droplongstr,
                                "promocode" : promocodetxt,
                                "special_ins" : specialIns,
                                "sub_service" : APPDELEGATE.selectedServiceID+":"+APPDELEGATE.selectedService,
                                "user_drop" : userdrop,
                                "user_pickup" : APPDELEGATE.pickupLoationAddress,
                                "user_rating" : "0",
                                "service_status" : "1",
                                "distance" : dist,
                                "amount_type" : "",//APPDELEGATE.amount_type,
                                "price_per_hour" : "",//APPDELEGATE.price_per_hour,
                                "price_per_km" : "",//APPDELEGATE.price_per_km,
                                "price_per_min" : "",//APPDELEGATE.price_per_min,
                                "visit_fare" : "",
                                "main_service_ar":APPDELEGATE.selectedCatInSpanish,
                                "sub_service_ar":APPDELEGATE.selectedServiceInSpanish]//APPDELEGATE.visit_fare]
                            
                            
                            firedata.setValue(dict)
                            PushnotificationToDriver()
                            
                        }
                        else if selectedStr == "Pay via Debit card / Credit card" {
                            
                           
                            
                            
                            
            //                if APPDELEGATE.stripToken == "" {
            //
            //                    self.showAlertView(message: "Please add your card details!".localized)
            //
            //                    return
            //                }
                            
                            if APPDELEGATE.isBookLater == true {
                                
                                booklaterAct(iswallet: "Card")
                                
                                return
                                
                            }
                            var userdrop = ""
                            
            //                if APPDELEGATE.selectedCat == "Tow Truck Service" || APPDELEGATE.selectedCat == "Taxi Service" || APPDELEGATE.selectedCat == "Recovery Truck" || APPDELEGATE.selectedCat == "Towing" || APPDELEGATE.selectedCat == "Flat Tire"
            //                {
            //
            //                    userdrop = APPDELEGATE.dropLoationAddress
            //                }
                          
                            var dist = ""//APPDELEGATE.distance
                            
                            if dist == "" {
                                
                                dist = "NoDistance"
                                
                            }
                            
                            var droplat = ""//APPDELEGATE.dropLocation
                            
                            var droplatstr = "0.0"
                            var droplongstr = "0.0"
                            
                            if APPDELEGATE.dropLocation != nil {
                                
                                droplatstr = "\(APPDELEGATE.dropLocation.coordinate.latitude)"
                                droplongstr = "\(APPDELEGATE.dropLocation.coordinate.longitude)"
                                
                            }
                            
                            if APPDELEGATE.isdroplocationcategory == false {
                                print("inside 2 isdroplocationcategory == false")
                                userdrop = "NoDrop"
                            }
                            else{
                                print("inside 2 isdroplocationcategory == true")
                                               userdrop = APPDELEGATE.dropLoationAddress
                                           }
                            
                            print("chkuserdrop\(userdrop)")
                                           print("chkdroplatstr\(droplatstr)")
                                           print("chkdroplongstr\(droplongstr)")
                            
                            let dict = ["base_fare" : APPDELEGATE.servicePrice,
                                        "customer_id" : userid,
                                        "customer_name" : username,
                                        "main_service" : APPDELEGATE.selectedCatID+":"+APPDELEGATE.selectedCat,
                                        "paymode" : "card",
                                        "stripe_token" :"",
                                        "pickup_lat" : "\(APPDELEGATE.pickupLocation.coordinate.latitude)",
                                "pickup_lng" : "\(APPDELEGATE.pickupLocation.coordinate.longitude)",
                                "drop_lat" : droplatstr,
                                "drop_lon" : droplongstr,
                                "promocode" : promocodetxt,
                                "special_ins" : specialIns,
                                "sub_service" : APPDELEGATE.selectedServiceID+":"+APPDELEGATE.selectedService,
                                "user_drop" : userdrop,
                                "user_pickup" : APPDELEGATE.pickupLoationAddress,
                                "user_rating" : "0",
                                "service_status" : "1",
                                "distance" : dist,
                                "amount_type" : "",//APPDELEGATE.amount_type,
                                "price_per_hour" : "",//APPDELEGATE.price_per_hour,
                                "price_per_km" : "",//APPDELEGATE.price_per_km,
                                "price_per_min" : "",//APPDELEGATE.price_per_min,
                                "visit_fare" : "",
                                "main_service_ar":APPDELEGATE.selectedCatInSpanish,
                                "sub_service_ar":APPDELEGATE.selectedServiceInSpanish]//APPDELEGATE.visit_fare]
                            
                            
                           
                            firedata.setValue(dict)
                             PushnotificationToDriver()
                            APPDELEGATE.stripToken = ""
                            
                            
                            
                        }
                        
                                    else {
                                        
                                        
                                          if APPDELEGATE.isBookLater == true {
                                              
                                              booklaterAct(iswallet: "Cash")
                                              
                                              return
                                              
                                          }
                                          var userdrop = ""
                                          
                        //                  if APPDELEGATE.selectedCat == "Tow Truck Service" || APPDELEGATE.selectedCat == "Taxi Service" || APPDELEGATE.selectedCat == "Recovery Truck" || APPDELEGATE.selectedCat == "Towing" || APPDELEGATE.selectedCat == "Flat Tire"
                        //                  {
                        //
                        //                      userdrop = APPDELEGATE.dropLoationAddress
                        //                  }
                                        
                                          var dist = ""//APPDELEGATE.distance
                                          
                                          if dist == "" {
                                              
                                              dist = "NoDistance"
                                              
                                          }
                                          
                                          var droplat = ""//APPDELEGATE.dropLocation
                                          
                                          var droplatstr = "0.0"
                                          var droplongstr = "0.0"
                                          
                                          if APPDELEGATE.dropLocation != nil {
                                              
                                              droplatstr = "\(APPDELEGATE.dropLocation.coordinate.latitude)"
                                              droplongstr = "\(APPDELEGATE.dropLocation.coordinate.longitude)"
                                              
                                          }
                                          
                                          if APPDELEGATE.isdroplocationcategory == false {
                                              userdrop = "NoDrop"
                                          }
                                          else{
                                            userdrop = APPDELEGATE.dropLoationAddress
                                        }
                                          
                                          print("chkuserdrop\(userdrop)")
                                                         print("chkdroplatstr\(droplatstr)")
                                                         print("chkdroplongstr\(droplongstr)")
                                          
                                          let dict = ["base_fare" : APPDELEGATE.servicePrice,
                                                      "customer_id" : userid,
                                                      "customer_name" : username,
                                                      "main_service" : APPDELEGATE.selectedCatID+":"+APPDELEGATE.selectedCat,
                                                      "paymode" : "cash",
                                                      "stripe_token" :"",
                                                      "pickup_lat" : "\(APPDELEGATE.pickupLocation.coordinate.latitude)",
                                              "pickup_lng" : "\(APPDELEGATE.pickupLocation.coordinate.longitude)",
                                              "drop_lat" : droplatstr,
                                              "drop_lon" : droplongstr,
                                              "promocode" : promocodetxt,
                                              "special_ins" : specialIns,
                                              "sub_service" : APPDELEGATE.selectedServiceID+":"+APPDELEGATE.selectedService,
                                              "user_drop" : userdrop,
                                              "user_pickup" : APPDELEGATE.pickupLoationAddress,
                                              "user_rating" : "0",
                                              "service_status" : "1",
                                              "distance" : dist,
                                              "amount_type" : "",//APPDELEGATE.amount_type,
                                              "price_per_hour" : "",//APPDELEGATE.price_per_hour,
                                              "price_per_km" : "",//APPDELEGATE.price_per_km,
                                              "price_per_min" : "",//APPDELEGATE.price_per_min,
                                              "visit_fare" : "",
                                              "main_service_ar":APPDELEGATE.selectedCatInSpanish,
                                              "sub_service_ar":APPDELEGATE.selectedServiceInSpanish]//APPDELEGATE.visit_fare]
                                          
                                          
                                         
                                          firedata.setValue(dict)
                                           PushnotificationToDriver()
                                          APPDELEGATE.stripToken = ""
                                        
                                    }
            
            APPDELEGATE.showRequest = true
            
            if APPDELEGATE.isFromImg == true {
                self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
            }
            else {
                self.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
            }
            
        }
        
        /* else if selectedArray.contains(1) && APPDELEGATE.stripToken == "" {
            
            self.showAlertView(message: "Please add your card details!")
            
        } */
            
        /* else {
            
            let firedata = Database.database().reference().child("providers").child(APPDELEGATE.driverID).child("trips")
            
            print("firedata \(APPDELEGATE.driverID)")
            
            let userdict = USERDEFAULTS.getLoggedUserDetails()
            
            let userid = userdict["id"] as! String
            
            var username = ""
            
            if case let first_name as String = userdict["first_name"] {
                
                if(!(first_name.isEmpty)){
                    
                    username = first_name.uppercased() + " "
                    
                }
                
            }
            
            if case let last_name as String = userdict["last_name"] {
                
                if(!(last_name.isEmpty)){
                    
                    username = username + last_name.uppercased()
                    
                }
                
            }
            
            if selectedArray[0] as! Int == 0 {
                
                if let wallet = Int(APPDELEGATE.userWallet) {
                    
                }
                else if let wallet = Float(APPDELEGATE.userWallet) {
                    
                }
                else if let wallet = Double(APPDELEGATE.userWallet) {
                    
                }
                else {
                    APPDELEGATE.userWallet = "0"
                }
                
                print("APPDELEGATE.servicePrice \(APPDELEGATE.servicePrice) && \(APPDELEGATE.userWallet)")
                
                if Int((APPDELEGATE.servicePrice as! NSString).floatValue) > Int((APPDELEGATE.userWallet as! NSString).floatValue) {
                    
                    self.showAlertView(message: "Your wallet is low")
                    
                    let navview = self.storyboard?.instantiateViewController(withIdentifier: "walletnav") as! UINavigationController
                    let vc = navview.viewControllers[0] as! WalletViewController
                    
                    self.present(navview, animated: true, completion: nil)
                    
                    return
                    
                }
                
                if APPDELEGATE.isBookLater == true {
                    
                    booklaterAct(iswallet: true)
                    
                    return
                    
                }
                
                let dict = ["base_fare" : APPDELEGATE.servicePrice,
                            "customer_id" : userid,
                            "customer_name" : username,
                            "main_service" : APPDELEGATE.selectedCatID+":"+APPDELEGATE.selectedCat,
                            "paymode" : "wallet",
                            "pickup_lat" : "\(APPDELEGATE.pickupLocation.coordinate.latitude)",
                    "pickup_lng" : "\(APPDELEGATE.pickupLocation.coordinate.longitude)",
                    "promocode" : promocodetxt,
                    "special_ins" : specialIns,
                    "sub_service" : APPDELEGATE.selectedServiceID+":"+APPDELEGATE.selectedService,
                    "user_drop" : "",
                    "user_pickup" : APPDELEGATE.pickupLoationAddress,
                    "user_rating" : "0",
                    "service_status" : "1" ]
                
                
                firedata.setValue(dict)
                
            }
            else {
                
                if APPDELEGATE.stripToken == "" {
                    
                    self.showAlertView(message: "Please enter your card details")
                    
                    let card = STORYBOARD.instantiateViewController(withIdentifier: "addcard")as! UINavigationController
                    let vc = card.viewControllers[0] as! AddcardViewController
                    vc.isPayOnline = true
                    self.present(card, animated: true, completion: nil)
                    
                    return
                    
                }
                
                if APPDELEGATE.isBookLater == true {
                    
                    booklaterAct(iswallet: false)
                    
                    return
                    
                }
                
                let dict = ["base_fare" : APPDELEGATE.servicePrice,
                            "customer_id" : userid,
                            "customer_name" : username,
                            "main_service" : APPDELEGATE.selectedCatID+":"+APPDELEGATE.selectedCat,
                            "paymode" : "card",
                            "stripe_token" : APPDELEGATE.stripToken,
                            "pickup_lat" : "\(APPDELEGATE.pickupLocation.coordinate.latitude)",
                    "pickup_lng" : "\(APPDELEGATE.pickupLocation.coordinate.longitude)",
                    "promocode" : promocodetxt,
                    "special_ins" : specialIns,
                    "sub_service" : APPDELEGATE.selectedServiceID+":"+APPDELEGATE.selectedService,
                    "user_drop" : "",
                    "user_pickup" : APPDELEGATE.pickupLoationAddress,
                    "user_rating" : "0",
                    "service_status" : "1" ]
                
                
                firedata.setValue(dict)
                
                APPDELEGATE.stripToken = ""
                
            }
            
            APPDELEGATE.showRequest = true
            
            if APPDELEGATE.isFromImg == true {
                self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
            }
            else {
                self.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
            }
            
        } */
        
    }
    
    func booklaterAct(iswallet: String) {
        
        let userdict = USERDEFAULTS.getLoggedUserDetails()
        
        let userid = userdict["id"] as! String
        
        var droplat = APPDELEGATE.dropLocation
        
        var droplatstr = "0.0"
        var droplongstr = "0.0"
        
        if APPDELEGATE.dropLocation != nil {
            
            droplatstr = "\(APPDELEGATE.dropLocation.coordinate.latitude)"
            droplongstr = "\(APPDELEGATE.dropLocation.coordinate.longitude)"
            
        }
        
        var droploc = APPDELEGATE.dropLoationAddress
        
        if droploc == "" {
            droploc = APPDELEGATE.pickupLoationAddress
        }
        
        
        if APPDELEGATE.isdroplocationcategory == false {
             print("inside 3 isdroplocationcategory == false")
            droploc = "NoDrop"
        }
        else{
             print("inside 3 isdroplocationcategory == true")
                           droploc = APPDELEGATE.dropLoationAddress
            }
        var params = [
            "customer_id": userid,
            "category": APPDELEGATE.selectedCatID,
            "promocode" : promocodetxt,
            "service_id": APPDELEGATE.selectedServiceID,
            "customer_location": APPDELEGATE.pickupLoationAddress,
            "customer_lat": "\(APPDELEGATE.pickupLocation.coordinate.latitude)",
            "customer_lon": "\(APPDELEGATE.pickupLocation.coordinate.longitude)",
            "drop_lat" : droplatstr,
            "drop_lon" : droplongstr,
            "drop_location" : droploc,
            "payment_type": "wallet",
            "driver_id": APPDELEGATE.driverID,
            "request_time": APPDELEGATE.schedulTime,
            "job_date": APPDELEGATE.schedulDate,
            "mode": "accept",
            "card_number": "1234",
            "special_instruction" : specialIns
        ]
        
          
            if iswallet == "Wallet"{
                params["payment_type"] = "wallet"
                params["stripe_token"] = ""
                params["card_number"] = "1234"
                
            }
            else if iswallet == "Card"{
                params["payment_type"] = "card"
                params["stripe_token"] = ""
                params["card_number"] = "1234"
            }
            else{
                params["payment_type"] = "cash"
                params["stripe_token"] = ""
                params["card_number"] = "1234"
            }
        
        print("params \(params)")
        
        APIManager.shared.scheduledBooking(params: params as [String : AnyObject]) { (response) in
            print("responsese\(response)")
            
            if case let msg as String = response?["message"], msg == "Unauthenticated." {
                
                APIManager.shared.refreshToken(params: params as [String : AnyObject]) { (response) in
                    
                    if case let access_token as String = response?["access_token"] {
                        
                        APPDELEGATE.bearerToken = access_token
                        
                        USERDEFAULTS.set(access_token, forKey: "access_token")
                        
                        self.booklaterAct(iswallet: iswallet)
                        
                    }
                        
                    else {
                        
                        self.showAlertView(title: "TowRoute".localiz(), message: "Your session has expired. Please log in again".localiz(), callback: { (check) in
                            
                            APPDELEGATE.updateLoginView()
                            
                        })
                        
                    }
                    
                }
                
            }
                
            else if case let msg as String = response?["message"], msg == "Request saved successfully." {
                
               // self.PushnotificationToDriver()
                
                self.showAlertView(title: "TowRoute".localiz(), message: "Booked successfully!".localiz(), callback: { (check) in
                    
                   // self.view.window?.rootViewController?.dismiss(animated: false, completion: nil)
                    
                    APPDELEGATE.updateHomeView()
                })
                
            }
            
            
        }
    }
    
    func PushnotificationToDriver()
    {
        let userdict = USERDEFAULTS.getLoggedUserDetails()
        
        let userid = userdict["id"] as! String
        let params = ["customer_id": userid,
                      "driver_id": APPDELEGATE.driverID,
                      "mode": "accept"]
        print("paramss\(params)")
        //  APIManager.shared.loginUser(params: params as [String : AnyObject]) { (response) in
        
        APIManager.shared.notificationToDriver(params: params as [String : AnyObject], callback: { (response) in
            
                
                
                
           if case let status as String = response?["message"] {
                
                print(status)
            }
            
        })
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


class paymentmenucell: UITableViewCell{
    @IBOutlet var paylabel: UILabel!
    @IBOutlet var img: UIImageView!
    
    
}
