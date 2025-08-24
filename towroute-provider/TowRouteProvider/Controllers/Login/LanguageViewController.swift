//
//  LanguageViewController.swift
//  CoinBanker
//
//  Created by Uplogic Technologies on 29/09/18.
//  Copyright © 2018 UPLOGIC. All rights reserved.
//

import UIKit



class LanguageViewController: UIViewController {

    var selectedlang = ""
    
    var curOption = ["BHD"]
    var curWithCountry = ["Bahraini Dinar (BHD)"]
    
    
    @IBOutlet weak var English_btn: UIButton!
    @IBOutlet weak var Arabic_btn: UIButton!
    @IBOutlet weak var finnish_btn: UIButton!
    @IBOutlet weak var SInhala_btn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("chcklang_id\(lang_id)")
        print("chcklang_name\(lang_name)")
        print("chcklang_Shrtform\(lang_Shrtform)")
       
        English_btn.setTitle("English", for: .normal)
        Arabic_btn.setTitle("Arabic", for: .normal)
        finnish_btn.setTitle("Finnish", for: .normal)
        SInhala_btn.setTitle("Sinhala", for: .normal)
        /*if lang_Shrtform.isEmpty {
            let params = ["":""] as [String : AnyObject]
            self.appSetting(params: params)
        }
              for cur in langarr! {
                  
                  let dict = cur as! NSDictionary
              
           
                      let arrvalue_one = lang_Shrtform.index(of: "en") as! Int
                      let arrvalue_two = lang_Shrtform.index(of: "si") as! Int
                       print("checkarrvalue\(arrvalue_one)")
                       print("checkarrvalue\(arrvalue_two)")
                
                let engname = lang_name[arrvalue_one]
                     let arabicname = lang_name[arrvalue_two]
                
                self.English_btn.setTitle(engname, for: UIControl.State.normal)
                self.Arabic_btn.setTitle(arabicname, for: UIControl.State.normal)
                    
                     // selectedlang = lang_id[arrvalue]
                
                      print("chckselectedlang\(selectedlang)")
        
                  
              }*/

        // Do any additional setup after loading the view.
    }

    @IBAction func chooseEnglish(_ sender: Any) {
    
       selectedlang = "1"
        
//        for cur in langarr! {
//
//            let dict = cur as! NSDictionary
//
//
//
//                let arrvalue = lang_Shrtform.index(of: "en") as! Int
//
//                print("checkarrvalue\(arrvalue)")
//
//                //selectedlang = lang_id.arrvalu
//                selectedlang = lang_id[arrvalue]
//                print("chckselectedlang\(selectedlang)")
//
//
//        }
        
   
        update_information()
    }
    
    @IBAction func chooseArabic(_ sender: Any) {
        
        selectedlang = "2"

        
//        let selectedLanguage:Languages = .ar
//
//        // change the language
//        LanguageManager.shared.setLanguage(language: selectedLanguage)
//
//        APPDELEGATE.updateHomeView()
//        APPDELEGATE.updateHomeView()
        
        update_information()
//
    }
    
    @IBAction func chooseFrench(_ sender: Any) {
        selectedlang = "3"
        
          update_information()
    }
    
    @IBAction func chooseSpanish(_ sender: Any) {
        
        selectedlang = "4"
        
        
//              for cur in langarr! {
//
//                  let dict = cur as! NSDictionary
//
//
//
//                      let arrvalue = lang_Shrtform.index(of: "si") as! Int
//
//                      print("checkarrvalue\(arrvalue)")
//
//                      //selectedlang = lang_id.arrvalu
//                      selectedlang = lang_id[arrvalue]
//                      print("chckselectedlang\(selectedlang)")
//
//
//              }
     
        update_information()
    }
    
    @IBAction func closeAct(_ sender: Any) {
    
        self.dismiss(animated: false, completion: nil)
        
    }
    
    
    func appSetting(params: [String : AnyObject]) {
        
        print("params \(params)")
        
        APIManager.shared.appSetting(params: params, callback: { (response) in
            
            if case let currency as NSArray = response?["currency"] {
                
                self.curOption.removeAll()
                
                self.curWithCountry.removeAll()
                
                for cur in currency {
                    
                    let dict = cur as! NSDictionary
                    
                    let curstr = dict.object(forKey: "short_name") as! String
                    
                    self.curOption.append(curstr)
                    
                    let currency = dict.object(forKey: "currency") as! String
                    
                    let curname = currency + " (" + curstr + ")"
                    
                    self.curWithCountry.append(curname)
                    
                }
                
            }
            
            if case let currency as NSArray = response?["language"] {
                
                langarr = currency
                 
                 //self.langOption.removeAll()
                 lang_id.removeAll()
                 lang_name.removeAll()
                 lang_Shrtform.removeAll()
                 
                 
                 for cur in currency {
                     
                     let dict = cur as! NSDictionary
                     
                     print("chckdict\(dict)")
                 
                     let langstr = dict.object(forKey: "language_name") as! String
                     let langcode = dict.object(forKey: "language_code") as! String
                     let language_id = dict.object(forKey: "id") as! NSNumber
                 
                     
                     
                     //self.langOption.append(curstr)
                     lang_id.append("\(language_id)")
                     lang_name.append(langstr)
                     lang_Shrtform.append(langcode)
                     
                   print("chcklang_id\(lang_id)")
                     print("chcklang_name\(lang_name)")
                     print("chcklang_Shrtform\(lang_Shrtform)")
                   
                     
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
                          "language": selectedlang]
            
            print("paramsapicall \(params)")
            
            APIManager.shared.updateProfileDriver(params: params as [String : AnyObject]) { (response) in
                
                if case let msg as String = response?["message"], msg == "Unauthenticated." {
                    
                    APIManager.shared.refreshToken(params: params as [String : AnyObject]) { (response) in
                        
                        if case let access_token as String = response?["access_token"] {
                            
                            APPDELEGATE.bearerToken = access_token
                            
                            USERDEFAULTS.set(access_token, forKey: "access_token")
                            
                            self.update_information()
                            
                        }
                            
                        else {
                            
                            self.showAlertView(title: "TOWROUTE PROVIDER", message: "Your session has expired. Please log in again".localiz(), callback: { (check) in
                                
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
                if case let msg as String = response?["message"], msg == "Driver updated successfully."{
                    
                    NotificationCenter.default.post(name: Notification.Name("ProfileUpdate"), object: nil)
                    
                  //  self.showAlertView(title: "Doctuber", message: "Customer updated successfully.".localized, callback: { (check) in
                        
                    
                        
                            if self.selectedlang == "1" {
                                  let selectedLanguage:Languages = .en
                                       
                                       // change the language
                                       LanguageManager.shared.setLanguage(language: selectedLanguage)
                                       
                                       APPDELEGATE.updateHomeView()
                                       APPDELEGATE.updateHomeView()
                                  
                              }
                                  else if self.selectedlang == "2" {
                                                             let selectedLanguage:Languages = .si
                                                                  
                                                                  // change the language
                                                                  LanguageManager.shared.setLanguage(language: selectedLanguage)
                                                                  
                                                                  APPDELEGATE.updateHomeView()
                                                                  APPDELEGATE.updateHomeView()
                                                             
                                                         }
                                  else if  self.selectedlang == "3" {
                                                             let selectedLanguage:Languages = .fi
                                                                  
                                                                  // change the language
                                                                  LanguageManager.shared.setLanguage(language: selectedLanguage)
                                                                  
                                                                  APPDELEGATE.updateHomeView()
                                                                  APPDELEGATE.updateHomeView()
                                                             
                                                         }
                              else{
                                 
                                 // let selectedLanguage:Languages = .si

                                  let selectedLanguage:Languages = .ar
                                       
                                       // change the language
                                       LanguageManager.shared.setLanguage(language: selectedLanguage)
                                       
                                       APPDELEGATE.updateHomeView()
                                       APPDELEGATE.updateHomeView()
                                  
                              }
                              
                              
                        //  })
                    
                   
                    
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
