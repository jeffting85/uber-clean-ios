//
//  BankDetailViewController.swift
//  TowRoute Provider
//
//  Created by Uplogic Technologies on 23/06/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import JVFloatLabeledTextField

class BankDetailViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet var emailtxt: JVFloatLabeledTextField!
    @IBOutlet var holdername: JVFloatLabeledTextField!
    @IBOutlet var accno: JVFloatLabeledTextField!
    @IBOutlet var bankloc: JVFloatLabeledTextField!
    @IBOutlet var bankname: JVFloatLabeledTextField!
    @IBOutlet var swiftcode: JVFloatLabeledTextField!
    
    @IBAction func backact(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        // self.dismiss(animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bankloc.delegate =  self
        holdername.delegate = self
        bankname.delegate = self
        swiftcode.delegate = self
        
        viewAct()
        self.title = "Bank Details".localized
        
        // Do any additional setup after loading the view.
    }

    func viewAct() {
        
        let userdict = USERDEFAULTS.getLoggedUserDetails()
        
        let userid = userdict["id"] as! String
        
        let params = ["id": userid
                      ] as [String : Any]
        
        APIManager.shared.viewBankDet(params: params as [String : AnyObject], callback: { (response) in
            
            if case let msg as String = response?["message"], msg == "Unauthenticated." {
                
                APIManager.shared.refreshToken(params: params as [String : AnyObject]) { (response) in
                    
                    if case let access_token as String = response?["access_token"] {
                        
                        APPDELEGATE.bearerToken = access_token
                        
                        USERDEFAULTS.set(access_token, forKey: "access_token")
                        
                        self.viewAct()
                        
                    }
                    
                    else {
                        
                        self.showAlertView(title: "TOWROUTE PROVIDER".localized, message: "Your session has expired. Please log in again", callback: { (check) in
                            
                            NotificationCenter.default.removeObserver(self)
                            
                            APPDELEGATE.updateLoginView()
                            
                        })
                        
                    }
                    
                }
                
            }
            
            else if case let data as NSArray = response?["data"], data.count > 0 {
                
                if case let dict as NSDictionary = data[0] {
                    
                    if let value = dict["payment_email"] {
                        
                        self.emailtxt.text = "\(value)"
                        
                        if self.emailtxt.text == "<null>" {
                            
                            self.emailtxt.text = ""
                            
                        }
                        
                    }
                    
                    if let value = dict["account_holder_name"] {
                        
                        self.holdername.text = "\(value)"
                        
                        if self.holdername.text == "<null>" {
                            
                            self.holdername.text = ""
                            
                        }
                        
                    }
                    
                    if let value = dict["bank_account_number"] {
                        
                        self.accno.text = "\(value)"
                        
                        if self.accno.text == "<null>" {
                            
                            self.accno.text = ""
                            
                        }
                        
                    }
                    
                    if let value = dict["bank_location"] {
                        
                        self.bankloc.text = "\(value)"
                        
                        if self.bankloc.text == "<null>" {
                            
                            self.bankloc.text = ""
                            
                        }
                        
                    }
                    
                    if let value = dict["bank_name"] {
                        
                        self.bankname.text = "\(value)"
                        
                        if self.bankname.text == "<null>" {
                            
                            self.bankname.text = ""
                            
                        }
                        
                    }
                    
                    if let value = dict["bank_code"] {
                        
                        self.swiftcode.text = "\(value)"
                        
                        if self.swiftcode.text == "<null>" {
                            
                            self.swiftcode.text = ""
                            
                        }
                        
                    }
                    
                }
                
            }
            
        })
        
    }
    
    @IBAction func submitAct(_ sender: Any) {
    
        let mail = emailtxt.text!
        let name = holdername.text!
        let accountno = accno.text!
        let banklocation = bankloc.text!
        let banknames = bankname.text!
        let swiftCode = swiftcode.text!
        
        let checkvaluearr: [String] = [mail,name,accountno,banklocation,banknames,swiftCode]
        let checkforarr: [validator] = [.empty,.empty,.empty,.empty,.empty,.empty]
        let alertmsgarr: [String] = ["Please enter your Payment Mail Id".localized,"Please Enter Account Name".localized,"Please Enter Account Number".localized,"Please Enter Bank Location".localized,"Please Enter Bank Name".localized,"Please Enter BIC/SWIFT Code".localized]
        
        let checker = model.validator(checkvalue: checkvaluearr, checkfor: checkforarr)
        
        if checker.error {
         
            let alert = UIAlertController(title: "TOWROUTE PROVIDER".localized, message: alertmsgarr[checker.errorId], preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok".localized, style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
            
        }
        
        
        let checkvaluearr1: [String] = [mail]
        let checkforarr1: [validator] = [.email]
        let alertmsgarr1: [String] = ["Please enter valid Email Id!".localized]
        let checker1 = model.validator(checkvalue: checkvaluearr1, checkfor: checkforarr1)
        
        if checker1.error {
            
            let alert = UIAlertController(title: "TOWROUTE PROVIDER".localized, message: alertmsgarr1[checker1.errorId], preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok".localized, style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
            
        }
        
            
        else
        {
            
        
        let userdict = USERDEFAULTS.getLoggedUserDetails()
        
        let userid = userdict["id"] as! String
        
        let params = ["id": userid,
                      "bank_email": emailtxt.text!,
                      "account_holder_name": holdername.text!,
                      "bank_name": bankname.text!,
                      "bank_location": bankloc.text!,
                      "bank_code": swiftcode.text!,
                      "bank_account_number": accno.text!,
                      ] as [String : Any]
        
         APIManager.shared.updateBankDet(params: params as [String : AnyObject], callback: { (response) in
            
            if case let msg as String = response?["message"], msg == "Unauthenticated." {
                
                APIManager.shared.refreshToken(params: params as [String : AnyObject]) { (response) in
                    
                    if case let access_token as String = response?["access_token"] {
                        
                        APPDELEGATE.bearerToken = access_token
                        
                        USERDEFAULTS.set(access_token, forKey: "access_token")
                        
                        self.submitAct(self)
                        
                    }
                    
                    else {
                        
                        self.showAlertView(title: "TOWROUTE PROVIDER".localized, message: "Your session has expired. Please log in again", callback: { (check) in
                            
                            NotificationCenter.default.removeObserver(self)
                            
                            APPDELEGATE.updateLoginView()
                            
                        })
                        
                    }
                    
                }
                
            }
            
            else if case let msg as String = response?["message"] {
               
                let alert = UIAlertController(title: "TOWROUTE PROVIDER", message: "Updated Successfully".localized, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction!) in
                    APPDELEGATE.updateHomeView()
                }))
                
                self.present(alert, animated: true, completion: nil)
              
            }
            
        })
        }
        
    }
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var ACCEPTABLE_CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
        if textField == holdername
        {
            ACCEPTABLE_CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "
        }
        else
        {
            ACCEPTABLE_CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 "
        }
        
        let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
        let filtered = string.components(separatedBy: cs).joined(separator: "")
        
        return (string == filtered)
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
