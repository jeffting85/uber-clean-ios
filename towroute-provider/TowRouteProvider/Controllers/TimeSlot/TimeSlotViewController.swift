//
//  TimeSlotViewController.swift
//  TowRoute Provider
//
//  Created by Uplogic Technologies on 14/06/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class TimeSlotViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let timeStr = ["12 - 01 AM","01 - 02 AM","02 - 03 AM","03 - 04 AM","04 - 05 AM","05 - 06 AM","06 - 07 AM","07 - 08 AM","08 - 09 AM","09 - 10 AM","10 - 11 AM","11 - 12 AM","12 - 01 PM","01 - 02 PM","02 - 03 PM","03 - 04 PM","04 - 05 PM","05 - 06 PM","06 - 07 PM","07 - 08 PM","08 - 09 PM","09 - 10 PM","10 - 11 PM","11 - 12 PM"]
    
    var selectTimeArr = NSMutableArray()
   
    var titlevalue = ""
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return timeStr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "timeslotcell", for: indexPath) as! timeSlotCollection
        cell.timelab.text = timeStr[indexPath.row]
        let selecttime = indexPath.row + 1
        if selectTimeArr.contains(selecttime) {
            cell.timelab.backgroundColor = UIColor(hex: "00d5ff")
            cell.timelab.textColor = UIColor.black
        }
        else {
            cell.timelab.backgroundColor = UIColor.white
            cell.timelab.textColor = UIColor.black
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selecttime = indexPath.row + 1
        if selectTimeArr.contains(selecttime) {
            selectTimeArr.remove(selecttime)
        }
        else {
            selectTimeArr.add(selecttime)
        }
        collectionView.reloadData()
    }
    
    @IBOutlet var collectionview: UICollectionView!
    
    @IBAction func updateAct(_ sender: Any) {
    
        if timeslottitle == "Sunday" {
            
            APPDELEGATE.SundaySelectTimeArr = selectTimeArr.mutableCopy() as! NSMutableArray
            
        }
        else if timeslottitle == "Monday" {
            
            APPDELEGATE.MondaySelectTimeArr = selectTimeArr.mutableCopy() as! NSMutableArray
            
        }
        else if timeslottitle == "Tuesday" {
            
            APPDELEGATE.TuesdaySelectTimeArr = selectTimeArr.mutableCopy() as! NSMutableArray
            
        }
        else if timeslottitle == "Wednesday" {
            
            APPDELEGATE.WednesdaySelectTimeArr = selectTimeArr.mutableCopy() as! NSMutableArray
            
        }
        else if timeslottitle == "Thursday" {
            
            APPDELEGATE.ThurdaySelectTimeArr = selectTimeArr.mutableCopy() as! NSMutableArray
            
        }
        else if timeslottitle == "Friday" {
            
            APPDELEGATE.FridaySelectTimeArr = selectTimeArr.mutableCopy() as! NSMutableArray
            
        }
        
        else if timeslottitle == "Saturday" {
            
            APPDELEGATE.SaturdaySelectTimeArr = selectTimeArr.mutableCopy() as! NSMutableArray
            
        }
        
        var allTimeDict = NSMutableDictionary()
        
        allTimeDict.setValue(APPDELEGATE.SundaySelectTimeArr, forKey: "Sunday")
        allTimeDict.setValue(APPDELEGATE.MondaySelectTimeArr, forKey: "Monday")
        allTimeDict.setValue(APPDELEGATE.TuesdaySelectTimeArr, forKey: "Tuesday")
        allTimeDict.setValue(APPDELEGATE.WednesdaySelectTimeArr, forKey: "Wednesday")
        allTimeDict.setValue(APPDELEGATE.ThurdaySelectTimeArr, forKey: "Thursday")
        allTimeDict.setValue(APPDELEGATE.FridaySelectTimeArr, forKey: "Friday")
        allTimeDict.setValue(APPDELEGATE.SaturdaySelectTimeArr, forKey: "Saturday")
        
        var strdata = ""
        
        do {
         
            let jsonData = try JSONSerialization.data(withJSONObject: allTimeDict, options: [])
            
            strdata = String(data: jsonData, encoding: String.Encoding.utf8)!
            
        } catch {
            print(error.localizedDescription)
        }
        
        let userdict = USERDEFAULTS.getLoggedUserDetails()
        
        let userid = userdict["id"] as! String
        
        let params = ["id":userid,
                      "availble_slots": strdata]
        
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
                
                self.navigationController?.popViewController(animated: true)
                
            }
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = timeslottitle.localized
        
        if timeslottitle == "Sunday" {
            
            selectTimeArr = APPDELEGATE.SundaySelectTimeArr.mutableCopy() as! NSMutableArray
            
        }
        else if timeslottitle == "Monday" {
            
            selectTimeArr = APPDELEGATE.MondaySelectTimeArr.mutableCopy() as! NSMutableArray
            
        }
        else if timeslottitle == "Tuesday" {
            
            selectTimeArr = APPDELEGATE.TuesdaySelectTimeArr.mutableCopy() as! NSMutableArray
            
        }
        else if timeslottitle == "Wednesday" {
            
            selectTimeArr = APPDELEGATE.WednesdaySelectTimeArr.mutableCopy() as! NSMutableArray
            
        }
        else if timeslottitle == "Thursday" {
            
            selectTimeArr = APPDELEGATE.ThurdaySelectTimeArr.mutableCopy() as! NSMutableArray
            
        }
        else if timeslottitle == "Friday" {
            
            selectTimeArr = APPDELEGATE.FridaySelectTimeArr.mutableCopy() as! NSMutableArray
            
        }
        else if timeslottitle == "Saturday" {
            
            selectTimeArr = APPDELEGATE.SaturdaySelectTimeArr.mutableCopy() as! NSMutableArray
            
        }
        
        // Do any additional setup after loading the view.
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


class timeSlotCollection: UICollectionViewCell {
    
    @IBOutlet var timelab: UILabel!
    
    override func awakeFromNib() {
        timelab.layer.borderColor = UIColor.lightGray.cgColor
        timelab.layer.borderWidth = 1
        timelab.layer.masksToBounds = true
        timelab.layer.cornerRadius = 5
    }
    
}

