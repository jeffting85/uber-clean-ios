//
//  PayOutViewController.swift
//  TowRoute Provider
//
//  Created by DevTeam1 on 16/07/21.
//  Copyright © 2021 Admin. All rights reserved.
//

import UIKit

class PayOutViewController: UIViewController {
    
    
    
    @IBOutlet weak var navbg: UIImageView!
    @IBOutlet weak var yourbal_lbl: UILabel!
    @IBOutlet weak var tot_cash_pay_amont: UILabel!
    @IBOutlet weak var debt_amount: UILabel!
    
    var earnings = ""
    var earncash = ""
    var driverpaid = ""

    override func viewDidLoad() {
        super.viewDidLoad()
self.title = "PAYOUT".localiz()
        
        let gradient = CAGradientLayer()
        let sizeLength = UIScreen.main.bounds.size.height * 2
        let defaultNavigationBarFrame = CGRect(x: 0, y: 0, width: sizeLength, height: 90)
        
        gradient.frame = defaultNavigationBarFrame
        let color1 = UIColor.init(hexString: "00d5ff")
        let color2 = UIColor.init(hexString: "ffffff")
        //let color3 = UIColor.init(hexString: "ffda6c")
        
        gradient.colors = [color1!.cgColor,color2!.cgColor]//,color3!.cgColor
        
        navbg.image = image(fromLayer: gradient)
        navbg.transform = navbg.transform.rotated(by: CGFloat(Double.pi / 1))
        
        self.viewProfile()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func view_transaction(_ sender: Any) {
        let yourtransaction = storyboard?.instantiateViewController(withIdentifier:"yourtransaction")
               self.navigationController?.pushViewController(yourtransaction!, animated: true)
    }
    @IBAction func back_act(_ sender: Any) {
           self.navigationController?.popViewController(animated: true)
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
                          
                          self.showAlertView(title: "AUTOCLINIC247".localized, message: "Your session has expired. Please log in again", callback: { (check) in
                              
                              APPDELEGATE.updateLoginView()
                              
                          })
                          
                      }
                      
                  }
                  
              }
                  
              else if case let msg as String = response?["message"], msg == "Profile listed successfully." {
                  
                  if case let rating as NSNumber = response?["rating"], "\(rating)" != "" {
                      
//                      Database.database().reference().child("providers").child(driver_id).child("rating").setValue(rating)
                      
                  }
                  
                  if let driver_certificate = response?["driver_certificate"] {
                      
//                      let driver_cert = "\(driver_certificate)"
//                      var myuserinfo = [String: String]()
//                      myuserinfo.updateValue(driver_cert, forKey: "driver_cert")
                      
                  }
                  if case let details as NSDictionary = response?["data"]{
                      
                    if let drvpd  = details["driver_paid"]{
                                
                        self.driverpaid = "\(drvpd)"
                        print("chk_drvpd\(self.driverpaid)")
                        
                      //  usewalletLbl.text = "Use Wallet (" +   symbol+  + ")"
                      let dr_paid = String(format: "%.2f", Double(self.driverpaid) ?? 0)
                        
                        self.debt_amount.text = currency_symbol! + " " + "\(dr_paid)"
                       
                                  
                              }
                    
                    if let earn  = details["earn_cash"]{
                                    
                            self.earncash = "\(earn)"
                            print("chk_earn\(self.earncash)")
                            
                        let ern_csh = String(format: "%.2f", Double(self.earncash) ?? 0)
                            self.tot_cash_pay_amont.text = currency_symbol! + " " + "\(ern_csh)"
                           
                                      
                                  }
                    
                    if let earning  = details["earnings"]{
                                    
                            self.earnings = "\(earning)"
                            print("chk_earning\(self.earnings)")
                        
                         let ern_csh = String(format: "%.2f", Double(self.earnings) ?? 0)
                            
                            self.yourbal_lbl.text = currency_symbol! + " " + "\(ern_csh)"
                           
                                      
                                  }
                    
                    
                    
                    
                    
                  }

              }
              
          }
          
      }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
