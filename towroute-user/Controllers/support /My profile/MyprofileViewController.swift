//
//  MyprofileViewController.swift
//  TowRoute User
//
//  Created by Admin on 06/06/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import JVFloatLabeledTextField
import CountryPickerView
import Alamofire
import CountryPickerView
import Firebase

struct language {
    var name = String()
    var id = String()
}

class MyprofileViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet var countrycodetxt: JVFloatLabeledTextField!
    @IBOutlet var languagetxt: JVFloatLabeledTextField!
    @IBOutlet var curtxt: JVFloatLabeledTextField!
    
    
    @IBOutlet var firstname: UILabel!
    @IBOutlet var lastname: UILabel!
    @IBOutlet var email: UILabel!
    @IBOutlet var countrycode: UILabel!
    
    @IBOutlet var firstnametxt: JVFloatLabeledTextField!
    @IBOutlet var lastnametxt: JVFloatLabeledTextField!
    @IBOutlet var emailtxt: JVFloatLabeledTextField!
    @IBOutlet var countrytxt: JVFloatLabeledTextField!
    @IBOutlet var mobiletxt: JVFloatLabeledTextField!
    @IBOutlet var servicetxt: JVFloatLabeledTextField!
    
    @IBOutlet var mobnum: UILabel!
    @IBOutlet var lang: UILabel!
    
    @IBOutlet var profimage: UIImageView!
    @IBOutlet var proofimage: UIImageView!
    @IBOutlet var currency: UILabel!
    
    let cpvInternal = CountryPickerView()
    
    var langOption = ["English", "Arabic"]
    
    var langpickerView = UIPickerView()
    
    var curOption = ["USD ($), GBP (AED)"]
    
    var curWithCountry = ["Dollor (USD)","Swiss Franc (CHF)","France Euro (EUR)","Nigerian Currency (NGN)"]
    
    @IBOutlet weak var changepwdbtn: UIButton!
    var curpickerView = UIPickerView()
    @IBOutlet var editbtn: UIButton!
    @IBOutlet var editview: UIScrollView!
    @IBOutlet var moreview: UIView!
    @IBOutlet var pwdview: UIView!
    
    var allLangOption = [language]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cpvInternal.delegate = self
        
        langpickerView.delegate = self
        
        languagetxt.inputView = langpickerView
        
        curpickerView.delegate = self
        
        curtxt.inputView = curpickerView
        viewProfile()
        
        self.title = "My Profile".localized
        
        firstnametxt.placeholder = "First name".localized
        lastnametxt.placeholder = "Last name".localized
        emailtxt.placeholder = "Email".localized
        countrytxt.placeholder = "Country".localized
        mobiletxt.placeholder = "Mobile".localized
        languagetxt.placeholder = "Language".localized
        curtxt.placeholder = "Currency".localized
        servicetxt.placeholder = "Service Description".localized
        oldpwd.placeholder = "ENTER OLD PASSWORD".localized
        newpwd.placeholder = "ENTER NEW PASSWORD".localized
        renewpwd.placeholder = "CONFIRM NEW PASSWORD".localized
        
        TextFiledAlignment(textfield: firstnametxt)
        TextFiledAlignment(textfield: lastnametxt)
        TextFiledAlignment(textfield: emailtxt)
        TextFiledAlignment(textfield: countrytxt)
        TextFiledAlignment(textfield: languagetxt)
        TextFiledAlignment(textfield: curtxt)
        TextFiledAlignment(textfield: servicetxt)
        TextFiledAlignment(textfield: newpwd)
        TextFiledAlignment(textfield: renewpwd)
        TextFiledAlignment(textfield: oldpwd)
        
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
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == langpickerView {
            return langOption.count
        }
        else {
            return curWithCountry.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == langpickerView {
            return langOption[row]
        }
        else {
            return curWithCountry[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == langpickerView {
            
            languagetxt.text = langOption[row]
            
            if row == 0
            {
                let selectedLanguage:Languages = .en
                LanguageManager.shared.setLanguage(language: selectedLanguage)
            }
            else if row == 1
            {
                let selectedLanguage:Languages = .ar
                LanguageManager.shared.setLanguage(language: selectedLanguage)
            }
            
        }
        else {
            
            
            curtxt.text = curOption[row]
        }
        
    }
    
    @IBAction func update_information(_ sender: Any) {
        
        let userdict = USERDEFAULTS.getLoggedUserDetails()
        
        let userid = userdict["id"] as! String
        
        let fname = firstnametxt.text!
        
        if fname == "" {
            
            self.showAlertView(message: "Please enter your First Name!".localized)
            
            return
            
        }
        
        let lname = lastnametxt.text!
        
        if lname == "" {
            
            self.showAlertView(message: "Please enter valid Last Name!".localized)
            
            return
            
        }
        
        let email = emailtxt.text!
        
        if email == "" {
            
            self.showAlertView(message: "Please enter your Email!".localized)
            
            return
            
        }
        
        let code = countrytxt.text!
        
        if code == "" {
            
            self.showAlertView(message: "Please enter your Country!".localized)
            
            return
            
        }
        
        let mobile = mobiletxt.text!
        
        if mobile == "" {
            
            self.showAlertView(message: "Please enter valid mobile number".localized)
            
            return
            
        }
        
        var servicedesc = servicetxt.text!
        if servicedesc == ""
        {
            servicedesc = ""
        }
        let selindex = langOption.index(of: languagetxt.text!)!
        
        let selLangIndex = self.allLangOption[selindex].id
        
        let params = ["id":userid,
                      "first_name":fname,
                      "last_name":lname,
                      "email":email,
                      "country_code":code,
                      "phone_number":mobile,
                      "service_description": servicedesc,
                      "language": selLangIndex,
            "currency": curtxt.text!]
        
        print("params \(params)")
        
        APIManager.shared.updateProfile(params: params as [String : AnyObject]) { (response) in
            
            if case let msg as String = response?["message"], msg == "Unauthenticated." {
                
                APIManager.shared.refreshToken(params: params as [String : AnyObject]) { (response) in
                    
                    if case let access_token as String = response?["access_token"] {
                        
                        APPDELEGATE.bearerToken = access_token
                        
                        USERDEFAULTS.set(access_token, forKey: "access_token")
                        
                        self.update_information(self)
                        
                    }
                        
                    else {
                        
                        self.showAlertView(title: "TowRoute".localiz(), message: "Your session has expired. Please log in again".localiz(), callback: { (check) in
                            
                            APPDELEGATE.updateLoginView()
                            
                        })
                        
                    }
                    
                }
                
            }
                
            else if case let details as NSDictionary = response?["data"] {
                
                var myuserinfo = [String: String]()
                
                if let id = details["id"] {
                    
                    customer_id = "\(id)"
                    
                    myuserinfo.updateValue(customer_id, forKey: "id")
                    
                }
                
                if let username = details["first_name"] {
                    
                    customer_name = "\(username)"
                    
                    myuserinfo.updateValue(customer_name, forKey: "first_name")
                    
                }
                
                if let userlname = details["last_name"] {
                    
                    customer_lname = "\(userlname)"
                    
                    myuserinfo.updateValue(customer_lname, forKey: "last_name")
                    
                }
                
                if let userlname = details["email"] {
                    
                    customer_email = "\(userlname)"
                    
                    myuserinfo.updateValue(customer_email, forKey: "email")
                    
                }
                
                if let cur = details["currency"] {
                    
                    currenc = "\(cur)"
                    
                    myuserinfo.updateValue(currenc!, forKey: "currency")
                    
                }
                
                if let currency_syml = details["currency_symbol"] {
                    
                    currency_symbol = "\(currency_syml)"
                    
                    myuserinfo.updateValue(currency_symbol!, forKey: "currency_symbol")
                    
                }
                
                if let avatar = details["avatar"] {
                    
                    customer_image = "\(avatar)"
                    
                    myuserinfo.updateValue(customer_image, forKey: "avatar")
                    
                }
                
                USERDEFAULTS.saveLoginDetails(logininfo: myuserinfo as [String: String])
                
                let firedata = Database.database().reference().child("users").child(userid)
                
                firedata.child("currency").setValue(currenc! + ":" + currency_symbol!)
                
                USERDEFAULTS.set(self.languagetxt.text!, forKey: "Language")
                
                userlang = self.languagetxt.text!
             
                
            }
            
            if case let msg as String = response?["message"], msg != "Unauthenticated."{
                
                NotificationCenter.default.post(name: Notification.Name("ProfileUpdate"), object: nil)
                
                self.showAlertView(title: "TowRoute", message: "Updated Successfully".localized, callback: { (check) in
                    
                    APPDELEGATE.updateHomeView()
                   let selindex = self.langOption.index(of: self.languagetxt.text!)!


                    if (LanguageManager.shared.currentLanguage == .ar) {

                        let selectedLanguage:Languages = .ar
                        LanguageManager.shared.setLanguage(language: selectedLanguage)
                        APPDELEGATE.updateHomeView()
                        APPDELEGATE.updateHomeView()

                    }
                    
                    else if (LanguageManager.shared.currentLanguage == .en) {

                        let selectedLanguage:Languages = .en
                        LanguageManager.shared.setLanguage(language: selectedLanguage)
                        APPDELEGATE.updateHomeView()
                        APPDELEGATE.updateHomeView()

                    }
                    
                })
                
                self.editview.isHidden = true
                self.editbtn.setTitle("   Edit Profile".localized, for: UIControlState.normal)
                self.viewProfile()
                
            }
            
            
        }
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        self.slideMenuController()?.addLeftGestures()
        self.slideMenuController()?.addRightGestures()
    }
    
    func viewProfile() {
        
        let country = self.countrycodetxt.text
        
        
        // profileViewDriver
        
        let userdict = USERDEFAULTS.getLoggedUserDetails()
        
        let userid = userdict["id"] as! String
        
        let params = ["id":userid,
                      "token":APPDELEGATE.bearerToken]
        
        print("params \(params)")
        
        APIManager.shared.profileView(params: params as [String : AnyObject]) { (response) in
            
            if case let msg as String = response?["message"], msg == "Unauthenticated." {
                
                APIManager.shared.refreshToken(params: params as [String : AnyObject]) { (response) in
                    
                    if case let access_token as String = response?["access_token"] {
                        
                        APPDELEGATE.bearerToken = access_token
                        
                        USERDEFAULTS.set(access_token, forKey: "access_token")
                        
                        self.viewProfile()
                        
                    }
                        
                    else {
                        
                        self.showAlertView(title: "TowRoute".localiz(), message: "Your session has expired. Please log in again".localiz(), callback: { (check) in
                            
                            APPDELEGATE.updateLoginView()
                            
                        })
                        
                    }
                    
                }
                
            }
                
            else if case let details as NSDictionary = response?["data"] {
                print("detailsdss\(details)")
                if case let first_name as String = details["first_name"] {
                    
                    self.firstname.text = first_name
                    self.firstnametxt.text = first_name
                }
                
                if case let last_name as String = details["last_name"] {
                    
                    self.lastname.text = last_name
                    self.lastnametxt.text = last_name
                    
                }
                
                if case let email as String = details["email"] {
                    
                    self.email.text = email
                    self.emailtxt.text = email
                    
                }
                
                if case let country_code as String = details["country_code"] {
                    
                    self.countrycodetxt.text = country_code
                    self.countrytxt.text = country_code
                    self.countrycode.text = country_code
                }
                
                if case let phone_number as String = details["phone_number"] {
                    
                    self.mobnum.text = phone_number
                    self.mobiletxt.text = phone_number
                    
                }
                
                if let selindex1 = details["language"] {
                    
                    let langtxt = "\(selindex1)"
                    
                    if langtxt != "" {
                        
                        
                        
                        if LanguageManager.shared.currentLanguage == .ar
                        {
                            self.lang.text = "Arabic"
                            self.languagetxt.text = "Arabic"
                        }
                        else
                        {
                            self.lang.text = "English"
                            self.languagetxt.text = "English"
                        }
                        
//                        self.lang.text = langtxt
//                        self.languagetxt.text = langtxt
                        
                    }
                    
                    else
                    {
                        if LanguageManager.shared.currentLanguage == .ar
                        {
                            self.lang.text = "Arabic"
                            self.languagetxt.text = "Arabic"
                        }
                        else
                        {
                            self.lang.text = "English"
                            self.languagetxt.text = "English"
                        }
                        
                    }
                    
                }
                
                if case let currency as String = details["currency"], currency != "" {
                    
                    self.currency.text = currency
                    self.curtxt.text = currency
                }
                if case let avatar as String = details["avatar"] {
                    
                    if(!(avatar.isEmpty)){
                        
                        let newavatar = BASEAPI.PRFIMGURL + avatar
                        
                        Alamofire.request(newavatar, method: .get).responseImage { response in
                            guard let image = response.result.value else {
                                // Handle error
                                return
                            }
                            
                            self.profimage.image = image
                            self.proofimage.image = image
                            
                            // Do stuff with your image
                        }
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    
    
    @IBAction func backact(_ sender: Any) {
        if editview.isHidden
        {
            self.navigationController?.popViewController(animated: true)
        }
            
        else
        {
            editview.isHidden = true
            editbtn.setTitle("   Edit Profile".localized, for: UIControlState.normal)
        }
       
        
    }
    
    @IBAction func countryPickAct(_ sender: Any) {
        
        if let nav = navigationController {
            cpvInternal.showCountriesList(from: nav)
        }
        
    }
    
    @IBAction func profilepic_act(_ sender: Any) {
        
        MediaPicker.shared.showMediaPicker(imageView: proofimage, placeHolder: nil) { (img, check) in
            
            if check == true {
                
                self.image_pic = true
                
                self.profimage.image = img
                
            }
            
        }
        
    }
    @IBAction func moreAct(_ sender: Any) {
        
        if moreview.isHidden == false {
            
            moreview.isHidden = true
            
        }
            
        else {
            
            moreview.isHidden = false
            
        }
        
    }
    
    
    var image_pic = false
    
    override func viewWillAppear(_ animated: Bool) {
        
        if image_pic == true{
            
            image_pic = false
            
            let refreshAlert = UIAlertController(title: "Image Upload!", message: "Do You Want Upload this Profile Image?", preferredStyle: UIAlertControllerStyle.alert)
            
            refreshAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
                print("Handle Cancel Logic here")
            }))
            
            refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
                print("Handle Ok logic here")
                self.editAct()
            }))
            
            self.present(refreshAlert, animated: true, completion: nil)
        }
        else {
            
            self.slideMenuController()?.removeLeftGestures()
            self.slideMenuController()?.removeRightGestures()
            
        }
        
        if LanguageManager.shared.currentLanguage == .ar
        {
            editbtn.addLeftPadding(10.0)
            changepwdbtn.addLeftPadding(10.0)
        }
        else
        {
            
        }
        userImage = self.profimage.image
        
        let params = ["":""] as [String : AnyObject]
        self.appSetting(params: params)
        
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
                
                self.langOption.removeAll()
                self.allLangOption.removeAll()
                
                for cur in currency {
                    
                    let dict = cur as! NSDictionary
                    
                    let curstr = dict.object(forKey: "language_name") as! String
                    
                    let langid = "\(dict["id"]!)"
                    
                    self.langOption.append(curstr)
                    
                    self.allLangOption.append(language(name: curstr, id: langid))

                }
                
            }
            
        })
        
    }
    
    func editAct() {
        
        let imageData = proofimage.image?.jpeg(.low)
        
        let imageStr = imageData?.base64EncodedString()
        
        let userdict = USERDEFAULTS.getLoggedUserDetails()
        
        let userid = userdict["id"] as! String
        
        let currentTimeStamp = NSDate().timeIntervalSince1970.toString()
        let filename = "\(currentTimeStamp)_img.jpg"
        
        let params = ["id": userid,
                      "avatar": filename,
                      "file_binary_data": imageStr!] as [String : Any]
        
        APIManager.shared.imageupload(params: params as [String : AnyObject], callback: { (response) in
            
            if case let msg as String = response?["message"], msg == "Unauthenticated." {
                
                APIManager.shared.refreshToken(params: params as [String : AnyObject]) { (response) in
                    
                    if case let access_token as String = response?["access_token"] {
                        
                        APPDELEGATE.bearerToken = access_token
                        
                        USERDEFAULTS.set(access_token, forKey: "access_token")
                        
                        self.editAct()
                        
                    }
                        
                    else {
                        
                        self.showAlertView(title: "TowRoute".localiz(), message: "Your session has expired. Please log in again".localiz(), callback: { (check) in
                            
                            APPDELEGATE.updateLoginView()
                            
                        })
                        
                    }
                    
                }
                
            }
                
            else if case let details as NSDictionary = response?["data"] {
                
                var myuserinfo = [String: String]()
                
                if let id = details["id"] {
                    
                    customer_id = "\(id)"
                    
                    myuserinfo.updateValue(customer_id, forKey: "id")
                    
                }
                
                if let username = details["first_name"] {
                    
                    customer_name = "\(username)"
                    
                    myuserinfo.updateValue(customer_name, forKey: "first_name")
                    
                }
                
                if let userlname = details["last_name"] {
                    
                    customer_lname = "\(userlname)"
                    
                    myuserinfo.updateValue(customer_lname, forKey: "last_name")
                    
                }
                
                if let userlname = details["email"] {
                    
                    customer_email = "\(userlname)"
                    
                    myuserinfo.updateValue(customer_email, forKey: "email")
                    
                }
                
                if let cur = details["currency"] {
                    
                    currenc = "\(cur)"
                    
                    myuserinfo.updateValue(currenc!, forKey: "currency")
                    
                }
                
                if let avatar = details["avatar"] {
                    
                    customer_image = "\(avatar)"
                    
                    myuserinfo.updateValue(customer_image, forKey: "avatar")
                    
                }
                
                let firedata = Database.database().reference().child("users").child(userid)
                
                firedata.child("pro_pic").setValue(customer_image)
                
                USERDEFAULTS.saveLoginDetails(logininfo: myuserinfo as [String: String])
                
                NotificationCenter.default.post(name: Notification.Name("ProfileUpdate"), object: nil)
                
            }
            
            if case let msg as String = response?["message"], msg != "Unauthenticated."{
                
                NotificationCenter.default.post(name: Notification.Name("ProfileUpdate"), object: nil)
                
                self.showAlertView(message: "Updated Successfully".localized)
                
                self.editview.isHidden = true
                self.editbtn.setTitle("   Edit Profile".localized, for: UIControlState.normal)
                self.viewProfile()
                
            }
            
            
        })
        
    }
    
    @IBAction func editAct(_ sender: Any) {
        
        moreview.isHidden = true
        
        if editbtn.titleLabel?.text == "   Edit Profile".localized {
            
            editbtn.setTitle("   View Profile".localized, for: UIControlState.normal)
            editview.isHidden = false
            
        }
            
        else {
            
            editbtn.setTitle("   Edit Profile".localized, for: UIControlState.normal)
            editview.isHidden = true
            
        }
        
    }
    
    @IBAction func changePwdAct(_ sender: Any) {
        
        moreview.isHidden = true
        
        pwdview.isHidden = false
        
    }
    
    @IBOutlet var oldpwd: JVFloatLabeledTextField!
    @IBOutlet var newpwd: JVFloatLabeledTextField!
    @IBOutlet var renewpwd: JVFloatLabeledTextField!
    
    @IBAction func okAct(_ sender: Any) {
        
        let oldpwdtxt = self.oldpwd.text!
        let newpwdtxt = self.newpwd.text!
        let renewpwdtxt = self.renewpwd.text!
        
        let checkvaluearr: [String] = [oldpwdtxt,newpwdtxt,renewpwdtxt]
        
        let checkforarr: [validator] = [.empty,.empty,.empty]
        
        let alertmsgarr: [String] = ["Please enter your Old Password!".localized,"Please enter your New Password!".localized,"Please enter confirm Password!".localized]
        
        let checker = model.validator(checkvalue: checkvaluearr, checkfor: checkforarr)
        
        if checker.error {
            
            let alert = UIAlertController(title: "TowRoute".localiz(), message: alertmsgarr[checker.errorId].localiz(), preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok".localiz(), style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
            
        else if (oldpwdtxt.count < 8) || (newpwdtxt.count < 8) {
            
            self.showAlertView(message: "Password must contain atleast 8 characters!".localized)
            
        }
            
        else if newpwdtxt.hasSpecialCharacters() == true
        {
            self.showAlertView(message: "Password must be atleast 8 characters with atleast 1 number and alphabets!".localized)
        }
            
        else if isValidPassword(testStr: newpwdtxt) == false {
            
            self.showAlertView(message: "Password must be atleast 8 characters with atleast 1 number and alphabets!".localized)
            
        }
            
            
        else if (newpwdtxt != renewpwdtxt){
            
            self.showAlertView(message: "New Password and confirm password are not same!".localized)
            
        }
            
        else {
            
            let userdict = USERDEFAULTS.getLoggedUserDetails()
            
            let userid = userdict["id"] as! String
            
            let params = ["id":userid,
                          "old_password":oldpwdtxt,
                          "new_password":newpwdtxt]
            
            print("params \(params)")
            
            APIManager.shared.passwordChange(params: params as [String : AnyObject]) { (response) in
                
                if case let msg as String = response?["message"], msg == "Unauthenticated." {
                    
                    APIManager.shared.refreshToken(params: params as [String : AnyObject]) { (response) in
                        
                        if case let access_token as String = response?["access_token"] {
                            
                            APPDELEGATE.bearerToken = access_token
                            
                            USERDEFAULTS.set(access_token, forKey: "access_token")
                            
                            self.okAct(self)
                            
                        }
                            
                        else {
                            
                            self.showAlertView(title: "TowRoute".localiz(), message: "Your session has expired. Please log in again".localiz(), callback: { (check) in
                                
                                APPDELEGATE.updateLoginView()
                                
                            })
                            
                        }
                        
                    }
                    
                }
                
                if case let msg as String = response?["message"], msg != "Unauthenticated."{
                    
                    self.showAlertView(message: "Password updated successfully.".localized)
                    
                    if msg == "Password updated successfully." {
                        
                        self.oldpwd.text = ""
                        self.newpwd.text = ""
                        self.renewpwd.text = ""
                        self.pwdview.isHidden = true
                        
                        self.editview.isHidden = true
                        self.editbtn.setTitle("   Edit Profile".localized, for: UIControlState.normal)
                        self.viewProfile()
                        
                    }
                    
                }
                
                if case let msg as String = response?["error"]{
                    
                    self.showAlertView(message: msg.localized)
                    
                }
                
            }
            
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
    
    
    @IBAction func cancelAct(_ sender: Any) {
        self.oldpwd.text = ""
        self.newpwd.text = ""
        self.renewpwd.text = ""
        
        pwdview.isHidden = true
        
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

extension MyprofileViewController: CountryPickerViewDelegate {
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        // Only countryPickerInternal has it's delegate set
        let title = "Selected Country"
        let message = "Name: \(country.name) \nCode: \(country.code) \nPhone: \(country.phoneCode)"
        print(message)
        
        countrycodetxt.text = country.phoneCode
        
    }
}

extension UIButton {
    func addLeftPadding(_ padding: CGFloat) {
        titleEdgeInsets = UIEdgeInsets(top: 0.0, left: padding, bottom: 0.0, right: -padding)
        contentEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: padding)
    }
}
