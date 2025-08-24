//
//  AvailabilityViewController.swift
//  TowRoute Provider
//
//  Created by Uplogic Technologies on 14/06/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class AvailabilityViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let daysStr = ["Sun","Mon","Tue","Wed","Thu","Fri","Sat"]
    let dayStr = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"]
    var selectTimeArr = [String]()
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return daysStr.count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dayscell", for: indexPath) as! daysCollection
        
        cell.daylab.text = daysStr[indexPath.row].localized
        
        let val = daysStr[indexPath.row]
        
        if selectTimeArr.contains(val)
        {
            cell.daylab.backgroundColor = UIColor(hex: "00d5ff") //cd1f01
            cell.daylab.textColor = UIColor.black
        }
            
        else
        {
            cell.daylab.backgroundColor = UIColor.white
            cell.daylab.textColor = UIColor.black
        }
       
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        
        let cell = collectionview.cellForItem(at: indexPath) as! daysCollection
        let lastCellColor = UIColor.white
        if cell.isSelected {
            cell.daylab.backgroundColor = UIColor(hex: "00d5ff")
            cell.daylab.textColor = UIColor.black
            
        } else {cell.backgroundColor = lastCellColor}
    
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            
            let availPage = self.storyboard?.instantiateViewController(withIdentifier:"timeslot")
            timeslottitle = self.dayStr[indexPath.row]
            self.navigationController?.pushViewController(availPage!, animated: true)
           
        }
        
        
    }
    
    



    @IBOutlet var collectionview: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

       self.title = "My Availability".localized
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
         viewAvailablity()
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
                
                if case let availableSlot as NSDictionary = details["availble_slots"] {
                    
                    print("availableSlot \(availableSlot)")
                    
                    if case let arr as NSArray = availableSlot["Friday"] {
                        
                      
                        if arr.count > 0 {
                              self.selectTimeArr.append("Fri")
                        }
                        APPDELEGATE.FridaySelectTimeArr = arr.mutableCopy() as! NSMutableArray
                        
                    }
                    
                    if case let arr as NSArray = availableSlot["Monday"] {
                        if arr.count > 0 {
                            self.selectTimeArr.append("Mon")
                        }
                        APPDELEGATE.MondaySelectTimeArr = arr.mutableCopy() as! NSMutableArray
                        
                    }
                    
                    if case let arr as NSArray = availableSlot["Saturday"] {
                        if arr.count > 0 {
                            self.selectTimeArr.append("Sat")
                        }
                        
                        APPDELEGATE.SaturdaySelectTimeArr = arr.mutableCopy() as! NSMutableArray
                        
                    }
                    
                    if case let arr as NSArray = availableSlot["Sunday"] {
                        if arr.count > 0 {
                            self.selectTimeArr.append("Sun")
                        }
                        
                        APPDELEGATE.SundaySelectTimeArr = arr.mutableCopy() as! NSMutableArray
                        
                    }
                    
                    if case let arr as NSArray = availableSlot["Thursday"] {
                        if arr.count > 0 {
                            self.selectTimeArr.append("Thu")
                        }
                        APPDELEGATE.ThurdaySelectTimeArr = arr.mutableCopy() as! NSMutableArray
                        
                    }
                    
                    if case let arr as NSArray = availableSlot["Tuesday"] {
                        if arr.count > 0 {
                            self.selectTimeArr.append("Tue")
                        }
                        APPDELEGATE.TuesdaySelectTimeArr = arr.mutableCopy() as! NSMutableArray
                        
                    }
                    
                    if case let arr as NSArray = availableSlot["Wednesday"] {
                        if arr.count > 0 {
                            self.selectTimeArr.append("Wed")
                        }
                        
                        APPDELEGATE.WednesdaySelectTimeArr = arr.mutableCopy() as! NSMutableArray
                        
                    }
                    print(self.selectTimeArr)
                     self.collectionview.reloadData()
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


class daysCollection: UICollectionViewCell {
    
    @IBOutlet var daylab: UILabel!
    
    override func awakeFromNib() {
        daylab.layer.masksToBounds = true
        daylab.layer.cornerRadius = 30
    }
    
}
