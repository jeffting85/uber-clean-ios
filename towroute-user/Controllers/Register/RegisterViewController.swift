//
//  RegisterViewController.swift
//  TowRoute User
//
//  Created by Admin on 05/06/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import Material
import JVFloatLabeledTextField
import CountryPickerView
import Firebase
import libPhoneNumber_iOS
import SVProgressHUD

class RegisterViewController: UIViewController,TextFieldDelegate,UITextFieldDelegate  {
    
    let STORYBOARD = UIStoryboard(name: "Main", bundle: nil)
    
    @IBOutlet var firstname: JVFloatLabeledTextField!
    @IBOutlet var lastname: JVFloatLabeledTextField!
    @IBOutlet var email: JVFloatLabeledTextField!
    
    @IBOutlet var country: JVFloatLabeledTextField!
    
    @IBOutlet var mobile: JVFloatLabeledTextField!
    
    @IBOutlet var password: JVFloatLabeledTextField!
    
    @IBOutlet var code: JVFloatLabeledTextField!
    
    let cpvInternal = CountryPickerView()
    
    var fromLogin = false
    
    @IBOutlet var registerbtn: UIButton!
    
    @IBOutlet weak var orimage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //addMenu()
        
//        if let countryCode = Locale.current.regionCode {
//            print(countryCode)
//
//             print(getCountryCallingCode(countryRegionCode: countryCode))
//             country.text = "+\(getCountryCallingCode(countryRegionCode: countryCode))"
//        }
        country.text = "+44"
        
        firstname.delegate = self
        lastname.delegate = self
        email.delegate = self
        country.delegate = self
        mobile.delegate = self
        password.delegate = self
        code.delegate = self
        
        cpvInternal.delegate = self
        
        self.title = "REGISTER".localized
        
//        firstname.placeholder = "First name".localized
//        lastname.placeholder = "Last name".localized
//        email.placeholder = "Email".localized
//        country.placeholder = "Country".localized
//        mobile.placeholder = "Mobile".localized
//        password.placeholder = "Password".localized
//        code.placeholder = "Referral/invitecode(optional)".localized
        
        TextFiledAlignment(textfield: firstname)
        TextFiledAlignment(textfield: lastname)
        TextFiledAlignment(textfield: email)
        TextFiledAlignment(textfield: country)
        TextFiledAlignment(textfield: mobile)
        TextFiledAlignment(textfield: password)
        TextFiledAlignment(textfield: code)
        
        firstname.placeholderText(textfield: email, name: "First name".localized)
        lastname.placeholderText(textfield: lastname, name: "Last name".localized)
        email.placeholderText(textfield: email, name: "Email".localized)
        password.placeholderText(textfield: password, name: "Password".localized)
        mobile.placeholderText(textfield: mobile, name: "Mobile".localized)
        country.placeholderText(textfield: country, name: "Country".localized)
        code.placeholderText(textfield: code, name: "Referral/invitecode(optional)".localized)
        
        if LanguageManager.shared.currentLanguage == .ar
        {
         orimage.image = #imageLiteral(resourceName: "OR1_update1")
        }
        else
        {
          orimage.image = #imageLiteral(resourceName: "OR1_updated")
        }
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
    @IBAction func backact(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == self.firstname {
            self.lastname.becomeFirstResponder()
        }
            
        else if textField == self.lastname {
            self.email.becomeFirstResponder()
        }
        else if textField == self.email {
            self.mobile.becomeFirstResponder()
        }
        else if textField == self.country {
            self.mobile.becomeFirstResponder()
        }
        else if textField == self.mobile {
            self.password.becomeFirstResponder()
        }
        else if textField == self.password {
            self.code.becomeFirstResponder()
        }
        else if textField == self.code {
            self.code.resignFirstResponder()
        }
        
        return true
    }
    
    @IBAction func countryPickAct(_ sender: Any) {
        
        if let nav = navigationController {
            cpvInternal.showCountriesList(from: nav)
        }
        
    }
    
    @IBAction func register(_ sender: Any) {
        
        
        let fname = self.firstname.text!
        let lname = self.lastname.text!
        let country = self.country.text!
        let mob = self.mobile.text!
        let pwrd = self.password.text!
        let code = self.code.text!
        let email = self.email.text!
        
        let pwd = password.text!
        
        
        let checkvaluearr: [String] = [fname,lname,email,email,country,mob,pwrd]
        
        let checkforarr: [validator] = [.empty,.empty,.empty,.email,.empty,.empty,.empty]
        
        let alertmsgarr: [String] = ["Please enter your First Name!".localized,"Please enter valid Last Name!".localized,"Please enter your Email!".localized,"Please enter valid Email!".localized,"Please enter your Country!".localized,"Please enter your Mobile!".localized,"Please enter your Password!".localized]
        
        let checker = model.validator(checkvalue: checkvaluearr, checkfor: checkforarr)
        
        var isValidNumber: Bool! = false
        
        let phoneUtil = NBPhoneNumberUtil.sharedInstance()
        
        print("countrycountry \(country)")
        
        print("isAlphanumeric \(pwd.isAlphanumeric)")
        
        if country.contains("+") {
            
            let newcode = country.replacingOccurrences(of: "+", with: "")
            
            let ioscode = phoneUtil?.getRegionCode(forCountryCode: NSNumber(value:Int(newcode)!))
            
            var phoneNumber: NBPhoneNumber!
            
            do {
                phoneNumber = try phoneUtil!.parse(mob, defaultRegion: ioscode)
            }
            catch let error as NSError {
                print(error.localizedDescription)
            }
            
            isValidNumber = phoneUtil?.isValidNumber(phoneNumber)
            
            print("code \(newcode) \(phoneNumber)")
            
        }
        
        print("isValidNumber \(isValidNumber)")
        
        if checker.error {
            
            let alert = UIAlertController(title: "TowRoute".localized, message: alertmsgarr[checker.errorId], preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok".localized, style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
        else if !isValidNumber {
            
            if !isValidNumber {
                
                let alert = UIAlertController(title: "TowRoute".localized, message: "Please enter valid mobile number".localized, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok".localized, style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            }
            
        }
            
        else if (pwrd.count < 8){
            
            self.showAlertView(message: "Password must contain atleast 8 characters!".localized)
            
        }
            
        else if pwrd.hasSpecialCharacters() == true
        {
            print("has special character")
            self.showAlertView(message: "Special characters such as @ ! # $ % & * . : ;? not allowed".localized)
        }
            
        else if isValidPassword(testStr: pwrd) == false {
             print("no special character")
            self.showAlertView(message: "Password must be atleast 8 characters with atleast 1 number and alphabet!".localized)
            
        }
            
            
        else if btn.isSelected == false {
            
            self.showAlertView(message: "Please accept terms and conditions!".localized)
            
        }
            
        else {
            
          //  registerbtn.isUserInteractionEnabled = false
          
            let params = ["phone_number": mob,
                          "email": email,
                          "mode": "customer"] as [String : Any]
            print("paramss\(params)")
            
       
            APIManager.shared.verifyEmail(params: params as [String : AnyObject], callback: { (response) in
                
              
              
                
                if case let status as String = response?["error"], status == "Invalid credentials." {
                    self.registerbtn.isUserInteractionEnabled = true
                    self.showAlertView(message: "Login Failed!".localized)
                }
                   
                    
                    
                else if case let msg as String = response?["message"], msg == "Email or Phone Number not exists in our db."{
                    
                    
                    
                  
                    
//                    SVProgressHUD.setContainerView(self.topMostViewController().view)
//                    SVProgressHUD.show()
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
                      let params = [
                           "first_name": fname,
                           "last_name": lname,
                            "password": pwd,
                           "phone_number": mob,
                            "email": email,
                            "device_token": APPDELEGATE.device_token,
                           "country_code": country,
                            "referral_code":self.code.text!
                       ]
                        print("paramss\(params)")
                    
                    
                    
                    

                    
//
//                        let viewcon = self.storyboard?.instantiateViewController(withIdentifier: "MobileVerification") as! PhoneVerificationViewController
//                        viewcon.phoneno = country+mob
//                        viewcon.isRegister = true
//                        viewcon.registerParams = params as [String : AnyObject]
                    
                    
                   
                        
                    APIManager.shared.registerUser(params: params as [String : AnyObject], callback: { (response) in
                            
                            print("response \(response)")
                            
                            if case let msg as String = response?["message"], msg == "Registered Successfully" {
                                
                                
                                
                                if case let details as NSDictionary = response?["result"] {
                                    
                                    if let id = details["id"] {
                                        
                                        customer_id = "\(id)"
                                        
                                    }
                                    
                                }
                                
                                self.showAlertView(title: "TowRoute".localized, message: "You have successfully registered".localized, callback: { (check) in
                                    
                                    let firedata = Database.database().reference().child("users").child(customer_id)
                                    
                                    firedata.child("fname").setValue(params["first_name"])
                                    firedata.child("lname").setValue(params["last_name"])
                                    firedata.child("email").setValue(params["email"])
                                    firedata.child("cc").setValue(params["country_code"])
                                    firedata.child("mobile").setValue(params["phone_number"])
                                    firedata.child("pro_pic").setValue("")
                                    firedata.child("wallet").setValue("0")
                                    firedata.child("rating").setValue("0")
                                    firedata.child("status").setValue("0")
                                    firedata.child("currency").setValue("GBP:£") //GBP:£
                                    
                                    Database.database().reference().child("users").child(customer_id).child("trips").child("accept_status").setValue("")
                                   self.registerbtn.isUserInteractionEnabled = true
                                    APPDELEGATE.isShowLogin = true
                                    
                                    APPDELEGATE.updateLoginView()
                                    
                                })
                                
                            }
                                
                            else if case let msgg as String = response?["message"] {
                                
                                self.registerbtn.isUserInteractionEnabled = true
                                self.showAlertView(message: msgg.localized)
                                
                            }
                            
                        })
                        
                
                }
                    
                else if case let msg as String = response?["message"] {
                    self.registerbtn.isUserInteractionEnabled = true
                    self.showAlertView(message: msg.localized)
                    
                }
                
            })
            
            
        }
        
        
    }
           func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
               
            if textField == mobile{
                
                 return (string.containsValidCharacter)
            }
            else{
                
                return true
            }
               

       
            
             }
    func isValidPassword(testStr:String?) -> Bool {
        guard testStr != nil else { return false }
        
        // atleast one number and alpha with 8characters
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "(?=.*[0-9])(?=.*[a-zA-Z]).{8,}")
        print(passwordTest.evaluate(with: testStr))
        return passwordTest.evaluate(with: testStr)
    }
    
    // let registervc = STORYBOARD.instantiateViewController(withIdentifier: "register") as! RegisterViewController
    
    //  self.navigationController?.pushViewController(registervc, animated: true)
    
    @IBOutlet var btn: UIButton!
    
    @IBAction func btnbox(_ sender: Any) {
        if (btn.isSelected == false)
        {
       btn.setBackgroundImage(#imageLiteral(resourceName: "checked"), for: UIControlState.normal)
            btn.isSelected = true;
        }
        else
        {
           btn.setBackgroundImage(#imageLiteral(resourceName: "un_check"), for: UIControlState.normal)
            btn.isSelected = false;
        }
        
        
    }
    @IBAction func already_account(_ sender: Any) {
        
        if fromLogin == true {
            
            self.dismiss(animated: true, completion: nil)
            return
            
        }
        
        let loginvc = STORYBOARD.instantiateViewController(withIdentifier: "loginvcc") as! UINavigationController
        
        let navview = loginvc.viewControllers[0] as! LoginViewController
        
        navview.fromRegister = true
        
        //self.navigationController?.pushViewController(registervc, animated: true)
        self.present(loginvc, animated: true, completion: nil)
        
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

extension RegisterViewController: CountryPickerViewDelegate {
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        // Only countryPickerInternal has it's delegate set
        let title = "Selected Country"
        let message = "Name: \(country.name) \nCode: \(country.code) \nPhone: \(country.phoneCode)"
        
        self.country.text = country.phoneCode
        
    }
}

extension String {
    var isAlphanumeric: Bool {
        
        print(!isEmpty && range(of: "/^(?=.*[0-9])(?=.*[a-zA-Z])([a-zA-Z0-9]+)$/", options: .regularExpression) == nil)
        return !isEmpty && range(of: "/^(?=.*[0-9])(?=.*[a-zA-Z])([a-zA-Z0-9]+)$/", options: .regularExpression) == nil
    }
    
    func isValidPassword() -> Bool {
        guard self != nil else { return false }
        
        // at least one uppercase,
        // at least one digit
        // at least one lowercase
        // 8 characters total
        // let passwordTest = NSPredicate(format: "SELF MATCHES %@", "(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,}")
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "(?=.*[0-9])(?=.*[A-Za-z]).{8,}")
        return passwordTest.evaluate(with: self)
    }
    
    func hasSpecialCharacters() -> Bool {
        
        do {
            let regex = try NSRegularExpression(pattern: ".*[^A-Za-z0-9].*", options: .caseInsensitive)
            if let _ = regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions.reportCompletion, range: NSMakeRange(0, self.count)) {
                return true
            }
            
        } catch {
            debugPrint(error.localizedDescription)
            return false
        }
        
        return false
    }
    
}
extension String {

var containsValidCharacter: Bool {
    guard self != "" else { return true }
    let hexSet = CharacterSet(charactersIn: "1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz")
    let newSet = CharacterSet(charactersIn: self)
    return hexSet.isSuperset(of: newSet)
  }
}
