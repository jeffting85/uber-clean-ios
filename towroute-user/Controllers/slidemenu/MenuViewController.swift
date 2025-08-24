//
//  MenuViewController.swift
//  TowRoute User
//
//  Created by Admin on 06/06/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import Alamofire
import FloatRatingView
import Firebase
class MenuViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    @IBOutlet var userimg: UIImageView!
    @IBOutlet var username: UILabel!
    var menus = ["My Profile".localized, "Your Bookings".localized,"My Wallet".localized, "On Going Job".localized,"Emergency Contacts".localized,"Invite Friends".localized,"Support".localized,"Notifications".localized,"Language".localized,"Currency".localized]
    
    
    
   var menuimages = [#imageLiteral(resourceName: "avatar"),#imageLiteral(resourceName: "map-location"),#imageLiteral(resourceName: "wallet"),#imageLiteral(resourceName: "wall-clock"),#imageLiteral(resourceName: "phone-book"),#imageLiteral(resourceName: "message"),#imageLiteral(resourceName: "support"),#imageLiteral(resourceName: "alarm-1"),#imageLiteral(resourceName: "translate"),#imageLiteral(resourceName: "currency")]
    
    @IBOutlet var walletbal: UILabel!
    @IBOutlet weak var menubg: UIView!
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menus.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell") as! MenuCell
        cell.name.text = menus[indexPath.row]
        cell.images.image = menuimages[indexPath.row]
        cell.selectionStyle = .none
        /* if(selectedItem != nil){
         cell.img_bg.isHighlighted = selectedItem == indexPath.row
         cell.lbl_title.textColor = selectedItem == indexPath.row ? UIColor(hexString: "000000") : UIColor(hexString: "171a16") //.black : .lightGray
         } */
        return cell
    }
    
    @IBAction func profile(_ sender: Any) {
        let profilePage = storyboard?.instantiateViewController(withIdentifier:"profile")
        
        self.slideMenuController()?.closeLeft()
        self.slideMenuController()?.closeRight()
        (self.slideMenuController()?.mainViewController as! UINavigationController).pushViewController(profilePage!, animated: true)
        
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // selectedItem = indexPath.row
        tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        
        switch indexPath.row {
            
        case 0:
            
            let profilePage = storyboard?.instantiateViewController(withIdentifier:"profile")
            
            self.slideMenuController()?.closeLeft()
            self.slideMenuController()?.closeRight()
            (self.slideMenuController()?.mainViewController as! UINavigationController).pushViewController(profilePage!, animated: true)
            break
            
        case 1:
            
            //let yourjob = storyboard?.instantiateViewController(withIdentifier:"yourjob")
            //self.slideMenuController()?.changeMainViewController(yourjob!, close: true)
            let yourjob = storyboard?.instantiateViewController(withIdentifier:"yourjob")
            
            self.slideMenuController()?.closeLeft()
            self.slideMenuController()?.closeRight()
            (self.slideMenuController()?.mainViewController as! UINavigationController).pushViewController(yourjob!, animated: true)
            
            break
            
        case 2:
            // logoutConfirmation()
            ride = ""
            let wallet = storyboard?.instantiateViewController(withIdentifier:"wallet")
            
            self.slideMenuController()?.closeLeft()
            self.slideMenuController()?.closeRight()
            (self.slideMenuController()?.mainViewController as! UINavigationController).pushViewController(wallet!, animated: true)
            
            break
            
        case 3:
            // Fare Calculation
            
            
            let jobs = storyboard?.instantiateViewController(withIdentifier:"Onjob")
            
            self.topMostViewController().present(jobs!, animated: true, completion: nil)
            
            self.slideMenuController()?.closeLeft()
            self.slideMenuController()?.closeRight()
            // (self.slideMenuController()?.mainViewController as! UINavigationController).pushViewController(jobs!, animated: true)
            
            
            break
            
            
            
        case 4:
            
            
            let emergency = storyboard?.instantiateViewController(withIdentifier:"emergency")
            
            self.slideMenuController()?.closeLeft()
            self.slideMenuController()?.closeRight()
            (self.slideMenuController()?.mainViewController as! UINavigationController).pushViewController(emergency!, animated: true)
            break
            
            
        case 5:
            
            
            let invite = storyboard?.instantiateViewController(withIdentifier:"invite")
            
            self.slideMenuController()?.closeLeft()
            self.slideMenuController()?.closeRight()
            (self.slideMenuController()?.mainViewController as! UINavigationController).pushViewController(invite!, animated: true)
            
            break
            
            
        case 6:
            
            
            let support = storyboard?.instantiateViewController(withIdentifier:"support")
            
            self.slideMenuController()?.closeLeft()
            self.slideMenuController()?.closeRight()
            (self.slideMenuController()?.mainViewController as! UINavigationController).pushViewController(support!, animated: true)
            
            
            
            break
            
        case 7:
            
            
            let support = storyboard?.instantiateViewController(withIdentifier:"notification")
            
            self.slideMenuController()?.closeLeft()
            self.slideMenuController()?.closeRight()
            (self.slideMenuController()?.mainViewController as! UINavigationController).pushViewController(support!, animated: true)
            
            
            
            break
            
            case 8:
                
                
                   
                         let changelanguage = STORYBOARD.instantiateViewController(withIdentifier: "language")
                         changelanguage.modalPresentationStyle = .overCurrentContext
                         changelanguage.modalTransitionStyle = .crossDissolve
                         (self.slideMenuController()?.mainViewController)?.present(changelanguage, animated: false, completion: nil)
                         self.slideMenuController()?.closeLeft()
                         self.slideMenuController()?.closeRight()
                
                
                
                break
            
            
            case 9:
                

                 let changelanguage = STORYBOARD.instantiateViewController(withIdentifier: "Currency")
                         changelanguage.modalPresentationStyle = .overCurrentContext
                         changelanguage.modalTransitionStyle = .crossDissolve
                         (self.slideMenuController()?.mainViewController)?.present(changelanguage, animated: false, completion: nil)
                         self.slideMenuController()?.closeLeft()
                         self.slideMenuController()?.closeRight()
                
                
                
                break

            
        default:
            break
        }
    }
    
    
    
    @IBAction func logout(_ sender: Any) {
        logoutConfirmation()
    }
    
    @IBOutlet var tableview: UITableView!
    @IBOutlet var userRating: FloatRatingView!
    var pendingRef: DatabaseReference! = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userdict = USERDEFAULTS.getLoggedUserDetails()
        
        let userid = userdict["id"] as! String
        
        let fireRef = Database.database().reference()
        pendingRef = fireRef.child("users").child(userid).child("wallet")
        pendingRef.observe(DataEventType.value) { (SnapShot: DataSnapshot) in
            print("wallet Value \(SnapShot.value)")
            
            if let statusval = SnapShot.value {
                
                

                APPDELEGATE.userWallet = "\(statusval)"
                
                print("APPDELEGATE.userWallet \(APPDELEGATE.userWallet)")


                print("Currency Mul \(currencymul)")

                
                let d = Double(APPDELEGATE.userWallet)!
                print(d)
                let currc = String(format: "%.2f", d)
                print(currc)
                let wal = "Wallet Balance:".localized
                self.walletbal.text = "\(wal) \(currency_symbol!) \(currc.convertCur())"
                
            }
            
            // Do any additional setup after loading the view.
        }
        
        addMenu()
        refreshData()
//        let curre = String(format: "%.2f", (Double("\(APPDELEGATE.userWallet.convertCur())")!))
//        walletbal.text = "Wallet Balance1: \(currency_symbol!)\(curre)"
       
        
        if APPDELEGATE.userRating != "<null>" {
            
            userRating.rating = Double(APPDELEGATE.userRating)!
            
        }
//        let gradient = CAGradientLayer()
//       // let sizeLength = UIScreen.main.bounds.size.height * 2
//        let defaultNavigationBarFrame = CGRect(x: 0, y: 0, width: 270, height: menubg.size.height)
//        
//        gradient.frame = defaultNavigationBarFrame
//         let color1 = UIColor.init(hexString: "#c67706")
//         let color2 = UIColor.init(hexString: "#fcff9e")
//        
//        gradient.colors = [color1!.cgColor,color2!.cgColor]//,color3!.cgColor
//        self.menubg.applyGradients(colors: gradient.colors as! [CGColor])
//        menubg.image = self.image(fromLayer: gradient)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("ProfileUpdate"), object: nil)
        
        //NotificationCenter.default.addObserver(self, selector: #selector(self.getWallet), name: NSNotification.Name(rawValue: "userwallet"), object: nil)
        
       NotificationCenter.default.addObserver(self, selector: #selector(self.getWallet1), name: NSNotification.Name(rawValue: "currencySymUpdate"), object: nil)
       NotificationCenter.default.addObserver(self, selector: #selector(self.getWallet1), name: NSNotification.Name(rawValue: "currencyUpdate"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.getRating), name: NSNotification.Name(rawValue: "ratingUpdate"), object: nil)
        
        // Do any additional setup after loading the view.
    }
    
    func image(fromLayer layer: CALayer) -> UIImage {
        UIGraphicsBeginImageContext(layer.frame.size)
        
        layer.render(in: UIGraphicsGetCurrentContext()!)
        
        let outputImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return outputImage!
    }
    
    @objc func methodOfReceivedNotification(notification: Notification){
        
        refreshData()
        
    }
    
    @objc func getRating(_ notification: Notification) {
        
        if APPDELEGATE.userRating != "<null>" {
            
            userRating.rating = Double(APPDELEGATE.userRating)!
            
        }
        
    }
    
    
    @objc func getWallet1(_ notification: Notification) {
        
        let d = Double(APPDELEGATE.userWallet)!
        print(d)
        let currc = String(format: "%.2f", d)
        print(currc)
        let wal = "Wallet Balance:".localized
        self.walletbal.text = "\(wal) \(currency_symbol!) \(currc.convertCur())"
        //self.walletbal.text = "Wallet Balance: \(currency_symbol!) \(currc)"
        
    }
    
   
    func getwall()
    {
        let curre = String(format: "%.2f", (Double("\(APPDELEGATE.userWallet)".convertCur())!))
        walletbal.text = "Wallet Balance3: \(currency_symbol!) \(curre)"
    }
    
    
    @objc func getWallet(_ notification: Notification) {
        
        let userInfo = notification.userInfo
        let userwallet = userInfo?["wallet"]
        let curre = String(format: "%.2f", (Double("\(APPDELEGATE.userWallet)".convertCur())!))
        let wal = "Wallet Balance:".localized
        self.walletbal.text = "\(wal) \(currency_symbol!) \(curre)"
       // walletbal.text = "Wallet Balance: \(currency_symbol!) \(curre)"
        
    }
    
    func refreshData() {
        
        let userdict = USERDEFAULTS.getLoggedUserDetails()
        
        print("userdicttt \(userdict)")
        
        if case let avatar as String = userdict["avatar"] {
            
            if(!(avatar.isEmpty)){
                
                var newavatar = BASEAPI.PRFIMGURL + avatar
                
                if !newavatar.contains("uploads"){
                    newavatar = BASEAPI.IMGURL + avatar
                }
                
                print("newavatar \(newavatar)")
                
                Alamofire.request(newavatar, method: .get).responseImage { response in
                    guard let image = response.result.value else {
                        // Handle error
                        return
                    }
                    
                    self.userimg.image = image
                    
                    // Do stuff with your image
                }
                
            }
            
        }
        
        if case let first_name as String = userdict["first_name"] {
            
            if(!(first_name.isEmpty)){
                
                username.text = first_name.uppercased() + " "
                
            }
            
        }
        
        if case let last_name as String = userdict["last_name"] {
            
            if(!(last_name.isEmpty)){
                
                username.text = username.text! + last_name.uppercased()
                
            }
            
        }
        
    }
    
    func logoutConfirmation(){
        
        let controller = UIAlertController(title: nil, message: "Are you sure want to Logout?".localized, preferredStyle: .actionSheet)
        let yes = UIAlertAction(title: "Yes".localized, style: .default) { (action) in
            APPDELEGATE.updateLoginView()
            
            self.logout()
        }
        
        let no = UIAlertAction(title: "No".localized, style: .cancel) { (action) in
        }
        controller.addAction(yes)
        controller.addAction(no)
        present(controller, animated: true, completion: nil)
    }
    
    func logout() {
        
        userRating.rating = 0.0
        
        NotificationCenter.default.removeObserver(self)
        
        // APPDELEGATE.locationManager.stopUpdatingLocation()
        USERDEFAULTS.set(false, forKey: "login already")
        APPDELEGATE.updateLoginView()
        
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

class MenuCell: UITableViewCell{
    
    
    @IBOutlet var images: UIImageView!
    
    @IBOutlet var name: UILabel!
    
}
extension UIView
{
func applyGradients(colors: [CGColor])
{
let gradientLayer = CAGradientLayer()
gradientLayer.colors = colors
gradientLayer.startPoint = CGPoint(x: 0, y: 0)
gradientLayer.endPoint = CGPoint(x: 1, y: 0)
gradientLayer.frame = self.bounds
self.layer.insertSublayer(gradientLayer, at: 0)
}
}
