//
//  MyprofileViewController.swift
//  TowRoute Provider
//
//  Created by Admin on 06/06/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import JVFloatLabeledTextField
import CountryPickerView
import Alamofire
import Firebase

struct language {
    var name = String()
    var id = String()
}

struct currencyval {
    var name = String()
    var id = String()
}

class MyprofileViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let cpvInternal = CountryPickerView()
    
    var langOption = ["English", "Swahili", "French", "Spanish"]
    
    var allLangOption = [language]()
    
    var allCurrencyVal = [currencyval]()
    
    var langpickerView = UIPickerView()
    
    var curOption = ["USD", "CHF", "EUR", "NGN"]
    
    var curWithCountry = ["Dollor (USD)","Swiss Franc (CHF)","France Euro (EUR)","Nigerian Currency (NGN)"]
    
    var curpickerView = UIPickerView()
    @IBOutlet weak var changepwdbtn: UIButton!
    @IBOutlet var editbtn: UIButton!
    @IBOutlet var editview: UIScrollView!
    @IBOutlet var moreview: UIView!
    @IBOutlet var pwdview: UIView!
    
    @IBOutlet var fnamelab: UILabel!
    @IBOutlet var lnamelab: UILabel!
    @IBOutlet var emaillab: UILabel!
    @IBOutlet var codelab: UILabel!
    @IBOutlet var mobilelab: UILabel!
    @IBOutlet var langlab: UILabel!
    @IBOutlet var curlab: UILabel!
    
    @IBOutlet var fnametxt: JVFloatLabeledTextField!
    @IBOutlet var lnametxt: JVFloatLabeledTextField!
    @IBOutlet var emailtxt: JVFloatLabeledTextField!
    @IBOutlet var codetxt: JVFloatLabeledTextField!
    @IBOutlet var phonetxt: JVFloatLabeledTextField!
    @IBOutlet var langtxt: JVFloatLabeledTextField!
    @IBOutlet var curtxt: JVFloatLabeledTextField!
    @IBOutlet var servicedesctxt: JVFloatLabeledTextField!
    
    @IBOutlet var oldpwd: JVFloatLabeledTextField!
    @IBOutlet var newpwd: JVFloatLabeledTextField!
    @IBOutlet var renewpwd: JVFloatLabeledTextField!

    @IBOutlet var proofimg: UIImageView!
    @IBOutlet var profimg: UIImageView!
    @IBOutlet var servicedesclab: UILabel!
    
    @IBOutlet weak var back_btn: UIButton!
    @IBOutlet weak var more_btn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fnametxt.placeholder = "First name".localized
        lnametxt.placeholder = "Last name".localized
        emailtxt.placeholder = "Email".localized
        codetxt.placeholder = "Country".localized
        phonetxt.placeholder = "Mobile".localized
        langtxt.placeholder = "Language".localized
        curtxt.placeholder = "Currency".localized
        servicedesctxt.placeholder = "Service Description".localized
        oldpwd.placeholder = "OLD PASSWORD".localized
        newpwd.placeholder = "NEW PASSWORD".localized
        renewpwd.placeholder = "RE ENTER PASSWORD".localized
        
        TextFiledAlignment(textfield: fnametxt)
        TextFiledAlignment(textfield: lnametxt)
        TextFiledAlignment(textfield: emailtxt)
        TextFiledAlignment(textfield: codetxt)
        TextFiledAlignment(textfield: langtxt)
        TextFiledAlignment(textfield: curtxt)
        TextFiledAlignment(textfield: servicedesctxt)
        TextFiledAlignment(textfield: oldpwd)
        TextFiledAlignment(textfield: renewpwd)
        TextFiledAlignment(textfield: newpwd)
        
        
        cpvInternal.delegate = self
        
        langpickerView.delegate = self
        
        langtxt.inputView = langpickerView
        
        curpickerView.delegate = self
        
        curtxt.inputView = curpickerView
        
        viewProfile()
        
        self.title = "My Profile".localized
        
        if LanguageManager.shared.currentLanguage == .ar
        {
            self.langlab.text = "Arabic"
            self.langtxt.text = "Arabic"
        }
        else
        {
            self.langlab.text = "English"
            self.langtxt.text = "English"
        }
        // Do any additional setup after loading the view.
        
        
        self.back_btn.clipsToBounds = true
        self.more_btn.clipsToBounds = true
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
    
    var checktime = 1
    
    func viewProfile() {
        
        // profileViewDriver
        
        let userdict = USERDEFAULTS.getLoggedUserDetails()
        
        let userid = userdict["id"] as! String
        
        let params = ["id":userid]
        
        print("params \(params)")
        
        APIManager.shared.profileViewDriver(params: params as [String : AnyObject]) { (response) in
            
            if case let msg as String = response?["message"], msg == "Unauthenticated." {
                
                APIManager.shared.refreshToken(params: params as [String : AnyObject]) { (response) in
                    
                    if case let access_token as String = response?["access_token"] {
                        
                        APPDELEGATE.bearerToken = access_token
                        
                        USERDEFAULTS.set(access_token, forKey: "access_token")
                        
                        self.viewProfile()
                        
                    }
                    
                    else {
                        
                        self.showAlertView(title: "TOWROUTE PROVIDER".localized, message: "Your session has expired. Please log in again", callback: { (check) in
                            
                            APPDELEGATE.updateLoginView()
                            
                        })
                        
                    }
                    
                }
                
            }
            
            else if case let details as NSDictionary = response?["data"] {
                
                if case let first_name as String = details["first_name"] {
                    
                    self.fnamelab.text = first_name
                    self.fnametxt.text = first_name
                    
                }
                
                if case let last_name as String = details["last_name"] {
                    
                    self.lnamelab.text = last_name
                    self.lnametxt.text = last_name
                    
                }
                
                if case let email as String = details["email"] {
                    
                    self.emaillab.text = email
                    self.emailtxt.text = email
                    
                }
                
                if case let country_code as String = details["country_code"] {
                    
                    self.codelab.text = country_code
                    self.codetxt.text = country_code
                    
                }
                
                if case let phone_number as String = details["phone_number"] {
                    
                    self.mobilelab.text = phone_number
                    self.phonetxt.text = phone_number
                    
                }
                
                if case let language as String = details["language"], language != "" {
                    
                    self.langlab.text = language
                    self.langtxt.text = language
                    
                }
                
                if case let currency as String = details["currency"], currency != "" {
                    
                    self.curlab.text = currency
                    self.curtxt.text = currency
                    
                }
                
                if case let profile_des as String = details["service_description"], profile_des != "" {
                    
                    self.servicedesctxt.text = profile_des
                    self.servicedesclab.text = profile_des
                    
                }
                
                if case let avatar as String = details["avatar"] {
                    
                    if(!(avatar.isEmpty)){
                        
                        let newavatar = BASEAPI.IMGURL + avatar
                        
                        Alamofire.request(newavatar, method: .get).responseImage { response in
                            guard let image = response.result.value else {
                                // Handle error
                                return
                            }
                            
                            self.profimg.image = image
                            self.proofimg.image = image
                            
                            // Do stuff with your image
                        }
                        
                    }
                    
                }
                
            }
            
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
            langtxt.text = langOption[row]
            
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
    
    override func viewWillDisappear(_ animated: Bool) {
        self.slideMenuController()?.addLeftGestures()
        self.slideMenuController()?.addRightGestures()
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
    
    @IBAction func moreAct(_ sender: Any) {
    
        if moreview.isHidden == false {
           
            moreview.isHidden = true
            
        }
        
        else {
            
            moreview.isHidden = false
            
        }
        
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
    
    @IBAction func updateAct(_ sender: Any) {
        
        // profileViewDriver
        
        let userdict = USERDEFAULTS.getLoggedUserDetails()
        
        let userid = userdict["id"] as! String
        
        let fname = fnametxt.text!
        
        if fname == "" {
            
            self.showAlertView(message: "Please enter your first name!".localized)
            
            return
            
        }
        
        let lname = lnametxt.text!
        
        if lname == "" {
            
            self.showAlertView(message: "Please enter your last name!".localized)
            
            return
            
        }
        
        let email = emailtxt.text!
        
        if email == "" {
            
            self.showAlertView(message: "Please enter your email address!".localized)
            
            return
            
        }
        
        let code = codetxt.text!
        
        if code == "" {
            
            self.showAlertView(message: "Please enter select your country code!".localized)
            
            return
            
        }
        
        let mobile = phonetxt.text!
        
        if mobile == "" {
            
            self.showAlertView(message: "Please enter your mobile no!".localized)
            
            return
            
        }
        
        var servicedesc = servicedesctxt.text!
        if servicedesc == ""
        {
            servicedesc = ""
        }
        
        let selindex = langOption.index(of: langtxt.text!)!
        
        let selLangIndex = self.allLangOption[selindex].id
        
        let selcurindex = curOption.index(of: curtxt.text!)!
        
        let selCurIndex = self.allCurrencyVal[selcurindex].id
        
        let params = ["id":userid,
                      "first_name":fname,
                      "last_name":lname,
                      "email":email,
                      "country_code":code,
                      "phone_number":mobile,
                      "service_description": servicedesc]
        print("params \(params)")
        
        APIManager.shared.updateProfileDriver(params: params as [String : AnyObject]) { (response) in
            
            if case let msg as String = response?["message"], msg == "Unauthenticated." {
                
                APIManager.shared.refreshToken(params: params as [String : AnyObject]) { (response) in
                    
                    if case let access_token as String = response?["access_token"] {
                        
                        APPDELEGATE.bearerToken = access_token
                        
                        USERDEFAULTS.set(access_token, forKey: "access_token")
                        
                        self.updateAct(self)
                        
                    }
                    
                    else {
                        
                        self.showAlertView(title: "TOWROUTE PROVIDER".localized, message: "Your session has expired. Please log in again", callback: { (check) in
                            
                            NotificationCenter.default.removeObserver(self)
                            
                            APPDELEGATE.updateLoginView()
                            
                        })
                        
                    }
                    
                }
                
            }
                
            else if case let details as NSDictionary = response?["data"] {
                
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
                
                if let cur = details["currency"] {
                    
                    currenc = "\(cur)"
                    
                    myuserinfo.updateValue(currenc!, forKey: "currency")
                    
                }
                
                if let currency_syml = details["currency_symbol"] {
                    
                    currency_symbol = "\(currency_syml)"
                    
                    myuserinfo.updateValue(currency_symbol!, forKey: "currency_symbol")
                    
                }
                
                if let avatar = details["avatar"] {
                    
                    driver_image = "\(avatar)"
                    
                    myuserinfo.updateValue(driver_image, forKey: "avatar")
                    
                }
                
                USERDEFAULTS.saveLoginDetails(logininfo: myuserinfo as [String: String])
                
                let firedata = Database.database().reference().child("providers").child(userid)
                
                firedata.child("currency").setValue(currenc! + ":" + currency_symbol!)
                
                firedata.child("service_desc").setValue(servicedesc)
                
                
            }
            
            if case let msg as String = response?["message"], msg != "Unauthenticated."{
                
                NotificationCenter.default.post(name: Notification.Name("ProfileUpdate"), object: nil)
                
                self.showAlertView(title: "TOWROUTE PROVIDER".localized, message: "Updated Successfully".localized, callback: { (check) in
                    
                    let selindex = self.langOption.index(of: self.langtxt.text!)!
                    
//                    if (LanguageManager.shared.currentLanguage == .en && selindex == 1) {
//
//                        LanguageManager.shared.setLanguage(language: Languages.es)
//                        APPDELEGATE.updateHomeView()
//                        APPDELEGATE.updateHomeView()
//
//                    }else if (LanguageManager.shared.currentLanguage == .es && selindex == 0) {
//
//                        LanguageManager.shared.setLanguage(language: Languages.en)
//                        APPDELEGATE.updateHomeView()
//                        APPDELEGATE.updateHomeView()
//
//                    }
                    
                    
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
        let params = ["":""] as [String : AnyObject]
        self.appSetting(params: params)
        
    }
    
    func appSetting(params: [String : AnyObject]) {
        
        print("params \(params)")
        
        APIManager.shared.appSetting(params: params, callback: { (response) in
            
            if case let currency as NSArray = response?["currency"] {
                
                self.curOption.removeAll()
                
                self.curWithCountry.removeAll()
                
                self.allCurrencyVal.removeAll()
                
                for cur in currency {
                    
                    let dict = cur as! NSDictionary
                    
                    let curstr = dict.object(forKey: "short_name") as! String
                    
                    self.curOption.append(curstr)
                    
                    let currency = dict.object(forKey: "currency") as! String
                    
                    let curname = currency + " (" + curstr + ")"
                    
                    self.curWithCountry.append(curname)
                    
                    let langid = "\(dict["id"]!)"
                    
                    self.allCurrencyVal.append(currencyval(name: curstr, id: langid))
                    
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
        
        let imageData = proofimg.image?.jpeg(.low)
        
        let imageStr = imageData?.base64EncodedString()
        
        let userdict = USERDEFAULTS.getLoggedUserDetails()
        
        let userid = userdict["id"] as! String
        
        let currentTimeStamp = NSDate().timeIntervalSince1970.toString()
        let filename = "\(currentTimeStamp)_img.jpg"
        
        let params = ["id": userid,
                      "avatar": filename,
                      "file_binary_data": imageStr!] as [String : Any]
        
        APIManager.shared.imageUploadDriver(params: params as [String : AnyObject], callback: { (response) in
            
            if case let msg as String = response?["message"], msg == "Unauthenticated." {
                
                APIManager.shared.refreshToken(params: params as [String : AnyObject]) { (response) in
                    
                    if case let access_token as String = response?["access_token"] {
                        
                        APPDELEGATE.bearerToken = access_token
                        
                        USERDEFAULTS.set(access_token, forKey: "access_token")
                        
                        self.editAct()
                        
                    }
                    
                    else {
                        
                        self.showAlertView(title: "TOWROUTE PROVIDER".localized, message: "Your session has expired. Please log in again", callback: { (check) in
                            
                            NotificationCenter.default.removeObserver(self)
                            
                            APPDELEGATE.updateLoginView()
                            
                        })
                        
                    }
                    
                }
                
            }
                
            else if case let details as NSDictionary = response?["data"] {
                
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
                
                let firedata = Database.database().reference().child("providers").child(userid)
                firedata.child("pro_pic").setValue(driver_image)
                
                USERDEFAULTS.saveLoginDetails(logininfo: myuserinfo as [String: String])
                
            }
            
            if case let msg as String = response?["message"], msg != "Unauthenticated."{
                
                NotificationCenter.default.post(name: Notification.Name("ProfileUpdate"), object: nil)
                
                self.showAlertView(message: "Image Updated Successfully".localized)
                
                self.editview.isHidden = true
                self.editbtn.setTitle("   Edit Profile".localized, for: UIControlState.normal)
                self.viewProfile()
                
            }
            
            
        })
        
    }
    
    @IBAction func profilePicAct(_ sender: Any) {
    
//        if APPDELEGATE.driverapproved == true {
//
//            self.showAlertView(message: "Oops!! You cannot change your profile picture currently, Kindly contact your admin for further details.".localized)
//            return
//
//        }
        
        MediaPicker.shared.showMediaPicker(imageView: proofimg, placeHolder: nil) { (img, check) in
            
            if check == true {
                
                self.image_pic = true
                
                self.profimg.image = img
                
            }
            
        }
        
    }
    
    @IBAction func changePwdAct(_ sender: Any) {
    
        moreview.isHidden = true
        
        pwdview.isHidden = false
        
    }
    
    @IBAction func okAct(_ sender: Any) {
    
        let oldpwdtxt = self.oldpwd.text!
        let newpwdtxt = self.newpwd.text!
        let renewpwdtxt = self.renewpwd.text!
        
        let checkvaluearr: [String] = [oldpwdtxt,newpwdtxt,renewpwdtxt]
        
        let checkforarr: [validator] = [.empty,.empty,.empty]
        
        let alertmsgarr: [String] = ["Please enter your Old Password!".localized,"Please enter your New Password!".localized,"Please Re enter your New Password!".localized]
        
        let checker = model.validator(checkvalue: checkvaluearr, checkfor: checkforarr)
        
        if checker.error {
            
            let alert = UIAlertController(title: "TOWROUTE PROVIDER".localized, message: alertmsgarr[checker.errorId], preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok".localized, style: UIAlertActionStyle.default, handler: nil))
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
                            
                            self.showAlertView(title: "TOWROUTE PROVIDER".localized, message: "Your session has expired. Please log in again", callback: { (check) in
                                
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
        codetxt.text = country.phoneCode
    }
}

extension UIButton {
    func addLeftPadding(_ padding: CGFloat) {
        titleEdgeInsets = UIEdgeInsets(top: 0.0, left: padding, bottom: 0.0, right: -padding)
        contentEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: padding)
    }
}
