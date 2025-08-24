//
//  MenuViewController.swift
//  TowRoute Provider
//
//  Created by Admin on 06/06/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import Alamofire
import HCSStarRatingView
import Firebase
class MenuViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var menus = ["My Profile".localized, "My Availability".localized, "Manage Services".localized, "Manage Document".localized, "My Jobs".localized, "Bank Details".localized, "My Wallet".localized,"Payout".localized, "Emergency Contact".localized, "User Feedback".localized, "Invite Friends".localized, "Support".localized,"Notifications".localized,"Language".localized,"Currency".localized]
    
    var menuimages = [#imageLiteral(resourceName: "avatar"),#imageLiteral(resourceName: "calendar"),#imageLiteral(resourceName: "settings"),#imageLiteral(resourceName: "copy"),#imageLiteral(resourceName: "map-location"),#imageLiteral(resourceName: "bank-building-2"),#imageLiteral(resourceName: "wallet"),#imageLiteral(resourceName: "cash-money"),#imageLiteral(resourceName: "phone-book"),#imageLiteral(resourceName: "chat"),#imageLiteral(resourceName: "message"),#imageLiteral(resourceName: "support"),#imageLiteral(resourceName: "alarm-1"),#imageLiteral(resourceName: "translate"),#imageLiteral(resourceName: "currency")]
    
    @IBOutlet var userimg: UIImageView!
    @IBOutlet var username: UILabel!
    @IBOutlet var driverRating: HCSStarRatingView!
    
    @IBOutlet var walletbal: UILabel!
    var pendingRef: DatabaseReference! = nil

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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    @IBAction func settingAct(_ sender: Any) {
    
        let profilePage = storyboard?.instantiateViewController(withIdentifier:"profile")
        self.slideMenuController()?.closeLeft()
        self.slideMenuController()?.closeRight()
        (self.slideMenuController()?.mainViewController as! UINavigationController).pushViewController(profilePage!, animated: true)
    
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
            
//            if APPDELEGATE.driverapproved == false {
//                
//                self.showAlertView(message: "Oops!! You cannot choose availability slots without approval, Kindly contact your admin for further details.".localized)
//                break
//                
//            }
            
            let availPage = storyboard?.instantiateViewController(withIdentifier:"availability")
            self.slideMenuController()?.closeLeft()
            self.slideMenuController()?.closeRight()
            (self.slideMenuController()?.mainViewController as! UINavigationController).pushViewController(availPage!, animated: true)
            break
            
        case 2:
            
//            if APPDELEGATE.driverapproved == false {
//
//                self.showAlertView(message: "Oops!! You cannot choose service without approval, Kindly contact your admin for further details.".localized)
//                break
//
//            }
            navigation_status = " "
            
            let availPage = storyboard?.instantiateViewController(withIdentifier:"manageservices")
            self.slideMenuController()?.closeLeft()
            self.slideMenuController()?.closeRight()
            (self.slideMenuController()?.mainViewController as! UINavigationController).pushViewController(availPage!, animated: true)
            break
            
        case 3:
            
            let availPage = storyboard?.instantiateViewController(withIdentifier:"NewDocumentViewController")
            self.slideMenuController()?.closeLeft()
            self.slideMenuController()?.closeRight()
            availPage?.title = "Manage Document".localized
            (self.slideMenuController()?.mainViewController as! UINavigationController).pushViewController(availPage!, animated: true)
            break
            
        case 4:
            
            let yourjob = storyboard?.instantiateViewController(withIdentifier:"yourjob")
            self.slideMenuController()?.closeLeft()
            self.slideMenuController()?.closeRight()
            (self.slideMenuController()?.mainViewController as! UINavigationController).pushViewController(yourjob!, animated: true)
            
        case 5:
            
            let bankdetail = storyboard?.instantiateViewController(withIdentifier:"bankdetail")
            self.slideMenuController()?.closeLeft()
            self.slideMenuController()?.closeRight()
            (self.slideMenuController()?.mainViewController as! UINavigationController).pushViewController(bankdetail!, animated: true)
            
        case 6:
            
            let wallet = storyboard?.instantiateViewController(withIdentifier:"wallet")
            self.slideMenuController()?.closeLeft()
            self.slideMenuController()?.closeRight()
            (self.slideMenuController()?.mainViewController as! UINavigationController).pushViewController(wallet!, animated: true)
            break
            
        case 7:
                  
                  let payout = storyboard?.instantiateViewController(withIdentifier:"PayOutViewController")
                  self.slideMenuController()?.closeLeft()
                  self.slideMenuController()?.closeRight()
                  (self.slideMenuController()?.mainViewController as! UINavigationController).pushViewController(payout!, animated: true)

                  break
              
          case 8:
              
              let emergency = storyboard?.instantiateViewController(withIdentifier:"emergency")
              self.slideMenuController()?.closeLeft()
              self.slideMenuController()?.closeRight()
              (self.slideMenuController()?.mainViewController as! UINavigationController).pushViewController(emergency!, animated: true)
              break
              
          case 9:
              
              let emergency = storyboard?.instantiateViewController(withIdentifier:"userfeedback")
              self.slideMenuController()?.closeLeft()
              self.slideMenuController()?.closeRight()
              (self.slideMenuController()?.mainViewController as! UINavigationController).pushViewController(emergency!, animated: true)
              break
              
          case 10:
              
              let invite = storyboard?.instantiateViewController(withIdentifier:"invite")
              self.slideMenuController()?.closeLeft()
              self.slideMenuController()?.closeRight()
              (self.slideMenuController()?.mainViewController as! UINavigationController).pushViewController(invite!, animated: true)
              break
              
              
          case 11:
              
              let support = storyboard?.instantiateViewController(withIdentifier:"support")
              self.slideMenuController()?.closeLeft()
              self.slideMenuController()?.closeRight()
              (self.slideMenuController()?.mainViewController as! UINavigationController).pushViewController(support!, animated: true)
              break
        
          case 12:
              
              
              let support = storyboard?.instantiateViewController(withIdentifier:"notification")
              
              self.slideMenuController()?.closeLeft()
              self.slideMenuController()?.closeRight()
              (self.slideMenuController()?.mainViewController as! UINavigationController).pushViewController(support!, animated: true)
              break
              
              case 13:
              
            let changelanguage = STORYBOARD.instantiateViewController(withIdentifier: "language")
              changelanguage.modalPresentationStyle = .overCurrentContext
              changelanguage.modalTransitionStyle = .crossDissolve
              (self.slideMenuController()?.mainViewController)?.present(changelanguage, animated: false, completion: nil)
              self.slideMenuController()?.closeLeft()
              self.slideMenuController()?.closeRight()
              break
              
                case 14:
                
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

    @IBOutlet var tableview: UITableView!
   
    override func viewWillAppear(_ animated: Bool) {
        //managedoc()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        
        managedoc()
        let fireRef = Database.database().reference()
        pendingRef = fireRef.child("providers").child(driver_id).child("wallet")
        pendingRef.observe(DataEventType.value) { (SnapShot: DataSnapshot) in
            print("wallet Value \(SnapShot.value)")
            
            if let statusval = SnapShot.value {
                
                

                APPDELEGATE.driverWallet = "\(statusval)"
                
                print("APPDELEGATE.driverWallet \(APPDELEGATE.driverWallet)")


                print("Currency Mul \(currencymul)")

                
                let d = Double(APPDELEGATE.driverWallet)!
                print(d)
                let currc = String(format: "%.2f", d)
                print(currc)
                let wal = "Wallet Balance:".localized
                self.walletbal.text = "\(wal) \(currency_symbol!) \(currc.convertCur())"
                
            }
            
            // Do any additional setup after loading the view.
        }
        
        
//        let curr = String(format: "%.2f", (Double("\(APPDELEGATE.driverWallet)".convertCur())!))
//        let wal = "Wallet Balance:".localized
//        self.walletbal.text = "\(wal) \(currency_symbol!) \(curr)"
//
       
        if APPDELEGATE.userRating != "<null>" {
            
            driverRating.value = CGFloat(Double(APPDELEGATE.userRating)!)
            
        }
        
        refreshData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("ProfileUpdate"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.getWallet), name: NSNotification.Name(rawValue: "driverwallet"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.getWallet1), name: NSNotification.Name(rawValue: "currencySymUpdate"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.getWallet1), name: NSNotification.Name(rawValue: "currencyUpdate"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.getRating), name: NSNotification.Name(rawValue: "ratingUpdate"), object: nil)
        
        driverRating.backgroundColor = UIColor.clear
        driverRating.emptyStarColor = UIColor(hex: "F2963C")
        driverRating.starBorderColor = UIColor.white // UIColor(hex: "F2963C")
        driverRating.tintColor = UIColor.white // UIColor(hex: "F2963C")
        
        // Do any additional setup after loading the view.
    }
    func managedoc(){
        let userdict = USERDEFAULTS.getLoggedUserDetails()
        
        let userid = userdict["id"] as! String
        
        let params = ["id": driver_id,
                      "type": "driver",
                      "mode": "api"]
        
        print("params \(params)")
        
        APIManager.shared.ManageDocument(params: params as [String : AnyObject]) { (response) in
            
            
            print("responsseManageDocument\(response)")
               if case let data as NSArray = response?["data"]{
                   print("dateapage \(data)")
                   
                  documentnames.removeAll()
                proof_id.removeAll()
                   for descri in data{
                       
                       let des = descri as! NSDictionary
                       
                       
                   
                         
                       let desvalue = des.value(forKey: "document_name") as! String
                       let desvalue1 = des.value(forKey: "id") as! NSNumber
                           print("documentdesname\(desvalue)")
                           print("documentdesid\(desvalue1)")
                       documentnames.append("\(desvalue)")
                     proof_id.append("\(desvalue1)")
                           print("chkdocumens\(documentnames)")
                           print("chkproofid\(proof_id)")

                   }


                   
            }
            
      }
    
    }
    @objc func getRating(_ notification: Notification) {
        
        if APPDELEGATE.userRating != "<null>" {
            
            driverRating.value = CGFloat(Double(APPDELEGATE.userRating)!)
            
        }
        
    }
    
    @objc func getWallet1(_ notification: Notification) {
        
     //   walletbal.text = "Wallet Balance: \(currency_symbol!) \(currc)"
        let wal = "Wallet Balance:".localized
        self.walletbal.text = "\(wal) \(currency_symbol!) \(APPDELEGATE.driverWallet.convertCur())"
        
    }
    
    @objc func getWallet(_ notification: Notification) {
        
        print("Come here Menu view controller")

        let userInfo = notification.userInfo
        let driverwallet = userInfo?["wallet"]
        let curre = String(format: "%.2f", (Double("\(driverwallet!)".convertCur())!))
       // walletbal.text = "Wallet Balance: \(currency_symbol!) \(curre)"
        
        let wal = "Wallet Balance:".localized
        self.walletbal.text = "\(wal) \(currency_symbol!) \(curre)"
        
    }
    
    @objc func methodOfReceivedNotification(notification: Notification){
        
        refreshData()
        let wal = "Wallet Balance:".localized
        self.walletbal.text = "\(wal) \(currency_symbol!) \(APPDELEGATE.driverWallet.convertCur())"

    }

    func refreshData() {
        
        let userdict = USERDEFAULTS.getLoggedUserDetails()
        
        print("userdict \(userdict)")
        
        if case let avatar as String = userdict["avatar"] {
            
            if(!(avatar.isEmpty)){
                
                var newavatar = BASEAPI.IMGURL + avatar
                
                if !newavatar.contains("uploads"){
                    newavatar = BASEAPI.PRFIMGURL + avatar
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
    
    @IBAction func logout(_ sender: Any) {
        
        logoutConfirmation()
        
    }

    func logoutConfirmation(){
        
        let controller = UIAlertController(title: nil, message: "Are you sure want to logout?".localized, preferredStyle: .actionSheet)
        let yes = UIAlertAction(title: "Yes".localized, style: .default) { (action) in
            
            self.logout()
        }
        
        
        
        let no = UIAlertAction(title: "No".localized, style: .cancel) { (action) in
        }
        controller.addAction(yes)
        controller.addAction(no)
        present(controller, animated: true, completion: nil)
        
    }
    
    func logout() {
        
        driverRating.value = 0.0
        
        APPDELEGATE.SundaySelectTimeArr.removeAllObjects()
        APPDELEGATE.MondaySelectTimeArr.removeAllObjects()
        APPDELEGATE.TuesdaySelectTimeArr.removeAllObjects()
        APPDELEGATE.WednesdaySelectTimeArr.removeAllObjects()
        APPDELEGATE.ThurdaySelectTimeArr.removeAllObjects()
        APPDELEGATE.FridaySelectTimeArr.removeAllObjects()
        APPDELEGATE.SaturdaySelectTimeArr.removeAllObjects()
        
        APPDELEGATE.selectedServicesArr = NSMutableArray()
        
        APPDELEGATE.drivercheckin = false
        APPDELEGATE.driverapproved = false
        
        NotificationCenter.default.removeObserver(self)
        
        APPDELEGATE.locationManager.stopUpdatingLocation()
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

