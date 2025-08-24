//
//  PhoneVerificationViewController.swift
//  TowRoute User
//
//  Created by Uplogic Technologies on 19/07/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import SVProgressHUD

class PhoneVerificationViewController: UIViewController {
    
    @IBOutlet var phnolab: UILabel!
    @IBOutlet var codetxt: UITextField!
    @IBOutlet var timerlab: UILabel!
    
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var resentBtn: UIButton!
    var phoneno = ""
    var userid = ""
    var otpcode = ""
    var mailid = ""
    var timer = Timer()
    
    var seconds = 30
    
    var isRegister = false
    
    var registerParams = [String : AnyObject]()
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(PhoneVerificationViewController.updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        
        seconds -= 1
        
        if seconds < 10 {
            
            timerlab.text = "00:0\(seconds)"
            
        }
        else {
            timerlab.text = "00:\(seconds)"
        }
        
        if seconds == 0 {
            
            timerlab.text = "Resend Code".localized
            
            self.timer.invalidate()
            self.seconds = 30
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        phnolab.text = mailid
        
        
        runTimer()
        
        self.title = "MAIL VERIFICATION".localized
        
        
        TextFiledAlignment(textfield: codetxt)
        codetxt.placeholderText(textfield: codetxt, name: "Enter Code here".localized)
        // Do any additional setup after loading the view.
    }
    func TextFiledAlignment(textfield : UITextField)
    {
        if LanguageManager.shared.currentLanguage == .ar
        {
            textfield.textAlignment = .right
            textfield.textAlignment = .right
        }
        else
        {
            textfield.textAlignment = .left
            textfield.textAlignment = .left
        }
    }
    
    @IBAction func resendAct(_ sender: Any) {
        
        resentBtn.isUserInteractionEnabled = false
      
        if timerlab.text == "Resend Code".localized {
            
            self.timer.invalidate()
            self.seconds = 30
            
            timerlab.text = "Resend Code".localized
            
            runTimer()
            
            
            let params = ["email": mailid,
                          "mode": "customer"] as [String : Any]
            print("paramss\(params)")
            
            APIManager.shared.verifyMobile(params: params as [String : AnyObject], callback: { (response) in
                
                print(response!)
                
                if case let status as String = response?["message"], status == "Mail sent successfully"{
                    self.resentBtn.isUserInteractionEnabled = true
                    self.showAlertView(message: "Code Resend Successfully".localized)
                }
                    
                else if case let msg as String = response?["message"]{
                    self.resentBtn.isUserInteractionEnabled = true
                    self.showAlertView(message: msg.localized)
                    
                }
            self.resentBtn.isUserInteractionEnabled = true
//            SVProgressHUD.setContainerView(topMostViewController().view)
//            SVProgressHUD.show()
//
//            PhoneAuthProvider.provider().verifyPhoneNumber(phoneno, uiDelegate: nil, completion: { (verificationID, error) in
//
//                SVProgressHUD.dismiss()
//
//                if let error = error {
//                    self.showAlertView(message: error.localizedDescription)
//                    return
//                }
//
//                print("verficationid \(verificationID)")
//
//                UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
//
//            })
            
        })
        }
    }
        
    
    
    
    
    @IBAction func submitAct(_ sender: Any) {
        
        let code = codetxt.text!
        if codetxt.text == "" {
            
            self.showAlertView(message: "Please enter verification code!".localized)
            
            return
            
        }
            
        else {
            
            submitBtn.isUserInteractionEnabled = false
            let viewcon = self.storyboard?.instantiateViewController(withIdentifier: "Changepassword") as! ChangePasswordViewController
            
            
            
            let params = ["email": mailid,
                          "mode": "customer","otp":code] as [String : Any]
            print("paramss\(params)")
            
            APIManager.shared.verifyOtp(params: params as [String : AnyObject], callback: { (response) in
                
                print(response!)
                
                if case let status as String = response?["error"], status == "Invalid credentials." {
                     self.submitBtn.isUserInteractionEnabled = true
                    self.showAlertView(message: "Invalid credentials.".localized)
                }
                    
                else if case let msg as String = response?["message"], msg == "Invalid OTP Code" {
                    self.submitBtn.isUserInteractionEnabled = true
                    self.showAlertView(message: "Invalid OTP Code".localized)
                    
                }
                    
                else if case let msg as String = response?["message"], msg == "Code verified successfuly"{
                    
                   self.submitBtn.isUserInteractionEnabled = true
                    if case let details as NSDictionary = response?["result"] {
                        
                        if let id = details["id"] {
                            
                            customer_id = "\(id)"
                        }
                        
                    self.navigationController?.pushViewController(viewcon, animated: true)
                    
                }
                    
                }
                
                    
                    //                    SVProgressHUD.setContainerView(self.topMostViewController().view)
                    //                    SVProgressHUD.show()
                    //
                    //
                    //
                    //
                    //
                    //
                    //                    PhoneAuthProvider.provider().verifyPhoneNumber(country+mob, uiDelegate: nil, completion: { (verificationID, error) in
                    //
                    //                        SVProgressHUD.dismiss()
                    //
                    //                        if let error = error {
                    //                            self.showAlertView(message: error.localizedDescription)
                    //                            return
                    //                        }
                    //
                    //                        print("verficationid \(verificationID)")
                    //
                    //                        UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
                    //
                    //                        var userid = ""
                    //
                    //                        if let usrid = response?["id"] {
                    //
                    //                            userid = "\(usrid!)"
                    //
                    //                        }
                    //
                    //
                    //
                    //                    })
                    
                
            })
            
        }
        
        
            
//        let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")
//
//        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID ?? "",
//                                                                 verificationCode: codetxt.text!)
//
//        SVProgressHUD.setContainerView(topMostViewController().view)
//        SVProgressHUD.show()
//
//        Auth.auth().signIn(with: credential) { (authData, error) in
//
//            SVProgressHUD.dismiss()
//
//            if ((error) != nil) {
//                // Handles error
//                self.showAlertView(message: "Invalid verification code!".localized)
//                return
//            }
//
//            self.timer.invalidate()
//            self.seconds = 30
//
//            self.timerlab.text = "Resend Code".localized
//
//            if self.isRegister == true {
//
//                APIManager.shared.registerUser(params: self.registerParams, callback: { (response) in
//
//                    print("response \(response)")
//
//                    if case let msg as String = response?["message"], msg == "Registered Successfully" {
//
//                        if case let details as NSDictionary = response?["result"] {
//
//                            if let id = details["id"] {
//
//                                customer_id = "\(id)"
//
//                            }
//
//                        }
//
//                        self.showAlertView(title: "TowRoute".localized, message: "You have successfully registered".localized, callback: { (check) in
//
//                            let firedata = Database.database().reference().child("users").child(customer_id)
//
//                            firedata.child("fname").setValue(self.registerParams["first_name"])
//                            firedata.child("lname").setValue(self.registerParams["last_name"])
//                            firedata.child("email").setValue(self.registerParams["email"])
//                            firedata.child("cc").setValue(self.registerParams["country_code"])
//                            firedata.child("mobile").setValue(self.registerParams["phone_number"])
//                            firedata.child("pro_pic").setValue("")
//                            firedata.child("wallet").setValue("0")
//                            firedata.child("rating").setValue("0")
//                            firedata.child("status").setValue("0")
//                            firedata.child("currency").setValue("USD:$")
//
//                            Database.database().reference().child("users").child(customer_id).child("trips").child("accept_status").setValue("")
//
//                            APPDELEGATE.isShowLogin = true
//
//                            APPDELEGATE.updateLoginView()
//
//                        })
//
//                    }
//
//                    else if case let msgg as String = response?["message"] {
//
//                        self.showAlertView(message: msgg.localized)
//
//                    }
//
//                })
//
//            }
        
            
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
