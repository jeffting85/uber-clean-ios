//
//  HomepageViewController.swift
//  TowRoute User
//
//  Created by Admin on 11/06/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import GoogleMaps
import MapKit
import GooglePlaces
import Alamofire
import MessageUI
import MaterialCard
import SVProgressHUD

class HomepageViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource, CLLocationManagerDelegate, GMSMapViewDelegate, MFMessageComposeViewControllerDelegate {
    
    
    @IBOutlet var currentlab: UILabel!
    @IBOutlet weak var droplab: UILabel!
    
    @IBOutlet var collectionview: UICollectionView!
    @IBOutlet var mapview: GMSMapView!
    
    @IBOutlet var pinimage: UIImageView!
    @IBOutlet weak var Currency_update: UIButton!
    @IBOutlet weak var language_btn: UIButton!
    
    var marker: GMSMarker!
    let manager = CLLocationManager()
    
    var getloc = false
    
    var images = [#imageLiteral(resourceName: "car-wheel"),#imageLiteral(resourceName: "locked-car"),#imageLiteral(resourceName: "fuel-station-pump"),#imageLiteral(resourceName: "tow-truck"),#imageLiteral(resourceName: "battery")]
    
    var colourimages = [#imageLiteral(resourceName: "car-wheelgrey"),#imageLiteral(resourceName: "locked-cargrey"),#imageLiteral(resourceName: "fuel-station-pumpgrey"),#imageLiteral(resourceName: "tow-truckgrey"),#imageLiteral(resourceName: "batterygrey")]
    var categoriesarray = NSMutableArray()
    var names = ["Flat Tire","Key Lock Out","Out Of Fuel","Towing","Jump Start"]
    
    var userLocation = CLLocation()
    
    var locationManager: CLLocationManager!
    var oldselectedcell: CategoryCell! = nil
    var oldselectedindex: Int! = 0
    var button: UIButton!
    var search_holder = "yes"
    var pickuplat = ""
    var pickuplong = ""
    
    var droplat = ""
    var droplong = ""
    var show = ""
    
    var pickupPlaceName = ""
    var dropPlaceName = ""
    
    var langtxt  = ""
    
    @IBOutlet weak var dropLocationView: MaterialCard!
    
    var ispickupselect = true
    
    var selectedCategoryIndex = 0
    
    @IBOutlet weak var donebtn: UIButton!
    
    var done = false
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
    }
    
    var isfromdropdown = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.Currency_update.isHidden = true
        self.language_btn.isHidden = true
        
        getlocation()
        addMenu()
        viewProfile()
        
        
        let camera = GMSCameraPosition.camera(withLatitude: 9.930286, longitude: 78.095500, zoom: 16.0)
        
        mapview.camera = camera
        mapview.delegate = self
        let orgin = UIScreen.main.bounds
        
        var rect = CGRect(x: orgin.width - 60, y: orgin.height / 2, width: 40, height: 40)
        
        button = UIButton(frame: rect)
        
        button.setImage(#imageLiteral(resourceName: "gps-fixed-indicator-3").resizeImage(newWidth: 26), for: UIControlState.normal)
        
        button.addTarget(self, action: #selector(self.getlocation(_:)), for: UIControlEvents.touchUpInside)
        
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        
        button.titleLabel?.textColor = UIColor.white
        
        button.backgroundColor = UIColor.white
        
        button.layer.cornerRadius = 20
        
        button.layer.masksToBounds = true
        
        self.view.addSubview(button)
        
        self.view.bringSubview(toFront: button)
        self.view.bringSubview(toFront: currentlab)
        // let frameSize: CGPoint = CGPoint(x: UIScreen.main.bounds.size.width*0.5 - 20,y: UIScreen.main.bounds.size.height*0.5 - 20)
        
        // pinimage.frame.size.width = 40
        
        // pinimage.frame.size.height = 40
        
        // pinimage.center = frameSize
        
        pinimage.contentMode = .center
        
        pinimage.image = #imageLiteral(resourceName: "marker").resizeImage(newWidth: 40)
        
        // self.view.addSubview(pinimage)
        
        self.view.bringSubview(toFront: pinimage)
        
      //  self.title = "TowRoute User"
        
        let imageView = UIImageView()
        imageView.frame.size.width = 150
        imageView.frame.size.height = 100
        imageView.contentMode = .scaleAspectFit
        let images = UIImage(named: "Spotntow_logo_black_m") //homepagenavigationbarimage
        imageView.image = images
        navigationItem.titleView = imageView
        
       // categories()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
      
    }
        @IBAction func currency_update(_ sender: Any) {
            
            let changecurrency = STORYBOARD.instantiateViewController(withIdentifier: "Currency")
            changecurrency.modalPresentationStyle = .overCurrentContext
            changecurrency.modalTransitionStyle = .crossDissolve
            (self.slideMenuController()?.mainViewController)?.present(changecurrency, animated: false, completion: nil)
            self.slideMenuController()?.closeLeft()
            self.slideMenuController()?.closeRight()
//
            
        }
    
    
    @IBAction func language_act(_ sender: Any) {
        
        let changelanguage = STORYBOARD.instantiateViewController(withIdentifier: "language")
        changelanguage.modalPresentationStyle = .overCurrentContext
        changelanguage.modalTransitionStyle = .crossDissolve
        (self.slideMenuController()?.mainViewController)?.present(changelanguage, animated: false, completion: nil)
        self.slideMenuController()?.closeLeft()
        self.slideMenuController()?.closeRight()

        
    }
    
    
    @IBAction func placePickAct(_ sender: Any) {

        if (sender as! UIButton).tag == 0{
            ispickupselect = true
        }
        
        else {
            ispickupselect = false
        }
        
        isfromdropdown = true
        
      
        
        let autocompleteController = GMSAutocompleteViewController()
//        let filter = GMSAutocompleteFilter()
//        filter.country = Locale.current.regionCode
////        autocompleteController.autocompleteFilter = filter
        
//        let visibleRegion = mapview.projection.visibleRegion()
//        let bounds = GMSCoordinateBounds(coordinate: visibleRegion.farLeft, coordinate: visibleRegion.nearRight)
//        autocompleteController.autocompleteBounds = bounds
//
//
//        //        let predictBounds = GMSCoordinateBounds(coordinate: userLocation.coordinate, coordinate: userLocation.coordinate)
////
////        autocompleteController.autocompleteBounds = predictBounds
      
        
        autocompleteController.delegate = self
        
       // APPDELEGATE.appearance(colorcode: "#FFD204")
        present(autocompleteController, animated: true, completion: nil)
        
    }
    
    var colour = NSMutableArray()
    
    var navview = UINavigationController()
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        colour.removeAllObjects()
        colour.add(indexPath.row)
        
        self.collectionview.reloadData()
        
        selectedCategoryIndex = indexPath.row
        
        let dict = self.categoriesarray.object(at: indexPath.row) as! NSDictionary
        APPDELEGATE.selectedCatID = "\(dict["id"]!)"
        
        
        APPDELEGATE.selectedCat = (dict.object(forKey: "category_name") as? String)!
        APPDELEGATE.selectedCatInSpanish = (dict.object(forKey: "category_name_spanish") as? String)!
         print("\(APPDELEGATE.selectedCatInSpanish)")
        mapview.clear()
        
        self.pinimage.isHidden = false
        let camera = GMSCameraPosition.camera(withLatitude: APPDELEGATE.pickupLocation.coordinate.latitude, longitude: APPDELEGATE.pickupLocation.coordinate.longitude, zoom: 16.0)
        self.mapview.camera = camera
        
        print("Check Category Type: \(dict["category_type"]!)")
        if "\(dict["category_type"]!)" == "1"{
            donebtn.setTitle("Next".localized, for: UIControlState.normal)
            dropLocationView.isHidden = false
            APPDELEGATE.isdroplocationcategory = true
             categoryAddressLbl = "show"
        }
        
        else {
            donebtn.setTitle("Next".localized, for: UIControlState.normal)
            dropLocationView.isHidden = true
            APPDELEGATE.isdroplocationcategory = false
            ispickupselect = true
             categoryAddressLbl = "notshow"
        }
        
    }
        func viewProfile() {
            
      //      let country = self.countrycodetxt.text
            
            
            // profileViewDriver
            
            let userdict = USERDEFAULTS.getLoggedUserDetails()
            
            let userid = userdict["id"] as! String
            
            let params = ["id":userid,
                          "token":APPDELEGATE.bearerToken]
            
            print("params \(params)")
            
            APIManager.shared.profileView(params: params as [String : AnyObject]) { (response) in
                
                if case let msg as String = response?["message"], msg == "Unauthenticated." {
                    
                    APIManager.shared.refreshToken(params: params as [String : AnyObject]) { (response) in
                        
                        if case let access_token as String = response?["access_token"] {
                            
                            APPDELEGATE.bearerToken = access_token
                            
                            USERDEFAULTS.set(access_token, forKey: "access_token")
                            
                            self.viewProfile()
                            
                        }
                            
                        else {
                            
                            self.showAlertView(title: "TowRoute".localiz(), message: "Your session has expired. Please log in again".localiz(), callback: { (check) in
                                
                                APPDELEGATE.updateLoginView()
                                
                            })
                            
                        }
                        
                    }
                    
                }
                    
                else if case let details as NSDictionary = response?["data"] {
                    print("detailsdss\(details)")
                    if case let first_name as String = details["first_name"] {
                        
//                        self.firstname.text = first_name
//                        self.firstnametxt.text = first_name
                    }
                    
                    if case let last_name as String = details["last_name"] {
                        
                      //  self.lastname.text = last_name
                        //self.lastnametxt.text = last_name
                        
                    }
                    
                    if case let email as String = details["email"] {
                        
                     //   self.email.text = email
                       // self.emailtxt.text = email
                        
                    }
                    
                    if case let country_code as String = details["country_code"] {
                        
//                        self.countrycodetxt.text = country_code
//                        self.countrytxt.text = country_code
//                        self.countrycode.text = country_code
                    }
                    
                    if case let phone_number as String = details["phone_number"] {
                        
                      //  self.mobnum.text = phone_number
                        //self.mobiletxt.text = phone_number
                        
                    }
                    
                    if let selindex1 = details["language"] {
                        
                                            self.langtxt = "\(selindex1)"
                                            
                                            print("chkself.langtxt\(self.langtxt)")
                                            
                                            if self.langtxt == "" {
                                                self.language_btn.isHidden = false
                                                
                                            }
                                            else{
                                                self.language_btn.isHidden = true
                                            }
                                            
                        
                    }
                    
                    if case let currency as String = details["currency"] {
                        
                        
                        if currency == ""{
                            print("chkcurrency1\(currency)")
                            self.Currency_update.isHidden = false
                        }
                        
                        else{
                            print("chkcurrency\(currency)")
                            self.Currency_update.isHidden = true
                        }
                        
                      
//                        self.currency.text = currency
//                        self.curtxt.text = currency
                    }
                    
//                    if case let currvalue as String = details["currency"]{
//
//                        if currvalue == ""{
//                             print("chkcurrency\(currency)")
//                        }
//
//
//                    }
                    
                    
                    if case let avatar as String = details["avatar"] {
                        
                        if(!(avatar.isEmpty)){
                            
                            let newavatar = BASEAPI.PRFIMGURL + avatar
                            
                            Alamofire.request(newavatar, method: .get).responseImage { response in
                                guard let image = response.result.value else {
                                    // Handle error
                                    return
                                }
                                
//                                self.profimage.image = image
//                                self.proofimage.image = image
                                
                                // Do stuff with your image
                            }
                            
                        }
                        
                    }
                    
                }
                
            }
            
        }
    
    @IBAction func submitAct(_ sender: Any) {
    
        isfromdropdown = false
        
        let dict = self.categoriesarray.object(at: selectedCategoryIndex) as! NSDictionary
        
        
        if "\(dict["category_type"]!)" == "1"{
            print("catagorytypechck\(dict["category_type"]!)")
            
            if droplat != "" {
                
                
                if donebtn.titleLabel?.text == "Next".localized && done == false{
                    
                    done = true
                    donebtn.setTitle("Next".localized, for: UIControlState.normal)
                    calculateRoutes(from: CLLocationCoordinate2D(latitude: Double(pickuplat)!, longitude: Double(pickuplong)!), to: CLLocationCoordinate2D(latitude: Double(droplat)!, longitude: Double(droplong)!))
                }
                
                else {
                    done = true
                    calculateDistance(from: CLLocationCoordinate2D(latitude: Double(pickuplat)!, longitude: Double(pickuplong)!), to: CLLocationCoordinate2D(latitude: Double(droplat)!, longitude: Double(droplong)!))
                }
                
            }
                
            else
            {
                
                done = false
                self.showAlertView(title: "TowRoute", message: "Please Enter Drop Location".localized)
            }
        }
        else {
           
            done = false
            self.navview = self.storyboard?.instantiateViewController(withIdentifier:"servicecategory") as! UINavigationController
            let service = self.navview.viewControllers[0] as! ServiceCategoryViewController
            let dict = self.categoriesarray.object(at: self.selectedCategoryIndex) as! NSDictionary
            let title = dict.object(forKey: "category_name") as? String
            service.title = title?.localized
            
            if LanguageManager.shared.currentLanguage == .ar{
                service.title = dict.object(forKey: "category_name_spanish") as? String
            }
            
            print("chkkrmdroploctxt\(self.droplab.text!)")
            
            service.catid = "\(dict["id"]!)"
            service.category_type = "\(dict["category_type"]!)"
            service.level_type = "\(dict["level_type"]!)"
            service.level_amount = "\(dict["level_amount"]!)"
            APPDELEGATE.pickupLoationAddress = self.currentlab.text!
            APPDELEGATE.dropLoationAddress = self.droplab.text!
            
            self.present(navview, animated: true, completion: nil)
        }
        
    }
    
    func calculateRoutes(from f: CLLocationCoordinate2D, to t: CLLocationCoordinate2D)  {
        
        let saddr = "\(f.latitude),\(f.longitude)"
        let daddr = "\(t.latitude),\(t.longitude)"
        
        let url = "https://maps.googleapis.com/maps/api/directions/json?&origin=\(saddr)&destination=\(daddr)&sensor=false&mode=driving&key=\(googleApiKey)"
        
        Alamofire.request(url).responseJSON { response in
            
            do {
                let json = try JSONSerialization.jsonObject(with: response.data!, options: .mutableContainers) as! NSDictionary
                
                //We need to get to the points key in overview_polyline object in order to pass the points to GMSPath.
                
                let routes = (json.object(forKey: "routes") as! NSArray)
                
                let status = (json.object(forKey: "status") as! NSString)
                
                if status == "OVER_QUERY_LIMIT" {
                    
                    // let mymarkers = [self.frommarker,self.tomarker]
                    
                    let mymarkers = [APPDELEGATE.pickupLocation,APPDELEGATE.dropLocation]
                    
                    var bounds = GMSCoordinateBounds()
                    for marker in mymarkers
                    {
                        bounds = bounds.includingCoordinate((marker?.coordinate)!)
                    }
                    let update = GMSCameraUpdate.fit(bounds, withPadding: 100)
                    self.mapview.animate(with: update)
                    
                    self.updateMarkers1()
                    
                }
                    
                else if routes.count > 0 {
                    
                    self.mapview.clear()
                    
                    if let routes = json["routes"] as? [Any] {
                        
                        if let route = routes[0] as? [String:Any] {
                            
                            if let legs = route["legs"] as? [Any] {
                                
                                if let leg = legs[0] as? [String:Any] {
                                    
                                    if let steps = leg["steps"] as? [Any] {
                                        
                                        for step in steps {
                                            
                                            if let step = step as? [String:Any] {
                                                
                                                if let polyline = step["polyline"] as? [String:Any] {
                                                    
                                                    if let points = polyline["points"] as? String {
                                                        
                                                        let path  = GMSPath(fromEncodedPath:points)!
                                                        let polyline  = GMSPolyline(path: path)
                                                        polyline.strokeColor = UIColor.black
                                                        polyline.strokeWidth = 5.0
                                                        
                                                        //mapView is your GoogleMaps Object i.e. _mapView in your case
                                                        polyline.map = self.mapview
                                                        
                                                    }
                                                }
                                            }
                                            
                                        }
                                        
                                        // let mymarkers = [self.frommarker,self.tomarker]
                                        
                                        let mymarkers = [APPDELEGATE.pickupLocation,APPDELEGATE.dropLocation]
                                        
                                        var bounds = GMSCoordinateBounds()
                                        for marker in mymarkers
                                        {
                                            bounds = bounds.includingCoordinate((marker?.coordinate)!)
                                        }
                                        // let update = GMSCameraUpdate.fit(bounds, withPadding: 60)
                                        let update = GMSCameraUpdate.fit(bounds, withPadding: 100)
                                        self.mapview.animate(with: update)
                                        
                                        self.updateMarkers1()
                                        
                                    }
                                }
                            }
                        }
                    }
                    
                }
                
            } catch {
            }
            
        }
    }
    
    func calculateDistance(from f: CLLocationCoordinate2D, to t: CLLocationCoordinate2D)  {
        
        SVProgressHUD.setContainerView(topMostViewController().view)
        SVProgressHUD.show()
        
        let saddr = "\(f.latitude),\(f.longitude)"
        let daddr = "\(t.latitude),\(t.longitude)"
        
        let url = "https://maps.googleapis.com/maps/api/distancematrix/json?&origins=\(saddr)&destinations=\(daddr)&mode=driving&key=\(googleApiKey)"
        
        Alamofire.request(url).responseJSON { response in
            
            SVProgressHUD.dismiss()
            
            do {
                let json = try JSONSerialization.jsonObject(with: response.data!, options: .mutableContainers) as! NSDictionary
                
                //We need to get to the points key in overview_polyline object in order to pass the points to GMSPath.
          
                let routes = (json.object(forKey: "rows") as! NSArray)
                
                let status = (json.object(forKey: "status") as! NSString)
                      print("responsekrnvalues\(json)")
                if status == "OVER_QUERY_LIMIT" {
                    
                    self.distancecal(from: f, to: t)
                    
                }
                    
                else if routes.count > 0 {
                    
                    if let elements = ((routes.object(at: 0) as? NSDictionary)?.object(forKey: "elements") as? NSArray)?.object(at: 0) as? NSDictionary {
                        
                        if let distancedict = elements.object(forKey: "distance") as? NSDictionary {
                            
                            let distext = distancedict.object(forKey: "text") as? String
                            let disvalue = distancedict.object(forKey: "value") as? Int
                            print("valueoftxt\(distext)")
                            print("valuedisvalue\(disvalue)")
                            
                            miles_dis_text = distext!
                            miles_dis_value = disvalue!
                            
                            self.navview = self.storyboard?.instantiateViewController(withIdentifier:"servicecategory") as! UINavigationController
                            let service = self.navview.viewControllers[0] as! ServiceCategoryViewController
                            let dict = self.categoriesarray.object(at: self.selectedCategoryIndex) as! NSDictionary
                            let title = dict.object(forKey: "category_name") as? String
                            service.title = title?.localized
                            service.catid = "\(dict["id"]!)"
                            service.category_type = "\(dict["category_type"]!)"
                            service.level_type = "\(dict["level_type"]!)"
                            service.level_amount = "\(dict["level_amount"]!)"
                            let distanceSplit = distext?.components(separatedBy: " ")
                            
                            if distanceSplit![1] == "m"{
                                service.distanceInKm = "\(Double(distanceSplit![0])!/1000)".replacingOccurrences(of: ",", with: ".")
                            }else {
                                service.distanceInKm = distanceSplit![0].replacingOccurrences(of: ",", with: ".")
                            }
                            print("chkkrmdroploctxt1\(self.droplab.text!)")
                            
                            APPDELEGATE.pickupLoationAddress = self.currentlab.text!
                            APPDELEGATE.dropLoationAddress = self.droplab.text!
                            self.present(self.navview, animated: true, completion: nil)
                            
                        }
                        else {
                            
                            self.distancecal(from: f, to: t)
                            
                        }
                        
                    }
                    
                }
                
            } catch {
                self.distancecal(from: f, to: t)
            }
            
        }
    }
    
    func distancecal(from f: CLLocationCoordinate2D, to t: CLLocationCoordinate2D) {
        
        let myLocation = CLLocation(latitude: f.latitude, longitude: f.longitude)
        //My buddy's location
        let myBuddysLocation = CLLocation(latitude: t.latitude, longitude: t.longitude)
        //Measuring my distance to my buddy's (in km)
        let distance = myLocation.distance(from: myBuddysLocation) / 1000
        let distext = String(format: "%.01fkm", distance)
        self.navview = self.storyboard?.instantiateViewController(withIdentifier:"servicecategory") as! UINavigationController
        let service = self.navview.viewControllers[0] as! ServiceCategoryViewController
        let dict = self.categoriesarray.object(at: self.selectedCategoryIndex) as! NSDictionary
        let title = dict.object(forKey: "category_name") as? String
        service.title = title?.localized
        service.catid = "\(dict["id"]!)"
        service.category_type = "\(dict["category_type"]!)"
        service.level_type = "\(dict["level_type"]!)"
        service.distanceInKm = "\(distance)"
        service.level_amount = "\(dict["level_amount"]!)"
        self.present(self.navview, animated: true, completion: nil)
        
    }
    
    @objc func getlocation(_ sender: Any?) {
        
        print("getLocation")
        
        startLocationSerice()
        
    }
    
    func startLocationSerice() {
        
        if CLLocationManager.locationServicesEnabled() == false {
            
            if (UIDevice.current.systemVersion as NSString).floatValue >= 8.0 {
                
                getlocation()
                
            }
            
            // displayLocationEnableMessage()
            
        }
        else {
            
            let status: CLAuthorizationStatus = CLLocationManager.authorizationStatus()
            if status == .denied || status == .restricted
            {
                displayLocationEnableMessage()
            }
            else {
                getlocation()
            }
        }
    }
    
    func displayLocationEnableMessage() {
        
        let alertController = UIAlertController (title: "TowRoute", message: "Location access is currently disable. Turn access on?", preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Yes", style: .default) { (_) -> Void in
            guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        print("Settings opened: \(success)") // Prints true
                    })
                } else {
                    // Fallback on earlier versions
                    UIApplication.shared.openURL(settingsUrl)
                }
            }
        }
        alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: "No", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    @IBAction func alertAct(_ sender: Any) {
        
        getContact()
        
    }
    
    var contactcat = NSMutableArray()
    
    func getContact() {
        
        let userdict = USERDEFAULTS.getLoggedUserDetails()
        
        let userid = userdict["id"] as! String
        
        let params = ["customer_id":userid]
        
        print("params \(params)")
        
        APIManager.shared.contactGet(params: params as [String : AnyObject]) { (response) in
            
            print("responseveess\(response)")
            if case let msg as String = response?["message"], msg == "Unauthenticated." {
                
                APIManager.shared.refreshToken(params: params as [String : AnyObject]) { (response) in
                    
                    if case let access_token as String = response?["access_token"] {
                        
                        APPDELEGATE.bearerToken = access_token
                        
                        USERDEFAULTS.set(access_token, forKey: "access_token")
                        
                        
                    }
                        
                    else {
                        
                        self.showAlertView(title: "TowRoute".localized, message: "Your session has expired. Please log in again", callback: { (check) in
                            
                            APPDELEGATE.updateLoginView()
                            
                        })
                        
                    }
                    
                }
            }
            else if case let details as NSArray = response?["data"], details.count > 0 {
                
                self.contactcat = details.mutableCopy() as! NSMutableArray
                
                var contactnumbers = [String]()
                
                for con in self.contactcat {
                    
                    let dict = con as!NSDictionary
                    let contactnum = dict.object(forKey: "phone_number") as! String
                    contactnumbers.append(contactnum)
                }
                
                if contactnumbers.count > 0 {
                    
                    if LanguageManager.shared.currentLanguage == .en{
                    if (MFMessageComposeViewController.canSendText()) {
                    let controller = MFMessageComposeViewController()
                    controller.body = "\(msgsubject) \n \(msgcontent) https://www.google.co.in/maps/dir/?saddr=&daddr=\(APPDELEGATE.currentLocation.coordinate.latitude),\(APPDELEGATE.currentLocation.coordinate.longitude)&directionsmode=driving"
                    controller.recipients = contactnumbers
                    controller.messageComposeDelegate = self
                    self.present(controller, animated: true, completion: nil)
                    }
                    }
                    else{
                    if (MFMessageComposeViewController.canSendText()) {
                    let controller = MFMessageComposeViewController()
                    controller.body = "\(msgsubject_ar) \n \(msgcontent_ar) https://www.google.co.in/maps/dir/?saddr=&daddr=\(APPDELEGATE.currentLocation.coordinate.latitude),\(APPDELEGATE.currentLocation.coordinate.longitude)&directionsmode=driving"
                    controller.recipients = contactnumbers
                    controller.messageComposeDelegate = self
                    self.present(controller, animated: true, completion: nil)
                    }
                    }
                    
                }
                
            }
            else if case let details as NSArray = response?["data"], details.count == 0 {
                
                let navview = self.storyboard?.instantiateViewController(withIdentifier: "emergencynav") as! UINavigationController
                let viw = navview.viewControllers[0] as! EmergencycontactViewController
                viw.ispresent = true
                self.present(navview, animated: true, completion: nil)
                
            }
            else if case let message as String = response?["message"], message == "No records Found." {
                
                let navview = self.storyboard?.instantiateViewController(withIdentifier: "emergencynav") as! UINavigationController
                let viw = navview.viewControllers[0] as! EmergencycontactViewController
                viw.ispresent = true
                self.present(navview, animated: true, completion: nil)
                
            }
            
            // Do any additional setup after loading the view.
        }
        
    }
    
    func updateMarkers() {
        
        let fromadd = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        
        self.marker = GMSMarker()
        
        self.marker.position = fromadd
        self.marker.icon = #imageLiteral(resourceName: "man").resizeImage(newWidth: 40)
        self.marker.map = self.mapview
        
    }
    
    var frommarker: GMSMarker!
    var tomarker: GMSMarker!
    
    func updateMarkers1(){
        
        if APPDELEGATE.dropLocation != nil && APPDELEGATE.pickupLocation != nil {
            
            let fromadd = CLLocationCoordinate2DMake(APPDELEGATE.pickupLocation.coordinate.latitude, APPDELEGATE.pickupLocation.coordinate.longitude)
            
            self.frommarker = GMSMarker()
            
            self.frommarker.position = fromadd
            self.frommarker.icon = #imageLiteral(resourceName: "img_map_pickup_marker").resizeImage(newWidth: 80)
            self.frommarker.map = self.mapview
            
            let toadd = CLLocationCoordinate2DMake(APPDELEGATE.dropLocation.coordinate.latitude, APPDELEGATE.dropLocation.coordinate.longitude)
            
            self.tomarker = GMSMarker()
            self.tomarker.position = toadd
            self.tomarker.icon = #imageLiteral(resourceName: "marker1").resizeImage(newWidth: 80)
            self.tomarker.map = self.mapview
            
            self.pinimage.isHidden = true
            
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        
        mapview.clear()
        let location = locations[0]
        
        
        userLocation = locations.last!
        let center = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        
        let camera = GMSCameraPosition.camera(withLatitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude, zoom: 15);
        // self.mapview.camera = camera
        self.mapview.animate(to: camera)
        self.mapview.isMyLocationEnabled = true
        updateMarkers()
        
        APPDELEGATE.pickupLocation = CLLocation(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        APPDELEGATE.currentLocation = CLLocation(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        
        print("pickupLocation \(APPDELEGATE.pickupLocation)")
        
        let geocoder = GMSGeocoder()
        
        geocoder.reverseGeocodeCoordinate(location.coordinate) { response, error in
            if let address = response?.firstResult() {
                
                // 3
                let lines = address.lines!
                userAddress = lines.joined(separator: ", ")
                
                if self.getloc == false {
                    
                    self.getloc = true
                    
                    
                    self.currentlab.text = userAddress
                    
                    APPDELEGATE.pickupLoationAddress = userAddress
                    
                }
                
            }
        }
        self.locationManager.stopUpdatingLocation()
        
        categories()
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        
        
        let lat1 = position.target.latitude
        let long1 = position.target.longitude
        
        if self.pinimage.isHidden == true && donebtn.titleLabel?.text == "Next".localized{
            
        }
            
            
        else if ispickupselect == true{
            
            // if self.pinimage.isHidden == false {
            
            pickuplat = "\(lat1)"
            pickuplong = "\(long1)"
            
            APPDELEGATE.pickupLocation = CLLocation(latitude: lat1, longitude: long1)
            
            print("idleAt")
            
            if pickupPlaceName == "" && getloc == true {
                
                getAddressFromLatLon(pdblLatitude: "\(lat1)", withLongitude: "\(long1)", label: currentlab)
                
            }
                
                
            else {
                
                pickupPlaceName = ""
                
            }
            
           // getAddressFromLatLon(pdblLatitude: "\(lat1)", withLongitude: "\(long1)", label: currentlab)

        }
            
            
        else {
           // ispickupselect = true
            droplat = "\(lat1)"
            droplong = "\(long1)"
            APPDELEGATE.dropLocation = CLLocation(latitude: lat1, longitude: long1)

            if dropPlaceName == "" && getloc == true {
                
                getAddressFromLatLon(pdblLatitude: "\(lat1)", withLongitude: "\(long1)", label: droplab)
                
            }
            else {
                
                dropPlaceName = ""
                
            }
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoriesarray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collection", for: indexPath) as! CategoryCell
        
        
        let dict = categoriesarray.object(at: indexPath.row) as! NSDictionary
       

        
        if indexPath.row == self.oldselectedindex {
            
            self.oldselectedcell = cell
            
            //  cell.image.image = colourimages[self.oldselectedindex]
            
        }
            
        else if images.count > indexPath.row {
            
            //  cell.image.image = images[indexPath.row]
            
        }
            
        else {
            
            //cell.image.image = #imageLiteral(resourceName: "tow-truckgrey").resizeImage(newWidth: cell.image.frame.width)
            
        }
        
        if colour.contains(indexPath.row){
            cell.imagebacklab.backgroundColor = UIColor.white
            cell.imagebacklab.layer.borderWidth = 2
            cell.imagebacklab.layer.borderColor = UIColor.init(hexString: "#00d5ff")!.cgColor
           
            //Default Category type set for drop location show on Book Later
            if "\(dict["category_type"]!)" == "1"{
                dropLocationView.isHidden = false
                APPDELEGATE.isdroplocationcategory = true
                 categoryAddressLbl = "show"
            }
            
            else {
                dropLocationView.isHidden = true
                APPDELEGATE.isdroplocationcategory = false
                ispickupselect = true
                 categoryAddressLbl = "notshow"
            } //Default Category set while Page loading
            
        }
        else {
             cell.imagebacklab.backgroundColor = UIColor.clear
             cell.imagebacklab.layer.borderWidth = 0
            cell.imagebacklab.layer.borderColor = UIColor.clear.cgColor
        }
        
        if LanguageManager.shared.currentLanguage == .ar{
             cell.name.text = dict.object(forKey: "category_name") as! String
        }
        else
        {
             cell.name.text = dict.object(forKey: "category_name") as! String
        }
        
        

        
        let img = dict.object(forKey: "category_image") as! String
        
        Alamofire.request(BASEAPI.IMGURL+img, method: .get).responseImage { response in
            guard let image = response.result.value else {
                // Handle error
                print("IMAGENOW\(BASEAPI.IMGURL+img)")
                return
            }
            
            
            
        
            cell.image.image = image
            
            // Do stuff with your image
        }
        
        //////////////////////////////////////////////////////////////////
        
        return cell
        
    }
    
    func categories() {
        let params = ["id": ""]
        
        print("params \(params)")
        
        APIManager.shared.categories(params: params as [String : AnyObject]) { (response) in
            print("responsese\(response)")
            
            if case let msg as String = response?["message"], msg == "Unauthenticated." {
                
                APIManager.shared.refreshToken(params: params as [String : AnyObject]) { (response) in
                    
                    if case let access_token as String = response?["access_token"] {
                        
                        APPDELEGATE.bearerToken = access_token
                        
                        USERDEFAULTS.set(access_token, forKey: "access_token")
                        
                        self.categories()
                        
                    }
                        
                    else {
                        
                        self.showAlertView(title: "TowRoute".localized, message: "Your session has expired. Please log in again", callback: { (check) in
                            
                            APPDELEGATE.updateLoginView()
                            
                        })
                        
                    }
                    
                }
                
            }
                
            else if case let details as NSArray = response?["data"] {
                self.categoriesarray = details.mutableCopy() as! NSMutableArray
                
                self.navview = self.storyboard?.instantiateViewController(withIdentifier:"servicecategory") as! UINavigationController
                let dict = self.categoriesarray.object(at: 0) as! NSDictionary
                let service = self.navview.viewControllers[0] as! ServiceCategoryViewController
                
                
                let title = dict.object(forKey: "category_name") as? String
                service.title = title?.localized
                service.catid = "\(dict["id"]!)"
                service.category_type = "\(dict["category_type"]!)"
                service.level_type = "\(dict["level_type"]!)"
                service.level_amount = "\(dict["level_amount"]!)"
                APPDELEGATE.selectedCat = (dict.object(forKey: "category_name") as? String)!
                APPDELEGATE.selectedCatInSpanish = (dict.object(forKey: "category_name_spanish") as? String)!
                APPDELEGATE.selectedCatID = "\(dict["id"]!)"

                if "\(dict["category_type"]!)" == "1"{
                    APPDELEGATE.isdroplocationcategory = true
                }
                
                else {
                    APPDELEGATE.isdroplocationcategory = false
                }
                
                self.colour.removeAllObjects()
                self.colour.add(0)
                
                self.collectionview.reloadData()
                self.get()
            }
            
        }
    }
    func get()
    {
        if self.categoriesarray.count > selectedCategoryIndex && isfromdropdown == false{
            
            let dict = self.categoriesarray.object(at: selectedCategoryIndex) as! NSDictionary
            
            if "\(dict["category_type"]!)" == "1"{
                donebtn.setTitle("Next".localized, for: UIControlState.normal)
                droplat = ""
                droplab.text = "Your Drop Location".localized
                dropLocationView.isHidden = false
                mapview.clear()
                self.pinimage.isHidden = false
                let camera = GMSCameraPosition.camera(withLatitude: APPDELEGATE.pickupLocation.coordinate.latitude, longitude: APPDELEGATE.pickupLocation.coordinate.longitude, zoom: 16.0)
                self.mapview.camera = camera
            }
                
            else {
                mapview.clear()
                self.pinimage.isHidden = false
                let camera = GMSCameraPosition.camera(withLatitude: APPDELEGATE.pickupLocation.coordinate.latitude, longitude: APPDELEGATE.pickupLocation.coordinate.longitude, zoom: 16.0)
                self.mapview.camera = camera
                donebtn.setTitle("Next".localized, for: UIControlState.normal)
            }
            
        }
    }
   
    
    func getlocation() {
        
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        
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
extension HomepageViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
       
        

        print("venki \(place.name)")
        
        var placedetail = place.name // place.formattedAddress
        
        let arrays : NSArray = place.addressComponents! as NSArray;
        print(arrays)
        for i in 0..<arrays.count {
            
            let dics : GMSAddressComponent = arrays[i] as! GMSAddressComponent
            print("venki dics \(dics)")
            let str : NSString = dics.type as NSString
            print("venki str \(str)")
          
            if (str == "country") {
                placedetail = placedetail! + ", \(dics.name)"
            }
                
            else if (str == "administrative_area_level_1") {
                placedetail = placedetail! + ", \(dics.name)"
            }
                
                
            else if (str == "administrative_area_level_2") {
                placedetail = placedetail! + ", \(dics.name)"
            }
        }
        
        
        self.pinimage.isHidden = false
        
        if ispickupselect == true{
            
            pickupPlaceName = place.name!
            currentlab.text = placedetail
            APPDELEGATE.pickupLoationAddress = placedetail!
            APPDELEGATE.pickupLocation = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
            pickuplat = "\(place.coordinate.latitude)"
            pickuplong = "\(place.coordinate.longitude)"
        }
        
        else {
            
            
            dropPlaceName = place.name!
            droplab.text = placedetail
            APPDELEGATE.dropLoationAddress = placedetail!
            APPDELEGATE.dropLocation = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
            droplat = "\(place.coordinate.latitude)"
            droplong = "\(place.coordinate.longitude)"
            print("chkkrmdroploctxt2\(self.droplab.text!)")
            donebtn.setTitle("Next".localized, for: UIControlState.normal)
        }
        
        let camera = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude, longitude: place.coordinate.longitude, zoom: 16.0)
        
        self.mapview.camera = camera
      
        //APPDELEGATE.appearance(colorcode: "#000000")

        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        
        //APPDELEGATE.appearance(colorcode: "#000000")
        if ispickupselect == true
        {
        ispickupselect = true
        }
            
        else
        {
            ispickupselect = false
        }
            
        dismiss(animated: true, completion: nil)
    }
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        
      


//        if #available(iOS 13.0, *) {
//            let views = viewController.view.subviews
//            let subviewsOfSubview = views.first!.subviews
//            let subOfNavTransitionView = subviewsOfSubview[1].subviews
//            let subOfContentView = subOfNavTransitionView[2].subviews
//            let searchBar = subOfContentView[0] as! UISearchBar
//
//            let searchTextField: UITextField? = searchBar.value(forKey: "searchField") as? UITextField
//            if searchTextField!.responds(to: #selector(getter: UITextField.attributedPlaceholder)) {
//                let attributeDict = [NSAttributedStringKey.foregroundColor: UIColor.init(hexString: "ffd204")!]
//                searchTextField!.attributedPlaceholder = NSAttributedString(string: "Search".localized, attributes: attributeDict)
//                searchBar.backgroundColor = UIColor.white
//                searchBar.shadowColor = UIColor.white
//            }
//
//            let textField = searchBar.value(forKey: "searchField") as! UITextField
//
//            let glassIconView = textField.leftView as! UIImageView
//            glassIconView.image = glassIconView.image?.withRenderingMode(.alwaysTemplate)
//            glassIconView.tintColor = UIColor.black
//
//            let clearButton = textField.value(forKey: "clearButton") as! UIButton
//            clearButton.setImage(clearButton.imageView?.image?.withRenderingMode(.alwaysTemplate), for: .normal)
//            clearButton.tintColor = UIColor.black
//
//        }
//
//
//        else
//        {
//
//        let views = viewController.view.subviews
//        let subviewsOfSubview = views.first!.subviews
//        let subOfNavTransitionView = subviewsOfSubview[1].subviews
//        let subOfContentView = subOfNavTransitionView[2].subviews
//        let searchBar = subOfContentView[0] as! UISearchBar
//
//        let searchTextField: UITextField? = searchBar.value(forKey: "searchField") as? UITextField
//        if searchTextField!.responds(to: #selector(getter: UITextField.attributedPlaceholder)) {
//            let attributeDict = [NSAttributedStringKey.foregroundColor: UIColor.init(hexString: "ffd204")!]
//            searchTextField!.attributedPlaceholder = NSAttributedString(string: "Search".localized, attributes: attributeDict)
//            searchBar.backgroundColor = UIColor.white
//            searchBar.shadowColor = UIColor.white
//        }
//
//        let textField = searchBar.value(forKey: "searchField") as! UITextField
//
//        let glassIconView = textField.leftView as! UIImageView
//        glassIconView.image = glassIconView.image?.withRenderingMode(.alwaysTemplate)
//        glassIconView.tintColor = UIColor.black
//
//        let clearButton = textField.value(forKey: "clearButton") as! UIButton
//        clearButton.setImage(clearButton.imageView?.image?.withRenderingMode(.alwaysTemplate), for: .normal)
//        clearButton.tintColor = UIColor.black
//        // searchBar.text = ""
//        }
       
        
        
        if #available(iOS 13.0, *) {


        }

        else
        {
            
            
            
            let views = viewController.view.subviews
            let subviewsOfSubview = views.first!.subviews
            let subOfNavTransitionView = subviewsOfSubview[1].subviews
            let subOfContentView = subOfNavTransitionView[2].subviews
            
            let searchBar = subOfContentView[0] as! UISearchBar
            
           
            
            // searchBar.text = ""
            
            if search_holder == "yes" {
                searchBar.placeholder = "Search".localiz()

                searchBar.backgroundColor = UIColor.init(hexString: "e68f80") //UIColor.red
            }
            else {
                searchBar.placeholder = "Search".localiz()
                searchBar.backgroundColor = UIColor.init(hexString: "e68f80") //UIColor.red
            }
        }
        


        
    }
    // Turn the network activity indicator on and off again.
//    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
//        UIApplication.shared.isNetworkActivityIndicatorVisible = true
//    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}



class CategoryCell: UICollectionViewCell{
    
    @IBOutlet var image: UIImageView!
    @IBOutlet weak var imagebacklab: UILabel!
    @IBOutlet var name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
