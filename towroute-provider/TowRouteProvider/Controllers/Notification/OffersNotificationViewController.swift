//
//  OffersNotificationViewController.swift
//  TowRoute Provider
//
//  Created by Vengatesh UPLOGIC on 01/07/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit
import Material
import XLPagerTabStrip
import Firebase
import SVProgressHUD
import MaterialCard

class OffersNotificationViewController: UIViewController,IndicatorInfoProvider,UITableViewDataSource,UITableViewDelegate {
   
    var offer = ["TOWROUTE PROVIDER Offers"]
    var time = ["July 31"]
    var descriptions = ["Ponmeni, Chandragandhi Nagar Main Road, Madurai, India, 625016 Ponmeni, Chandragandhi Nagar Main Road, Madurai, India, 625016  Ponmeni, Chandragandhi Nagar Main Road, Madurai, India, 625016  Ponmeni, Chandragandhi Nagar Main Road, Madurai, India, 625016  Ponmeni, Chandragandhi Nagar Main Road, Madurai, India, 625016 "]
   
    
   
    var offerstatusRef: DatabaseReference! = nil
    var firebaseDict = NSDictionary()
    var firebaseKeys = [String]()
    
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "OFFERS".localized)
    }
    
    @IBOutlet weak var norecordsLbl: UILabel!
    @IBOutlet weak var norecordImg: UIImageView!
    @IBOutlet weak var offersTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

       offersTable.tableFooterView = UIView()
      //getTrips()
       getoff()
        // Do any additional setup after loading the view.
    }
    
//    func getTrips()
//    {
//
//
//        SVProgressHUD.setContainerView(topMostViewController().view)
//        SVProgressHUD.show()
//        let fireRef = Database.database().reference()
//
//        offerstatusRef = fireRef.child("Notifications").child("Offers").child("provider")
//
//        fireRef.child("Notifications").child("Offers").child("provider").observeSingleEvent(of: .value, with: { (snapshot) in
//
//            if snapshot.exists() {
//
//
//                self.offersTable.isHidden = false
//                self.norecordsLbl.isHidden = true
//                self.norecordImg.isHidden = true
//                let query = self.offerstatusRef.queryOrdered(byChild: "status").queryEqual(toValue: "1")
//                query.observe(DataEventType.value) { (SnapShot: DataSnapshot) in
//                    print("SnapShot \(SnapShot.value)")
//
//                    if SnapShot.value is NSNull
//                    {
//                        self.norecordsLbl.isHidden = false
//                        self.norecordImg.isHidden = false
//                        print("No Offers")
//                        self.offersTable.isHidden = true
//
//
//                    }
//
//                    else
//                    {
//                    if let dict = SnapShot.value as? NSDictionary {
//
//                        self.norecordImg.isHidden = true
//                        self.norecordsLbl.isHidden = true
//                        print("Offers")
//                        self.offersTable.isHidden = false
//
//                        self.firebaseDict = dict
//                        let dictkeys = dict.allKeys
//                        self.firebaseKeys = dictkeys as! [String]
//                        print(self.firebaseKeys)
//                        print(self.firebaseDict)
//                        self.offersTable.reloadData()
//
//
//                        }}
//                }
//
//            }
//
//
//            else{
//                                self.norecordImg.isHidden = false
//                                self.norecordsLbl.isHidden = false
//                                print("No Offers")
//                               self.offersTable.isHidden = true
//
//                            }
//
//
//
//
//})
//
//
//
//
//
//
//        SVProgressHUD.dismiss()
//
//
//    }
    
    func getoff(){
        
       
                    let fireRef = Database.database().reference()
                     offerstatusRef = fireRef.child("Notifications").child("Offers").child("provider")
                    offerstatusRef.observe(DataEventType.value) { (SnapShot: DataSnapshot) in
                        
                         firebaseDictArray.removeAllObjects()
                        print("SnapShot UserStatus \(SnapShot.value)")

                      
                        if let dict = SnapShot.value as? NSDictionary
                        {
                            
                            
                            let firebaseDicts = dict
                            let dictkeys = dict.allKeys
                       //     firebaseKeys = dict.allKeys
                            for i in 0...firebaseDicts.count - 1
                            {
                                
                                let keys = dictkeys[i]
                                let dictvalue = firebaseDicts[keys] as! [String: AnyObject]
                                
                            
                                    firebaseDictArray.add(dictvalue)
                                    
                                    print("Firbase Dict Array \(firebaseDictArray)")
                               
                                
                                
                                if i == firebaseDicts.count - 1
                                {
                                    print("Firbase Dict Array Count \(firebaseDictArray.count)")
                                    if firebaseDictArray.count > 0
                                    {
                                    self.norecordImg.isHidden = true
                                                           self.norecordsLbl.isHidden = true
                                                           print("Offers")
                                                           self.offersTable.isHidden = false
                                       self.offersTable.reloadData()
                                    }
                                        
                                    else
                                    {
                                        print("Empty Value")

                                      
                                        print("empty")
                                        
                                        print("self.topMostViewController() \(self.topMostViewController())")
                                       
                                    }
                                    
                                }
                                
                                
                                
                            }
                        
                        }
                        
                        
                        else if let dict = SnapShot.value as? NSArray
                        {

                            
                            
                            for (index,child) in SnapShot.children.enumerated() {

                                                    
                                                    let data = child as! DataSnapshot
                                                   let dictvalue = data.value! as! [String:AnyObject]

                                
                                

                                print("VALUE \(dictvalue)")
                                print("index \(index)")

                            
                                    firebaseDictArray.add(dictvalue)
                                     
                                     print("Firbase Dict Array \(firebaseDictArray)")
                           
                                 
                                 
                                 if index == SnapShot.childrenCount - 1
                                 {
                                     print("Firbase Dict Array Count \(firebaseDictArray.count)")
                                     if firebaseDictArray.count > 0
                                     {
                                    self.norecordImg.isHidden = true
                                                                                  self.norecordsLbl.isHidden = true
                                                                                  print("Offers")
                                                                                  self.offersTable.isHidden = false
                                         self.offersTable.reloadData()
                                     }
                                         
                                     else
                                     {
                                         print("Empty Value")
                                                                        self.norecordImg.isHidden = false
                                                                        self.norecordsLbl.isHidden = false
                                                                        print("No Offers")
                                                                       self.offersTable.isHidden = true
                                       
                                         
                                         print("empty")
                                      
                                     }
                                     
                                 }

                            }

        print("dict nsarray \(dict)")
                            
                        }
                        
                        else
                        {
                            self.norecordImg.isHidden = false
                                                   self.norecordsLbl.isHidden = false
                                                   print("No Offers")
                                                  self.offersTable.isHidden = true
                            
                            print("Comes here no dict")

                        }

                        
                    }
        
           }
  
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return firebaseDictArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = offersTable.dequeueReusableCell(withIdentifier: "offerscell", for: indexPath) as! offerscell
        
//      //  let keys = firebaseKeys[indexPath.row]
//        let reversedArray = firebaseKeys.sorted() {$0 > $1}
//        let sorted = reversedArray.sorted {$0.localizedStandardCompare($1) == .orderedDescending}
//        let keys = sorted[indexPath.row]
//       // let keyss = firebaseKeys.reversed()[indexPath.row]
//        let dict = firebaseDict[keys] as! [String: AnyObject]
//        print("ch_ofers_dict\(dict)")
//
//        cell.offerTitle.text = dict["title"] as? String
//        cell.offerDescription.text = dict["message"] as? String
//        cell.offerExp.text = dict["date"] as? String
//
//        cell.offerImg.image = UIImage(named: "offer_with_bg_round")
//        cell.matcard.borderColor = UIColor.init(hexString: "#e04f00")
//        cell.matcard.borderWidthPreset = .border2
//
        let dicts = firebaseDictArray.object(at: indexPath.row) as! NSDictionary
        print("chk_dictsfirebaseDictArray\(dicts)")
        
                cell.offerTitle.text = dicts["title"] as? String
        
            //Removing HTML tags
            let desvalue: String = (dicts["message"] as? String ?? "")
            cell.offerDescription.attributedText =  desvalue.convertHtmlToAttributedStringWithCSS(font: UIFont(name: "Arial", size: 16), csscolor: "black", lineheight: 5, csstextalign: "justify") //HTML Tags Removed
        
        //cell.offerDescription.text = (dicts["message"] as? String)
                cell.offerExp.text = dicts["date"] as? String
        
        
                cell.offerImg.image = UIImage(named: "offer_with_bg_round")
                cell.matcard.borderColor = UIColor.init(hexString: "#00d5ff")
                cell.matcard.borderWidthPreset = .border2
        
      //  cell.offerExp.text = "EXP : \(time[indexPath.row])"
       // let dict = pastJobsarray.object(at: indexPath.row) as! NSDictionary
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 120
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let farevc = STORYBOARD.instantiateViewController(withIdentifier: "detailsview") as! DetailsViewController
     
//        let reversedArray = firebaseKeys.sorted() {$0 > $1}
//        let sorted = reversedArray.sorted {$0.localizedStandardCompare($1) == .orderedDescending}
//        let keys = sorted[indexPath.row]
//        let dict = firebaseDict[keys] as! [String: AnyObject]
//       
//        if let title = dict["title"] as? String
//        {
//          farevc.offertitle = dict["title"] as! String
//        }
//        if let title = dict["message"] as? String
//        {
//            farevc.offerdesc = dict["message"] as! String
//        }
//        if let title = dict["date"] as? String
//        {
//            farevc.offerexp = dict["date"] as! String
//        }
        
        let dicts = firebaseDictArray.object(at: indexPath.row) as! NSDictionary
            print("chk_dictsfirebaseDictArray\(dicts)")
            
        farevc.offertitle = (dicts["title"] as? String)!
        farevc.offerdesc = (dicts["message"] as? String)!
        farevc.offerexp = (dicts["date"] as? String)!
            
            
             
        
        farevc.titleString = "Offers".localized
        self.navigationController!.pushViewController(farevc, animated: true)
        
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
class offerscell: UITableViewCell {
    
    @IBOutlet weak var offerImg: UIImageView!
    @IBOutlet weak var offerTitle: UILabel!
    @IBOutlet weak var offerExp: UILabel!
    @IBOutlet weak var offerDescription: UILabel!
    @IBOutlet weak var matcard: MaterialCard!
    
    
}
