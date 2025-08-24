//
//  ChangePasswordViewController.swift
//  TowRoute User
//
//  Created by Uplogic Technologies on 19/07/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import JVFloatLabeledTextField

class ChangePasswordViewController: UIViewController {
    
    @IBOutlet var pwd: JVFloatLabeledTextField!
    @IBOutlet var conpwd: JVFloatLabeledTextField!
    @IBOutlet weak var submitBtn: UIButton!
    
    var userid = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "CHANGE PASSWORD".localized
       
        TextFiledAlignment(textfield: pwd)
        TextFiledAlignment(textfield: conpwd)
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
    
    @IBAction func BACK(_ sender: Any) {
        APPDELEGATE.updateLoginView()
    }
    
    @IBAction func submitAct(_ sender: Any) {
        
        self.endEditing()
        
//        pwd.placeholder = "Password".localized
//        conpwd.placeholder = "Confirm Password".localized
        pwd.placeholderText(textfield: pwd, name: "Password".localized)
        conpwd.placeholderText(textfield: conpwd, name: "Confirm Password".localized)
        let pwdtxt = pwd.text!
        
        let conpwdtxt = conpwd.text!
        
        let checkvaluearr: [String] = [pwdtxt,conpwdtxt]
        
        let checkforarr: [validator] = [.empty,.empty]
        
        let alertmsgarr: [String] = ["Please enter your Password!".localized,"Please enter your Confirm Password!".localized]
        
        let checker = model.validator(checkvalue: checkvaluearr, checkfor: checkforarr)
        
        if checker.error {
            
            let alert = UIAlertController(title: "TowRoute".localized, message: alertmsgarr[checker.errorId], preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok".localized, style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
            
        else if (pwdtxt.count < 8){
            
            self.showAlertView(message: "Password must contain atleast 8 characters!".localized)
            
        }
            
        else if pwdtxt.hasSpecialCharacters() == true
        {
            self.showAlertView(message: "Password must be atleast 8 characters with atleast 1 number and alphabets!".localized)
        }
            
        else if isValidPassword(testStr: pwdtxt) == false {
            
            self.showAlertView(message: "Password must be atleast 8 characters with atleast 1 number and alphabets!".localized)
            
        }
            
        else if (pwdtxt != conpwdtxt){
            
            self.showAlertView(message: "Password and Confirm Password are not same!".localized)
            
        }
            
            
        else{
            
            submitBtn.isUserInteractionEnabled = false
            let params = ["id": customer_id,
                          "mode": "customer",
                          "password": pwdtxt] as [String : Any]
            print("paramss\(params)")
            
            APIManager.shared.updatePassword(params: params as [String : AnyObject], callback: { (response) in
                
                if case let status as String = response?["error"], status == "Invalid credentials." {
                    self.submitBtn.isUserInteractionEnabled = true
                    self.showAlertView(message: "Login Failed!".localized)
                }
                    
                else if case let msg as String = response?["message"], msg == "Customer password updated successfuly." {
                    self.submitBtn.isUserInteractionEnabled = true
                    self.showAlertView(message: "Password Updated Successfully".localized)
                    APPDELEGATE.isShowLogin = true
                    
                    APPDELEGATE.updateLoginView()
                    
                }
                else
                {
                    self.submitBtn.isUserInteractionEnabled = true
                    if case let msg as String = response?["message"]
                    {
                        self.showAlertView(message: msg)
                    }
                }
                
                
            })
            
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
