//
//  RegisterViewController.swift
//  TowRoute Provider
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
    
    @IBOutlet weak var orimage: UIImageView!
    let cpvInternal = CountryPickerView()
    
    var fromLogin = false
    
    @IBOutlet var registerbtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
//        if let countryCode = Locale.current.regionCode {
//            print(countryCode)
//
//            print(getCountryCallingCode(countryRegionCode: countryCode))
//            country.text = "+\(getCountryCallingCode(countryRegionCode: countryCode))"
//        }
        
        country.text = "+44"
        
        // Do any additional setup after loading the view.
        navigationController?.navigationBar.prefersLargeTitles = false
       let barHeight = navigationController?.navigationBar.frame.maxY
        print(barHeight)
        firstname.delegate = self
        lastname.delegate = self
        email.delegate = self
        country.delegate = self
        mobile.delegate = self
        password.delegate = self
        code.delegate = self
        
        cpvInternal.delegate = self
        
        self.navigationController?.navigationBar.topItem?.title = "REGISTER".localized
        
//        firstname.placeholder = "First name".localized
//        lastname.placeholder = "Last name".localized
//        email.placeholder = "Email".localized
//        country.placeholder = "Country".localized
//        mobile.placeholder = "Mobile".localized
//        password.placeholder = "Password".localized
//        code.placeholder = "Referral/Invite code(Optional)".localized
        
        
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
        
        self.endEditing()
        
        let firstnametxt = firstname.text!
        
        let lastnametxt = lastname.text!
        
        var emailtxt = email.text!
        
        let countrytxt = country.text!
        
        let mobiletxt = mobile.text!
        
        let pwdtxt = password.text!
        
        emailtxt = String(emailtxt.characters.filter { !" \n\t\r".characters.contains($0) })
        
        let emailvalid = model.isValidEmail(testStr: emailtxt)
        
        var isValidNumber: Bool! = false
        
        let phoneUtil = NBPhoneNumberUtil.sharedInstance()
        
        print("countrycountry \(country)")
        
        if countrytxt.contains("+") {
            
            let newcode = countrytxt.replacingOccurrences(of: "+", with: "")
            
            let ioscode = phoneUtil?.getRegionCode(forCountryCode: NSNumber(value:Int(newcode)!))
            
            var phoneNumber: NBPhoneNumber!
            
            do {
                phoneNumber = try phoneUtil!.parse(mobiletxt, defaultRegion: ioscode)
            }
            catch let error as NSError {
                print(error.localizedDescription)
            }
            
            isValidNumber = phoneUtil?.isValidNumber(phoneNumber)
            
            print("code \(newcode) \(phoneNumber)")
            
        }
        
        if firstnametxt == "" || lastnametxt == "" || emailtxt == "" || countrytxt == "" || mobiletxt == "" || pwdtxt == "" {
            
            if firstnametxt == "" {
                
                self.showAlertView(message: "Please enter your First name!".localized)
                
            }
                
            else if lastnametxt == "" {
                
                self.showAlertView(message: "Please enter your Last name!".localized)
                
            }
            
            else if emailtxt == "" {
                
                self.showAlertView(message: "Please enter your Email ID!".localized)
                
            }
            
            else if countrytxt == "" {
                
                self.showAlertView(message: "Please select your Country Code!".localized)
                
            }
            
            else if mobiletxt == "" {
                
                self.showAlertView(message: "Please enter your Mobile No!".localized)
                
            }
            
            else if pwdtxt == "" {
                
                self.showAlertView(message: "Please enter your Password!".localized)
                
            }
            
        }
            
        else if (!emailvalid) {
            
            self.showAlertView(message: "Please enter valid Email ID!".localized)
            
        }
            
        else if !isValidNumber {
            
            if !isValidNumber {
                
                let alert = UIAlertController(title: "TOWROUTE PROVIDER".localized, message: "Please enter valid mobile number".localized, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok".localized, style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            }
            
        }
            
        else if (pwdtxt.count < 8){
            
            self.showAlertView(message: "Password must contain atleast 8 characters!".localized)
            
        }
            
            else if pwdtxt.hasSpecialCharacters() == true
        {
            self.showAlertView(message: "Special characters such as @ ! # $ % & * . : ;? not allowed".localized)
        }
            
        else if isValidPassword(testStr: pwdtxt) == false {
            
            self.showAlertView(message: "Password must be atleast 8 characters with atleast 1 number and alphabet!".localized)
            
        }
            
        else if btn.isSelected == false {
            
            self.showAlertView(message: "Please accept terms and conditions!".localized)
            
        }
        
            
        else {

           // self.registerbtn.isUserInteractionEnabled = false

            let params = ["phone_number": mobiletxt,
                          "email": emailtxt,
                          "mode": "driver"] as [String : Any]
            print("paramss\(params)")

            APIManager.shared.verifyEmail(params: params as [String : AnyObject], callback: { (response) in

                if case let status as String = response?["error"], status == "Invalid credentials." {
                    self.registerbtn.isUserInteractionEnabled = true
                    self.showAlertView(message: "Login Failed!".localized)
                }



                else if case let msg as String = response?["message"], msg == "Email or Phone Number not exists in our db."
                {



//                    SVProgressHUD.setContainerView(self.topMostViewController().view)
//                    SVProgressHUD.show()
//
//                    PhoneAuthProvider.provider().verifyPhoneNumber(countrytxt+mobiletxt, uiDelegate: nil, completion: { (verificationID, error) in
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

                        var params = ["first_name": firstnametxt,
                                      "last_name":lastnametxt,
                                      "country_code":countrytxt,
                                      "phone_number":mobiletxt,
                                      "email":emailtxt,
                                      "password":pwdtxt,
                                      "device_token":"123",
                                      "referral_code":self.code.text!]

                        print("params \(params)")






//                        let viewcon = self.storyboard?.instantiateViewController(withIdentifier: "MobileVerification") as! PhoneVerificationViewController
//                        viewcon.phoneno = countrytxt+mobiletxt
//                        viewcon.isRegister = true
//                        viewcon.registerParams = params as [String : AnyObject]
//                        self.navigationController?.pushViewController(viewcon, animated: true)

                  //  })



                    APIManager.shared.driverRegister(params: params as [String : AnyObject], callback: { (response) in

                            print("response \(response)")
                            if case let msg as String = response?["message"], msg == "Registered Successfully" {

                                if case let details as NSDictionary = response?["result"] {

                                    if let id = details["id"] {

                                        driver_id = "\(id)"

                                    }

                                        var myuserinfo = [String: String]()
                                        
                                        if let id = details["id"] {
                                            
                                            driver_id = "\(id)"
                                            
                                            myuserinfo.updateValue(driver_id, forKey: "id")
                                            
                                        }
                                        
                                        if let username = details["first_name"] {
                                            
                                            driver_name = "\(username)"
                                            
                                            myuserinfo.updateValue(driver_name, forKey: "first_name")
                                            
                                        }
                                        
                                        if let userlname = details["last_name"] {
                                            
                                            driver_lname = "\(userlname)"
                                            
                                            myuserinfo.updateValue(driver_lname, forKey: "last_name")
                                            
                                        }
                                        
                                        if let userlname = details["email"] {
                                            
                                            driver_email = "\(userlname)"
                                            
                                            myuserinfo.updateValue(driver_email, forKey: "email")
                                            
                                        }
                                        
                                        if let cur = details["currency"] {
                                            
                                            currency = "\(cur)"
                                            
                                            myuserinfo.updateValue(currency!, forKey: "currency")
                                            
                                        }
                                        
                                        if let avatar = details["avatar"] {
                                            
                                            driver_image = "\(avatar)"
                                            
                                            myuserinfo.updateValue(driver_image, forKey: "avatar")
                                            
                                        }
                                        
                                        if let driver_certificate = details["driver_certificate"] {
                                            
                                            let driver_cert = "\(driver_certificate)"
                                            
                                            myuserinfo.updateValue(driver_cert, forKey: "driver_cert")
                                            
                                        }
                                        

                                        
                                        if let invite_code = details["invite_code"] {
                                            
                                            invitecode = "\(invite_code)"
                                            
                                            myuserinfo.updateValue(invitecode!, forKey: "invite_code")
                                            
                                        }
                                    
                                    APPDELEGATE.bearerToken = "12345"
                                    
                                    USERDEFAULTS.set("12345", forKey: "access_token")

                                        
                                        USERDEFAULTS.saveLoginDetails(logininfo: myuserinfo as [String: String])

                                }

                                self.showAlertView(title: "TOWROUTE PROVIDER".localized, message: "You have successfully registered".localized, callback: { (check) in

                                    let firedata = Database.database().reference().child("providers").child(driver_id)

                                    firedata.child("fname").setValue(params["first_name"])
                                    firedata.child("lname").setValue(params["last_name"])
                                    firedata.child("email").setValue(params["email"])
                                    firedata.child("cc").setValue(params["country_code"])
                                    firedata.child("mobile").setValue(params["phone_number"])
                                    firedata.child("pro_pic").setValue("")
                                    firedata.child("wallet").setValue("0")
                                    firedata.child("category").setValue("0")
                                    firedata.child("status").setValue("0")
                                    firedata.child("approved").setValue("0")
                                    firedata.child("currency").setValue("GBP:£")

                                    Database.database().reference().child("providers").child(driver_id).child("trips").child("service_status").setValue("0")
                                    self.registerbtn.isUserInteractionEnabled = true

                                    
                                    
                                    
                                    
//                                    APPDELEGATE.isShowLogin = true
//
//                                    APPDELEGATE.updateLoginView()
                                    
                            //navigating to manage service after register
                                    
                                    navigation_status = "1"
                                    

                                    let availPage = self.storyboard?.instantiateViewController(withIdentifier:"manageservices")
                                    self.navigationController?.pushViewController(availPage!, animated: true)
                                   
                                })

                            }

                            else if case let msg as String = response?["message"] {
                                self.registerbtn.isUserInteractionEnabled = true
                                self.showAlertView(message: msg.localized)

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
        
        // at least one uppercase,
        // at least one digit
        // at least one lowercase
        // 8 characters total
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "(?=.*[0-9])(?=.*[a-zA-Z]).{8,}")
        print(passwordTest.evaluate(with: testStr))
        return passwordTest.evaluate(with: testStr)
    }
    
    @IBAction func backact(_ sender: Any) {
        //self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
        print("backkkkkk")
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

var containsValidCharacter1: Bool {
    guard self != "" else { return true }
    let hexSet = CharacterSet(charactersIn: "1234567890ABCDEFabcdef")
    let newSet = CharacterSet(charactersIn: self)
    return hexSet.isSuperset(of: newSet)
  }
}
