//
//  SummaryPageViewController.swift
//  TowRoute User
//
//  Created by DevTeam1 on 16/07/21.
//  Copyright © 2021 Admin. All rights reserved.
//

import UIKit
import Firebase
import FloatRatingView
//import HCSStarRatingView
import JVFloatLabeledTextField

class SummaryPageViewController: UIViewController {
    
    @IBOutlet var totallab: UILabel!
    @IBOutlet var jobdatelab: UILabel!
    @IBOutlet var discountlab: UILabel!
    @IBOutlet var paymenttype: UILabel!
    @IBOutlet var category: UILabel!
    @IBOutlet var curcharger: UILabel!
    @IBOutlet var totcharger: UILabel!
    
    @IBOutlet weak var sumbit_btn: UIButton!
    @IBOutlet weak var cash_sts_lbl: UILabel!
    
    
    @IBOutlet weak var rateLbl: UILabel!
     var rating_status = "0"
    var totalval = ""
    var jobdate = ""
    var discount = ""
    var payment = ""
    var cat = ""
    var cur = ""
    var tot = ""
    var customer_id = ""
    var driver_id = ""
    var booking_id = ""
    
    var mat = ""
    var misc = ""
    var discounttext = ""
    var distancetext = ""
    var addresstext = ""
    
    
    var sub_level_amount = ""
    var visit_fare = ""
    var price_per_km = ""
    var total_distance = ""
    var total_amount = ""
    var balance_amount = ""
    
   
    var extra_charge = ""
    var misc_charge = ""
    var driver_discount = ""
    
    var customer_location = ""
    var drop_location = ""
   
    
    @IBOutlet var mattxt: UILabel!
    @IBOutlet var misctxt: UILabel!
    @IBOutlet var distxt: UILabel!
    
    var showBalAlert = false
    
    @IBOutlet var backlab: UILabel!
   // @IBOutlet var rateCustomer: HCSStarRatingView!
    
    @IBOutlet weak var rateCustomer: FloatRatingView!
    @IBOutlet var commentText: JVFloatLabeledTextField!
    @IBOutlet var line: UILabel!
    @IBOutlet var ratebtn: UIButton!
    
    var prmocode = "0"
    
    var promocode = ""
    var promovalue = ""
    
    @IBOutlet weak var promoval: UILabel!
    
    @IBOutlet weak var fareVechileType: UILabel!
    @IBOutlet weak var farePickupAddress: UILabel!
    @IBOutlet weak var fareDropAddress: UILabel!
    @IBOutlet weak var fareChargeTitle: UILabel!
    @IBOutlet weak var fareChargeValue: UILabel!
    @IBOutlet weak var fareDistanceTitle: UILabel!
    @IBOutlet weak var fareDistanceValue: UILabel!
    @IBOutlet weak var fareTotalValue: UILabel!
    
    @IBOutlet weak var topSpacetoFare: NSLayoutConstraint!
    @IBOutlet weak var pickupLbl: UILabel!
    
    @IBOutlet weak var dropLbl: UILabel!
    @IBOutlet weak var materialview: UIView!
    @IBOutlet weak var miscview: UIView!
    @IBOutlet weak var discountview: UIView!
    @IBOutlet weak var distanceview: UIView!
    
    @IBOutlet weak var materialtxt: UILabel!
    @IBOutlet weak var miscfeetxt: UILabel!
    @IBOutlet weak var discountfeetxt: UILabel!
    
    @IBOutlet weak var detailtopcons: NSLayoutConstraint!
    
    @IBOutlet weak var promocodeLbl: UILabel!
    @IBOutlet weak var promocodeTop: NSLayoutConstraint!
    
    //Constraints for Wallet and Card Payment
    @IBOutlet weak var backLbl_height: NSLayoutConstraint! //115
    @IBOutlet weak var cashStsLbl_Height: NSLayoutConstraint! //66
    @IBOutlet weak var cashReqBtnAgain_Height: NSLayoutConstraint!//66
    @IBOutlet weak var info_icon: UIImageView!
    override func viewDidLoad() {
    
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
        
        totallab.text = "\(currency_symbol!) " + String(format: "%.2f", (Double(totalval.convertCur())!))
        jobdatelab.text = jobdate
        
        
        if discount == "0.0" || discount == "0" || discount == "0.00"
        {
          discountlab.text = "--"
        }
        else
        {
        discountlab.text = "\(currency_symbol!) " + String(format: "%.2f", (Double(discount.convertCur())!))
        }
        
        paymenttype.text = payment
        
        
        if payment == "cash" {
            paymenttype.text = "Cash".localiz()
            self.backLbl_height.constant = 115
            self.cashStsLbl_Height.constant = 66
            self.cashReqBtnAgain_Height.constant = 66
            self.info_icon.isHidden = false
        }
        
        else { //Cash Status Hide Constarint
            self.backLbl_height.constant = 49
            self.cashStsLbl_Height.constant = 0
            self.cashReqBtnAgain_Height.constant = 0
            self.info_icon.isHidden = true
        }
        
        category.text = cat
        curcharger.text = "\(currency_symbol!) " + String(format: "%.2f", (Double(cur.convertCur())!))
        totcharger.text = "\(currency_symbol!) " + String(format: "%.2f", (Double(tot.convertCur())!))
        
        mattxt.text = "\(currency_symbol!) " + String(format: "%.2f", (Double(mat.convertCur())!))
        misctxt.text = "\(currency_symbol!) " + String(format: "%.2f", (Double(misc.convertCur())!))
        distxt.text = "-\(currency_symbol!) " + String(format: "%.2f", (Double(discounttext.convertCur())!))
        
        
        promoval.text = "-\(currency_symbol!) " + String(format: "%.2f", (Double(prmocode.convertCur())!))
        
        fareVechileType.text = cat
        
        fareaddress()
        
        if sub_level_amount != ""{
            fareChargeTitle.text = "Current Charges".localized+"(\(sub_level_amount.convertCur()))+"+"Visit Price".localized+"(\(visit_fare.convertCur()))"
            if visit_fare == "0"{
                fareChargeTitle.text = "Current Charges".localized
            }
            fareChargeValue.text = "\(currency_symbol!) " + String(format: "%.2f", (Double(sub_level_amount.convertCur())! + Double(visit_fare.convertCur())!))
        }
        
        if price_per_km != "" && total_distance != "" && price_per_km != "0"{
            
            fareDistanceTitle.text = "Total Distance".localized+" "+"("+"Price per KM".localized+" "+"\(price_per_km.convertCur()) * \(String(format: "%.2f", (Double(total_distance)!))) KM = "
            fareDistanceValue.text = "\(currency_symbol!) " + String(format: "%.2f", (Double(price_per_km.convertCur())! * Double(total_distance)!))
            distanceview.isHidden = false
        }
        
        if extra_charge != "" && extra_charge != "0.0" {
            materialview.isHidden = false
            materialtxt.text = "\(currency_symbol!) " + String(format: "%.2f", (Double(extra_charge.convertCur())!))
        }
        if misc_charge != "" && misc_charge != "0.0" {
            miscview.isHidden = false
            miscfeetxt.text = "\(currency_symbol!) " + String(format: "%.2f", (Double(misc_charge.convertCur())!))
        }
        if driver_discount != "" && driver_discount != "0.0" {
            discountview.isHidden = false
            discountfeetxt.text = "-\(currency_symbol!) " + String(format: "%.2f", (Double(driver_discount.convertCur())!))
        }
        
        fareTotalValue.text = "\(currency_symbol!) " + String(format: "%.2f", (Double(totalval.convertCur())!))
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.currencyNotification(notification:)), name: Notification.Name("currencySymUpdate"), object: nil)
        
        cashonhandobserver()
        
        // Do any additional setup after loading the view.
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        commentText.resignFirstResponder()
    }
    
    func fareaddress()
    {
        
        farePickupAddress.text = customer_location
        
        
        
        promocodeValue()
        
        if cat == "Towing"
            
        {
            fareDropAddress.text = drop_location
            pickupLbl.text = "Pickup"
            topSpacetoFare.constant = 70
            dropLbl.isHidden = false
            fareDropAddress.isHidden = false
            promocodeTop.constant = 20
            
        
        }
            
            
        else
            
        {
            fareDropAddress.text = drop_location
            pickupLbl.text = "Job Location".localized
            topSpacetoFare.constant = 20
            dropLbl.isHidden = true
            fareDropAddress.isHidden = true
            promocodeTop.constant = -15
            
        }
        
    }
    
    func promocodeValue()
    {
        if promocode != "" && promovalue != ""
        {
            promocodeLbl.isHidden = false
            promocodeLbl.text = "PromoCode \(promocode) \(promovalue)%"
        }
            
            
        else
            
        {
            
            promocodeLbl.isHidden = true
            
        }
    }
    
    @IBAction func cash_request_again(_ sender: Any) {
        Database.database().reference().child("providers").child(driver_id).child("trips").child("cash_status").setValue("0")
         Database.database().reference().child("booking_trips").child(booking_id).child("cash_status").setValue("0")
 
        print("cash_request_again_tapped")
    }
    
    func cashonhandobserver() {
                print("cashonhandobserver_called")
        let fireRef = Database.database().reference()
        var driverstatusRef: DatabaseReference! = nil
        driverstatusRef = fireRef.child("booking_trips").child(booking_id)
        driverstatusRef.observe(DataEventType.value) { (SnapShot: DataSnapshot) in
                        print("SnapShotaa \(SnapShot.value)")
        if let dict = SnapShot.value as? NSDictionary {
        

                if let service_state = dict["service_status"]
                    {
                        let state = "\(dict["service_status"]!)"
                         print("chk_service_state \(state)")
                        
                        if let cash_state = dict["cash_status"]
                        {
                            let state_c = "\(dict["cash_status"]!)"
                            print("chk_cash_state \(state_c)")
                            
                            
                            if let rate_state = dict["rating_status"]{
                            let state_r = "\(dict["rating_status"]!)"
                             
                                print("chk_state_r\(state_r)")
                                  
                                if state == "5.2" && state_c == "2"{
                                    
                                    if state_r == "0"{
                                        
                                        self.cash_sts_lbl.text = "Provider can't receive cash payment from your side".localiz() + "\n" + "Click here , You or Provider can send the request again".localiz()
                                        self.cash_sts_lbl.backgroundColor = UIColor.red
                                        self.cash_sts_lbl.textColor = UIColor.white
                                        self.sumbit_btn.isEnabled = false
                                        
                                    }
                                    else if state_r == "1"{
                                        
                                        self.cash_sts_lbl.text = "Provider can't receive cash payment from your side".localiz() + "\n" + "Click here , You or Provider can send the request again".localiz()
                                        self.cash_sts_lbl.backgroundColor = UIColor.red
                                        self.cash_sts_lbl.textColor = UIColor.white
                                        self.sumbit_btn.isEnabled = false
                                         self.backlab.isHidden = true
                                         self.rateCustomer.isHidden = true
                                         self.rateLbl.isHidden = true
                                        self.commentText.isHidden = true
                                        self.line.isHidden = true
                                        self.ratebtn.isHidden = true
                                        self.bottomcons.constant = 20
                                        self.detailtopcons.constant = -150
                                        
                                    }
                                    else{
                                        
                                        self.cash_sts_lbl.text = "Provider can't receive cash payment from your side".localiz() + "\n" + "Click here , You or Provider can send the request again".localiz()
                                        self.cash_sts_lbl.backgroundColor = UIColor.red
                                        self.cash_sts_lbl.textColor = UIColor.white
                                        self.sumbit_btn.isEnabled = false
                                        
                                    }

                                    
                                }
                                else if state == "5.2" && state_c == "0"{
                                    if state_r == "0"{
                                        self.cash_sts_lbl.text = "Please provide a cash payment to Provider!".localiz()
                                          self.cash_sts_lbl.backgroundColor = UIColor.black
                                          self.cash_sts_lbl.textColor = UIColor.white
                                          self.sumbit_btn.isEnabled = false
                                     }
                                     else if state_r == "1"{
                                         self.cash_sts_lbl.text = "Please provide a cash payment to Provider!".localiz()
                                         self.cash_sts_lbl.backgroundColor = UIColor.black
                                         self.cash_sts_lbl.textColor = UIColor.white
                                         self.sumbit_btn.isEnabled = false
                                         self.backlab.isHidden = true
                                         self.rateCustomer.isHidden = true
                                         self.rateLbl.isHidden = true
                                        self.commentText.isHidden = true
                                        self.line.isHidden = true
                                        self.ratebtn.isHidden = true
                                        self.bottomcons.constant = 20
                                        self.detailtopcons.constant = -150
                                     }
                                     else{
                                        self.cash_sts_lbl.text = "Please provide a cash payment to Provider!".localiz()
                                        self.cash_sts_lbl.backgroundColor = UIColor.black
                                        self.cash_sts_lbl.textColor = UIColor.white
                                        self.sumbit_btn.isEnabled = false
                                     }
                                    
                                   
                                    
                                }
                                else if state == "6" {
                                    
                                    if state_r == "0"{
                                         self.cash_sts_lbl.text = "Cash Paid Successfully".localiz()
                                            self.cash_sts_lbl.backgroundColor = UIColor(hexString: "00a651")
                                            self.cash_sts_lbl.textColor = UIColor.white
                                            self.sumbit_btn.isEnabled = true
                                     }
                                     else if state_r == "1"{
                                         self.cash_sts_lbl.text = "Cash Paid Successfully".localiz()
                                            self.cash_sts_lbl.backgroundColor = UIColor(hexString: "00a651")
                                            self.cash_sts_lbl.textColor = UIColor.white
                                            self.sumbit_btn.isEnabled = true
                                         self.backlab.isHidden = true
                                         self.rateCustomer.isHidden = true
                                         self.rateLbl.isHidden = true
                                        self.commentText.isHidden = true
                                        self.line.isHidden = true
                                        self.ratebtn.isHidden = true
                                        self.bottomcons.constant = 20
                                        self.detailtopcons.constant = -150
                                     }
                                     else{
                                         self.cash_sts_lbl.text = "Cash Paid Successfully".localiz()
                                            self.cash_sts_lbl.backgroundColor = UIColor(hexString: "00a651")
                                            self.cash_sts_lbl.textColor = UIColor.white
                                            self.sumbit_btn.isEnabled = true
                                     }
                                    
   
                                }
                                
                                
                                
                            }
                            
                            
                            
                                                    
                        }
                        
                    
                     }
                            
                }
             }
        }
    
    
    @objc func currencyNotification(notification: Notification) {
        
        totallab.text = "\(currency_symbol!) " + String(format: "%.2f", (Double(totalval.convertCur())!))
        
        if discount == "0.0" || discount == "0" || discount == "0.00"
        {
            discountlab.text = "--"
        }
        else
        {
        discountlab.text = "\(currency_symbol!) " + String(format: "%.2f", (Double(discount.convertCur())!))
        }
        if sub_level_amount != ""{
            fareChargeTitle.text = "Current Charges".localized+"(\(sub_level_amount.convertCur()))+"+"Visit Price".localized+"(\(visit_fare.convertCur()))"
            if visit_fare == "0"{
                fareChargeTitle.text = "Current Charges".localized
            }
            fareChargeValue.text = "\(currency_symbol!) " + String(format: "%.2f", (Double(sub_level_amount.convertCur())! + Double(visit_fare.convertCur())!))
        }
        if price_per_km != "" && total_distance != "" && price_per_km != "0"{
            fareDistanceTitle.text = "Total Distance".localized+" ("+"Price per KM".localized+" \(price_per_km.convertCur()) * \(String(format: "%.2f", (Double(total_distance)!))) KM = "
            fareDistanceValue.text = "\(currency_symbol!) " + String(format: "%.2f", (Double(price_per_km.convertCur())! * Double(total_distance)!))
            distanceview.isHidden = false
        }
        
        if extra_charge != "" && extra_charge != "0.0" {
            materialview.isHidden = false
            materialtxt.text = "\(currency_symbol!) " + String(format: "%.2f", (Double(extra_charge.convertCur())!))
        }
        if misc_charge != "" && misc_charge != "0.0" {
            miscview.isHidden = false
            miscfeetxt.text = "\(currency_symbol!) " + String(format: "%.2f", (Double(misc_charge.convertCur())!))
        }
        if driver_discount != "" && driver_discount != "0.0" {
            discountview.isHidden = false
            discountfeetxt.text = "-\(currency_symbol!) " + String(format: "%.2f", (Double(driver_discount.convertCur())!))
        }
        
        fareTotalValue.text = "\(currency_symbol!) " + String(format: "%.2f", (Double(totalval.convertCur())!))
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if showBalAlert == true {
            
            self.showAlertView(message: "User can able to balance amount via online".localized)
            
        }
        
        cashonhandobserver()
        
    }
    
    @IBAction func collectPayment(_ sender: Any) {
        
       APPDELEGATE.updateHomeView()
        
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
                      "to_id": driver_id,
                      "job_id": booking_id,
                      "rating": Int(rateCustomer.rating),
                      "status": "0",
                      "feedback": commentText.text!,
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
                        
                        self.showAlertView(title: "TOWROUTE".localized, message: "Your session has expired. Please log in again", callback: { (check) in
                            
                            APPDELEGATE.updateLoginView()
                            
                        })
                        
                    }
                    
                }
                
            }
                
            else if case let msg as String = response?["message"], msg == "Feedback received" {
                
                 Database.database().reference().child("booking_trips").child(self.booking_id).child("rating_status").setValue("1")
                
                 self.backlab.isHidden = true
                 self.rateCustomer.isHidden = true
                 self.rateLbl.isHidden = true
                self.commentText.isHidden = true
                self.line.isHidden = true
                self.ratebtn.isHidden = true
                self.bottomcons.constant = 20
                self.detailtopcons.constant = -150
                
            }
            
        }
        
    }
    
    @IBOutlet var bottomcons: NSLayoutConstraint!
    
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
