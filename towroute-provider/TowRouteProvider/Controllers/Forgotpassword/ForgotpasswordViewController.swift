//
//  ForgotpasswordViewController.swift
//  TowRoute Provider
//
//  Created by Admin on 05/06/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import JVFloatLabeledTextField
import CountryPickerView
import libPhoneNumber_iOS
import FirebaseAuth
import SVProgressHUD

class ForgotpasswordViewController: UIViewController {
    
    @IBOutlet var email: JVFloatLabeledTextField!
    @IBOutlet var codetxt: JVFloatLabeledTextField!
    @IBOutlet var mobiletxt: JVFloatLabeledTextField!
    
    @IBOutlet weak var CountinueBtn: UIButton!
    let cpvInternal = CountryPickerView()
    
    @IBAction func countryPickAct(_ sender: Any) {
        
        if let nav = navigationController {
            cpvInternal.showCountriesList(from: nav)
        }
        
    }
    
    @IBAction func submit(_ sender: Any) {
        
        let mail = self.mobiletxt.text!
        
        let checkvaluearr: [String] = [mail]
        let checkforarr: [validator] = [.empty]
        let alertmsgarr: [String] = ["Please enter your Registered Email ID!".localized]
        let checker = model.validator(checkvalue: checkvaluearr, checkfor: checkforarr)
        
        if checker.error {
            
            let alert = UIAlertController(title: "TOWROUTE PROVIDER".localized, message: alertmsgarr[checker.errorId], preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok".localized, style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
        let checkvaluearr1: [String] = [mail]
        let checkforarr1: [validator] = [.email]
        let alertmsgarr1: [String] = ["Please enter Valid Email Id!".localized]
        let checker1 = model.validator(checkvalue: checkvaluearr1, checkfor: checkforarr1)
        
        if checker1.error {
            
            let alert = UIAlertController(title: "TOWROUTE PROVIDER".localized, message: alertmsgarr1[checker1.errorId], preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok".localized, style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
            
            
            //        let mob = self.mobiletxt.text!
            //        let country = self.codetxt.text!
            //
            //        //let checkvaluearr: [String] = [country,mob]
            //
            //      //  let checkforarr: [validator] = [.empty,.empty]
            //
            //       // let alertmsgarr: [String] = ["Please enter your Country!","Please enter your Mobile!"]
            //
            //      //  let checker = model.validator(checkvalue: checkvaluearr, checkfor: checkforarr)
            //
            //        var isValidNumber: Bool! = false
            //
            //        let phoneUtil = NBPhoneNumberUtil.sharedInstance()
            //
            //        print("countrycountry \(country)")
            //
            //        if country.contains("+") {
            //
            //            let newcode = country.replacingOccurrences(of: "+", with: "")
            //
            //            let ioscode = phoneUtil?.getRegionCode(forCountryCode: NSNumber(value:Int(newcode)!))
            //
            //            var phoneNumber: NBPhoneNumber!
            //
            //            do {
            //                phoneNumber = try phoneUtil!.parse(mob, defaultRegion: ioscode)
            //            }
            //            catch let error as NSError {
            //                print(error.localizedDescription)
            //            }
            //
            //            isValidNumber = phoneUtil?.isValidNumber(phoneNumber)
            //
            //            print("code \(newcode) \(phoneNumber)")
            //
            //        }
            //
            //        print("isValidNumber \(isValidNumber)")
            //
            //        if checker.error {
            //
            //            let alert = UIAlertController(title: "TowRoute".localized, message: alertmsgarr[checker.errorId], preferredStyle: UIAlertControllerStyle.alert)
            //            alert.addAction(UIAlertAction(title: "Ok".localized, style: UIAlertActionStyle.default, handler: nil))
            //            self.present(alert, animated: true, completion: nil)
            //
            //        }
            //        else if !isValidNumber {
            //
            //            if !isValidNumber {
            //
            //                let alert = UIAlertController(title: "TowRoute".localized, message: "Please enter valid mobile number", preferredStyle: UIAlertControllerStyle.alert)
            //                alert.addAction(UIAlertAction(title: "Ok".localized, style: UIAlertActionStyle.default, handler: nil))
            //                self.present(alert, animated: true, completion: nil)
            //
            //            }
            //
            //        }
            
        else {
            
            CountinueBtn.isUserInteractionEnabled = false
            
            let viewcon = self.storyboard?.instantiateViewController(withIdentifier: "MobileVerification") as! PhoneVerificationViewController
            let params = ["email": mail,
                          "mode": "driver"] as [String : Any]
            print("paramss\(params)")
            
            APIManager.shared.verifyMobile(params: params as [String : AnyObject], callback: { (response) in
                
                print(response!)
                
                if case let status as String = response?["error"], status == "Invalid credentials." {
                    self.CountinueBtn.isUserInteractionEnabled = true
                    self.showAlertView(message: "Invalid credentials.".localized)
                }
                    
                else if case let msg as String = response?["message"], msg == "Invalid mail id" {
                    self.CountinueBtn.isUserInteractionEnabled = true
                    self.showAlertView(message: "Your Email id is not registered".localized)
                    
                }
                    
                else if case let msg as String = response?["message"], msg == "Mail sent successfully"{
                    
                    self.CountinueBtn.isUserInteractionEnabled = false
                    
                   viewcon.mailid =  mail
                    
                    self.navigationController?.pushViewController(viewcon, animated: true)
                    
                    
                    
                    
                    
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
                    
                }
            })
            
        }
        
    }
    
    @IBAction func backact(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //addMenu()
        self.navigationController?.navigationBar.topItem?.title = "FORGOT PASSWORD".localized
        
        cpvInternal.delegate = self
        
//        email.placeholder = "Email".localized
//        codetxt.placeholder = "Country".localized
//        mobiletxt.placeholder = "Email".localized
        TextFiledAlignment(textfield: email)
        TextFiledAlignment(textfield: codetxt)
        TextFiledAlignment(textfield: mobiletxt)
        email.placeholderText(textfield: email, name: "Email".localized)
        mobiletxt.placeholderText(textfield: mobiletxt, name: "Email".localized)
        codetxt.placeholderText(textfield: codetxt, name: "Country".localized)
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func bactact(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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

extension ForgotpasswordViewController: CountryPickerViewDelegate {
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        // Only countryPickerInternal has it's delegate set
        let title = "Selected Country"
        let message = "Name: \(country.name) \nCode: \(country.code) \nPhone: \(country.phoneCode)"
        
        self.codetxt.text = country.phoneCode
        
    }
}

