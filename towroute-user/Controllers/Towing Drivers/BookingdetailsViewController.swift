//
//  BookingdetailsViewController.swift
//  TowRoute User
//
//  Created by Admin on 25/06/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import JVFloatLabeledTextField

class BookingdetailsViewController: UIViewController {

    @IBOutlet var servicelab: UILabel!
    @IBOutlet var catlab: UILabel!
    @IBOutlet var bookingprice: UILabel!
    @IBOutlet var drivername: UILabel!
    @IBOutlet var bookingdate: UILabel!
    @IBOutlet var bookingtime: UILabel!
    @IBOutlet var promocodetxt: JVFloatLabeledTextField!
    @IBOutlet var specialInsTxt: UITextView!
    @IBOutlet weak var specialtxtlab: UILabel!
    
    @IBOutlet weak var bookingAddress: UILabel!
    @IBOutlet weak var applyact: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bookingAddress.text = APPDELEGATE.pickupLoationAddress
        
        
        
        if LanguageManager.shared.currentLanguage == .ar{
            servicelab.text = APPDELEGATE.selectedServiceInSpanish
            catlab.text = APPDELEGATE.selectedCatInSpanish + " " + "Provider".localized
        }
        
        else
        {
            servicelab.text = APPDELEGATE.selectedService
            catlab.text = APPDELEGATE.selectedCat + " " + "Provider".localized
        }
        
        bookingprice.text = currency_symbol!+APPDELEGATE.servicePrice.convertCur()
        drivername.text = APPDELEGATE.driverName
        
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        let date = Date()
        let dateString = dateFormatter.string(from: date)
        
        let datearr = dateString.components(separatedBy: " ")
        
        bookingdate.text = datearr[0]
        bookingtime.text = datearr[1]
        
        self.title = "BOOKING DETAILS".localized
        
        if LanguageManager.shared.currentLanguage == .ar{
            
            print("\(APPDELEGATE.selectedCatInSpanish)")
         //  specialtxtlab.text = "Add Special Instruction for".localized + " " + APPDELEGATE.selectedCatInSpanish + " " + "Driver".localized
          specialtxtlab.text = "Add Special Instruction for Towing Provider".localized
        }
        else
        {
         //   specialtxtlab.text = "Add Special Instruction for Driver".localized + " " + APPDELEGATE.selectedCat + " " + "Driver".localized
            specialtxtlab.text = "Add Special Instruction for Towing Provider".localized
        }
        
        
        
        promocodetxt.placeholder = "Promo Code(optional)".localized
        
        // Do any additional setup after loading the view.
    }

    @IBAction func back_act(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var promo_code = ""
    
    @IBAction func applyAct(_ sender: Any) {
    
        applyact.isUserInteractionEnabled = false
        if promocodetxt.isUserInteractionEnabled
        {
             checkPromocode()
        }
        else
        {
            self.showAlertView(message: "Promo Code Already Applied".localized)
            self.applyact.isUserInteractionEnabled = true
        }
       
        
    }
    
    
    
    func checkPromocode() {
        
        
        let promocode = promocodetxt.text!
        
        if promocode == "" {
            
            self.showAlertView(message: "Please enter your promo code!".localized)
            self.applyact.isUserInteractionEnabled = true
            return
            
        }
        
        let userdict = USERDEFAULTS.getLoggedUserDetails()
        
        let userid = userdict["id"] as! String
        
        let params = [
            "customer_id": userid,
            "promocode": promocode
        ]
        
        print("params \(params)")
        
        APIManager.shared.checkPromoCode(params: params as [String : AnyObject]) { (response) in
            print("responsese\(response)")
            
            if case let msg as String = response?["message"], msg == "Unauthenticated." {
                
                APIManager.shared.refreshToken(params: params as [String : AnyObject]) { (response) in
                    
                    if case let access_token as String = response?["access_token"] {
                        
                        APPDELEGATE.bearerToken = access_token
                        
                        USERDEFAULTS.set(access_token, forKey: "access_token")
                        
                        self.checkPromocode()
                        
                    }
                        
                    else {
                        
                        self.showAlertView(title: "TowRoute".localized, message: "Your session has expired. Please log in again", callback: { (check) in
                            
                            APPDELEGATE.updateLoginView()
                            
                        })
                        
                    }
                    
                }
                
            }
                
            else if case let msg as String = response?["message"],msg == "Valid Promocode" {
                
                self.showAlertView(message: "Promocode Applied Successfully".localized)
                   self.promo_code = promocode
                    self.promocodetxt.text = self.promo_code.uppercased()
                    self.promocodetxt.isUserInteractionEnabled = false
                   self.promocodetxt.placeholder = "Promo Code".localized
                self.applyact.isUserInteractionEnabled = true
                    
                }
                
            else
            {
               if case let msg as String = response?["message"]
               {
                self.showAlertView(message: msg.localized)
                }
                
                self.applyact.isUserInteractionEnabled = true
            }
            
        }
    }
    
    @IBAction func continue_act(_ sender: Any) {
        
        let payment = STORYBOARD.instantiateViewController(withIdentifier: "pay") as! UINavigationController
        
        let vc = payment.viewControllers[0] as! PaymentmodeViewController
        
        vc.promocodetxt = promo_code
        
        vc.specialIns = specialInsTxt.text!
        
        // self.navigationController?.pushViewController(loginvc, animated: true)
        self.present(payment, animated: true, completion: nil)
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
