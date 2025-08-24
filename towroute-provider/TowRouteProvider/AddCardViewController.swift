//
//  AddCardViewController.swift
//  firgun
//
//  Created by Vishnu Varthan on 21/12/18.
//  Copyright © 2018 UPLOGIC. All rights reserved.
//

import UIKit
import Stripe
import SVProgressHUD
import Firebase
class AddCardViewController: UIViewController {

    
    @IBOutlet weak var paymentCardTextField: STPPaymentCardTextField!
    
    var amount = ""
//    var viewModel = StripeViewModel()
    
    @IBOutlet weak var backbtn: UIButton!
    override func viewDidLoad() {
        
        paymentCardTextField.postalCodeEntryEnabled = false
     }

    
    
    @IBAction func back_act(_ sender: Any) {
        
       
            self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func cancel_act(_ sender: Any) {
           self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save_act(_ sender: Any) {
        
        self.view.endEditing(true)
//
        if paymentCardTextField.cardNumber == "" || paymentCardTextField.cardNumber == nil {
         
            self.showAlertView(message: "Please enter card number")
        } else if paymentCardTextField.expirationMonth == 0 {
            self.showAlertView(message: "Please enter expire month")
        } else if paymentCardTextField.expirationYear == 0 {
        self.showAlertView(message: "Please enter expire year")
        } else if paymentCardTextField.cvc == ""{
            self.showAlertView(message: "Please enter cvc")
        }  else if paymentCardTextField.isValid == false {
            self.showAlertView(message: "Please enter valid card details")
        }
            
            
            else {
            
            
            SVProgressHUD.setContainerView(topMostViewController().view)
            SVProgressHUD.show()

             let cardParams = paymentCardTextField.cardParams
            
            let stripCard = STPCardParams()
            
            stripCard.number = cardParams.number
            stripCard.cvc = cardParams.cvc
            stripCard.expMonth = UInt(truncating: cardParams.expMonth!)
            stripCard.expYear = UInt(truncating: cardParams.expYear!)
            
            print("carddetails \(stripCard)")
                STPAPIClient.shared.createToken(withCard: stripCard) { (token: STPToken?, error: Error?) in
                
                
                                guard let token = token, error == nil else {
                                    // self.showAlertView(message: (error?.localizedDescription)!)
                                    SVProgressHUD.dismiss()
                                    self.showAlertView(message: error!.localizedDescription)
                                   
                                    
                                    return
                                }
                

                self.postStripeToken(token: token, cardnumber: "1234")
               

                
            }
            
        }
     }
    
    
    
    func postStripeToken(token: STPToken, cardnumber: String) {
        
        print("poststripe")
        
        let userdict = USERDEFAULTS.getLoggedUserDetails()
        
        let userid = userdict["id"] as! String
        
        let params = ["transaction_token": token.tokenId,
                      "transaction_amount": amount,
                      "transaction_mode": "card",
                      "driver_id": userid,
                      "card_number": cardnumber] as [String : Any]
        
        print("params \(params)")
        
        APIManager.shared.driverAddMoney(params: params as [String : AnyObject]) { (response) in
            
            if case let msg as String = response?["message"], msg == "Unauthenticated." {
                
                APIManager.shared.refreshToken(params: params as [String : AnyObject]) { (response) in
                    
                    if case let access_token as String = response?["access_token"] {
                        
                        APPDELEGATE.bearerToken = access_token
                        
                        USERDEFAULTS.set(access_token, forKey: "access_token")
                        
                        self.postStripeToken(token: token, cardnumber: "1234")
                        
                    }
                        
                    else {
                        
                        self.showAlertView(title: "TOWROUTE PROVIDER".localized, message: "Your session has expired. Please log in again", callback: { (check) in
                            
                            APPDELEGATE.updateLoginView()
                            
                        })
                        
                    }
                    
                }
                
            }
            
            else if case let msg as String = response?["message"], msg == "Money added in wallet successfully."
              
          {
              
              
              let walletstr = response?.object(forKey: "wallet_balance")
              
              if let wallet1 = walletstr {
                  let wallet1str = "\(wallet1)"
                print("Check Wallet \(wallet1str)")
                  Database.database().reference().child("providers").child(userid).child("wallet").setValue(wallet1str)
                  
              }
              
              let creditAlert = UIAlertController(title: "TowRoute", message: "Money added in wallet successfully.", preferredStyle: .alert)
              
              let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
          
                  self.dismiss(animated: true, completion: nil)
              }
              creditAlert.addAction(OKAction)
              self.present(creditAlert, animated: true, completion:nil)
              
          }
          
          else
          {
              
              if case let msg as String = response?["message"]
               {
              self.showAlertView(title: "TowRoute", message: "\(msg)" , callback: { (true) in
                  
                  self.dismiss(animated: true, completion: nil)
                  
              })
              
              }
          }
        }
        

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 }

extension AddCardViewController: STPPaymentCardTextFieldDelegate{
    func paymentCardTextFieldDidChange(_ textField: STPPaymentCardTextField) {
        // cardView.paymentCardTextFieldDidChange(cardNumber: textField.cardNumber, expirationYear: textField.expirationYear, expirationMonth: textField.expirationMonth, cvc: textField.cvc)
    }
    
    func paymentCardTextFieldDidEndEditingExpiration(_ textField: STPPaymentCardTextField) {
        //  cardView.paymentCardTextFieldDidEndEditingExpiration(expirationYear: textField.expirationYear)
    }
    
    func paymentCardTextFieldDidBeginEditingCVC(_ textField: STPPaymentCardTextField) {
        //cardView.paymentCardTextFieldDidBeginEditingCVC()
    }
    
    func paymentCardTextFieldDidEndEditingCVC(_ textField: STPPaymentCardTextField) {
        // cardView.paymentCardTextFieldDidEndEditingCVC()
    }
}

