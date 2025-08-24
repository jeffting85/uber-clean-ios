//
//  ServiceCategoryViewController.swift
//  TowRoute User
//
//  Created by Uplogic Technologies on 15/06/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class ServiceCategoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var subcat = NSMutableArray()
    
    var catid = ""
    
     var DrivbgView = UIView()
    
    var selectserviceid = ""
    
    var selectedServices = NSMutableArray()
    
    var category_type = ""
    var level_type = ""
    
    var distanceInKm = ""
    
    var allAdvertisement = [Advertisement]()
    var menuimages = [#imageLiteral(resourceName: "NEW LOGO"),#imageLiteral(resourceName: "NEW LOGO"),#imageLiteral(resourceName: "NEW LOGO")]
    
    @IBOutlet weak var Booknow: UIButton!
    @IBOutlet weak var Booklatr: UIButton!
    
    @IBOutlet weak var advertisementCollectionview: UICollectionView!
    @IBOutlet weak var advertisementPageControl: UIPageControl!
    @IBOutlet weak var fareAmountDetailView: UIStackView!
    @IBOutlet weak var levelAmountDetailView: UIStackView!
    
    @IBOutlet var collectionView2: UICollectionView!
    @IBOutlet weak var fareAmountTotalLabel: UILabel!
    @IBOutlet weak var baseFareLabel: UILabel!
    @IBOutlet weak var visitFareLabel: UILabel!
    @IBOutlet weak var pricePerKMLabel: UILabel!
    @IBOutlet weak var EstimateDistanceLabel: UILabel!
    @IBOutlet weak var estimateDistanceCalculateLabel: UILabel!
    
    @IBOutlet weak var levelAmountTotalLabel: UILabel!
    @IBOutlet weak var levelBaseFareTitle: UILabel!
    @IBOutlet weak var levelBaseFareLabel: UILabel!
    @IBOutlet weak var levelbaseFareServiceTitle: UILabel!
    @IBOutlet weak var levelbaseFareServiceLabel: UILabel!
    @IBOutlet weak var levelVisitFareLabel: UILabel!
    @IBOutlet weak var banner_defau_img: UIImageView!
    @IBOutlet weak var banner_circle_logo: UIImageView!
       @IBOutlet weak var banner_no_rec_found: UILabel!
    
    @IBOutlet var Estimation_view: UIView!
    @IBOutlet weak var Estimated_Fare_Amount: UILabel!
    @IBOutlet weak var Base_fare: UILabel!
    @IBOutlet weak var Visit_Fare: UILabel!
    @IBOutlet weak var Est_details_btn: UIButton!
    @IBOutlet weak var ppm: UILabel!
    @IBOutlet weak var estimated_distance: UILabel!
    @IBOutlet weak var estimated_dis_calc: UILabel!
    @IBOutlet weak var estimate_detail_btn: UIButton!
    
    
    var level_amount = "0"
    
    
   var mode_value = "7"
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subcat.count
    }
    
    var selectedArray = NSMutableArray()
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "servicecatcell", for: indexPath) as! servicecategorycell
        let dict = subcat.object(at: indexPath.row) as! NSDictionary //collectionview2
       
        if selectedArray.contains(indexPath.row) {
            cell.img.image = #imageLiteral(resourceName: "dot-and-circle")
        }
        else {
            cell.img.image = #imageLiteral(resourceName: "circle-shape-outline")
        }
       
        
        if LanguageManager.shared.currentLanguage == .ar{
            cell.servicecatlab.text = dict.object(forKey: "service_name_spanish") as? String //collectionview2
        }
        else
        {
             cell.servicecatlab.text = dict.object(forKey: "service_name") as? String //collectionview2
        }
        let amounts = dict.object(forKey: "base_fare") as! NSNumber//collectionview2
        print("amountview\(amounts)")//collectionview2
       
        let d = Double(amounts)
        print(d)//collectionview2
        let currc = String(format: "%.2f", d)
        print(currc)                 //collectionview2
      
        cell.amount.text = currency_symbol! + currc
        cell.amount.tag = Int(amounts)
        
        cell.selectionStyle = .none
        
        
        //Collectionview2
        let cat_images = dict.object(forKey: "service_image") as? String
        
        let img = BASEAPI.IMGURL + cat_images!
          print("imagesset\(img)")
                      cell.img.sd_setImage(with: URL(string: img)) { (img, err, type, url) in
                          
                          if img != nil
                          {
                         // cell.img.image = img?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
          //                let titntImage = cell.img_bg.image?.maskWithColor(color: UIColor.clear)
          //                  //     let titntImage = cell.img_bg.image?.maskWithColor(color: UIColor.Yellow)
          //                cell.img_bg.image = titntImage
                         // print(titntImage!)
                          }
                          else
                          {
                              print("ImageError")
                          }
                          
                      }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedArray.removeAllObjects()
        
        selectedArray.add(indexPath.row)
        
        let dict = subcat.object(at: indexPath.row) as! NSDictionary
        selectserviceid = "\(dict["id"]!)"
        
        APPDELEGATE.selectedService = dict.object(forKey: "service_name") as! String  //collectionview2
        APPDELEGATE.selectedServiceInSpanish = dict.object(forKey: "service_name_spanish") as! String  //collectionview2
        APPDELEGATE.servicePrice = "\(dict["base_fare"]!)"  //collectionview2
        
        tableView.reloadData()
        
        fareAmountDetailView.isHidden = true
        levelAmountDetailView.isHidden = true
        
        
        
//        if category_type == "1"{
//            fareAmountDetailView.isHidden = false
//            levelAmountDetailView.isHidden = true
//
//            let EDC = "\(Double("\(dict["price_per_km"]!)".convertCur())! * Double("\(distanceInKm)")!)"
//            fareAmountTotalLabel.text = "BF + VF + EDC = \(currency_symbol!)" + "\(Double("\(dict["base_fare"]!)".convertCur())! + Double("\(dict["visit_fare"]!)".convertCur())! + Double(EDC)!)"
//            baseFareLabel.text = currency_symbol!+"\(dict["base_fare"]!)".convertCur()
//            visitFareLabel.text = currency_symbol!+"\(dict["visit_fare"]!)".convertCur()
//            pricePerKMLabel.text = currency_symbol!+"\(dict["price_per_km"]!)".convertCur()
//            EstimateDistanceLabel.text = distanceInKm + "KM"
//            estimateDistanceCalculateLabel.text = "PPKM*ED = \(currency_symbol!)" + EDC
//
//        }else if category_type == "0" && level_type == "1"{
//            fareAmountDetailView.isHidden = true
//            levelAmountDetailView.isHidden = false
//
//            let total = "\(Double("\(dict["base_fare"]!)".convertCur())! * Double("\(level_amount)".convertCur())!)"
//
//            levelAmountTotalLabel.text = "(Subway*Level 1) + VF = \(currency_symbol!)" + "\(Double("\(dict["visit_fare"]!)".convertCur())! + Double(total)!)"
//            levelBaseFareTitle.text = "Base Fare("+self.title!+")"
//            levelBaseFareLabel.text = currency_symbol!+level_amount.convertCur()
//            levelbaseFareServiceTitle.text = "Base Fare("+"\(dict["service_name"]!)"+")"
//            levelbaseFareServiceLabel.text = currency_symbol!+"\(dict["base_fare"]!)".convertCur()
//            levelVisitFareLabel.text = currency_symbol!+"\(dict["visit_fare"]!)".convertCur()
//        }

    }
    
    @IBOutlet var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewCategories()
        Booknow.layer.borderWidth = 1
        Booklatr.layer.borderWidth = 1
        Booknow.layer.borderColor = UIColor.black.cgColor
        Booklatr.layer.borderColor = UIColor.black.cgColor
        
        viewAdvertisement()
        
       
        
       advertisementCollectionview.delegate = self
       advertisementCollectionview.dataSource = self
        
        print("chk_miles_dis_value\(miles_dis_value)")
        print("chk_miles_dis_text\(miles_dis_text)")
        
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func booknow(_ sender: Any) {
        
        if selectedArray.count == 0 {
            
            self.showAlertView(message: "Please select service!".localized)
            
            return
            
        }
        
        let towing = STORYBOARD.instantiateViewController(withIdentifier: "towng") as! UINavigationController
        
        let towview = towing.viewControllers[0] as! TowingViewController
        
        towview.selectserviceid = selectserviceid
        
//        if LanguageManager.shared.currentLanguage == .ar {
//            towview.title = APPDELEGATE.selectedServiceInSpanish
//        }
        
        APPDELEGATE.selectedServiceID = selectserviceid
        
        APPDELEGATE.isBookLater = false
        
        // self.navigationController?.pushViewController(loginvc, animated: true)
        self.present(towing, animated: true, completion: nil)
    }
    @IBAction func booklater(_ sender: Any) {
        
        if selectedArray.count == 0 {
            
            self.showAlertView(message: "Please select service!".localized)
            
            return
            
        }
        
        let booklater = STORYBOARD.instantiateViewController(withIdentifier: "booklater") as! UINavigationController
        
        let towview = booklater.viewControllers[0] as! BookinglaterViewController
        
        towview.selectserviceid = selectserviceid
        
        towview.title = APPDELEGATE.selectedService.localized
        
        if LanguageManager.shared.currentLanguage == .ar {
            towview.title = APPDELEGATE.selectedServiceInSpanish
        }
        
        APPDELEGATE.isBookLater = true
        
        // self.navigationController?.pushViewController(loginvc, animated: true)
        self.present(booklater, animated: true, completion: nil)
    }
    
    
    @IBAction func Estimation_Act(_ sender: Any) {
        self.Estimation_Present()
    }
    
    @IBAction func Estimation_close(_ sender: Any) {
        DrivbgView.removeFromSuperview()
        Estimation_view.removeFromSuperview()
    }
    
    func Estimation_Present(){
    
                Estimation_view.backgroundColor = UIColor(hexString: "ffffff") //UIColor.SpotnBlue
      
              
            
        
                
                DrivbgView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
                
                DrivbgView.backgroundColor = UIColor(white: 1, alpha: 0.5)
                
                let dimAlphaRedColor =  UIColor.black.withAlphaComponent(0.5)
                DrivbgView.backgroundColor =  dimAlphaRedColor
                
                self.view.addSubview(DrivbgView)
                self.view.bringSubview(toFront: DrivbgView)
                
               
                
        //        fareDetailBaseView.frame = CGRect(x: 15, y: 80, width: fareDetailBaseView.frame.size.width, height: fareDetailBaseView.frame.size.height)
        //
        //        bgView.addSubview(fareDetailBaseView)
        //        bgView.bringSubviewToFront(fareDetailBaseView)
                
                
                Estimation_view.frame = CGRect(x: (self.view.frame.size.width / 2) - (Estimation_view.frame.size.width / 2), y: self.view.frame.size.height / 2 - Estimation_view.frame.size.height / 2, width: Estimation_view.frame.size.width , height: Estimation_view.frame.size.height)
                 
                 Estimation_view.center.x = DrivbgView.center.x
                 
                 DrivbgView.addSubview(Estimation_view)
                 DrivbgView.bringSubview(toFront: Estimation_view)
        
        
        
    }
    
    func viewCategories() {
        
        let userdict = USERDEFAULTS.getLoggedUserDetails()
        
        let userid = userdict["id"] as! String
        
        let params = ["id":catid]
        
        print("params \(params)")
        
        APIManager.shared.subCategories(params: params as [String : AnyObject]) { (response) in
            
            if case let msg as String = response?["message"], msg == "Unauthenticated." {
     
                APIManager.shared.refreshToken(params: params as [String : AnyObject]) { (response) in
                    
                    if case let access_token as String = response?["access_token"] {
                        
                        APPDELEGATE.bearerToken = access_token
                        
                        USERDEFAULTS.set(access_token, forKey: "access_token")
                        
                        self.viewCategories()
                        
                    }
                        
                    else {
                        
                        self.showAlertView(title: "TowRoute".localized, message: "Your session has expired. Please log in again", callback: { (check) in
                            
                            APPDELEGATE.updateLoginView()
                            
                        })
                        
                    }
                    
                }
                
            }
                
            else if case let details as NSArray = response?["data"] {
                
                self.subcat = details.mutableCopy() as! NSMutableArray
                
                self.tableview.reloadData()
                self.advertisementCollectionview.reloadData()
                self.collectionView2.reloadData()
                
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
                print("Check details: \(details)")
                for det in details{
                    
                    self.banner_defau_img.isHidden = true
                    self.banner_circle_logo.isHidden = true
                    self.banner_no_rec_found.isHidden = true
                    if case let dict as NSDictionary = det{
                        let ads = Advertisement(banner_id: dict["banner_id"] as! NSNumber, description: dict["description"] as! String, id: dict["id"] as! NSNumber, images: dict["images"] as! String, status: dict["status"] as! NSNumber, title: dict["title"] as! String)
                        self.allAdvertisement.append(ads)
                        print("valaddarray\(self.allAdvertisement)")
                        print("cio\(self.allAdvertisement.count)")
                        
                        self.advertisementCollectionview.reloadData()
                        self.collectionView2.reloadData()

                    }
                }
                
                self.advertisementPageControl.numberOfPages = self.allAdvertisement.count
               
               
            }
            
        }
         self.advertisementCollectionview.reloadData()
         self.collectionView2.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backact(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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

struct Advertisement {
    var banner_id = NSNumber()
    var description = String()
    var id = NSNumber()
    var images = String()
    var status = NSNumber()
    var title = String()
}

extension ServiceCategoryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
             if collectionView == advertisementCollectionview {
                return self.allAdvertisement.count       //self.menuimages.count
        }
             else {
               return subcat.count
        }
       
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        
        print("chlinsidecollviewarray\(allAdvertisement)")
        
        if collectionView == advertisementCollectionview {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "advertisementcell", for: indexPath) as! advertisementcell
            print("titile addd\(self.allAdvertisement[indexPath.row].title)")
            print("descriptionaddd\(self.allAdvertisement[indexPath.row].description)")
            
                   cell.advertisementtitle.text = self.allAdvertisement[indexPath.row].title
                   cell.advertisementdescription.text = self.allAdvertisement[indexPath.row].description
                   let imageUrl: String? = BASEAPI.IMGURL+self.allAdvertisement[indexPath.row].images
                   cell.bannerimage.sd_setImage(with: URL(string: imageUrl!), placeholderImage: nil)
            
            
//            let img = BASEAPI.IMGURL+self.allAdvertisement[indexPath.row].images
//              print("imagessetaddd\(img)")
//                          cell.bannerimage.sd_setImage(with: URL(string: img)) { (img, err, type, url) in
//
//                              if img != nil
//                              {
//                              cell.bannerimage.image = img
//
//
//                              }
//                              else
//                              {
//                                  print("ImageError")
//                              }
//
//                          }
            
           // cell.bannerimage.image = self.menuimages[indexPath.row]
            //let img = String(describing: self.menuimages[indexPath.row].images)
            //cell.bannerimage.sd_setImage(with: URL(string: img), placeholderImage: nil)
            
              return cell
        }
        else {
             let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Collectcell", for: indexPath) as! Collectcell
                    let dict = subcat.object(at: indexPath.row) as! NSDictionary
             let service_name = dict.object(forKey: "service_name") as? String
            cell.txtLbl.text = service_name
            let cat_images = dict.object(forKey: "service_image") as? String
            
            let amounts = dict.object(forKey: "base_fare") as! NSNumber //collectionview2
                   print("amountview\(amounts)")//collectionview2
                  
                   let d = Double(amounts)
                   print(d)//collectionview2
            let currc = String(format: "%.1f", d)
                   print("chk_currc\(currc)")                 //collectionview2
                 
                   
            cell.Basefare_value.text = "\(amounts)".convertCur()
            
            cell.basefareTitle.text = "Base Fare(\(currency_symbol!))"
            let img = BASEAPI.IMGURL + cat_images!
              print("imagesset\(img)")
                          cell.img.sd_setImage(with: URL(string: img)) { (img, err, type, url) in
                              
                              if img != nil
                              {
                              cell.img.image = img
                              
                      
                              }
                              else
                              {
                                  print("ImageError")
                              }
                              
                          }
            
            if selectedArray.contains(indexPath.row) {
                         
                cell.contentView.backgroundColor = UIColor.white //UIColor.init(hexString: "c67706")!
                cell.contentView.borderColor = UIColor.init(hexString: "00d5ff")!
                cell.contentView.layer.borderWidth = 1
                self.Booknow.backgroundColor = UIColor.init(hexString: "#00d5ff")
                self.Booklatr.backgroundColor = UIColor.init(hexString: "#393939")
                self.Booklatr.setTitleColor(.white, for: .normal)

                     }
                     else {
                         
                         cell.contentView.backgroundColor = .lightGray
                         cell.contentView.borderColor = UIColor.clear

                     }
          
            return cell
        }
     
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == advertisementCollectionview{
           print("bbb")
        }
        else{
             print("ccc")
            //Booknow.layer.backgroundColor = UIColor.init(hexString: "cd1f01")!.cgColor
            //Booknow.titleLabel?.textColor = UIColor.white
            //Booklatr.layer.backgroundColor = UIColor.init(hexString: "cd1f01")!.cgColor
            //Booklatr.titleLabel?.textColor = UIColor.white
            
            if APPDELEGATE.isdroplocationcategory == false{
                estimate_detail_btn.isHidden = true
            }
            else{
                estimate_detail_btn.isHidden = true
            }
            
            selectedArray.removeAllObjects()
            
            selectedArray.add(indexPath.row)
            
            let dict = subcat.object(at: indexPath.row) as! NSDictionary
            selectserviceid = "\(dict["id"]!)"
            
            APPDELEGATE.selectedService = dict.object(forKey: "service_name") as! String  //collectionview2
            APPDELEGATE.selectedServiceInSpanish = dict.object(forKey: "service_name") as! String  //collectionview2
            APPDELEGATE.servicePrice = "\(dict["base_fare"]!)"  //collectionview2
            
//            let amounts = dict.object(forKey: "base_fare") as! NSNumber//collectionview2
//                              print("amountview\(amounts)")//collectionview2
//
//                              let d = Double(amounts)
//                              print(d)//collectionview2
//                              let currc = String(format: "%.1f", d)
//                              print("chk_currc\(currc)")
            
            //basefare
            let baseamt = dict.object(forKey: "base_fare") as! NSNumber
            print("chk_baseamt\(baseamt)")
            let d = Double(baseamt)
            print(d)
            let currc = String(format: "%.1f", d)
            Base_fare.text = "£" + currc //"£ \(dict["base_fare"]!)"
            
            //visitfare
            let visitamt = dict.object(forKey: "visit_fare") as! NSNumber
            print("chk_visitamt\(visitamt)")
            let dv = Double(visitamt)
            print(dv)
            let currc_v = String(format: "%.1f", dv)
            Visit_Fare.text = "£" + currc_v //"\(dict["visit_fare"]!)"
            
            //ppm
            let ppm_amt = dict.object(forKey: "price_per_km") as! NSNumber
            print("chk_ppm_amt\(ppm_amt)")
            let dppm = Double(ppm_amt)
            let currc_ppm = String(format: "%.1f", dppm)
            ppm.text = "£" + currc_ppm // "\(dict["price_per_km"]!)"
            
            //edc
            let edc = Double(miles_dis_value) / 1000
            let edc_amt = dppm * edc
            print("chk_edc_amt\(edc_amt)")
            let currc_edc = String(format: "%.2f", edc_amt)
            print("chk_currc_edc\(currc_edc)")
            estimated_dis_calc.text = "£" + currc_edc
            
            //ed
            let ed_mi = miles_dis_text
             print("chk_ed_mi\(ed_mi)")
            estimated_distance.text = "\(ed_mi)"
            
            //efa
            let efa = d + dv + edc_amt
            print("chk_efa\(efa)")
            let currc_efa = String(format: "%.2f", efa)
            Estimated_Fare_Amount.text = "£" + currc_efa
           // Estimated_Fare_Amount
            
           
           
            
            if let cell = collectionView.cellForItem(at: indexPath) as? Collectcell {
                
                cell.contentView.backgroundColor = UIColor.init(hexString: "c67706")!
            }
            
            fareAmountDetailView.isHidden = true
            levelAmountDetailView.isHidden = true
            
            
            
            
            collectionView2.reloadData()
        }
        
        
        
    }
    
//    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
//        if collectionView == advertisementCollectionview{
//            print("aaa")
//        }
//        else{
//            print("bbb")
//            guard let cell = collectionView.cellForItem(at: indexPath) as? Collectcell else {
//                         return
//                 }
//                 cell.contentView.backgroundColor = .lightGray
//        }
//    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == advertisementCollectionview {
            let screen = UIScreen.main.bounds
                   let size = CGSize(width: screen.width, height: 220)
                   return size
        }
        else {
            return CGSize(width: 155.0, height: 165.0)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        advertisementPageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        
        advertisementPageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
    
}

class advertisementcell: UICollectionViewCell {
    @IBOutlet weak var advertisementtitle: UILabel!
    @IBOutlet weak var advertisementdescription: UILabel!
    @IBOutlet weak var bannerimage: UIImageView!
}

class servicecategorycell: UITableViewCell {
    @IBOutlet var img: UIImageView!
    @IBOutlet var servicecatlab: UILabel!
    @IBOutlet var amount: UILabel!
}
class Collectcell: UICollectionViewCell {
    @IBOutlet var txtLbl: UILabel!
    
    @IBOutlet weak var basefareTitle: UILabel!
    @IBOutlet weak var Basefare_value: UILabel!
    @IBOutlet var img: UIImageView!
}
