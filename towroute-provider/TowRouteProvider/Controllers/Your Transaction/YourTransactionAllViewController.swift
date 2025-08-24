//
//  YourTransactionAllViewController.swift
//  TowRoute Provider
//
//  Created by Uplogic Technologies on 20/07/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class YourTransactionAllViewController: UIViewController,IndicatorInfoProvider,UITableViewDelegate,UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    var transactionarray = NSMutableArray()
    
    @IBOutlet var nojoblab: UILabel!
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "ALL".localized)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.transactionarray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "transactionCell", for: indexPath) as! transactionCell
        
        let dict = transactionarray.object(at: indexPath.row) as! NSDictionary
        
        let transaction_type = dict.object(forKey: "transaction_type") as! String
        
        if transaction_type == "credit" {
            cell.img.image = #imageLiteral(resourceName: "upload")
        }
        else {
            cell.img.image = #imageLiteral(resourceName: "download-2")
        }
        
        cell.amount.text = "\(currency_symbol!) " + "\(dict["transaction_amount"]!)".convertCur()
        
        if LanguageManager.shared.currentLanguage == .ar{
            
           cell.type.text = dict.object(forKey: "transaction_notes_ar") as? String
            
        }
        else
        {
           cell.type.text = dict.object(forKey: "transaction_notes") as? String
        }
   
        cell.date.text = dict.object(forKey: "transaction_date") as? String
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    @IBOutlet var tableview: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        
        transactions()
        
    }
    
    func transactions() {
        
        let userdict = USERDEFAULTS.getLoggedUserDetails()
        
        let userid = userdict["id"] as! String
        
        let params = ["driver_id": userid]
        
        print("params \(params)")
        
        APIManager.shared.transaction(params: params as [String : AnyObject]) { (response) in
            print("responsese\(response)")
            
            if case let msg as String = response?["message"], msg == "Unauthenticated." {
                
                APIManager.shared.refreshToken(params: params as [String : AnyObject]) { (response) in
                    
                    if case let access_token as String = response?["access_token"] {
                        
                        APPDELEGATE.bearerToken = access_token
                        
                        USERDEFAULTS.set(access_token, forKey: "access_token")
                        
                        self.transactions()
                        
                    }
                        
                    else {
                        
                        self.showAlertView(title: "TOWROUTE PROVIDER".localized, message: "Your session has expired. Please log in again", callback: { (check) in
                            
                            APPDELEGATE.updateLoginView()
                            
                        })
                        
                    }
                    
                }
                
            }
                
            else if case let details as NSArray = response?["data"] {
                self.transactionarray = details.mutableCopy() as! NSMutableArray
                self.tableview.reloadData()
                self.nojoblab.isHidden = true
            }
            
            if self.transactionarray.count == 0 {
                
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

class transactionCell: UITableViewCell {
    
    @IBOutlet var img: UIImageView!
    @IBOutlet var amount: UILabel!
    @IBOutlet var type: UILabel!
    @IBOutlet var date: UILabel!
    
    
}
