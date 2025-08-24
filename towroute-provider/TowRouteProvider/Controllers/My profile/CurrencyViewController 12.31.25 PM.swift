//
//  CurrencyViewController.swift
//  AUTOCLINIC247 User
//
//  Created by Karan Vignesh on 11/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import Stripe
import Firebase

class CurrencyViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

       var selectedcur = ""
        var selectedindex = Int()
        var curOption = ["BHD"]
        var curWithCountry = ["Bahraini Dinar (BHD)"]
        var selectedArray = NSMutableArray()
        
        @IBOutlet weak var English_btn: UIButton!
        @IBOutlet weak var Arabic_btn: UIButton!
    @IBOutlet weak var curr_table: UITableView!
    
    
    var usercurrencySymRef: DatabaseReference! = nil

        var querycurrencySymhandle: UInt! = nil

    @IBOutlet weak var titleLbl: UILabel!
    
        override func viewDidLoad() {
            super.viewDidLoad()
            print("chk_curOption\(curOption)")
            
            print("chckcurrency_name\(currency_name)")
                               print("chckcurr_symbol\(curr_symbol)")
                               print("chckconvertion_ratio_value\(convertion_ratio_value)")
            
            if currency_name.isEmpty{
                let params = ["":""] as [String : AnyObject]
                self.appSetting(params: params)
                
            }
            
            print("chk_currarr\(currarr)")
            

            self.curr_table.delegate = self
            self.curr_table.dataSource = self
            
          //  English_btn.setTitle("USD ($)", for: .normal)
           // Arabic_btn.setTitle("LKR (Rs)", for: .normal)

            titleLbl.text = "Choose Your Currency"
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currarr!.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = curr_table.dequeueReusableCell(withIdentifier: "currcell", for: indexPath) as! currcell
        
                        
                              
        let dict = currarr![indexPath.row] as! NSDictionary
                          
        cell.curr_lbl.text = dict.object(forKey: "currency") as! String
          
                               if selectedArray.contains(indexPath.row) {
                                          cell.curr_lbl.backgroundColor = UIColor.gray
                                          cell.curr_lbl.textColor = UIColor.white
                                      }
        
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 44
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
     let dict = currarr![indexPath.row] as! NSDictionary
        
        selectedindex = indexPath.row
        
        print("chk_selectedindex\(selectedindex)")
        
      selectedcur =  dict.object(forKey: "currency") as! String
        
        //selectedArray.removeAllObjects()
                   
        selectedArray.add(indexPath.row)
       
       
        update_information()
      
        self.curr_table.reloadData()
    }
    
    
        @IBAction func chooseEnglish(_ sender: Any) {
        
        
            
         
                    
       selectedcur = "USD"
            
            
            for cur in currarr! {
                       
                       let dict = cur as! NSDictionary
                   
                
                           
                           let arrvalue = currency_name.index(of: "USD") as! Int
                           
                           print("checkarrvalue\(arrvalue)")
                         
                           //selectedlang = lang_id.arrvalu
                           selectedcur = currency_name[arrvalue]
                           print("chckselectedlang\(selectedcur)")
             
                       
                   }
      
                
            
       
            update_information()
        }
        
        @IBAction func chooseArabic(_ sender: Any) {
            
            selectedcur = "LKR"
            
            
            for cur in currarr! {
                       
                       let dict = cur as! NSDictionary
                   
                
                           
                           let arrvalue = currency_name.index(of: "QAR") as! Int
                           
                           print("checkarrvalue\(arrvalue)")
                         
                           //selectedlang = lang_id.arrvalu
                           selectedcur = currency_name[arrvalue]
                           print("chckselectedlang\(selectedcur)")
             
                       
                   }

            update_information()

            
        }
        
        @IBAction func chooseFrench(_ sender: Any) {
            
            let selectedLanguage:Languages = .fr
            
            // change the language
            LanguageManager.shared.setLanguage(language: selectedLanguage)
            
            APPDELEGATE.updateHomeView()
            APPDELEGATE.updateHomeView()
            
        }
        
        @IBAction func chooseSpanish(_ sender: Any) {
            
           // selectedlang = "4"
            
            
        selectedcur = "BHD"
         
            update_information()
        }
        
        @IBAction func closeAct(_ sender: Any) {
        
            self.dismiss(animated: false, completion: nil)
            
        }
        
        
        func appSetting(params: [String : AnyObject]) {
            
            print("params \(params)")
            
            APIManager.shared.appSetting(params: params, callback: { (response) in
                
                print("inside apimanager")
                print(response as Any)
                if case let currency as NSArray = response?["currency"] {
                    
                    self.curOption.removeAll()

                    currency_name.removeAll()
                    curr_symbol.removeAll()
                    convertion_ratio_value.removeAll()
                    
                    self.curWithCountry.removeAll()
                    
                    for cur in currency {
                        
                        let dict = cur as! NSDictionary
                        
                        let curstr = dict.object(forKey: "short_name") as! String
                        
                        self.curOption.append(curstr)
                        
                        let currency = dict.object(forKey: "currency") as! String
                        
                        let curname = currency + " (" + curstr + ")"
                        
                        self.curWithCountry.append(curname)
                        
                        let currencystr = dict.object(forKey: "currency") as! String
                        let currencycode = dict.object(forKey: "symbol") as! String
                        let currency_conv_ratio = dict.object(forKey: "converions_ratio") as! String
                        
                        currency_name.append(currencystr)
                        curr_symbol.append(currencycode)
                        convertion_ratio_value.append(currency_conv_ratio)
                        
                        print("chckcurrency_name\(currency_name)")
                        print("chckcurr_symbol\(curr_symbol)")
                        print("chckconvertion_ratio_value\(convertion_ratio_value)")
                        
                        self.curr_table.reloadData()
                        
                    }
                    
                }
                
                if case let currency as NSArray = response?["language"] {
                    
                    //self.langOption.removeAll()
                    lang_id.removeAll()
                    lang_name.removeAll()
                   lang_Shrtform.removeAll()
                    
                    
                    for cur in currency {
                        
                        let dict = cur as! NSDictionary
                    
                        let langstr = dict.object(forKey: "language_name") as! String
                        let langcode = dict.object(forKey: "language_code") as! String
                        let language_id = dict.object(forKey: "id") as! NSNumber
                        
                        //self.langOption.append(curstr)
                       lang_id.append("\(language_id)")
                        lang_name.append(langstr)
                        lang_Shrtform.append(langcode)
                      
                        
                    }
                    
                }
                
                if case let key as NSDictionary = response?["app_setting"]
                {
                    
                    if let publishkey = key["payment_publisher_key"] {
                        
                        let keys = "\(publishkey)"
                        print("user key \(keys)")
                        Stripe.setDefaultPublishableKey(keys)
                       
                        
                    }
                    
                    
                }
                if case let key as NSDictionary = response?["app_setting"]
                {
                    
                    if let distance = key["distance_limit"] {
                        
                        let keys = distance as! Int
                        distance_limit = keys
                        print("user key \(keys)")
                        USERDEFAULTS.set(distance_limit, forKey: "distance_limit")
                        
                        
                    }
                    
                    
                }
               
                
                
                
            })
            
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
            func update_information() {
                
                let userdict = USERDEFAULTS.getLoggedUserDetails()
                
                let userid = userdict["id"] as! String
                
                
                
                let params = ["id":userid,
                              "currency": selectedcur]
                
                print("paramsapicall \(params)")
                
                APIManager.shared.updateProfile(params: params as [String : AnyObject]) { (response) in
                    
                    if case let msg as String = response?["message"], msg == "Unauthenticated." {
                        
                        APIManager.shared.refreshToken(params: params as [String : AnyObject]) { (response) in
                            
                            if case let access_token as String = response?["access_token"] {
                                
                                APPDELEGATE.bearerToken = access_token
                                
                                USERDEFAULTS.set(access_token, forKey: "access_token")
                                
                                self.update_information()
                                
                            }
                                
                            else {
                                
                                self.showAlertView(title: "AUTOCLINIC247", message: "Your session has expired. Please log in again".localiz(), callback: { (check) in
                                    
                                    APPDELEGATE.updateLoginView()
                                    
                                })
                                
                            }
                            
                        }
                        
                    }
                        

    //
                      
    //
    //
    //                }
                    //msg != "Unauthenticated."
                    if case let msg as String = response?["message"], msg == "Customer updated successfully."{
                        print("chk_selectedindex1\(self.selectedindex)")
                        let dict = currarr![self.selectedindex] as! NSDictionary
                        let userid = userdict["id"] as! String

//                        if self.selectedcur == "USD"
//                        {
                        currenc = dict.object(forKey: "currency") as? String //"USD"
                        print("chk_scurrenc\(String(describing: currenc))")
                        currency_symbol = dict.object(forKey: "symbol") as? String //"$"
                        print("chk_currency_symbol\(String(describing: currency_symbol))")
                            let firedata = Database.database().reference().child("users").child(userid)

                        firedata.child("currency").setValue("\(currenc!):\(currency_symbol!)") //"USD:$"

//                        }
//                        else
//                        {
//                            currenc = "QAR"
//                            currency_symbol = "QR"
//
//                            let firedata = Database.database().reference().child("users").child(userid)
//
//                            firedata.child("currency").setValue("QAR:QR")
//
//
//                        }
//
                        
                        
                        
//                        let fireRef = Database.database().reference()
//
//                        self.usercurrencySymRef = fireRef.child("currency").child(currenc!)
//
//
//                        self.querycurrencySymhandle = self.usercurrencySymRef.observe(DataEventType.value) { (SnapShot: DataSnapshot) in
//                            print("Currency Value SnapShot \(SnapShot.value)")
//
//
//                            if let statusval = SnapShot.value {
//
//                                let statusString = "\(statusval)"
//                                if statusString == "<null>"
//                                {
////                                    if currenc == "QAR"
////                                    {
//                                        currencymul = "1"
//
//                                   // }
//
////                                    else
////                                    {
//                                       // currencymul = "0.0054"
//
//                                  //  }
//
//                                    print("Currency Update multiple \(currencymul)")
//
//                                }
//                                else
//                                {
//                                currencymul = "\(statusval)"
//                                    print("Currency Update Multiple Value \(currencymul)")
//
//                                }
//                                let nc = NotificationCenter.default
//                               nc.post(name: NSNotification.Name("currencySymUpdate"), object: self, userInfo: nil)
//
//                            }
//
//                        }
                        
                         currencymul = dict.object(forKey: "converions_ratio") as! String //"0.0054"
                        
                        print("chk_currencymul\(currencymul)")
                        let nc = NotificationCenter.default
                        nc.post(name: NSNotification.Name("currencySymUpdate"), object: self, userInfo: nil)
                        
                        NotificationCenter.default.post(name: Notification.Name("ProfileUpdate"), object: nil)
                        
                      //  self.showAlertView(title: "Doctuber", message: "Customer updated successfully.".localized, callback: { (check) in
                            
                        
                            APPDELEGATE.updateHomeView()
                            
                      //  })
                        
                       APPDELEGATE.updateHomeView()

                        
                    }
                    
                    
                }
                
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
class currcell: UITableViewCell {
    
    @IBOutlet weak var curr_lbl: UILabel!
    
    
}
