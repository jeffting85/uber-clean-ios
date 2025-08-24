//
//  BookinglaterViewController.swift
//  TowRoute User
//
//  Created by Admin on 05/07/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import DatePickerDialog

class BookinglaterViewController: UIViewController {
    
    @IBOutlet var droploctitleLbl: UILabel!
    @IBOutlet var pickuptim: UIButton!
    @IBOutlet var pickupdate: UIButton!
    @IBOutlet var datelabel: UILabel!
    @IBOutlet var timelabel: UILabel!
    @IBOutlet weak var pickupLocation: UILabel!
    
    @IBOutlet weak var pickupdatetopconstrain: NSLayoutConstraint!
    @IBOutlet weak var dropLocation: UILabel!
    var schedulHour = ""
    var schedulDay = ""
    
    var selectserviceid = ""
    
    var selectedDate: Date!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectedDate = Date()
        showAddresslabels()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func date_picker(_ sender: Any) {
        
        DatePickerDialog().show("Date".localized, doneButtonTitle: "Done".localized, cancelButtonTitle: "Cancel".localized, minimumDate: Date(), datePickerMode: .date) {
            (date) -> Void in
            if let dt = date {
                self.selectedDate = dt
                let formatter = DateFormatter()
                
                formatter.dateFormat = "yyy-MM-dd"
                formatter.locale = Locale(identifier: "en_US_POSIX")
                self.datelabel.text = formatter.string(from: dt)
                
                formatter.dateFormat = "EEEE"
                self.schedulDay = formatter.string(from: dt)
                
                self.timelabel.text = "Select Pickup Time".localized
                
            }
        }
        
    }
    func showAddresslabels() {
        self.pickupLocation.text = APPDELEGATE.pickupLoationAddress
        self.dropLocation.text =  APPDELEGATE.dropLoationAddress
        print("Check categoryAddressLbl: \(categoryAddressLbl)")
        if categoryAddressLbl == "show"{
            self.dropLocation.isHidden = false
            self.droploctitleLbl.isHidden = false
            self.pickupLocation.text = APPDELEGATE.pickupLoationAddress
            self.dropLocation.text =  APPDELEGATE.dropLoationAddress
            print("checkdropf\(APPDELEGATE.dropLoationAddress)")
        }
        else if categoryAddressLbl == "notshow"{
            self.dropLocation.isHidden = true
            self.droploctitleLbl.isHidden = true
            self.pickupdatetopconstrain.constant = -80.0
            self.pickupLocation.text = APPDELEGATE.pickupLoationAddress
            //            self.dropLocation.text = APPDELEGATE.pickupLoationAddress
        }
        
    }
    @IBAction func time_picker(_ sender: Any) {
        
        if schedulDay == ""
        {
            self.showAlertView(title:"TowRoute" , message: "Please Select Pickup Date!".localized)
        }
            
        else
        {
            //        var date: Date!
            //
            //        if timelabel.text != "Select Pickup Time".localized || datelabel.text != "Select Pickup Date".localized{
            //
            //            let dateFormatter = DateFormatter()
            //            dateFormatter.dateFormat = "MM/dd/yyyy"
            //            date = dateFormatter.date(from: datelabel.text!)!
            //
            //        }
            
            let todayDate = Date()
            let calendar = Calendar.current
            
            if calendar.isDateInToday(selectedDate){
                DatePickerDialog().show("Time".localized, doneButtonTitle: "Done".localized, cancelButtonTitle: "Cancel".localized, minimumDate: Date(), datePickerMode: .time) {
                    (date) -> Void in
                    if let dt = date {
                        let formatter = DateFormatter()
                        formatter.dateFormat = "hh:mm a"
                        formatter.locale = Locale(identifier: "en_US_POSIX")

                        self.timelabel.text = formatter.string(from: dt)
                        
                        formatter.dateFormat = "H"
                        self.schedulHour = formatter.string(from: dt)
                        
                    }
                }
            }
                
                
                
            else{
                
                DatePickerDialog().show("Time".localized, doneButtonTitle: "Done".localized, cancelButtonTitle: "Cancel".localized, datePickerMode: .time) {
                    (date) -> Void in
                    if let dt = date {
                        let formatter = DateFormatter()
                        formatter.dateFormat = "hh:mm a"
                        formatter.locale = Locale(identifier: "en_US_POSIX")
                        self.timelabel.text = formatter.string(from: dt)
                        
                        formatter.dateFormat = "H"
                        self.schedulHour = formatter.string(from: dt)
                        
                    }
                }
            }
            
        }
    }
    @IBAction func next(_ sender: Any) {
        
        if datelabel.text == "Select Job Date".localized {
            
            self.showAlertView(message: "Please Select Job Date!".localized)
            
            return
            
        }
        else if timelabel.text == "Select Job Time".localized {
            
            self.showAlertView(message: "Please Select Job Time!".localized)
            
            return
            
        }
        
        print("hour \(schedulHour) \(schedulDay)")
        
        let towing = STORYBOARD.instantiateViewController(withIdentifier: "towng") as! UINavigationController
        
        let towview = towing.viewControllers[0] as! TowingViewController
        
        towview.selectserviceid = selectserviceid
        
        APPDELEGATE.selectedServiceID = selectserviceid
        
        towview.isBookLater = true
        
        towview.schedulHour = schedulHour
        towview.schedulDay = schedulDay
        
        APPDELEGATE.schedulTime = timelabel.text!
        APPDELEGATE.schedulDate = datelabel.text!
        
        // self.navigationController?.pushViewController(loginvc, animated: true)
        self.present(towing, animated: true, completion: nil)
        
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
