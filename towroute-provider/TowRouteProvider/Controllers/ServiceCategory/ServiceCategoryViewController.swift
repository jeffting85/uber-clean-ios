//
//  ServiceCategoryViewController.swift
//  TowRoute Provider
//
//  Created by Uplogic Technologies on 15/06/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import Firebase

class ServiceCategoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var subcat = NSMutableArray()
    
    var catid = ""
    
    var selectedServices = NSMutableArray()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subcat.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "servicecatcell", for: indexPath) as! servicecategorycell
        
        let dict = subcat.object(at: indexPath.row) as! NSDictionary
        
        if LanguageManager.shared.currentLanguage == .ar{
            
            cell.servicecatlab.text = dict.object(forKey: "service_name") as? String
            
        }
        else
        {
            cell.servicecatlab.text = dict.object(forKey: "service_name") as? String
            
            
        }
        
        
        
        let serviceID = "\(dict["id"]!)"
        
        if selectedServices.contains(serviceID) {
            
          cell.img.image = #imageLiteral(resourceName: "checked")
            
        }
        else {
            
         cell.img.image = #imageLiteral(resourceName: "un_check")
            
        }
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let dict = subcat.object(at: indexPath.row) as! NSDictionary
        let serviceID = "\(dict["id"]!)"
        
        if selectedServices.contains(serviceID) {
            selectedServices.remove(serviceID)
        }
        else {
            selectedServices.add(serviceID)
        }
        tableView.reloadData()
    }

    @IBOutlet var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewCategories()
        
        selectedServices = APPDELEGATE.selectedServicesArr.mutableCopy() as! NSMutableArray
        
        // Do any additional setup after loading the view.
    }

    func viewCategories() {
        
        let userdict = USERDEFAULTS.getLoggedUserDetails()
        
        let userid = userdict["id"] as! String
        
        let params = ["id":catid]
        
        print("params \(params)")
        
        APIManager.shared.subCategoriesDriver(params: params as [String : AnyObject]) { (response) in
            
            if case let msg as String = response?["message"], msg == "Unauthenticated." {
                
                APIManager.shared.refreshToken(params: params as [String : AnyObject]) { (response) in
                    
                    if case let access_token as String = response?["access_token"] {
                        
                        APPDELEGATE.bearerToken = access_token
                        
                        USERDEFAULTS.set(access_token, forKey: "access_token")
                        
                        self.viewCategories()
                        
                    }
                        
                    else {
                        
                        self.showAlertView(title: "TOWROUTE PROVIDER".localized, message: "Your session has expired. Please log in again", callback: { (check) in
                            
                            APPDELEGATE.updateLoginView()
                            
                        })
                        
                    }
                    
                }
                
            }
                
            else if case let details as NSArray = response?["data"] {
                
                self.subcat = details.mutableCopy() as! NSMutableArray
                
                self.tableview.reloadData()
                
            }
            
        }
        
    }
    
    @IBAction func updateAct(_ sender: Any) {
        
        let userdict = USERDEFAULTS.getLoggedUserDetails()
        
        let userid = userdict["id"] as! String
        
        APPDELEGATE.selectedServicesArr = selectedServices.mutableCopy() as! NSMutableArray
        
        let strdata = selectedServices.componentsJoined(by: ",")
        
        let params = ["id":userid,
                      "service_ids": strdata]
        
        print("params \(params)")
        
        APIManager.shared.updateService(params: params as [String : AnyObject]) { (response) in
            
            if case let msg as String = response?["message"], msg == "Unauthenticated." {
                
                APIManager.shared.refreshToken(params: params as [String : AnyObject]) { (response) in
                    
                    if case let access_token as String = response?["access_token"] {
                        
                        APPDELEGATE.bearerToken = access_token
                        
                        USERDEFAULTS.set(access_token, forKey: "access_token")
                        
                        self.updateAct(self)
                        
                    }
                        
                    else {
                        
                        self.showAlertView(title: "TOWROUTE PROVIDER".localized, message: "Your session has expired. Please log in again", callback: { (check) in
                            
                            APPDELEGATE.updateLoginView()
                            
                        })
                        
                    }
                    
                }
                
            }
                
            else if case let msg as String = response?["message"] {
                
                // self.showAlertView(message: msg)
                
                if USERDEFAULTS.bool(forKey: "login already") {
                        self.showAlertView(title: "TOWROUTE PROVIDER", message: "Category Updated".localized, callback: { (check) in
                            
                            
                            
                             self.navigationController?.popViewController(animated: true)
                            
                        })
                        
                            
                        }
                
                    else {
                       
                     //   USERDEFAULTS.set(true, forKey: "login already")
                         navigation_status = "2"
                        self.showAlertView(title: " TOWROUTE PROVIDER".localized, message: "Category Updated".localized, callback: { (check) in
                            self.navigationController?.popViewController(animated: true)
                           // APPDELEGATE.updateLoginView()
                            
                        })
                      
                        
                    }
                
                
                
                
                
                
                
                
                Database.database().reference().child("providers").child(driver_id).child("category").setValue(strdata)
                
                //self.navigationController?.popViewController(animated: true)
                
                
                
            }
            
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


class servicecategorycell: UITableViewCell {
    
    @IBOutlet var img: UIImageView!
    @IBOutlet var servicecatlab: UILabel!
    
}
