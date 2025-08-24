//
//  YourjobPendingViewController.swift
//  TowRoute Provider
//
//  Created by Uplogic Technologies on 23/06/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Firebase
class YourjobPendingViewController: UIViewController,IndicatorInfoProvider,UITableViewDelegate,UITableViewDataSource  {
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "PENDING".localized)
    }
    
    var pendingJobsarray = NSMutableArray()
    
    @IBOutlet var nojoblab: UILabel!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.pendingJobsarray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "pendingJobsCell", for: indexPath) as! pendingJobsCell
        
        let dict = pendingJobsarray.object(at: indexPath.row) as! NSDictionary
        
        if LanguageManager.shared.currentLanguage == .ar{
            
            cell.category.text = dict.object(forKey: "category_ar") as? String
            
            cell.category.text = cell.category.text! + " - " + (dict.object(forKey: "service_ar") as! String)
        }
        else
        {
            cell.category.text = dict.object(forKey: "category_name") as? String
            
            cell.category.text = cell.category.text! + " - " + (dict.object(forKey: "service_name") as! String)
        }
        
       
        
        cell.bookingnum.text = "Booking No# " + "\(dict["booking_id"]!)"
        
        //cell.date.text = dict.object(forKey: "job_date") as? String
        
        if LanguageManager.shared.currentLanguage == .es{
            
            cell.date.text = dict.object(forKey: "job_date") as? String
            
        }
        else{
            
            
              let date = dict.object(forKey: "job_date") as! String
                    print("chkdate\(date)")
            //
                    let fullNameArr = date.components(separatedBy: [","," ",","," "," "])
                                   let firstName: String = fullNameArr[0].capitalized
                                   let secondName: String = fullNameArr[1].capitalized
                                   let thirdname: String = fullNameArr[2]
                                    let fourthname: String = fullNameArr[3]
                                    let fifthname: String = fullNameArr[4]
                                   let sixname: String = fullNameArr[5].uppercased()
                     print("1value\(firstName),2ndvalue\(secondName),3rdvalue\(thirdname),4thvalue\(fourthname),5thvalue\(fifthname),6thvalue\(sixname)")
                                   
                    cell.date.text = firstName.localized + "," + secondName.localized + " " + fourthname + "," + thirdname + " " + fifthname + " " + sixname.localized
            
        }
        
        // let rating = "\(dict["rating"]!)"
        
        cell.address.text = dict.object(forKey: "customer_location") as? String
        
        cell.acceptbtn.tag = indexPath.row
        cell.declinebtn.tag = indexPath.row
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    @IBAction func acceptAct(_ sender: Any) {
        
        let dict = pendingJobsarray.object(at: (sender as! UIButton).tag) as! NSDictionary
        
        let params = ["booking_id": "\(dict["booking_id"]!)"]
        
        print("params \(params)")
        
        APIManager.shared.acceptJob(params: params as [String : AnyObject]) { (response) in
            print("responsese\(response)")
            
            if case let msg as String = response?["message"], msg == "Unauthenticated." {
                
                APIManager.shared.refreshToken(params: params as [String : AnyObject]) { (response) in
                    
                    if case let access_token as String = response?["access_token"] {
                        
                        APPDELEGATE.bearerToken = access_token
                        
                        USERDEFAULTS.set(access_token, forKey: "access_token")
                        
                        self.acceptAct(self)
                        
                    }
                        
                    else {
                        
                        self.showAlertView(title: "TOWROUTE PROVIDER".localized, message: "Your session has expired. Please log in again", callback: { (check) in
                            
                            APPDELEGATE.updateLoginView()
                            
                        })
                        
                    }
                    
                }
                
            }
                
            else if case let msg as String = response?["message"], msg == "successfully updated" {
                
                let yourjob = self.storyboard?.instantiateViewController(withIdentifier:"yourjob") as! YourjobParentViewController
                self.slideMenuController()?.closeLeft()
                self.slideMenuController()?.closeRight()
                yourjob.acceptjob = true
                (self.slideMenuController()?.mainViewController as! UINavigationController).pushViewController(yourjob, animated: true)
//                self.upcomingJobs()
                
            }
            
        }
    }
    
    @IBAction func declineAct(_ sender: Any) {
        
        let dict = pendingJobsarray.object(at: (sender as! UIButton).tag) as! NSDictionary
        
        let params = ["booking_id": "\(dict["booking_id"]!)",
                      "mode": "driver"]
        
        print("params \(params)")
        
        APIManager.shared.declineJob(params: params as [String : AnyObject]) { (response) in
            print("responsese\(response)")
            
            if case let msg as String = response?["message"], msg == "Unauthenticated." {
                
                APIManager.shared.refreshToken(params: params as [String : AnyObject]) { (response) in
                    
                    if case let access_token as String = response?["access_token"] {
                        
                        APPDELEGATE.bearerToken = access_token
                        
                        USERDEFAULTS.set(access_token, forKey: "access_token")
                        
                        self.declineAct(self)
                        
                    }
                        
                    else {
                        
                        self.showAlertView(title: "TOWROUTE PROVIDER".localized, message: "Your session has expired. Please log in again", callback: { (check) in
                            
                            APPDELEGATE.updateLoginView()
                            
                        })
                        
                    }
                    
                }
                
            }
                
            else if case let msg as String = response?["message"], msg == "successfully updated" || msg == "Cancelled successfully." {
                
                self.upcomingJobs()
                
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
        
    }
    
    @IBOutlet var tableview: UITableView!
    var pendingRef: DatabaseReference! = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableview.rowHeight = UITableViewAutomaticDimension;
        tableview.estimatedRowHeight = 44.0;
        
        
        let fireRef = Database.database().reference()
        pendingRef = fireRef.child("providers").child(driver_id)
        pendingRef.observe(DataEventType.value) { (SnapShot: DataSnapshot) in
            print("SnapShot \(SnapShot.value)")
            
            if let dict = SnapShot.value as? NSDictionary {
                
                if let status = dict["pending"] {
                    
                    let state = "\(dict["pending"]!)"
                    
                    if state == "0"
                    {
                        self.upcomingJobs()
                      //  NotificationCenter.default.post(name: Notification.Name("jobalert"), object: nil)
                    }
                    else
                    {
                        
                        self.upcomingJobs()
                      //  NotificationCenter.default.post(name: Notification.Name("jobalert"), object: nil)
                    }
                    
                }
        // Do any additional setup after loading the view.
    }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        upcomingJobs()
        
    }
    
    
    
    func upcomingJobs() {
        
        let userdict = USERDEFAULTS.getLoggedUserDetails()
        
        let userid = userdict["id"] as! String
        
        let params = ["user_id": userid,
                      "mode": "driver"]
        
        print("params \(params)")
        
        APIManager.shared.pendingJobs(params: params as [String : AnyObject]) { (response) in
            print("responsese\(response)")
            
            if case let msg as String = response?["message"], msg == "Unauthenticated." {
                
                APIManager.shared.refreshToken(params: params as [String : AnyObject]) { (response) in
                    
                    if case let access_token as String = response?["access_token"] {
                        
                        APPDELEGATE.bearerToken = access_token
                        
                        USERDEFAULTS.set(access_token, forKey: "access_token")
                        
                        self.upcomingJobs()
                        
                    }
                        
                    else {
                        
                        self.showAlertView(title: "TOWROUTE PROVIDER".localized, message: "Your session has expired. Please log in again", callback: { (check) in
                            
                            APPDELEGATE.updateLoginView()
                            
                        })
                        
                    }
                    
                }
                
            }
                
            else if case let details as NSArray = response?["service_request"] {
                self.pendingJobsarray = details.mutableCopy() as! NSMutableArray
                self.tableview.reloadData()
                self.nojoblab.isHidden = true
            }
            
            if self.pendingJobsarray.count == 0 {
                
                self.nojoblab.isHidden = false
                self.tableview.isHidden = true
                
            }
            else {
                
                self.tableview.isHidden = false
                
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

class pendingJobsCell: UITableViewCell {
    
    @IBOutlet var status: UILabel!
    @IBOutlet var address: UILabel!
    @IBOutlet var date: UILabel!
    @IBOutlet var category: UILabel!
    @IBOutlet var bookingnum: UILabel!
    @IBOutlet var acceptbtn: UIButton!
    @IBOutlet var declinebtn: UIButton!
    
}

