//
//  AddcardViewController.swift
//  TowRoute User
//
//  Created by Admin on 14/06/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import Material
import Stripe
import AFNetworking
import JVFloatLabeledTextField
import SVProgressHUD
import Firebase

class AddcardViewController: UIViewController, TextFieldDelegate {
    
    @IBOutlet var cardnumber: JVFloatLabeledTextField!
    @IBOutlet var ccv: JVFloatLabeledTextField!
    
    @IBOutlet var month: JVFloatLabeledTextField!
    
    @IBOutlet var year: JVFloatLabeledTextField!
    
    
    var stripCard = STPCardParams()
    var resultText = ""
    var amounts = ""
    
    var isPayOnline = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    func handleError(error: NSError) {
        UIAlertView(title: "Please Try Again",
                    message: error.localizedDescription,
                    delegate: nil,
                    cancelButtonTitle: "OK".localized).show()
        
    }
    
    var sttoken: STPToken!
    
    func postStripeToken(token: STPToken) {
        
        print("poststripe")
        
        let userdict = USERDEFAULTS.getLoggedUserDetails()
        
        let userid = userdict["id"] as! String
        
        sttoken = token
        
        let params = ["transaction_token": token.tokenId,
                      "transaction_amount": amounts,
                      "transaction_mode": "card",
                      "customer_id": userid] as [String : Any]
        
        print("params \(params)")
        
        APIManager.shared.customerAddMoney(params: params as [String : AnyObject]) { (response) in
            
            if case let msg as String = response?["message"], msg == "Unauthenticated." {
                
                APIManager.shared.refreshToken(params: params as [String : AnyObject]) { (response) in
                    
                    if case let access_token as String = response?["access_token"] {
                        
                        APPDELEGATE.bearerToken = access_token
                        
                        USERDEFAULTS.set(access_token, forKey: "access_token")
                        
                        self.postStripeToken(token: self.sttoken)
                        
                    }
                        
                    else {
                        
                        self.showAlertView(title: "TowRoute".localized, message: "Your session has expired. Please log in again", callback: { (check) in
                            
                            APPDELEGATE.updateLoginView()
                            
                        })
                        
                    }
                    
                }
                
            }
            
            let walletstr = response?.object(forKey: "wallet_balance")
            
            if let wallet1 = walletstr {
                
                let wallet1str = "\(wallet1)"
                Database.database().reference().child("users").child(userid).child("wallet").setValue(wallet1str)
                
            }
            
            self.dismiss(animated: true, completion: nil)
            
        }
        
    }
    
    
    @IBAction func backact(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func pay(_ sender: Any) {
        
        SVProgressHUD.setContainerView(topMostViewController().view)
        SVProgressHUD.show()
        
        if self.month.text?.isEmpty == false {
            
            let expirationDate = self.month.text?.components(separatedBy: "/")
            let expmonth = UInt((expirationDate?[0])!)
            //    let expyear = UInt((expirationDate?[1])!)
            
            // send card info
            
            stripCard.number = self.cardnumber.text!
            stripCard.cvc = self.ccv.text!
            stripCard.expMonth = UInt(self.month.text!)!
            stripCard.expYear = UInt(self.year.text!)!
            
        }
        
        var underlyingError: NSError?
        if STPCardValidator.validationState(forCard: stripCard) == .valid {
            
            STPAPIClient.shared.createToken(withCard: stripCard, completion: { (token, error) -> Void in
                
                if error != nil {
                    self.handleError(error: error! as NSError)
                    return
                }
                
                if self.isPayOnline == true {
                    
                    APPDELEGATE.stripToken = (token?.tokenId)!
                    
                    SVProgressHUD.dismiss()
                    
                    self.dismiss(animated: true, completion: nil)
                    
                }
                    
                else {
                    
                    self.postStripeToken(token: token!)
                    
                }
                
            })
            
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
