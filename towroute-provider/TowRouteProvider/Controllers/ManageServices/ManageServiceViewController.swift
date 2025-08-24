//
//  ManageServiceViewController.swift
//  TowRoute Provider
//
//  Created by Uplogic Technologies on 15/06/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class ManageServiceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var servicestr = NSMutableArray()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return servicestr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "servicecell", for: indexPath) as! servicecell
        let dict = servicestr.object(at: indexPath.row) as! NSDictionary
        
        if LanguageManager.shared.currentLanguage == .ar{
            
            cell.servicelab.text = dict.object(forKey: "category_name") as? String
        }
        else
        {
           cell.servicelab.text = dict.object(forKey: "category_name") as? String
            
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let availPage = storyboard?.instantiateViewController(withIdentifier:"servicecategory") as! ServiceCategoryViewController
        let dict = servicestr.object(at: indexPath.row) as! NSDictionary
        if LanguageManager.shared.currentLanguage == .ar{
            
            availPage.title = dict.object(forKey: "category_name") as? String
           
        }
        else
        {
            availPage.title = dict.object(forKey: "category_name") as? String
           
            
        }
        
        
        availPage.catid = "\(dict["id"]!)"
        self.navigationController?.pushViewController(availPage, animated: true)
    }

    @IBOutlet var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewCategories()
        viewAvailablity()
         self.title = "Manage Services".localized
        
      if navigation_status == "1" || navigation_status == "2"
                {
                 
                
                 //self.showAlertView(title: "Doctuber", message: "Please Select Services".localiz())
                 self.navigationItem.setHidesBackButton(true, animated:true);
                 let button1 = UIBarButtonItem(image: UIImage(named: "home"), style: .plain, target: self, action: #selector(logoutUser))
                 self.navigationItem.leftBarButtonItem  = button1
                 
             }
        
        
        // Do any additional setup after loading the view.
    }
    @objc func logoutUser(){
        
            if navigation_status == "1"
            {
       self.showAlertView(title: "TOWROUTE", message: "Oops! Please Select any Manage Service!")
            }
            else if navigation_status == "2"
            {
                //APPDELEGATE.updateLoginView()
                
        USERDEFAULTS.set(true, forKey: "login already")
                      
                  
        APPDELEGATE.updateHomeView()
                  

            }
       
    }

    func viewCategories() {
        
        let userdict = USERDEFAULTS.getLoggedUserDetails()
        
        let userid = userdict["id"] as! String
        
        let params = ["id":userid]
        
        print("params \(params)")
        
        APIManager.shared.categoriesDriver(params: params as [String : AnyObject]) { (response) in
            
            if case let msg as String = response?["message"], msg == "Unauthenticated." {
                
                APIManager.shared.refreshToken(params: params as [String : AnyObject]) { (response) in
                    
                    if case let access_token as String = response?["access_token"] {
                        
                        APPDELEGATE.bearerToken = access_token
                        
                        USERDEFAULTS.set(access_token, forKey: "access_token")
                        
                        self.viewCategories()
                        
                    }
                        
                    else {
                        
                        self.showAlertView(title: "TOWROUTE PROVIDER".localized, message: "Your session has expired. Please log in again".localiz(), callback: { (check) in
                            
                            APPDELEGATE.updateLoginView()
                            
                        })
                        
                    }
                    
                }
                
            }
                
            else if case let details as NSArray = response?["data"] {
                
                self.servicestr = details.mutableCopy() as! NSMutableArray
                
                self.tableview.reloadData()
                
            }
            
        }
        
    }
    
    func viewAvailablity() {
        
        let userdict = USERDEFAULTS.getLoggedUserDetails()
        
        let userid = userdict["id"] as! String
        
        let params = ["id":userid]
        
        print("params \(params)")
        
        APIManager.shared.allServicesDriver(params: params as [String : AnyObject]) { (response) in
            
            if case let msg as String = response?["message"], msg == "Unauthenticated." {
                
                APIManager.shared.refreshToken(params: params as [String : AnyObject]) { (response) in
                    
                    if case let access_token as String = response?["access_token"] {
                        
                        APPDELEGATE.bearerToken = access_token
                        
                        USERDEFAULTS.set(access_token, forKey: "access_token")
                        
                        self.viewAvailablity()
                        
                    }
                        
                    else {
                        
                        self.showAlertView(title: "TOWROUTE PROVIDER".localized, message: "Your session has expired. Please log in again", callback: { (check) in
                            
                            APPDELEGATE.updateLoginView()
                            
                        })
                        
                    }
                    
                }
                
            }
                
            else if case let details as NSDictionary = response?["data"] {
                
                if case let availableSlot as NSString = details["service_ids"] {
                    
                    let strdata = availableSlot.components(separatedBy: ",")
                    
                    APPDELEGATE.selectedServicesArr = NSMutableArray(array: strdata)
                    
                }
                
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

class servicecell: UITableViewCell {
    
    @IBOutlet var servicelab: UILabel!
    
}
