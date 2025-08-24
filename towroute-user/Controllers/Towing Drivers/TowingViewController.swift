//
//  TowingViewController.swift
//  TowRoute User
//
//  Created by Admin on 23/06/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import CoreLocation
import FloatRatingView
import Firebase
import GeoFire
import Alamofire
import SDWebImage

class TowingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var regionQuery: GFCircleQuery! = nil
    var queryenterhandle: UInt! = nil
    var queryexithandle: UInt! = nil
    var geoFire: GeoFire! = nil
    var geofireRef: DatabaseReference! = nil
    
    var driverids = NSMutableArray()
    var  driveridsLocation = [CLLocation]()
    var driverlocations = NSMutableArray()
   // var driverlocations = NSMutableArray()
    var driveridsList = [String]()
    var geofireprovider: DatabaseReference!
    
    var providerDetails = NSMutableArray()
    
    @IBOutlet var tableview: UITableView!
     @IBOutlet weak var banner_defau_img: UIImageView!
    @IBOutlet weak var banner_circle_logo: UIImageView!
    @IBOutlet weak var banner_no_rec_found: UILabel!
    
    
    
    var selectserviceid = ""
    var mode_value = "8"
    @IBOutlet weak var closebtn: UIButton!
    @IBOutlet var requestscreen: UIView!
    @IBOutlet weak var Advertisementscreen: UIView!
    
    var pulsator: Pulsator!
    
    @IBOutlet var carimg: UIImageView!
    
    var isBookLater = false
    
    var schedulHour = ""
    var schedulDay = ""
    
    var allAdvertisement = [Advertisement]()
    @IBOutlet weak var advertisementCollectionview: UICollectionView!
    @IBOutlet weak var advertisementPageControl: UIPageControl!

    var driversidsArray = [String]()
    var driverslocationArray = [CLLocation]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        closebtn.layer.cornerRadius = 25
        if let dis = USERDEFAULTS.value(forKey: "distance_limit") {
        distance_limit = dis as! Int
        }
        geofireprovider = Database.database().reference().child("providers")

        if isBookLater == false {
            
            updateCars()
            
        }
        else {
            
            checkAvailable()
            
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.locationNotification(notification:)), name: Notification.Name("RejectTrip"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.locationNotification1(notification:)), name: Notification.Name("AcceptTrip"), object: nil)
        
        viewAdvertisement()
        
        
       
        if LanguageManager.shared.currentLanguage == .ar{
            
            print("\(APPDELEGATE.selectedCatInSpanish)")
            self.title = APPDELEGATE.selectedCatInSpanish + "-" + APPDELEGATE.selectedServiceInSpanish
           
        }
        else
        {
            self.title = APPDELEGATE.selectedCat + "-" + APPDELEGATE.selectedService
        }
       
        
        // Do any additional setup after loading the view.
    }
    
    func checkAvailable() {
        
        let userdict = USERDEFAULTS.getLoggedUserDetails()
        
        let userid = userdict["id"] as! String
        
        let params = ["day": schedulDay,
                      "hour": schedulHour,
                      "service": selectserviceid,
                      "pick_lat":"\(APPDELEGATE.pickupLocation.coordinate.latitude)",
                      "pick_lon":"\(APPDELEGATE.pickupLocation.coordinate.longitude)",]
        
        print("params \(params)")
        
        APIManager.shared.availabilityCheckService(params: params as [String : AnyObject]) { (response) in
            
            if case let msg as String = response?["message"], msg == "Unauthenticated." {
                
                APIManager.shared.refreshToken(params: params as [String : AnyObject]) { (response) in
                    
                    if case let access_token as String = response?["access_token"] {
                        
                        APPDELEGATE.bearerToken = access_token
                        
                        USERDEFAULTS.set(access_token, forKey: "access_token")
                        
                        self.checkAvailable()
                        
                    }
                        
                    else {
                        
                        self.showAlertView(title: "TowRoute".localized, message: "Your session has expired. Please log in again", callback: { (check) in
                            
                            APPDELEGATE.updateLoginView()
                            
                        })
                        
                    }
                    
                }
                
            }
                
            else if case let result as String = response?["result"], result != "" {
                
                let res = result.components(separatedBy: ",")
                
                self.driverids.addObjects(from: res)
                
                print("Driverids result from api \(self.driverids)")
                
//                for driverid in self.driverids {
//
//                    self.getDriversProfile(driveridstr: driverid as! String, location: CLLocation())
//
//                }
                
                self.updateCars1()
                
            }
                
            else {
                //old message ... No Service Providers available for your required timeslot.
                self.showAlertView(title: "TowRoute", message: "No service provider available currently".localized, callback: { (true) in
                    self.dismiss(animated: true, completion: nil)
                })
               
                
            }
            
        }
        
    }
    
    func viewAdvertisement() {
        
        let params = ["mode": mode_value]
        
        print("paramsviewAdvertisement \(params)")
        
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
                for det in details{
                    
                    self.banner_defau_img.isHidden = true
                    self.banner_circle_logo.isHidden = true
                    self.banner_no_rec_found.isHidden = true
                    
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
    
    @objc func locationNotification(notification: Notification){
        
        let alert = UIAlertController(title: "TowRoute".localized, message: "Your job rejected!".localized, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK".localized, style: .default, handler: { (check) in
            
            if self.pulsator != nil {
                
                self.pulsator.stop()
                self.pulsator.removeFromSuperlayer()
                self.requestscreen.isHidden = true
                self.Advertisementscreen.isHidden = false
                self.tableview.isHidden = false
                
                
            }
            
        })
        self.tableview.isHidden = false
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
        
        
        
    }
    
    @objc func locationNotification1(notification: Notification){
        
        NotificationCenter.default.removeObserver(self)
        
        if self.pulsator != nil {
            
            self.pulsator.stop()
            self.pulsator.removeFromSuperlayer()
            
        }
        
        let alert = UIAlertController(title: "TowRoute".localized, message: "Your job accepted!".localized, preferredStyle: .alert)
        
          self.requestscreen.isHidden = true
           let okAction = UIAlertAction(title: "View Ongoing jobs".localized, style: .default, handler: { (check) in
           let OnjobView = self.storyboard?.instantiateViewController(withIdentifier: "Onjob")
            self.topMostViewController().present(OnjobView!, animated: true, completion: nil)
            
        })
        

        //        let cancel = UIAlertAction(title: "Cancel".localized, style: .cancel) { (action) in
//
//            self.requestscreen.isHidden = true
//
//        }
        
        alert.addAction(okAction)
        
       // alert.addAction(cancel)
        
        self.topMostViewController().present(alert, animated: true, completion: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if APPDELEGATE.showRequest == true {
            
            tableview.isHidden = true
            
            APPDELEGATE.showRequest = false
            
            requestscreen.isHidden = false
            banner_defau_img.isHidden = true
            banner_circle_logo.isHidden = true
            banner_no_rec_found.isHidden = true
            Advertisementscreen.isHidden = true
            pulsator = Pulsator()
            
            // carimg.layer.addSublayer(pulsator)
            
            carimg.layer.superlayer?.insertSublayer(pulsator, below: carimg.layer)
            
            pulsator.numPulse = 6
            pulsator.radius = 1 * 200
            pulsator.animationDuration = 0.5 * 10
            pulsator.backgroundColor = UIColor(hexString: "00d5ff")?.cgColor
            pulsator.start()
            
            self.view.bringSubview(toFront: carimg)
            
            self.viewDidLayoutSubviews()
            
        }
        else
        {
            tableview.isHidden = false
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.layer.layoutIfNeeded()
        
        if pulsator != nil {
            
            print("viewDidLayoutSubviews")
            
            pulsator.position = carimg.layer.position
            
        }
        
    }
    
    @IBAction func closeAct(_ sender: Any) {
        
        pulsator.stop()
        pulsator.removeFromSuperlayer()
        
        requestscreen.isHidden = true
        Advertisementscreen.isHidden = false
        
        // Database.database().reference().child("providers").child(driverID).child("trips").removeValue()
        Database.database().reference().child("providers").child(APPDELEGATE.driverID).child("trips").child("service_status").setValue("0")
        tableview.isHidden = false
        PushnotificationToDriver()
        
    }
    
    func PushnotificationToDriver()
    {
        let userdict = USERDEFAULTS.getLoggedUserDetails()
        
        let userid = userdict["id"] as! String
        let params = ["customer_id": userid,
                      "driver_id": APPDELEGATE.driverID]
        print("paramss\(params)")
        //  APIManager.shared.loginUser(params: params as [String : AnyObject]) { (response) in
        
        APIManager.shared.cancelNotificationToDriver(params: params as [String : AnyObject], callback: { (response) in
            
            if case let status as String = response?["message"] {
                
                print(status)
            }
            
        })
    }
    
    @IBAction func bookingAct(_ sender: Any) {
        
        print("tag \((sender as! UIButton).tag)")
        
        print("chkproviderDetails\(providerDetails)")
        
        let dict = providerDetails.object(at: (sender as! UIButton).tag) as! NSDictionary
        
        
        
        var name = ""
        
        if let fname = dict["fname"] {
            
            name = (dict.object(forKey: "fname") as? String)!
            
        }
        
        if let lname = dict["lname"] {
            
            name = name + " " + (dict.object(forKey: "lname") as! String)
            
        }
        
        APPDELEGATE.driverName = name
        
        APPDELEGATE.driverID = "\(driverids[(sender as! UIButton).tag])"
        
        APPDELEGATE.isFromImg = true
        
        let booking = STORYBOARD.instantiateViewController(withIdentifier: "bookings")

        self.present(booking, animated: true, completion: nil)
        
    }
    
    @IBAction func booknowBtn(_ sender: Any) {
        
        
        print("tag \((sender as! UIButton).tag)")
        print("chkproviderDetails\(providerDetails)")
        
        
        let dict = providerDetails.object(at: (sender as! UIButton).tag) as! NSDictionary
        

        print("booknow act dict \(dict)")
        
        var name = ""
        var drv_id = ""
        
        if let fname = dict["fname"] {
            
            name = (dict.object(forKey: "fname") as? String)!
            
        }
        
        if let lname = dict["lname"] {
            
            name = name + " " + (dict.object(forKey: "lname") as! String)
            
        }
        
//        if case let driv_id = dict["trips"] as! NSDictionary{
//            
//            print("chkdriv_id\(driv_id)")
//            
//            drv_id = driv_id["driver_id"] as? String
//            
//            print("chk''drv_id\(drv_id)")
//            
//             APPDELEGATE.driverID = drv_id
//            print("chk_APPDELEGATE.driverID\(APPDELEGATE.driverID)")
//            
//            
//            
//        }
        
        

        
        
        print("driversidsArray \(self.driversidsArray)")
        print("driverslocationArray \(self.driverslocationArray)")

        
        
        if let lname = dict["trips"] {
            
            APPDELEGATE.driverID = "\(lname)"
            
        }
        
        
        APPDELEGATE.driverName = name
        
        
//        print("DRiverids \(driverids)")
//        APPDELEGATE.driverID = "\(driverids[(sender as! UIButton).tag])"
//        print("selected DRiverid \(APPDELEGATE.driverID)")
//
        
               APPDELEGATE.driverID = "\(self.driversidsArray[(sender as! UIButton).tag])"
               print("selected DRiverid \(APPDELEGATE.driverID)")
        APPDELEGATE.isFromImg = true
        
       let booking = STORYBOARD.instantiateViewController(withIdentifier: "bookings")
//
        self.present(booking, animated: true, completion: nil)
    }
    
    
    
    @IBAction func more_info(_ sender: Any) {
        
        print("tag \((sender as! UIButton).tag)")
        
        let dict = providerDetails.object(at: (sender as! UIButton).tag) as! NSDictionary
        
        var name = ""
        
        if let fname = dict["fname"] {
            
            name = (dict.object(forKey: "fname") as? String)!
            
        }
        
        if let lname = dict["lname"] {
            
            name = name + " " + (dict.object(forKey: "lname") as! String)
            
        }
        
        APPDELEGATE.driverName = name
        
        APPDELEGATE.driverID = "\(self.driversidsArray[(sender as! UIButton).tag])"

      //  APPDELEGATE.driverID = "\(driverids[(sender as! UIButton).tag])"
        
        APPDELEGATE.isFromImg = false
        
        let driverdet = STORYBOARD.instantiateViewController(withIdentifier: "driverdetail") as! DriverdetailViewController
        
        driverdet.providerdict = providerDetails.object(at: (sender as! UIButton).tag) as! NSDictionary
        
//        if isBookLater == false {
            
            driverdet.driverLocation = driverlocations.object(at: (sender as! UIButton).tag) as! CLLocation
            
      //  }
        
        // self.navigationController?.pushViewController(loginvc, animated: true)
        self.present(driverdet, animated: true, completion: nil)
        
    }
    
    func updateCars() {
        
                print("pickupLocation \(APPDELEGATE.pickupLocation)")
                
                let center = CLLocation(latitude: APPDELEGATE.pickupLocation.coordinate.latitude, longitude: APPDELEGATE.pickupLocation.coordinate.longitude)
                
                if geofireRef != nil {
                    
                    geofireRef.removeAllObservers()
                    
                    geofireRef = nil
                    
                }
                
                if geoFire != nil {
                    
                    geoFire = nil
                    
                }
                
                geofireRef = Database.database().reference().child("drivers_location")
                
                geoFire = GeoFire(firebaseRef: geofireRef)
                
                if regionQuery != nil {
                    
                    if queryenterhandle != nil {
                        
                        regionQuery.removeObserver(withFirebaseHandle: queryenterhandle)
                        
                    }
                    
                }
                
                regionQuery = geoFire.query(at: center, withRadius: Double(distance_limit))
                
                queryenterhandle = regionQuery?.observe(.keyEntered, with: { (key: String!, location: CLLocation!) in
                    
                    let driverid = key
                    
                    print("driverid \(driverid)")
                    
                    
                    if driverid != ""

                    {            self.driveridsList.append(driverid!)
                        
                        self.driveridsLocation.append(location)
                    }
                    
                    
        //            if !self.driverids.contains(driverid) {
        //
        //                self.getDriversProfile(driveridstr: driverid!, location: location, finished: {
        //
        //
        //                })
        ////
        //         }
                    
                })
                
                
                    
                    
                    
                
                
                if regionQuery != nil {
                    
                    if queryexithandle != nil {
                        
                        regionQuery.removeObserver(withFirebaseHandle: queryexithandle)
                        
                    }
                    
                }
                
                queryexithandle = regionQuery?.observe(.keyExited, with: { (key: String!, location: CLLocation!) in
                    
                    if self.driverids.contains(key) {
                        
                        let driver_id_index = self.driverids.index(of: key)
                        
                        self.driverids.removeObject(at: driver_id_index)
                        
                        if self.driverlocations.count > 0 {
                            
                            self.driverlocations.removeObject(at: driver_id_index)
                            
                        }
                        
                        self.providerDetails.removeObject(at: driver_id_index)
                        self.tableview.reloadData()
                        
                    }
                    
                })
                
                

                regionQuery.observeReady {
                    
                    
                    print("Finished Running regionQuery")

                    
                    
                  if self.driveridsList.count > 0{       //rareissue
                        for id in 0...self.driveridsList.count - 1 {

                        
                            let did = self.driveridsList[id]
                            let dlocation = self.driveridsLocation[id]
                                    if !self.driverids.contains(did) {

                                        self.getDriversProfile(driveridstr: did, location: dlocation, finished: {


                                            if id == self.driveridsList.count - 1

                                            {
                                                            if self.providerDetails.count > 0
                                                            {
                                                
                                                            }
                                                            else
                                                            {
                                                            self.showAlertView(title: "TowRoute", message: "No service provider available currently".localized, callback: { (true) in
                                                                self.dismiss(animated: true, completion: nil)
                                                            })
                                                            }

                                            }
                                            
                                            
                                        })
                 
                                 }
                            
                            
                            
                            
                            
                        }
                        
                    }
                    else{
                        self.showAlertView(title: "TowRoute", message: "No service provider available currently".localized, callback: { (true) in
                            self.dismiss(animated: true, completion: nil)
                        })
                    }

                    
                    
        //            if self.providerDetails.count > 0
        //            {
        //
        //            }
        //            else
        //            {
        //            self.showAlertView(title: "TowRoute", message: "No service provider available currently".localized, callback: { (true) in
        //                self.dismiss(animated: true, completion: nil)
        //            })
        //            }
                }
    }
    
    
    
    func updateCars1() {
        
        print("pickupLocation \(APPDELEGATE.pickupLocation)")
        
        let center = CLLocation(latitude: APPDELEGATE.pickupLocation.coordinate.latitude, longitude: APPDELEGATE.pickupLocation.coordinate.longitude)
        
        if geofireRef != nil {
            
            geofireRef.removeAllObservers()
            
            geofireRef = nil
            
        }
        
        if geoFire != nil {
            
            geoFire = nil
            
        }
        
        geofireRef = Database.database().reference().child("drivers_location")
        
        geoFire = GeoFire(firebaseRef: geofireRef)
        
        if regionQuery != nil {
            
            if queryenterhandle != nil {
                
                regionQuery.removeObserver(withFirebaseHandle: queryenterhandle)
                
            }
            
        }
        
        regionQuery = geoFire.query(at: center, withRadius: Double(distance_limit))
        
        queryenterhandle = regionQuery?.observe(.keyEntered, with: { (key: String!, location: CLLocation!) in
            
            let driverid = key
            
            
            
            print("driverid \(driverid)")
            
            
           // self.driversidsArray.append(driverid!)
           // self.driverslocationArray.append(location!)

            
            
            if self.driverids.contains(driverid!) {

                print("comes here driver id found")
                print("provider details beffore \(self.providerDetails)")
                self.getDriversProfile(driveridstr: driverid!, location: location, finished: {

                })
            }
            else
            {
                print("comes here driver id not found")

            }
            
        })
        
        if ((regionQuery?.observeReady) != nil) {
            
            
            print("Firebbase finished running self.driversidsArray \(self.driversidsArray)")
            print("Firebbase finished running self.driverslocationArray \(self.driverslocationArray)")

            print("Firebbase finished running")
            
            print("provider details finished after firebase load \(self.providerDetails)")
            

          /*  for i in 0...self.driversidsArray.count - 1
            {

                let driverid1 = self.driversidsArray[i]

                let location1 = self.driverslocationArray[i]

                if self.driverids.contains(driverid1) {

                    print("comes here driver id found")
                    print("provider details beffore \(self.providerDetails)")
                    self.getDriversProfile(driveridstr: driverid1, location: location1, finished: {


                        if self.providerDetails.count > 0
                        {
                            self.tableview.reloadData()
                        }


                        else
                        {
                            self.showAlertView(message: "No Service Providers Available")
                        }

                    })
                }
                else
                {
                    print("comes here driver id not found")

                }

            }*/

            
        }
        if regionQuery != nil {
            
            if queryexithandle != nil {
                
                regionQuery.removeObserver(withFirebaseHandle: queryexithandle)
                
            }
            
        }
        
        queryexithandle = regionQuery?.observe(.keyExited, with: { (key: String!, location: CLLocation!) in
            
//            if self.driverids.contains(key) {
//
//                let driver_id_index = self.driverids.index(of: key)
//
//                self.driverids.removeObject(at: driver_id_index)
//
//                if self.driverlocations.count > 0 {
//
//                    self.driverlocations.removeObject(at: driver_id_index)
//
//                }
//
//                self.providerDetails.removeObject(at: driver_id_index)
//                self.tableview.reloadData()
//
//            }
            
        })
        
    }
    
    func getDriversProfile(driveridstr: String, location: CLLocation,finished: @escaping () -> Void) {
        
        
        print("driveridffor \(self.driverids)")
    print("driveridffor getdriversprofile \(driveridstr)")
        geofireprovider.child(driveridstr).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if snapshot.value != nil && snapshot.value as? NSDictionary != nil {
                
                let dict = snapshot.value as! NSDictionary
                
                let providercat = dict.object(forKey: "category") as? String
                
                print("providercat \(providercat) selectserviceid \(self.selectserviceid) driveridstr \(driveridstr)")
                
                if providercat != nil {
                    
                    let catarr = providercat?.components(separatedBy: ",")
                    
                    if (catarr?.contains(self.selectserviceid))! {
                        
//                        if self.isBookLater == true {
//
//                            self.driverids.add(driveridstr)
//                            self.providerDetails.add(snapshot.value)
//                            self.tableview.reloadData()
//
//                        }
                       // else {
                            
                            if case let tripsdict as NSDictionary = dict.object(forKey: "trips") {
                                
                                if let status = tripsdict.object(forKey: "service_status") {
                                    
                                    let stat = "\(status)"
print("DriverStatus \(stat)")
                                    if stat == "0"  || stat == "7" || stat == "8" || stat == "9" {
                                        
                                        self.driverids.add(driveridstr)
                                        
                                        if !self.driversidsArray.contains(driveridstr)
                                        {
                                            self.driversidsArray.append(driveridstr)

                                        }
                                        if !self.driverslocationArray.contains(location)
                                        {
                                            self.driverslocationArray.append(location)

                                        }

                                        

                                        self.driverlocations.add(location)
                                        self.providerDetails.add(snapshot.value)
                                        print("provider details after 1 \(self.providerDetails)")

                                        self.tableview.reloadData()
                                        
                                    }
                                    
                                    else
                                    {
                                        
                                    }
                                    
                                }
                                else {
                                    
//                                    self.driverids.add(driveridstr)
//                                    self.driversidsArray.append(driveridstr)
//                                    self.driverslocationArray.append(location)
//
//                                    self.driverlocations.add(location)
//                                    self.providerDetails.add(snapshot.value)
//                                    self.tableview.reloadData()
//                                    print("provider details after 2 \(self.providerDetails)")

                                }
                                
                            }
                            else {
                                
//                                self.driverids.add(driveridstr)
//                                self.driversidsArray.append(driveridstr)
//                                self.driverslocationArray.append(location)
//
//                                self.driverlocations.add(location)
//                                self.providerDetails.add(snapshot.value)
//                                self.tableview.reloadData()
//
//                                print("provider details after 2 \(self.providerDetails)")

                            }
                            
                        finished()

                      //  }
                        
                    }
                    
                    else
                    {
                        finished()
                    }
                    
                }
                
            }
            
        })
        
        
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return providerDetails.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableview.dequeueReusableCell(withIdentifier: "providerListCell", for: indexPath) as! providerListCell
        
        let dict = providerDetails.object(at: indexPath.row) as! NSDictionary
        
        
        
        let img = dict.object(forKey: "pro_pic") as? String
        
        if (img != nil) && !(img == "") {
            
            var imageUrl: String? = BASEAPI.PRFIMGURL+img!
            cell.prfimg.sd_setImage(with: URL(string: imageUrl!), placeholderImage: #imageLiteral(resourceName: "user(1)"))
            
        }
        else {
            cell.prfimg.sd_setImage(with: URL(string: ""), placeholderImage: #imageLiteral(resourceName: "user(1)"))
        }
        
        cell.prfimg.layer.cornerRadius = (cell.prfimg.frame.size.width) / 2
        cell.prfimg.layer.masksToBounds = true
        
        if let fname = dict["fname"] {
            
            cell.name.text = dict.object(forKey: "fname") as? String
            
        }
        
        if let lname = dict["lname"] {
            
            cell.name.text = cell.name.text! + " " + (dict.object(forKey: "lname") as! String)
            
        }
        
        var rating = "0"
        
        if let rat = dict["rating"] {
            
            rating = "\(dict["rating"]!)"
            
        }
        
        cell.rating.rating = Double(rating)!
        
//        if isBookLater == false {
            
            let dist = APPDELEGATE.pickupLocation.distance(from: driverlocations.object(at: indexPath.row) as! CLLocation)
            
            let distanceBetweenLocations = Utility.convertCLLocationDistanceToKiloMeters(targetDistance: dist)
            
            print("dist \(dist) \(distanceBetweenLocations)")
            
            cell.distance.text = "\(round(distanceBetweenLocations)) KM"
            
      //  }
//        else {
//
//            cell.distance.isHidden = true
//
//        }
        
        
        cell.moreinfobtn.tag = indexPath.row
        cell.bookingbtn.tag = indexPath.row
        cell.booknowBtn.tag = indexPath.row
        cell.selectionStyle = .none
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        return 147
//        if isBookLater == true {
//            
//            return 117
//            
//        }
//        else {
//            
//            return 147
//            
//        }
        
    }
    
    @IBAction func back_act(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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

extension TowingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
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

class providerListCell: UITableViewCell {
    
    @IBOutlet var prfimg: UIImageView!
    @IBOutlet var name: UILabel!
    @IBOutlet var distance: UILabel!
    @IBOutlet var rating: FloatRatingView!
    @IBOutlet var moreinfobtn: UIButton!
    @IBOutlet var bookingbtn: UIButton!
    
    @IBOutlet weak var booknowBtn: UIButton!
}

class Utility {
    
    class func convertCLLocationDistanceToMiles ( targetDistance : CLLocationDistance?) -> CLLocationDistance {
        var targetDistance = targetDistance
        targetDistance =  targetDistance!*0.00062137
        return targetDistance!
    }
    class func convertCLLocationDistanceToKiloMeters ( targetDistance : CLLocationDistance?) -> CLLocationDistance {
        var targetDistance = targetDistance
        targetDistance =  targetDistance!/1000
        return targetDistance!
    }
    
}
