//
//  FareSummaryViewController.swift
//  TowRoute User
//
//  Created by Uplogic Technologies on 04/07/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import Firebase
import FloatRatingView
import JVFloatLabeledTextField

class FareSummaryViewController: UIViewController {

    @IBOutlet var jobdatelab: UILabel!
    @IBOutlet var category: UILabel!
    @IBOutlet var curcharger: UILabel!
    @IBOutlet var totcharger: UILabel!
    
    var totalval = "0"
    var jobdate = ""
    var discount = ""
    var payment = ""
    var cat = ""
    var cur = "0"
    var tot = "0"
    var driver_id = ""
    var booking_id = ""
    
    var driver_name = ""
    var imgurl = ""
    
    var mat = "0"
    var misc = "0"
    var discounttext = "0"
    var prmocode = "0"
    
    var tripRating = "0"
    var rating = "0"
    
    var job_loc = ""
    
    var rating_status = "Yes"
    
    @IBOutlet var mattxt: UILabel!
    @IBOutlet var misctxt: UILabel!
    @IBOutlet var distxt: UILabel!
    
    var showBalAlert = false
    @IBOutlet var img: UIImageView!
    @IBOutlet var drivername: UILabel!
    @IBOutlet var driverrating: FloatRatingView!
    @IBOutlet var triprating: FloatRatingView!
    @IBOutlet var bookinglab: UILabel!
    
    @IBOutlet var joblocation: UILabel!
    
    @IBOutlet var paymentType: UILabel!
    
    @IBOutlet var whitelab: UILabel!
    @IBOutlet var howislab: UILabel!
    @IBOutlet var rateDriver: FloatRatingView!
    @IBOutlet var commentText: JVFloatLabeledTextField!
    @IBOutlet var linelab: UILabel!
    @IBOutlet var ratebtn: UIButton!
    @IBOutlet var labtopcons: NSLayoutConstraint!
    @IBOutlet weak var promoval: UILabel!
    @IBOutlet weak var promocode_title: UILabel!
    
    @IBOutlet weak var distanceview: UIView!
    @IBOutlet weak var currentchargelabel: UILabel!
    @IBOutlet weak var fareDistanceTitle: UILabel!
    @IBOutlet weak var fareDistanceValue: UILabel!

    @IBOutlet weak var curheightcons: NSLayoutConstraint!
    @IBOutlet weak var mattopcons: NSLayoutConstraint!
    var visit_fare = "0"
    var price_per_km = "0"
    var sub_level_amount = "0"
    var distances = ""
    var drop_location = ""
    
    @IBOutlet weak var pickupLocationlbl: UILabel!
    @IBOutlet weak var chargestop: NSLayoutConstraint!
    
    @IBOutlet weak var dropLocationLbl: UILabel!
    @IBOutlet weak var dropLocation: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commentText.placeholder = "Enter your comment".localized
        
        if (imgurl != nil) && !(imgurl == "") {
            
            var imageUrl: String? = BASEAPI.IMGURL+imgurl
            img.sd_setImage(with: URL(string: imageUrl!), placeholderImage: #imageLiteral(resourceName: "user(1)"))
            
        }
        else {
            img.sd_setImage(with: URL(string: ""), placeholderImage: #imageLiteral(resourceName: "user(1)"))
        }
        
        img.layer.cornerRadius = (img.frame.size.width) / 2
        img.layer.masksToBounds = true
        
        drivername.text = self.driver_name
        
        jobdatelab.text = jobdate
        category.text = cat
        
        curcharger.text = "\(currency_symbol!) " + String(format: "%.1f", Double(cur.convertCur())!)
        totcharger.text = "\(currency_symbol!) " + String(format: "%.2f", Double(tot.convertCur())!)
        
        mattxt.text = "\(currency_symbol!) " + String(format: "%.1f", Double(mat.convertCur())!)
        misctxt.text = "\(currency_symbol!) " + String(format: "%.1f", Double(misc.convertCur())!)
        distxt.text = "-\(currency_symbol!) " + String(format: "%.1f", Double(discounttext.convertCur())!)
        
        print("servicerating \(Double(tripRating)!)")
        
        triprating.rating = Double(tripRating)!
        
        bookinglab.text = "Booking#".localized + " \(booking_id)"
        jobdatelab.text = jobdate
        
        
        
        paymentType.text = payment
        
        print("chk_prmocode \(prmocode)")
        print("chk_prmocode.convertCur() \(prmocode.convertCur())")
        
        if prmocode == "0"{
            promocode_title.isHidden = true
            promoval.isHidden = true
        }
        else{
            promocode_title.isHidden = false
            promoval.isHidden = false
            promoval.text = "-\(currency_symbol!) " + prmocode.convertCur()
            print("chk_ promoval.text \( promoval.text)")
        }
        
         
        
        if rating_status == "Yes" {
            
            whitelab.isHidden = true
            howislab.isHidden = true
            rateDriver.isHidden = true
            commentText.isHidden = true
            linelab.isHidden = true
            ratebtn.isHidden = true
            labtopcons.constant = -230
            
        }
        
        let fireRef = Database.database().reference()
        let driverratingtRef = fireRef.child("providers").child(self.driver_id).child("rating")
        
        driverratingtRef.observeSingleEvent(of: DataEventType.value) { (SnapShot: DataSnapshot) in
            
            if let statusval = SnapShot.value {
                
                let rating = "\(statusval)"
                
                print("rating \(rating)")
                
                if rating != "<null>" {
                    
                    self.driverrating.rating = Double(rating)!
                    
                }
                
            }
            
        }
         print("chk_distances\(distances)")
         print("chk_visit_fare\(visit_fare)")
        
        if visit_fare != "0"{
            
            currentchargelabel.text = "Current Charges(\(sub_level_amount.convertCur()))+Visit Price(\(visit_fare.convertCur()))"
            curcharger.text = "\(currency_symbol!)" + String(format: "%.2f", (Double(sub_level_amount.convertCur())! + Double(visit_fare.convertCur())!))

            
        }else {
            
           // curheightcons.constant = 21
           // mattopcons.constant = -41
            
        }
        
       
        if distances != "0" || distances != "0.0" {
            
            distanceview.isHidden = false
            fareDistanceTitle.isHidden = false
            print("chk_price_per_km\(price_per_km)")
            print("chk_price_per_km.convertCur()\(price_per_km.convertCur())")
            print("chk_distance2s \(distances)")
            fareDistanceTitle.text = "( Price per KM \(price_per_km.convertCur()) * \(String(format: "%.2f", (Double("\(distances)")!))) KM )"
            fareDistanceValue.text = "\(currency_symbol!) " + String(format: "%.2f", (Double(price_per_km.convertCur())! * Double(String(format: "%.2f", (Double("\(distances)")!)))!))
            
        }
        else{
            distanceview.isHidden = true
            fareDistanceTitle.isHidden = true
        }
        
        
      location()
        // Do any additional setup after loading the view.
    }
    
    func location()
    {
        if cat == "Towing"
        {
            print("cat_==_Towing")
            dropLocation.isHidden = false
            dropLocationLbl.isHidden = false
            chargestop.constant = 70
            pickupLocationlbl.text = "Pickup Location"
            joblocation.text = job_loc
            dropLocation.text = drop_location
        }
            
        else
        {
            print("cat_=else=_Towing")
            dropLocation.isHidden = true
            dropLocationLbl.isHidden = true
            chargestop.constant = 20
            pickupLocationlbl.text = "Job Location".localized
            joblocation.text = job_loc
            
        }
        

    }
    override func viewWillAppear(_ animated: Bool) {
        
        if showBalAlert == true {
            
            self.showAlertView(message: "User can able to balance amount via online".localized)
            
        }
        
    }

    @IBAction func collectPayment(_ sender: Any) {
    
        // Database.database().reference().child("providers").child(driver_id).child("trips").removeValue()
        Database.database().reference().child("providers").child(driver_id).child("trips").child("service_status").setValue("0")
        
        self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
        
        // self.dismiss(animated: true, completion: nil)
        
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
                
            else if case let msg as String = response?["message"] {
                
                self.showAlertView(message: msg.localized)
                
                if msg == "Feedback received" {
                    
                    self.whitelab.isHidden = true
                    self.howislab.isHidden = true
                    self.rateDriver.isHidden = true
                    self.commentText.isHidden = true
                    self.linelab.isHidden = true
                    self.ratebtn.isHidden = true
                    self.labtopcons.constant = -230
                    
                }
                
            }
            
        }
        
    }
    
    @IBAction func backAct(_ sender: Any) {
    
        self.dismiss(animated: true, completion: nil)
        
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
