//
//  EmergencycontactViewController.swift
//  TowRoute Provider
//
//  Created by Admin on 07/06/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import ContactsUI

class EmergencycontactViewController: UIViewController,CNContactPickerDelegate,UITableViewDelegate,UITableViewDataSource  {
  

    @IBOutlet var tableview: UITableView!
    var name = ""
    var number = ""
    
    var contactcat = NSMutableArray()
    @IBOutlet var addbtn: UIButton!
    @IBOutlet var addlab: UILabel!
    
    @IBOutlet var bottomcons: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//addMenu()
        
        getContact()
        
        self.tableview.isHidden = true
        
        self.title = "EMERGENCY CONTACTS".localized
        
    }
    
    func getContact() {
        
        let userdict = USERDEFAULTS.getLoggedUserDetails()
        
        let userid = userdict["id"] as! String
        
        let params = ["driver_id":userid]
        
        print("params \(params)")
        
        APIManager.shared.contactGet(params: params as [String : AnyObject]) { (response) in
            
            print("responseveess\(response)")
            if case let msg as String = response?["message"], msg == "Unauthenticated." {
                
                APIManager.shared.refreshToken(params: params as [String : AnyObject]) { (response) in
                    
                    if case let access_token as String = response?["access_token"] {
                        
                        APPDELEGATE.bearerToken = access_token
                        
                        USERDEFAULTS.set(access_token, forKey: "access_token")
                        
                        
                    }
                    
                    else {
                        
                        self.showAlertView(title: "TOWROUTE PROVIDER".localized, message: "Your session has expired. Please log in again", callback: { (check) in
                            
                            APPDELEGATE.updateLoginView()
                            
                        })
                        
                    }
                    
                }
            }
            else if case let details as NSArray = response?["data"], details.count > 0 {
                
                if details.count >= 5 {
                    
                    self.bottomcons.constant = -112
                    
                    self.addbtn.isHidden = true
                    self.addlab.isHidden = true
                    
                }
                else {
                    
                    self.bottomcons.constant = 32
                    
                    self.addbtn.isHidden = false
                    self.addlab.isHidden = false
                    
                }
                
                self.tableview.isHidden = false
                
                print("details \(details)")
                
                self.contactcat = details.mutableCopy() as! NSMutableArray
                
                print("self.contactcat \(self.contactcat)")
                
                self.tableview.reloadData()
                
            }
            else {
                
                self.tableview.isHidden = true
                
            }
            
            
            // Do any additional setup after loading the view.
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactcat.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell = tableView.dequeueReusableCell(withIdentifier: "contact") as! menucontactcell
        let dict = contactcat.object(at: indexPath.row) as!NSDictionary
        print("dictdict \(dict)")
        cell.contactname.text = dict.object(forKey: "contact_name") as? String
        print(cell.contactname.text)
        cell.contactnum.text = dict.object(forKey: "phone_number") as? String
        print("checkinh\(cell.contactnum.text)")
        let contid = dict.object(forKey: "id") as! NSNumber
        cell.delete.tag = Int(contid)
        cell.delete.addTarget(self, action: #selector(EmergencycontactViewController.deleted(_:)), for: UIControlEvents.touchUpInside)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }

    @IBAction func contacts(_ sender: Any) {
        
        
        if contactcat.count < 5 {
            
            let cnPicker = CNContactPickerViewController()
            cnPicker.delegate = self
            self.present(cnPicker, animated: true, completion: nil)
            
        }
        
        
    }
    
    @objc func deleted(_ btn: UIButton){
        
        
        let userdict = USERDEFAULTS.getLoggedUserDetails()
        
        let userid = "\(btn.tag)"
        
        let params = ["contact_id":userid]
        
        print("params \(params)")
        
        APIManager.shared.contactDelete(params: params as [String : AnyObject]) { (response) in
            self.tableview.isHidden = false
            print("responseve\(response)")
            if case let msg as String = response?["message"], msg == "Unauthenticated." {
                
                APIManager.shared.refreshToken(params: params as [String : AnyObject]) { (response) in
                    
                    if case let access_token as String = response?["access_token"] {
                        
                        APPDELEGATE.bearerToken = access_token
                        
                        USERDEFAULTS.set(access_token, forKey: "access_token")
                        
                        
                    }
                    
                    else {
                        
                        self.showAlertView(title: "TOWROUTE PROVIDER".localized, message: "Your session has expired. Please log in again", callback: { (check) in
                            
                            APPDELEGATE.updateLoginView()
                            
                        })
                        
                    }
                    
                }
                
            }
                
            else if case let msg as String = response?["message"] {
                
                self.getContact()
                
                self.showAlertView(message: msg.localized)
                
            }
            
        }
        
        
        
    }
    
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        
        if contact.isKeyAvailable(CNContactPhoneNumbersKey)
        {
            
                let con = contact.mutableCopy() as! CNMutableContact
                
                let firstName = con.value(forKey: "givenName") as! String
                let lastName = con.value(forKey: "familyName") as! String
                 name = firstName + lastName
                print("firstttt\(name)")
                let valPairs = (con.phoneNumbers[0].value(forKey: "labelValuePair") as AnyObject)
                print("valpairss\(valPairs)")
                let value = valPairs.value(forKey: "value") as AnyObject
                //Mobile No
                print("valuuuee\(value)")
                number = value.value(forKey: "stringValue") as! String
                print(value.value(forKey: "stringValue"))
                print("numbercustomer\(number)")
                ////////////////////////////////////////////////////
                
                let userdict = USERDEFAULTS.getLoggedUserDetails()
                
                let userid = userdict["id"] as! String
                
                let params = ["driver_id":userid,
                              "contact_name":name,
                              "phone_number":number,
                              "status":"1"]
                
                print("params \(params)")
                
                APIManager.shared.contactAdd(params: params as [String : AnyObject]) { (response) in
                    self.tableview.isHidden = false
                    print("responseve\(response)")
                    if case let msg as String = response?["message"], msg == "Unauthenticated." {
                        
                        APIManager.shared.refreshToken(params: params as [String : AnyObject]) { (response) in
                            
                            if case let access_token as String = response?["access_token"] {
                                
                                APPDELEGATE.bearerToken = access_token
                                
                                USERDEFAULTS.set(access_token, forKey: "access_token")
                               
                                
                            }
                            
                            else {
                                
                                self.showAlertView(title: "TOWROUTE PROVIDER".localized, message: "Your session has expired. Please log in again", callback: { (check) in
                                    
                                    APPDELEGATE.updateLoginView()
                                    
                                })
                                
                            }
                            
                        }
                        
                    }
                    
                    else if case let msg as String = response?["message"] {
                        
                        self.getContact()
                        
                        self.showAlertView(message: msg.localized)
                        
                    }
                    
                }
                
                
                /////////////////////////////////////////////////////
              
                
                if con.emailAddresses.count > 0 {
                    let mailPair = (con.emailAddresses[0].value(forKey: "labelValuePair") as AnyObject)
                    print("ccoonttact")
                    print(mailPair.value(forKey: "value"))
                    let maill = mailPair.value(forKey: "value")
                   
                    
                }
                
                
            }
            else
            {
                print("No phone numbers are available")
            }
    }
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        print("Cancel Contact Picker")
    }
    
    var ispresent = false
    
    @IBAction func backact(_ sender: Any) {
        if ispresent == true {
            self.dismiss(animated: true, completion: nil)
        }
        else {
            self.navigationController?.popViewController(animated: true)
        }
        
        //self.dismiss(animated: true, completion: nil)
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

class menucontactcell: UITableViewCell{
    
    @IBOutlet var contactname: UILabel!
    
    @IBOutlet var contactnum: UILabel!
    
    @IBOutlet var delete: UIButton!
    
}
