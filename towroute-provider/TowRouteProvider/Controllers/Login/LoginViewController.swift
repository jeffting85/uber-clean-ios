//
//  LoginViewController.swift
//  TowRoute Provider
//
//  Created by Admin on 04/06/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import Material
import JVFloatLabeledTextField

class LoginViewController: UIViewController,TextFieldDelegate {

    let STORYBOARD = UIStoryboard(name: "Main", bundle: nil)
    
    @IBOutlet var email: JVFloatLabeledTextField!
    @IBOutlet var password: JVFloatLabeledTextField!
    @IBOutlet weak var loginBtn: UIButton!
    
    @IBOutlet weak var orimage: UIImageView!
    var fromRegister = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        email.delegate = self
        password.delegate = self
        
        email.placeholderText(textfield: email, name: "Email".localized)
        password.placeholderText(textfield: password, name: "Password".localized)
        
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
    
    @IBAction func backact(_ sender: Any) {
        //self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
        print("backkkkkk")
    }
    
    @IBAction func login(_ sender: Any) {
        
        self.endEditing()
        
        var emailtxt = email.text!
        
        let pwd = password.text!
        
        emailtxt = String(emailtxt.characters.filter { !" \n\t\r".characters.contains($0) })
        
        let emailvalid = model.isValidEmail(testStr: emailtxt)
        
        if emailtxt == "" || pwd == "" {
            
            if emailtxt == "" {
                
                self.showAlertView(message: "Please enter your Email!".localized)
                
            }
            
            else if pwd == "" {
                
                self.showAlertView(message: "Please enter your Password!".localized)
                
            }
            
        }
            
        else if (!emailvalid) {
            
            self.showAlertView(message: "Please Enter Valid Email ID!".localized)
            
        }
            
        else if (pwd.characters.count < 8){
            
            self.showAlertView(message: "Password must contain atleast 8 characters!".localized)
            
        }
            
        else {
            
          //  loginBtn.isUserInteractionEnabled = false
            
            let params = ["password": pwd,
                          "email":emailtxt,
                          "device_token": APPDELEGATE.device_token]
            
            print("params \(params)")
            
            APIManager.shared.driverlogin(params: params as [String : AnyObject], callback: { (response) in
                
               print(response)
                if case let details as NSDictionary = response?["driver"] {
                    
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
                    
                    if case let access_token as String = response?["access_token"] {
                        
                        APPDELEGATE.bearerToken = access_token
                        
                        USERDEFAULTS.set(access_token, forKey: "access_token")
                        
                    }
                    
                    if self.btn.isSelected == true {
                        
                        USERDEFAULTS.set(emailtxt, forKey: "RememberMe")
                        
                    }
                    
                    if let invite_code = details["invite_code"] {
                        
                        invitecode = "\(invite_code)"
                        
                        myuserinfo.updateValue(invitecode!, forKey: "invite_code")
                        
                    }
                    
                  //  self.loginBtn.isUserInteractionEnabled = true
                    USERDEFAULTS.saveLoginDetails(logininfo: myuserinfo as [String: String])
                    
                    USERDEFAULTS.set(true, forKey: "login already")
                    
                    APPDELEGATE.updateHomeView()
                    
                }
                
                else if case let status as String = response?["error"], status == "Invalid credentials." {
                    // self.loginBtn.isUserInteractionEnabled = true
                    self.showAlertView(message: "Invalid credentials".localized)
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
        
        let registervc = STORYBOARD.instantiateViewController(withIdentifier: "registervcc") as! UINavigationController
        
        let navview = registervc.viewControllers[0] as! RegisterViewController
        
        navview.fromLogin = true
        
        //self.navigationController?.pushViewController(registervc, animated: true)
        self.present(registervc, animated: true, completion: nil)
    }
    
    
    @IBAction func forgot(_ sender: Any) {
        
        let forgot = STORYBOARD.instantiateViewController(withIdentifier: "forgott")
        
        //self.navigationController?.pushViewController(forgot, animated: true)
        
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
