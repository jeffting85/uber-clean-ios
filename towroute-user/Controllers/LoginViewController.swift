//
//  LoginViewController.swift
//  TowRoute User
//
//  Created by Admin on 04/06/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import Material
import JVFloatLabeledTextField
import FBSDKLoginKit
import FBSDKCoreKit
//import GoogleSignIn


class LoginViewController: UIViewController,TextFieldDelegate {
    
    //, GIDSignInDelegate
    var fromRegister = false
    
    @IBOutlet weak var orimage: UIImageView!
    @IBOutlet weak var loginbtn: UIButton!
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
//            let params = ["oauth_provider": "google",
//                          "oauth_uid": user.userID,
//                          "first_name": user.profile.name,
//                          "last_name": "",
//                          "email": user.profile.email,
//                          "picture": user.profile.imageURL(withDimension: 120)
//                ] as [String : AnyObject]
//
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
//
//    }
    
//    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
//        self.showAlertView(message: "Google Signin Disconnect!".localized)
//    }
    func socialLogin(params: [String : AnyObject]) {
        
        print("params \(params)")
        
        APIManager.shared.registerUser(params: params, callback: { (response) in
            
            if case let msg as String = response?["message"] {
                
                if msg == "Login Successfully" {
                    
                    var myuserinfo = [String: String]()
                    
                    
                    if let email = response?["email"] {
                        
                        customer_email = "\(email!)"
                        
                        myuserinfo.updateValue(customer_email, forKey: "email")
                        
                        print("user email \(customer_email)")
                        
                    }
                    
                    if let first_name = response?["first_name"] {
                        
                        customer_name = "\(first_name!)"
                        
                        myuserinfo.updateValue(customer_name, forKey: "first_name")
                        
                        print("driver_vehicle_type \(customer_name)")
                        
                    }
                    
                    if let last_name = response?["last_name"] {
                        
                        customer_lname = "\(last_name!)"
                        
                        myuserinfo.updateValue(customer_lname, forKey: "last_name")
                        
                        print("driver_vehicle_type \(customer_lname)")
                        
                    }
                    
                    if let uid = response?["uid"] {
                        
                        customer_id = "\(uid!)"
                        
                        myuserinfo.updateValue(customer_id, forKey: "uid")
                        
                        print("driver_vehicle_type \(customer_id)")
                        
                    }
                    
                    print("userInfoRes \(myuserinfo)")
                    
                    USERDEFAULTS.saveLoginDetails(logininfo: myuserinfo as [String: String])
                    
                    USERDEFAULTS.set(true, forKey: "login already")
                    
                    self.APPDELEGATE.updateHomeView()
                    
                }
                    
                else {
                    
                    self.showAlertView(message: msg.localized)
                    
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
                    
                    let params = ["oauth_provider": "facebook",
                                  "oauth_uid": strID,
                                  "first_name": strName,
                                  "last_name": "",
                                  "email": strEmail,
                                  "picture": strPictureURL
                    ]
                    
                    print("fbresult params \(params)")
                    
                    //   self.socialLogin(params: params as [String : AnyObject])
                    
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
//        TWTRTwitter.sharedInstance().logIn { (session, error) in
//
//            if session != nil {
//
//                let client = TWTRAPIClient.withCurrentUser()
//
//                client.requestEmail(forCurrentUser: { (email, error) in
//
//                    if email != nil {
//
//                        let twitterClient = TWTRAPIClient(userID: session?.userID)
//                        twitterClient.loadUser(withID: (session?.userID)!, completion: { (user, error) in
//
//                            print(user!.profileImageURL)
//
//                            let params = ["oauth_provider": "twitter",
//                                          "oauth_uid": session?.userID,
//                                          "first_name": session?.userName,
//                                          "last_name": "",
//                                          "email": email,
//                                          "picture": user!.profileImageURL
//                            ]
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
//                        self.showAlertView(message: "Twitter Login Failed".localized)
//                    }
//
//                })
//
//            }
//
//            else {
//
//                self.showAlertView(message: "Twitter Login Failed".localized)
//
//            }
//
//        }
//    }
    
    @IBAction func google_act(_ sender: Any) {
        
//        GIDSignIn.sharedInstance().signOut()
//
//        GIDSignIn.sharedInstance().shouldFetchBasicProfile = true
//        GIDSignIn.sharedInstance().signIn()
        
    }
    
    
    let APPDELEGATE = UIApplication.shared.delegate as! AppDelegate
    
    let STORYBOARD = UIStoryboard(name: "Main", bundle: nil)
    @IBOutlet var email: JVFloatLabeledTextField!
    @IBOutlet var password: JVFloatLabeledTextField!
    
    @IBOutlet weak var back: UIButton!
    var backicon = "1"
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
       
        email.delegate = self
        password.delegate = self
        self.title = "LOG IN".localized
        
        email.placeholderText(textfield: email, name: "Email".localized)
        password.placeholderText(textfield: password, name: "Password".localized)
        
//        GIDSignIn.sharedInstance().delegate = self
       // GIDSignIn.sharedInstance().uiDelegate = self
        
        if USERDEFAULTS.value(forKey: "RememberMe") != nil {
            
            email.text = USERDEFAULTS.value(forKey: "RememberMe") as? String
         btn.setBackgroundImage(#imageLiteral(resourceName: "checked"), for: UIControlState.normal)
            btn.isSelected = true;
            
        }
        else
        {
            email.text = ""
            btn.setBackgroundImage(#imageLiteral(resourceName: "un_check"), for: UIControlState.normal)
            btn.isSelected = false;
        }
       
        
        self.navigationController?.navigationBar.topItem?.title = "LOG IN".localized
        TextFiledAlignment(textfield: email)
        TextFiledAlignment(textfield: password)
        
        if LanguageManager.shared.currentLanguage == .ar
        {
            orimage.image = #imageLiteral(resourceName: "OR1_update1")
        }
        else
        {
            orimage.image = #imageLiteral(resourceName: "OR1_updated")
        }
        // addMenu()
        
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
    
    @IBAction func backact(_ sender: Any) {
        //self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
        print("backkkkkk")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == self.email {
            self.password.becomeFirstResponder()
        }
            
        else if textField == self.password {
            self.password.resignFirstResponder()
        }
        
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        if backicon == ""
        {
            back.isHidden = true
        }
        else
        {
            back.isHidden = false
        }
        
    }
    
    @IBAction func login(_ sender: Any) {
        
        
        
        self.endEditing()
        
        let email = self.email.text!
        
        let pwd = password.text!
        
        
        let checkvaluearr: [String] = [email,email,pwd]
        
        let checkforarr: [validator] = [.empty,.email,.empty]
        
        let alertmsgarr: [String] = ["Please enter your Email!".localized,"Please enter valid Email ID!".localized,"Please enter your Password!".localized]
        
        let checker = model.validator(checkvalue: checkvaluearr, checkfor: checkforarr)
        
        if checker.error {
            
            let alert = UIAlertController(title: "TowRoute".localized, message: alertmsgarr[checker.errorId], preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok".localized, style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
            
        else if (pwd.characters.count < 8){
            
            self.showAlertView(message: "Password must contain atleast 8 characters!".localized)
            
        }
            
        else{
            
       //     loginbtn.isUserInteractionEnabled = false
            
            let params = ["email": email,
                          "password": pwd,
                          "device_token": APPDELEGATE.device_token]
            print("paramss\(params)")
            //  APIManager.shared.loginUser(params: params as [String : AnyObject]) { (response) in
            
            APIManager.shared.loginUser(params: params as [String : AnyObject], callback: { (response) in
             
                if case let details as NSDictionary = response?["customer"] {
                    
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
                    
                    if let invite_code = details["invite_code"] {
                        
                        invitecode = "\(invite_code)"
                        
                        myuserinfo.updateValue(invitecode!, forKey: "invite_code")
                        
                    }
                    
                    if let avatar = details["avatar"] {
                        
                        customer_image = "\(avatar)"
                        
                        myuserinfo.updateValue(customer_image, forKey: "avatar")
                        
                    }
                    
                    USERDEFAULTS.saveLoginDetails(logininfo: myuserinfo as [String: String])
                    
                    USERDEFAULTS.set(true, forKey: "login already")
                    
                    if case let access_token as String = response?["access_token"] {
                        
                        self.APPDELEGATE.bearerToken = access_token
                        
                        USERDEFAULTS.set(access_token, forKey: "access_token")
                        
                    }
                    
                    if self.btn.isSelected == true {
                        
                        USERDEFAULTS.set(email, forKey: "RememberMe")
                        
                    }
                //    self.loginbtn.isUserInteractionEnabled = true
                    self.APPDELEGATE.updateHomeView()
                    
                }
                    
                    
                    
                else if case let status as String = response?["error"], status == "Invalid credentials." {
                 //   self.loginbtn.isUserInteractionEnabled = true
                    self.showAlertView(message: "Invalid Credentials".localized)
                }
              
            })
            
        }
        
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
    
    @IBAction func reg(_ sender: Any) {
        
        if fromRegister == true {
            
            self.dismiss(animated: true, completion: nil)
            return
            
        }
        
        let registervc = STORYBOARD.instantiateViewController(withIdentifier: "registervc") as! UINavigationController
        
        let navview = registervc.viewControllers[0] as! RegisterViewController
        
        navview.fromLogin = true
        
        //self.navigationController?.pushViewController(registervc, animated: true)
        self.present(registervc, animated: true, completion: nil)
    }
    @IBAction func forgot(_ sender: Any) {
        
        let forgot = STORYBOARD.instantiateViewController(withIdentifier: "forgott")
        
        // self.navigationController?.pushViewController(forgot, animated: true)
        
        self.present(forgot, animated: true, completion: nil)
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

extension UIViewController{
    
    func addtapguesture(){
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(endEditing)))
    }
    
    @objc func endEditing(){
        self.view.endEditing(true)
    }
    
}
extension UITextField
{
    func placeholderText(textfield : UITextField, name: String)
    {
        textfield.attributedPlaceholder = NSAttributedString(string: name.localiz())
        
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
}
