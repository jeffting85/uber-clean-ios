//
//  WalletViewController.swift
//  TowRoute Provider
//
//  Created by Admin on 07/06/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import Stripe
import Firebase
import JVFloatLabeledTextField

class WalletViewController: UIViewController {

   
    
    @IBOutlet var walletbal: UILabel!
    @IBOutlet weak var navbackimg: UIImageView!
    
    @IBOutlet var amount: JVFloatLabeledTextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        //addMenu()
        // Do any additional setup after loading the view.
        
        walletbal.text = "\(currency_symbol!)" + String(format: "%.2f", (Double("\(APPDELEGATE.driverWallet)".convertCur())!))
        
      amount.placeholder = "Recharge Amount".localized
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.getWallet), name: NSNotification.Name(rawValue: "driverwallet"), object: nil)
        
        self.title = "MY WALLET".localized
        
        let gradient = CAGradientLayer()
        let sizeLength = UIScreen.main.bounds.size.height * 2
        let defaultNavigationBarFrame = CGRect(x: 0, y: 0, width: sizeLength, height: 90)
        
        gradient.frame = defaultNavigationBarFrame
        let color1 = UIColor.init(hexString: "#00d5ff")
        let color2 = UIColor.init(hexString: "#FFFFFF")
        //let color3 = UIColor.init(hexString: "81223d")
        
        gradient.colors = [color1!.cgColor,color2!.cgColor]//,color3!.cgColor
        
        navbackimg.image = image(fromLayer: gradient)
        navbackimg.transform = navbackimg.transform.rotated(by: CGFloat(Double.pi / 1))
        
        
    }
    
    
    @objc func getWallet(_ notification: Notification) {
        
        print("Come here wallet view controller")
        let userInfo = notification.userInfo
        let userwallet = userInfo?["wallet"]
        
        walletbal.text = "\(currency_symbol!) "+String(format: "%.2f", (Double("\(userwallet!)".convertCur())!))
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
            
            self.navigationController?.popViewController(animated: true)
            

        
    }
    
    @IBAction func termsandcondtion(_ sender: Any) {
    
        let terms = storyboard?.instantiateViewController(withIdentifier:"terms")
        self.navigationController?.pushViewController(terms!, animated: true)
        
    }
    
    
    @IBAction func addmoney(_ sender: Any) {
        if amount.text == "" {
                  
                  self.showAlertView(message: "Please Enter the recharge amount".localized)
                  return
                  
              }
              
                 let addcardVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddCardViewController") as? AddCardViewController
              
              addcardVC!.amount = amount.text!.convertCurToDollar()
        
        amount.text = ""
              //   self.navigationController?.pushViewController(addcardVC!, animated: true)
                self.present(addcardVC!, animated: true, completion: nil)

        
    }
    
    
    func postStripeToken(token: STPToken) {
        
        print("poststripe")
        
        let userdict = USERDEFAULTS.getLoggedUserDetails()
        
        let userid = userdict["id"] as! String
        
        let params = ["transaction_token": token.tokenId,
                      "transaction_amount": amount.text!.convertCurToDollar(),
                      "transaction_mode": "card",
                      "driver_id": userid,
                      "card_number": "123"] as [String : Any]
        
        print("params \(params)")
        
        APIManager.shared.driverAddMoney(params: params as [String : AnyObject]) { (response) in
            
            if case let msg as String = response?["message"], msg == "Unauthenticated." {
                
                APIManager.shared.refreshToken(params: params as [String : AnyObject]) { (response) in
                    
                    if case let access_token as String = response?["access_token"] {
                        
                        APPDELEGATE.bearerToken = access_token
                        
                        USERDEFAULTS.set(access_token, forKey: "access_token")
                        
                        self.postStripeToken(token: token)
                        
                    }
                        
                    else {
                        
                        self.showAlertView(title: "TOWROUTE PROVIDER".localized, message: "Your session has expired. Please log in again", callback: { (check) in
                            
                            APPDELEGATE.updateLoginView()
                            
                        })
                        
                    }
                    
                }
                
            }
            
            let walletstr = response?.object(forKey: "wallet_balance")
            
            if let wallet1 = walletstr {
                
                let wallet1str = "\(wallet1)"
                Database.database().reference().child("providers").child(userid).child("wallet").setValue(wallet1str)
                
            }
            
            self.amount.text = ""
            
            self.dismiss(animated: true, completion: nil)
            
        }
        
    }


    
   
    @IBAction func viewtransactionact(_ sender: Any) {
        
        let yourtransaction = storyboard?.instantiateViewController(withIdentifier:"yourtransaction")
        self.navigationController?.pushViewController(yourtransaction!, animated: true)
        
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


extension UIView {
    
   
    // OUTPUT 2
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        layer.cornerRadius = 5
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}
