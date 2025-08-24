//
//  YourjobViewController.swift
//  TowRoute User
//
//  Created by Admin on 07/06/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import Material
import XLPagerTabStrip

class YourjobPastViewController: UIViewController,IndicatorInfoProvider,TextFieldDelegate,UITableViewDelegate,UITableViewDataSource {
    
    var pastJobsarray = NSMutableArray()
    
    @IBOutlet var nojoblab: UILabel!
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "PAST".localized)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.pastJobsarray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "passJobsCell", for: indexPath) as! passJobsCell
        
        let dict = pastJobsarray.object(at: indexPath.row) as! NSDictionary
        
        
        if LanguageManager.shared.currentLanguage == .ar{
            
            cell.category.text = dict.object(forKey: "category_ar") as? String
            
            cell.category.text = cell.category.text! + " - " + (dict.object(forKey: "service_ar") as! String)
        }
        else
        {
            cell.category.text = dict.object(forKey: "category_name") as? String
            
            cell.category.text = cell.category.text! + " - " + (dict.object(forKey: "service_name") as! String)
        }
        
        
        
        cell.bookingnum.text = "Booking No#".localized + " \(dict["booking_id"]!)"
        
        
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
        
        let status = "\(dict["service_status"]!)"
        
        if status == "6" {
            
            cell.status.text = "Finished".localized
            
        }
        else if status == "8"
        {
            cell.status.text = "Job Cancelled by User".localized
        }
        else if status == "9"
        {
            cell.status.text = "Job Cancelled by Driver".localized
        }
        else if status == "14"
        {
            cell.status.text = "Schedule Job Cancelled by User".localized
        }
        else if status == "15"
        {
            cell.status.text = "Schedule Job Cancelled by Driver".localized
        }
            
        else {
            
            cell.status.text = "Not Completed".localized
            
        }
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let dict = pastJobsarray.object(at: indexPath.row) as! NSDictionary
        let status = "\(dict["service_status"]!)"
        
        if status == "6" {
            
            let viewcon = self.storyboard?.instantiateViewController(withIdentifier: "FareSummary") as! FareSummaryViewController
            viewcon.totalval = "\(dict["total_amount"]!)"
            viewcon.jobdate = "\(dict["job_date"]!)"
            viewcon.discount = "\(dict["driver_discount"]!)"
            viewcon.payment = "\(dict["payment_type"]!)"
            
            
            if LanguageManager.shared.currentLanguage == .ar{
                
                  viewcon.cat = "\(dict["category_ar"]!)"
            }
            else
            {
                 viewcon.cat = "\(dict["category_name"]!)"
                
            }
            
          
            viewcon.cur = "\(dict["sub_level_amount"]!)"
            viewcon.tot = "\(dict["total_amount"]!)"
            viewcon.driver_id = "\(dict["driver_id"]!)"
            viewcon.booking_id = "\(dict["booking_id"]!)"
            
            viewcon.mat = "\(dict["extra_charge"]!)"
            viewcon.misc = "\(dict["misc_charge"]!)"
            viewcon.discounttext = "\(dict["driver_discount"]!)"
            viewcon.tripRating = "\(dict["rating"]!)"
            
            viewcon.rating_status = "\(dict["rating_status"]!)"
            viewcon.driver_name = "\(dict["driver_name"]!)"
            viewcon.job_loc = "\(dict["customer_location"]!)"
            viewcon.rating_status = "\(dict["rating_status"]!)"
            viewcon.imgurl = "\(dict["driver_avatar"]!)"
            
            if let promo = dict["promo_discount"]{
                
                viewcon.prmocode = "\(dict["promo_discount"]!)"
                
            }
           
            if let drop = dict["drop_location"]
            {
                viewcon.drop_location = "\(dict["drop_location"]!)"
            }
            
           
            
            viewcon.visit_fare = "\(dict["visit_fare"]!)"
            viewcon.price_per_km = "\(dict["price_per_km"]!)"
            viewcon.sub_level_amount = "\(dict["sub_level_amount"]!)"
            viewcon.distances = "\(dict["total_distance"]!)"
            
            self.present(viewcon, animated: true, completion: nil)
            
        }
        
        
    }
    
    @IBOutlet var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableview.rowHeight = UITableViewAutomaticDimension;
        tableview.estimatedRowHeight = 44.0;
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        pastJobs()
        
    }
    
    func pastJobs() {
        
        let userdict = USERDEFAULTS.getLoggedUserDetails()
        
        let userid = userdict["id"] as! String
        
        let params = ["user_id": userid,
                      "mode": "customer"]
        
        print("params \(params)")
        
        APIManager.shared.pastJobs(params: params as [String : AnyObject]) { (response) in
            print("responsese\(response)")
            
            if case let msg as String = response?["message"], msg == "Unauthenticated." {
                
                APIManager.shared.refreshToken(params: params as [String : AnyObject]) { (response) in
                    
                    if case let access_token as String = response?["access_token"] {
                        
                        APPDELEGATE.bearerToken = access_token
                        
                        USERDEFAULTS.set(access_token, forKey: "access_token")
                        
                        self.pastJobs()
                        
                    }
                        
                    else {
                        
                        self.showAlertView(title: "TowRoute".localized, message: "Your session has expired. Please log in again", callback: { (check) in
                            
                            APPDELEGATE.updateLoginView()
                            
                        })
                        
                    }
                    
                }
                
            }
                
            else if case let details as NSArray = response?["service_request"] {
                self.pastJobsarray = details.mutableCopy() as! NSMutableArray
                self.tableview.reloadData()
                self.nojoblab.isHidden = true
            }
            
            if self.pastJobsarray.count == 0 {
                
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


class passJobsCell: UITableViewCell {
    
    @IBOutlet var status: UILabel!
    @IBOutlet var address: UILabel!
    @IBOutlet var date: UILabel!
    @IBOutlet var category: UILabel!
    @IBOutlet var bookingnum: UILabel!
    @IBOutlet var statuslab: UILabel!
    
}
