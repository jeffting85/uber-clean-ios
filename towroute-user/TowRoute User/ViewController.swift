//
//  ViewController.swift
//  TowRoute User
//
//  Created by Admin on 04/06/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import DropDown
import FBSDKLoginKit
import FBSDKCoreKit
//import GoogleSignIn

import Firebase
import SVProgressHUD
import Stripe
class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
 
    //, GIDSignInDelegate
    
    
    var langOption = ["English","Arabic"]
    var curOption = ["BD"]
    var curWithCountry = ["Bahraini Dinar (BHD)"]
    
   
    var curpickerView = UIPickerView()
    
    
     let dropDown = DropDown()
    
    
    var langpickerView = UIPickerView()
    
    
    @IBOutlet weak var navbackimg: UIImageView!
    
    override func viewDidLoad() {
        
        
        
        super.viewDidLoad()
        
        
        
        
        let gradient = CAGradientLayer()
        let sizeLength = UIScreen.main.bounds.size.height * 2
        let defaultNavigationBarFrame = CGRect(x: 0, y: 0, width: sizeLength, height: 90)
        
        gradient.frame = defaultNavigationBarFrame
         let color1 = UIColor.init(hexString: "#00d5ff")
         let color2 = UIColor.init(hexString: "#00d5ff")
        
        gradient.colors = [color1!.cgColor,color2!.cgColor]//,color3!.cgColor
        
        navbackimg.image = self.image(fromLayer: gradient)
        
        
        
        let gradient1 = CAGradientLayer()
        //let sizeLength1 = UIScreen.main.bounds.size.height * 2
        let defaultNavigationBarFrame1 = CGRect(x: 0, y: 0, width: bg_img.size.width, height: bg_img.size.height)
        
        gradient1.frame = defaultNavigationBarFrame1
         let color3 = UIColor.init(hexString: "#00d5ff")
         let color4 = UIColor.init(hexString: "#00d5ff")
         let color5 = UIColor.init(hexString: "#FFFFFF")
        
        gradient1.colors = [color3!.cgColor,color4!.cgColor,color5!.cgColor]//,color3!.cgColor
        
        bg_img.image = self.image(fromLayer: gradient1)
        
        let gradient2 = CAGradientLayer()
        //let sizeLength1 = UIScreen.main.bounds.size.height * 2
        let defaultNavigationBarFrame2 = CGRect(x: 0, y: 0, width: loginbtn.size.width, height: loginbtn.size.height)
        
        gradient2.frame = defaultNavigationBarFrame2
         let color6 = UIColor.init(hexString: "#00d5ff")
         let color7 = UIColor.init(hexString: "#FFFFFF")
        
        gradient2.colors = [color6!.cgColor,color7!.cgColor]//,color3!.cgColor
        
        loginbg.image = self.image(fromLayer: gradient2)
        
        let gradient3 = CAGradientLayer()
               //let sizeLength1 = UIScreen.main.bounds.size.height * 2
               let defaultNavigationBarFrame3 = CGRect(x: 0, y: 0, width: registerbg.size.width, height: registerbg.size.height)
               
               gradient3.frame = defaultNavigationBarFrame3
                let color8 = UIColor.init(hexString: "#00d5ff")
                let color9 = UIColor.init(hexString: "#FFFFFF")
               
               gradient3.colors = [color8!.cgColor,color9!.cgColor]//,color3!.cgColor
               
               registerbg.image = self.image(fromLayer: gradient3)
        
        
        //UINavigationBar.appearance().setBackgroundImage(self.image(fromLayer: gradient), for: .default)
        
        ////////////////////////////////////
        self.curpickerView.delegate = self
        self.langpickerView.delegate = self
      //  GIDSignIn.sharedInstance().delegate = self
      //  GIDSignIn.sharedInstance().uiDelegate = self

        if LanguageManager.shared.currentLanguage == .ar{
            self.lang.setTitle("Arabic", for: UIControlState.normal)
        }
        
        /////////////////////////////////////

        // pickerData = ["English", "USD", "Item 3", "Item 4", "Item 5", "Item 6"]
        // Do any additional setup after loading the view, typically from a nib.
        }
    
    @IBAction func mony(_ sender: Any) {
        
        
        
        dropDown.dataSource = curWithCountry as! [String]
        
        // Action triggered on selection
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            
            print("Selected item: \(item) at index: \(index)")
            
            let itemval = self.curOption[index]
            
            self.money.setTitle(itemval, for: UIControlState.normal)
            
            self.dropDown.hide()
            
        }
        
        dropDown.anchorView = sender as? AnchorView
        
        dropDown.show()
    }
    @IBOutlet var money: UIButton!
    @IBOutlet var lang: UIButton!
    @IBOutlet weak var bg_img: UIImageView!
    @IBOutlet weak var loginbg: UIImageView!
    @IBOutlet weak var registerbg: UIImageView!
    
    @IBOutlet var welcomelabtxt: UILabel!
    
    @IBAction func language(_ sender: Any) {
        dropDown.dataSource = lang_name as! [String]
        
        // Action triggered on selection
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            
            print("Selected item: \(item) at index: \(index)")
            
            self.lang.setTitle(item, for: .normal)
            
            self.dropDown.hide()
            
            USERDEFAULTS.set(item, forKey: "Language")
            
            userlang = item
            
           
            
            if userlang == "Arabic"
            {
                let selectedLanguage:Languages = .ar
                print("userlang \(userlang) \(selectedLanguage)")
                
                // change the language
              
                LanguageManager.shared.setLanguage(language: selectedLanguage)
               APPDELEGATE.updateLoginView()
                
            }
          
            else if userlang == "English"
            {
                let selectedLanguage:Languages = .en
                print("userlang \(userlang) \(selectedLanguage)")
                
                // change the language
               LanguageManager.shared.setLanguage(language: selectedLanguage)
                
               APPDELEGATE.updateLoginView()
            }
            
           
            
            // DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                
            /* let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyBoard.instantiateViewController(withIdentifier: "view")
            UIApplication.shared.keyWindow?.rootViewController = viewController
            UIApplication.shared.keyWindow?.makeKeyAndVisible()
            
            UIApplication.shared.keyWindow?.rootViewController = viewController
            UIApplication.shared.keyWindow?.makeKeyAndVisible() */
            
            SVProgressHUD.dismiss()
            
            // }
            
            // APPDELEGATE.updateLoginView()
            
        }
        
        dropDown.anchorView = sender as? AnchorView
        
        dropDown.show()
        
    }
    
   


func image(fromLayer layer: CALayer) -> UIImage {
    UIGraphicsBeginImageContext(layer.frame.size)
    
    layer.render(in: UIGraphicsGetCurrentContext()!)
    
    let outputImage = UIGraphicsGetImageFromCurrentImageContext()
    
    UIGraphicsEndImageContext()
    
    return outputImage!
}
    
    @IBOutlet var loginbtn: UIButton!
    @IBOutlet var registerbtn: UIButton!
    
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
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == langpickerView {
            //self.lang = langOption[row]
            lang.setTitle(langOption[row], for: UIControlState.normal)
        }
        else {
           money.setTitle(langOption[row], for: UIControlState.normal)
        }
        
    }
   
    //////////////////////////////////////////////////////

    
    /////////////////////////////////////////////
    @IBAction func login(_ sender: Any) {
        let loginvc = STORYBOARD.instantiateViewController(withIdentifier: "loginvcc")
        
       // self.navigationController?.pushViewController(loginvc, animated: true)
         self.present(loginvc, animated: true, completion: nil)
    }
    @IBAction func reg(_ sender: Any) {
        
        let registervc = STORYBOARD.instantiateViewController(withIdentifier: "registervc")
        
       //self.navigationController?.pushViewController(registervc, animated: true)
          self.present(registervc, animated: true, completion: nil)
    }
    
    @IBAction func fb_act(_ sender: Any) {
        let fbLoginManager = LoginManager()
        
        fbLoginManager.logOut()
        
//        fbLoginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
//            
//            if(result?.grantedPermissions != nil) {
//                self.getFBUserData()
//            }
//                
//            else if((result?.declinedPermissions) != nil) {
//                self.showAlertView(message: "Facebook permission declined".localized)
//            }
//                
//            else if((result?.isCancelled) != nil) {
//                self.showAlertView(message: "Facebook session cancelled".localized)
//            }
//            
//        }
    }
    
    
    
//    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
//        self.present(viewController, animated: true, completion: nil)
//    }
//
//    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
//        self.dismiss(animated: true, completion: nil)
//    }
//
//    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
//
//        print("error \(error)")
//
//        if error == nil {
//
//            print("user profile",user.profile.email, user.profile.givenName)
//
//
//
//            let params = ["first_name":user.profile.name,
//                          "last_name":user.profile.familyName,
//                          "email": user.profile.email,
//                          "device_token":APPDELEGATE.device_token,
//                          "social_id":user.userID,
//                          "social_type":"google"] as [String : AnyObject]
//            self.socialLogin(params: params)
//
//            /* UserDefaults.standard.set(true, forKey: "login already")
//
//             (UIApplication.shared.delegate as! AppDelegate).isLoggedIn(status: true) */
//
//        }
//
//        else {
//            self.showAlertView(message: "Failed to Google signin".localized)
//        }
//    }
    
    
    
    
//    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
//        self.showAlertView(message: "Google Signin Disconnect!".localized)
//    }
    
    
    
    func socialLogin(params: [String : AnyObject]) {
        
        print("params \(params)")
        
        APIManager.shared.sociallog(params: params, callback: { (response) in
            print("fbgmailrs\(response)")
            
            if case let msg as String = response?["message"], msg == "Unauthenticated." {
                
                
                APIManager.shared.refreshToken(params: params as [String : AnyObject]) { (response) in
                    
                    if case let access_token as String = response?["access_token"] {
                        
                        APPDELEGATE.bearerToken = access_token
                        
                        USERDEFAULTS.set(access_token, forKey: "access_token")
                        
                        
                        
                    }
                    else {
                        
                        self.showAlertView(title: "TowRoute".localized, message: "Your session has expired. Please log in again", callback: { (check) in
                            
                            APPDELEGATE.updateLoginView()
                            
                        })
                        
                    }
                }
                
                
            }
            else if case let msgs as NSDictionary = response?["customer"] {
                print("googyyy\(msgs)")
                
                
                var myuserinfo = [String: String]()
                
                if let email = msgs["email"] {
                    
                    customer_email = "\(email)"
                    
                    myuserinfo.updateValue(customer_email, forKey: "email")
                    
                    print("user email \(customer_email)")
                    
                }
                if let first_name = msgs["first_name"] {
                    
                    customer_name = "\(first_name)"
                    
                    myuserinfo.updateValue(customer_name, forKey: "first_name")
                    
                    print("driver_vehicle_type \(customer_name)")
                    
                }
                
                if let last_name = msgs["last_name"] {
                    
                    customer_lname = "\(last_name)"
                    
                    myuserinfo.updateValue(customer_lname, forKey: "last_name")
                    
                    print("driver_vehicle_type \(customer_lname)")
                    
                }
                
                if let uid = msgs["id"] {
                    
                    customer_id = "\(uid)"
                    
                    myuserinfo.updateValue(customer_id, forKey: "id")
                    
                    print("driver_vehicle_type \(customer_id)")
                    
                }
                
                if let cur = msgs["currency"] {
                    
                    currenc = "\(cur)"
                    
                    if currenc == "" {
                        
                        currenc = "GBP"
                        
                    }
                    
                    myuserinfo.updateValue(currenc!, forKey: "currency")
                    
                }
                
                if let currency_syml = msgs["currency_symbol"] {
                    
                    currency_symbol = "\(currency_syml)"
                    
                    if currency_symbol == "" {
                        
                        currency_symbol = "£"
                        
                    }
                    
                    myuserinfo.updateValue(currency_symbol!, forKey: "currency_symbol")
                    
                }
                
                if case let access_token as String = response?["access_token"] {
                    
                    APPDELEGATE.bearerToken = access_token
                    
                    USERDEFAULTS.set(access_token, forKey: "access_token")
                    
                }
                
                if let invite_code = msgs["invite_code"] {
                    
                    invitecode = "\(invite_code)"
                    
                    myuserinfo.updateValue(invitecode!, forKey: "invite_code")
                    
                }
                
                print("userInfoRes \(myuserinfo)")
                
                USERDEFAULTS.saveLoginDetails(logininfo: myuserinfo as [String: String])
                
                USERDEFAULTS.set(true, forKey: "login already")
                
                
                let firedata = Database.database().reference().child("users").child(customer_id)
                
                firedata.child("fname").setValue(customer_name)
                firedata.child("lname").setValue(customer_lname)
                firedata.child("email").setValue(customer_email)
                
                if let country_code = response?["country_code"] {
                    
                    let cc = "\(country_code)"
                    
                    firedata.child("cc").setValue(cc)
                    
                }
                
                if let phone_number = response?["phone_number"] {
                    
                    let cc = "\(phone_number)"
                    
                    firedata.child("mobile").setValue(cc)
                    
                }
                
                if let avatar = response?["avatar"] {
                    
                    let cc = "\(avatar)"
                    
                    firedata.child("pro_pic").setValue(cc)
                    
                }
                
                if let wallet_balance = response?["wallet_balance"] {
                    
                    let cc = "\(wallet_balance)"
                    
                    firedata.child("wallet").setValue(cc)
                    
                }
                
                firedata.child("currency").setValue(currenc! + ":" + currency_symbol!)
                
                if case let log as NSString = response?["message"] as! String {
                    print("logy\(log)")
                    // self.showAlertView(message: log as String)
                    APPDELEGATE.updateHomeView()
                }
                
            }
            
            else if case let msg as String = response?["message"] {
                
                self.showAlertView(message: msg.localized)
                
            }
                
            else if case let msg as String = response?["app_setting"] {
                
                self.showAlertView(message: msg.localized)
                
            }
            
        })
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let params = ["":""] as [String : AnyObject]
      //  self.appSetting(params: params)
     
     
            if LanguageManager.shared.currentLanguage == .ar
            {
                  UIView.appearance().semanticContentAttribute = .forceLeftToRight
                   UITextField.appearance().semanticContentAttribute = .forceLeftToRight
            }
            else
            {
                UIView.appearance().semanticContentAttribute = .forceLeftToRight
                UITextField.appearance().semanticContentAttribute = .forceLeftToRight
            }
       
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if APPDELEGATE.isShowLogin == true {
            
            APPDELEGATE.isShowLogin = false
            
            let loginvc = STORYBOARD.instantiateViewController(withIdentifier: "loginvcc")
            self.present(loginvc, animated: false, completion: nil)
            
        }
        
    }
    
    func appSetting(params: [String : AnyObject]) {
        
        print("params \(params)")
        
        APIManager.shared.appSetting(params: params, callback: { (response) in
            
            print(response)
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
                
                for cur in currency {
                    
                    let dict = cur as! NSDictionary
                    
                    let curstr = dict.object(forKey: "language_name") as! String
                    
                    self.langOption.append(curstr)
                    
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
    
    func getFBUserData() {
        
        if ((AccessToken.current) != nil) {
            
            GraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email, gender"]).start(completionHandler: { (connection, result, error) in
                
                if error == nil {
                    
                    print("fbresult \(result)")
                    
                    let fbResult = result as! NSDictionary
                    let strEmail: String = (fbResult.object(forKey:"email") as? String)!
                    let strID: String = (fbResult.object(forKey:"id") as? String)!
                    let strName: String = (fbResult.object(forKey:"name") as? String)!
                    let strFirstName: String = (fbResult.object(forKey:"first_name") as? String)!
                    let strLastName: String = (fbResult.object(forKey:"last_name") as? String)!
                    let strPictureURL: String = (((fbResult.object(forKey:"picture") as AnyObject).object(forKey:"data") as AnyObject).object(forKey:"url") as? String)!
                    
                    //                    let params = ["oauth_provider": "facebook",
                    //                                  "oauth_uid": strID,
                    //                                  "first_name": strName,
                    //                                  "last_name": "",
                    //                                  "email": strEmail,
                    //                                  "picture": strPictureURL
                    //                    ]
                    
                    
                    let params = ["first_name":strFirstName,
                                  "last_name":strLastName,
                                  "email": strEmail,
                                  "device_token":APPDELEGATE.device_token,
                                  "social_id":strID,
                                  "social_type":"facebook"]
                    
                    print("fbresult params \(params)")
                    
                    self.socialLogin(params: params as [String : AnyObject])
                    
                    /* UserDefaults.standard.set(true, forKey: "login already")
                     
                     (UIApplication.shared.delegate as! AppDelegate).isLoggedIn(status: true) */
                    
                }
                else {
                    // self.showAlert(alertMsg: "Failed to get facebook info")
                }
                
            })
            
        }
        
    }
//    @IBAction func twitter_act(_ sender: Any) {
//        print("twitttrtrt")
//
//        TWTRTwitter.sharedInstance().logIn { (session, error) in
//
//            if (session != nil) {
//
//
//                let client = TWTRAPIClient.withCurrentUser()
//
//                client.requestEmail(forCurrentUser: { (email, error) in
//
//                    if email != nil {
//
//                        print("signed in as \(session?.userName)")
//
//                        let twitterClient = TWTRAPIClient(userID: session?.userID)
//                        twitterClient.loadUser(withID: (session?.userID)!, completion: { (user, error) in
//
//                            print(user!.profileImageURL)
//
//                            let params = ["first_name":(user?.name)!,
//                                          "last_name":(user?.name)!,
//                                          "email": email,
//                                          "device_token":APPDELEGATE.device_token,
//                                          "social_id":user?.userID,
//                                          "social_type":"twitter"]
//
//                            self.socialLogin(params: params as [String : AnyObject])
//                        })
//
//                        /* UserDefaults.standard.set(true, forKey: "login already")
//
//                         (UIApplication.shared.delegate as! AppDelegate).isLoggedIn(status: true) */
//
//                    }
//                    else {
//
//                        self.showAlertView(message: "Twitter Login Failed".localized)
//
//                    }
//
//                })
//
//            }
//
//        }
//
//    }
    
    @IBAction func google_act(_ sender: Any) {
//        GIDSignIn.sharedInstance().signOut()
//
//        GIDSignIn.sharedInstance().shouldFetchBasicProfile = true
//        GIDSignIn.sharedInstance().signIn()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

