//
//  WalletViewController.swift
//  TowRoute User
//
//  Created by Admin on 07/06/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import JVFloatLabeledTextField
import Stripe
import Firebase

class WalletViewController: UIViewController, STPAddCardViewControllerDelegate {
    func addCardViewController(_ addCardViewController: STPAddCardViewController, didCreatePaymentMethod paymentMethod: STPPaymentMethod, completion: @escaping STPErrorBlock) {
        
    }
    
    
    @IBOutlet var num: UIButton!
    @IBOutlet var amount: JVFloatLabeledTextField!
    
    @IBOutlet weak var navbackimg: UIImageView!
    @IBOutlet var walletbal: UILabel!
    var stripCard = STPCardParams()
    var ride = ""
    override func viewDidLoad() {
        super.viewDidLoad()
    
       
        //addMenu()
        // Do any additional setup after loading the view.
        
       
       // let currcc = String(format: "%.2f", (Double("\(APPDELEGATE.userWallet)".convertCur())!))
       // let val = String(format: "%.2f", APPDELEGATE.userWallet)
        let d = Double(APPDELEGATE.userWallet)!
        print(d)
        let currc = String(format: "%.2f", d)
        print(currc)
        self.walletbal.text = "\(currency_symbol!) \(currc.convertCur())"
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.getWallet), name: NSNotification.Name(rawValue: "userwallet"), object: nil)
        
        
        self.title = "MY WALLET".localized
        amount.placeholder="Recharge Amount".localized
        
        
        let gradient = CAGradientLayer()
        let sizeLength = UIScreen.main.bounds.size.height * 2
        let defaultNavigationBarFrame = CGRect(x: 0, y: 0, width: sizeLength, height: 199)
        
        gradient.frame = defaultNavigationBarFrame
        let color1 = UIColor.init(hexString: "#00d5ff")
        let color2 = UIColor.init(hexString: "#ffffff")
        //let color3 = UIColor.init(hexString: "#81223d")
        
        gradient.colors = [color1!.cgColor,color2!.cgColor]//,color3!.cgColor
        navbackimg.image = self.image(fromLayer: gradient)
        navbackimg.transform = navbackimg.transform.rotated(by: CGFloat(Double.pi / 1))
        
    }
    
    
    @objc func getWallet(_ notification: Notification) {
        
        let d = Double(APPDELEGATE.userWallet)!
        print(d)
        let currc = String(format: "%.2f", d)
        print(currc)
        self.walletbal.text = "\(currency_symbol!) \(currc.convertCur())"
        
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func image(fromLayer layer: CALayer) -> UIImage {
        UIGraphicsBeginImageContext(layer.frame.size)
        
        layer.render(in: UIGraphicsGetCurrentContext()!)
        
        let outputImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return outputImage!
    }
    
    @IBAction func btn_act(_ sender: Any) {
        amount.text = "100"
        
    }
    
    
    @IBAction func btn2_act(_ sender: Any) {
        amount.text = "150"
    }
    
    @IBAction func btn3_act(_ sender: Any) {
        amount.text = "200"
    }
    
    var isdismiss = false
    
    @IBAction func backact(_ sender: Any) {
        
        
        if isdismiss == false {
            
            self.navigationController?.popViewController(animated: true)
            
        }
        else {
            
            self.dismiss(animated: true, completion: nil)
            
        }
        
    }
    
    @IBAction func addmoney(_ sender: Any) {
        
        
        if amount.text == "" {
                  
                  self.showAlertView(message: "Please Enter the recharge amount".localized)
                  return
                  
              }
        
        
        
              
                 let addcardVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddCardViewController") as? AddCardViewController
              
        addcardVC!.amount = amount.text!.convertCurToDollar()
              //   self.navigationController?.pushViewController(addcardVC!, animated: true)
                self.present(addcardVC!, animated: true, completion: nil)
        amount.text = ""
        
    }
    
    @IBAction func viewtransactionact(_ sender: Any) {
        
        let yourtransaction = storyboard?.instantiateViewController(withIdentifier:"yourtransaction")
        self.navigationController?.pushViewController(yourtransaction!, animated: true)
        
    }
    
    @IBAction func termsandcondtion(_ sender: Any) {
        
        let terms = storyboard?.instantiateViewController(withIdentifier:"terms")
        self.navigationController?.pushViewController(terms!, animated: true)
        
    }
    
    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func addCardViewController(_ addCardViewController: STPAddCardViewController, didCreateToken token: STPToken, completion: @escaping STPErrorBlock) {
        // self.paymentCell.paymentField
        
        postStripeToken(token: token, cardnumber: "1234")
        
    }
    
    func postStripeToken(token: STPToken, cardnumber: String) {
        
        print("poststripe")
        
        let userdict = USERDEFAULTS.getLoggedUserDetails()
        
        let userid = userdict["id"] as! String
        
        let params = ["transaction_token": token.tokenId,
                      "transaction_amount": amount.text!.convertCurToDollar(),
                      "transaction_mode": "card",
                      "customer_id": userid,
                      "card_number": cardnumber] as [String : Any]
        
        print("params \(params)")
        
        APIManager.shared.customerAddMoney(params: params as [String : AnyObject]) { (response) in
            
            if case let msg as String = response?["message"], msg == "Unauthenticated." {
                
                APIManager.shared.refreshToken(params: params as [String : AnyObject]) { (response) in
                    
                    if case let access_token as String = response?["access_token"] {
                        
                        APPDELEGATE.bearerToken = access_token
                        
                        USERDEFAULTS.set(access_token, forKey: "access_token")
                        
                        self.postStripeToken(token: token, cardnumber: cardnumber)
                        
                    }
                        
                    else {
                        
                        self.showAlertView(title: "TowRoute".localized, message: "Your session has expired. Please log in again", callback: { (check) in
                            
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
                    Database.database().reference().child("users").child(userid).child("wallet").setValue(wallet1str)
                    
                }
                
                self.amount.text = ""
                
                self.dismiss(animated: true, completion: nil)
               
            }
            
            else
            {
                
                self.showAlertView(title: "TowRoute", message: "Invalid Card Token" , callback: { (true) in
                    
                    self.dismiss(animated: true, completion: nil)
                    
                })
                
            }
            
          
            
        }
        

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
