//
//  YourjobUpcomingViewController.swift
//  TowRoute User
//
//  Created by Admin on 07/06/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import Material
import XLPagerTabStrip
import MessageUI


class YourjobUpcomingViewController: UIViewController,IndicatorInfoProvider,TextFieldDelegate,UITableViewDelegate,UITableViewDataSource, MFMessageComposeViewControllerDelegate  {
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
    self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet var nojoblab: UILabel!
    
    
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "UPCOMING".localized)
    }
    
    var upcomingJobsarray = NSMutableArray()
    var drv_number = ""
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.upcomingJobsarray.count
        
    }
    
    var textField = UITextField()
    
    func configurationTextField(textField: UITextField!)
    {
        print("configurate hire the TextField")
        
        if let tField = textField {
            
            self.textField = textField!        //Save reference to the UITextField
            self.textField.placeholder = "Enter your reason".localized
        }
        
    }
    
    func handleCancel(alertView: UIAlertAction!)
    {
        print("User click Cancel button")
        print(self.textField.text)
        
        if self.textField.text == "" {
            
            self.showAlertView(message: "Please enter your reason!".localized)
            return
            
        }
        
        let params = ["booking_id": cancelBookingID,
                      "reason": self.textField.text!,
                      "mode": "customer"]
        
        print("params \(params)")
        
        APIManager.shared.declineJob(params: params as [String : AnyObject]) { (response) in
            print("responsese\(response)")
            
            if case let msg as String = response?["message"], msg == "Unauthenticated." {
                
                APIManager.shared.refreshToken(params: params as [String : AnyObject]) { (response) in
                    
                    if case let access_token as String = response?["access_token"] {
                        
                        APPDELEGATE.bearerToken = access_token
                        
                        USERDEFAULTS.set(access_token, forKey: "access_token")
                        
                        self.handleCancel(alertView: alertView)
                        
                    }
                        
                    else {
                        
                        self.showAlertView(title: "TowRoute".localized, message: "Your session has expired. Please log in again", callback: { (check) in
                            
                            APPDELEGATE.updateLoginView()
                            
                        })
                        
                    }
                    
                }
                
            }
                
            else if case let msg as String = response?["message"], msg == "Cancelled successfully." {
                
                self.upcomingJobs()
                
            }
            
        }
        
    }
    
    var cancelBookingID = ""
    
    
    
    
    
    
    @IBAction func cancelJobs(_ sender: Any) {
        
        let dict = upcomingJobsarray.object(at: (sender as! UIButton).tag) as! NSDictionary
        
        cancelBookingID = "\(dict["booking_id"]!)"
        
        var alert = UIAlertController(title: "", message: "Cancel Job".localized, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addTextField(configurationHandler: configurationTextField)
        
        alert.addAction(UIAlertAction(title: "CONTINUE JOB".localized, style: UIAlertActionStyle.default, handler:{ (UIAlertAction)in
            print("User click Ok button")
        }))
        alert.addAction(UIAlertAction(title: "CANCEL JOB".localized, style: UIAlertActionStyle.cancel, handler:handleCancel))
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "upcomingJobsCell", for: indexPath) as! upcomingJobsCell
        
        let dict = upcomingJobsarray.object(at: indexPath.row) as! NSDictionary
        print("chk_dict\(dict)")
        
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
        cell.providername.text = "Name :" + "\(dict["driver_name"]!)"  //dict.object(forKey: "driver_name") as? String
        cell.providercontact.text = "Phone :" + "\(dict["driver_phone_number"]!)" //dict.object(forKey: "driver_phone_number") as? String
        print("chkcell.providercontact.text\(cell.providercontact.text)")
        drv_number = "\(dict["driver_phone_number"]!)"
        
        
       // cell.date.text = dict.object(forKey: "job_date") as? String
        
        cell.call.tag = indexPath.row
        cell.call.addTarget(self, action: #selector(call), for: .touchUpInside)
        
        cell.message.tag = indexPath.row
        cell.message.addTarget(self, action: #selector(message), for: .touchUpInside)
        
        
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
        
        cell.cancelbtn.tag = indexPath.row
        
        let status = "\(dict["service_status"]!)"
        
        if status == "14" {
            cell.Pending_status.isHidden = true
            cell.cancelbtn.isHidden = true
            cell.statuslab.isHidden = false
            cell.statuslb.isHidden = false
            cell.statuslab.text = "Job Cancelled".localized
            
        }
        else if status == "15" {
            
            cell.Pending_status.isHidden = true
            cell.cancelbtn.isHidden = true
            cell.statuslab.isHidden = false
            cell.statuslb.isHidden = false
            cell.statuslab.text = "Driver has Cancelled Job".localized
            
        }
        else if status == "13" {
            
            cell.Pending_status.isHidden = true
            cell.cancelbtn.isHidden = true
            cell.statuslab.isHidden = false
            cell.statuslb.isHidden = false
            cell.statuslab.text = "Accepted".localized
            cell.statuslab.textColor = .green
            
        }
        else {
            cell.Pending_status.isHidden = false
            cell.cancelbtn.isHidden = false
            cell.statuslab.isHidden = true
            cell.statuslb.isHidden = true
            
        }
        
        cell.selectionStyle = .none
        
        
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
       // return UITableViewAutomaticDimension
        
        return 350
        
    }
    
    @IBOutlet var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableview.rowHeight = UITableViewAutomaticDimension;
        tableview.estimatedRowHeight = 44.0;
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        upcomingJobs()
        
    }
    
    func upcomingJobs() {
        
        let userdict = USERDEFAULTS.getLoggedUserDetails()
        
        let userid = userdict["id"] as! String
        
        let params = ["user_id": userid,
                      "mode": "customer"]
        
        print("params \(params)")
        
        APIManager.shared.upcomingJobs(params: params as [String : AnyObject]) { (response) in
            print("responsese\(response)")
            
            if case let msg as String = response?["message"], msg == "Unauthenticated." {
                
                APIManager.shared.refreshToken(params: params as [String : AnyObject]) { (response) in
                    
                    if case let access_token as String = response?["access_token"] {
                        
                        APPDELEGATE.bearerToken = access_token
                        
                        USERDEFAULTS.set(access_token, forKey: "access_token")
                        
                        self.upcomingJobs()
                        
                    }
                        
                    else {
                        
                        self.showAlertView(title: "TowRoute".localized, message: "Your session has expired. Please log in again", callback: { (check) in
                            
                            APPDELEGATE.updateLoginView()
                            
                        })
                        
                    }
                    
                }
                
            }
                
            else if case let details as NSArray = response?["service_request"] {
                self.upcomingJobsarray = details.mutableCopy() as! NSMutableArray
                self.tableview.reloadData()
                self.nojoblab.isHidden = true
            }
            
            if self.upcomingJobsarray.count == 0 {
                
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
    @objc func call(sender: UIButton){
        print(sender.tag)
        let dict = upcomingJobsarray.object(at: sender.tag) as! NSDictionary
        drv_number = "\(dict["driver_phone_number"]!)"
        if let url = URL(string: "tel://\(drv_number)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
        
    }
    
    @objc func message(sender: UIButton){
        print(sender.tag)
        let dict = upcomingJobsarray.object(at: sender.tag) as! NSDictionary
        drv_number = "\(dict["driver_phone_number"]!)"
        if (MFMessageComposeViewController.canSendText()) {
        let controller = MFMessageComposeViewController()
        // controller.body = "Message Body"
            print("chkdriver_mob_no\(drv_number)")
        controller.recipients = ["\(drv_number)"]
        //controller.recipients = [phoneNumber.text]
        controller.messageComposeDelegate = self
        self.present(controller, animated: true, completion: nil)
        }
    }
    
}

class upcomingJobsCell: UITableViewCell {
    
    
    @IBOutlet weak var message: UIButton!
    
    @IBOutlet weak var Pending_status: UILabel!
    @IBOutlet weak var call: UIButton!
    @IBOutlet var providername: UILabel!
     @IBOutlet var providercontact: UILabel!
    @IBOutlet var status: UILabel!
    @IBOutlet var address: UILabel!
    @IBOutlet var date: UILabel!
    @IBOutlet var category: UILabel!
    @IBOutlet var bookingnum: UILabel!
    @IBOutlet var cancelbtn: UIButton!
    @IBOutlet var statuslab: UILabel!
    @IBOutlet var statuslb: UILabel!
    
}
