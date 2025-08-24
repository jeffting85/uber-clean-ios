//
//  onjobViewController.swift
//  TowRoute User
//
//  Created by Admin on 04/07/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import FloatRatingView
import Firebase

class onjobViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var onGoingJobsarray = NSMutableArray()
    
    var mode_value = "9"
    
    @IBOutlet weak var banner_defau_img: UIImageView!
    @IBOutlet weak var banner_circle_logo: UIImageView!
    @IBOutlet weak var banner_no_rec_found: UILabel!
    
    
    @IBOutlet var nojobtext: UILabel!
    
    var allAdvertisement = [Advertisement]()
    @IBOutlet weak var advertisementCollectionview: UICollectionView!
    @IBOutlet weak var advertisementPageControl: UIPageControl!

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.onGoingJobsarray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "onmenu", for: indexPath) as! onmenucell
        
        let dict = onGoingJobsarray.object(at: indexPath.row) as! NSDictionary
        
        let img = dict.object(forKey: "driver_avatar") as? String
        
        if (img != nil) && !(img == "") {
            
            var imageUrl: String? = BASEAPI.IMGURL+img!
            cell.profileimage.sd_setImage(with: URL(string: imageUrl!), placeholderImage: #imageLiteral(resourceName: "user(1)"))
            
        }
        else {
            cell.profileimage.sd_setImage(with: URL(string: ""), placeholderImage: #imageLiteral(resourceName: "user(1)"))
        }
        
        cell.profileimage.layer.cornerRadius = (cell.profileimage.frame.size.width) / 2
        cell.profileimage.layer.masksToBounds = true
        
        cell.name.text = dict.object(forKey: "driver_name") as? String
        
       
        
        if LanguageManager.shared.currentLanguage == .ar{
            
            cell.category.text = dict.object(forKey: "category_ar") as? String
            
            cell.category.text = cell.category.text! + " - " + (dict.object(forKey: "service_ar") as! String)
        }
        else
        {
            cell.category.text = dict.object(forKey: "category_name") as? String
            
            cell.category.text = cell.category.text! + " - " + (dict.object(forKey: "service_name") as! String)
        }
        
        
        
        
        cell.bookingnum.text = "Booking No#".localized + " " + (dict.object(forKey: "booking_id") as! String)
        
       // cell.date.text = dict.object(forKey: "job_date") as? String
        
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
        
        // let rating = dict.object(forKey: "rating") as! String
        
        // cell.review.rating = Double(rating)!
        
        let fireRef = Database.database().reference()
        
        fireRef.child("booking_trips").child(dict.object(forKey: "booking_id") as! String).observeSingleEvent(of: DataEventType.value) { (SnapShot: DataSnapshot) in
            
            if let dict = SnapShot.value as? NSDictionary {
                
                var driverid = ""
                
                if let driver_id = dict["driver_id"] {
                    
                    driverid = "\(dict["driver_id"]!)"
                    
                }
                
                fireRef.child("providers").child(driverid).child("rating").observeSingleEvent(of: DataEventType.value) { (SnapShot: DataSnapshot) in
                    
                    if let statusval = SnapShot.value {
                        
                        let rating = "\(statusval)"
                        
                        print("rating \(rating)")
                        
                        if rating != "<null>" {
                            
                            cell.review.rating = Double(rating)!
                            
                        }
                        
                    }
                    
                }
                
            }
            
        }
        
        
        
        cell.address.text = dict.object(forKey: "customer_location") as? String
        
        cell.viewdetail.tag = indexPath.row
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
        
    }
    
    @IBOutlet var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableview.rowHeight = UITableViewAutomaticDimension;
        tableview.estimatedRowHeight = 44.0;
        
        self.title = "MY ON GOING JOBS".localized
        
        onJobs()
        viewAdvertisement()
        
        // Do any additional setup after loading the view.
    }

    func onJobs() {
        
        let userdict = USERDEFAULTS.getLoggedUserDetails()
        
        let userid = userdict["id"] as! String
        
        let params = ["customer_id": userid]
        
        print("params \(params)")
        
        APIManager.shared.customerOnGoing(params: params as [String : AnyObject]) { (response) in
            print("responsese\(response)")
            
            if case let msg as String = response?["message"], msg == "Unauthenticated." {
                
                APIManager.shared.refreshToken(params: params as [String : AnyObject]) { (response) in
                    
                    if case let access_token as String = response?["access_token"] {
                        
                        APPDELEGATE.bearerToken = access_token
                        
                        USERDEFAULTS.set(access_token, forKey: "access_token")
                        
                        self.onJobs()
                        
                    }
                        
                    else {
                        
                        self.showAlertView(title: "TowRoute".localized, message: "Your session has expired. Please log in again", callback: { (check) in
                            
                            APPDELEGATE.updateLoginView()
                            
                        })
                        
                    }
                    
                }
                
            }
                
            else if case let details as NSArray = response?["service_request"] {
                self.onGoingJobsarray = details.mutableCopy() as! NSMutableArray
                self.tableview.reloadData()
                
            }
            
            if self.onGoingJobsarray.count == 0 {
                
                self.nojobtext.isHidden = false
                self.tableview.isHidden = true
                
            }
            
        }
    }
    
    func viewAdvertisement() {
        
        let params = ["mode": mode_value]
        
        print("params \(params)")
        
        APIManager.shared.viewAdvertisement(params: params as [String : AnyObject]) { (response) in
            
            self.allAdvertisement.removeAll()
            
            if case let msg as String = response?["message"], msg == "Unauthenticated." {
                
                APIManager.shared.refreshToken(params: params as [String : AnyObject]) { (response) in
                    
                    if case let access_token as String = response?["access_token"] {
                        
                        APPDELEGATE.bearerToken = access_token
                        
                        USERDEFAULTS.set(access_token, forKey: "access_token")
                        
                        self.viewAdvertisement()
                        
                    }
                        
                    else {
                        
                        self.showAlertView(title: "TowRoute".localized, message: "Your session has expired. Please log in again", callback: { (check) in
                            
                            APPDELEGATE.updateLoginView()
                            
                        })
                        
                    }
                    
                }
                
            }
                
                if case let msg as String = response?["message"], msg == "No Image Found"{
                        
                        if self.mode_value == "all"{
                            self.banner_defau_img.isHidden = false
                            self.banner_circle_logo.isHidden = false
                            self.banner_no_rec_found.isHidden = false
                        }
                        else{

                            self.banner_defau_img.isHidden = false
                            self.banner_circle_logo.isHidden = false
                            self.banner_no_rec_found.isHidden = false
                            self.mode_value = "all"
                            self.viewAdvertisement()
                        }
                        
                        
                        
                    }
                
            else if case let details as NSArray = response?["data"] {
                    
                    self.banner_defau_img.isHidden = true
                    self.banner_circle_logo.isHidden = true
                    self.banner_no_rec_found.isHidden = true
                for det in details{
                    if case let dict as NSDictionary = det{
                        let ads = Advertisement(banner_id: dict["banner_id"] as! NSNumber, description: dict["description"] as! String, id: dict["id"] as! NSNumber, images: dict["images"] as! String, status: dict["status"] as! NSNumber, title: dict["title"] as! String)
                        self.allAdvertisement.append(ads)
                    }
                }
                
                self.advertisementPageControl.numberOfPages = self.allAdvertisement.count
                
                self.advertisementCollectionview.reloadData()
            }
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func viewdetails(_ sender: Any) {
        
        let onjob = STORYBOARD.instantiateViewController(withIdentifier: "JobProgressVC") as! JobProgressViewController
        
        let dict = onGoingJobsarray.object(at: (sender as! UIButton).tag) as! NSDictionary
        
        onjob.booking_id = "\(dict["booking_id"]!)"
        
        //self.navigationController?.pushViewController(registervc, animated: true)
        self.present(onjob, animated: true, completion: nil)
    }
    
    @IBAction func backAct(_ sender: Any) {
    
        self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
        
        // self.dismiss(animated: true, completion: nil)
        
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

extension onjobViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.allAdvertisement.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "advertisementcell", for: indexPath) as! advertisementcell
        cell.advertisementtitle.text = self.allAdvertisement[indexPath.row].title
        cell.advertisementdescription.text = self.allAdvertisement[indexPath.row].description
        let imageUrl: String? = BASEAPI.IMGURL+self.allAdvertisement[indexPath.row].images
        cell.bannerimage.sd_setImage(with: URL(string: imageUrl!), placeholderImage: nil)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screen = UIScreen.main.bounds
        let size = CGSize(width: screen.width, height: 220)
        return size
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        advertisementPageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        
        advertisementPageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
    
}

class onmenucell :UITableViewCell{
    @IBOutlet var name: UILabel!
    @IBOutlet var address: UILabel!
    @IBOutlet var viewdetail: UIButton!
    @IBOutlet var profileimage: UIImageView!
    @IBOutlet var date: UILabel!
    @IBOutlet var category: UILabel!
    @IBOutlet var bookingnum: UILabel!
    @IBOutlet var review: FloatRatingView!
    
}
