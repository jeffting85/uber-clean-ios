//
//  FeedbackViewController.swift
//  TowRoute Provider
//
//  Created by Uplogic Technologies on 18/07/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import HCSStarRatingView

class FeedbackViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableview: UITableView!
    
    var feedbackarray = NSMutableArray()
    @IBOutlet var nofeedbacklab: UILabel!
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.feedbackarray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "feedbackcell", for: indexPath) as! feedbackcell
        
        let dict = feedbackarray.object(at: indexPath.row) as! NSDictionary
        
        let img = dict.object(forKey: "avatar") as? String

        if (img != nil) && !(img == "") {

            let imageUrl: String? = BASEAPI.PRFIMGURL+img!
            cell.prfimg.sd_setImage(with: URL(string: imageUrl!), placeholderImage: #imageLiteral(resourceName: "user(1)"))

        }
        else {
            cell.prfimg.sd_setImage(with: URL(string: ""), placeholderImage: #imageLiteral(resourceName: "user(1)"))
        }

        cell.prfimg.layer.cornerRadius = (cell.prfimg.frame.size.width) / 2
        cell.prfimg.layer.masksToBounds = true
        
        cell.name.text = dict.object(forKey: "name") as? String
        cell.feedbacktxt.text = dict.object(forKey: "feedback") as? String
        
        var rating = "0"
        
        if let rat = dict["rating"] {
            
            rating = "\(dict["rating"]!)"
            
        }
        
        cell.rating.isEnabled = false
        cell.rating.value = CGFloat(Double(rating)!)
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableview.rowHeight = UITableViewAutomaticDimension;
        tableview.estimatedRowHeight = 44.0;
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.title = "USER FEEDBACK".localized
        
        driverFeedback()
        
    }
    
    func driverFeedback() {
        
        let userdict = USERDEFAULTS.getLoggedUserDetails()
        
        let userid = userdict["id"] as! String
        
        let params = ["driver_id": userid]
        
        print("params \(params)")
        
        APIManager.shared.driverFeedback(params: params as [String : AnyObject]) { (response) in
            print("responsese\(response)")
            
            if case let msg as String = response?["message"], msg == "Unauthenticated." {
                
                APIManager.shared.refreshToken(params: params as [String : AnyObject]) { (response) in
                    
                    if case let access_token as String = response?["access_token"] {
                        
                        APPDELEGATE.bearerToken = access_token
                        
                        USERDEFAULTS.set(access_token, forKey: "access_token")
                        
                        self.driverFeedback()
                        
                    }
                        
                    else {
                        
                        self.showAlertView(title: "TOWROUTE PROVIDER".localized, message: "Your session has expired. Please log in again", callback: { (check) in
                            
                            APPDELEGATE.updateLoginView()
                            
                        })
                        
                    }
                    
                }
                
            }
                
            else if case let details as NSArray = response?["data"] {
                self.feedbackarray = details.mutableCopy() as! NSMutableArray
                self.tableview.reloadData()
                
            }
            
            if self.feedbackarray.count == 0 {
                
                self.nofeedbacklab.isHidden = false
                self.tableview.isHidden = true
                
            }
            
        }
    }
    
    @IBAction func backAct(_ sender: Any) {
    
        self.navigationController?.popViewController(animated: true)
        
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


class feedbackcell: UITableViewCell {
    
    @IBOutlet var prfimg: UIImageView!
    @IBOutlet var name: UILabel!
    @IBOutlet var rating: HCSStarRatingView!
    @IBOutlet var feedbacktxt: UILabel!
    
}
