//
//  DriverdetailViewController.swift
//  TowRoute User
//
//  Created by Admin on 25/06/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import FloatRatingView
import CoreLocation

class DriverdetailViewController: UIViewController {

    @IBOutlet var kilometer: UILabel!
    @IBOutlet var name: UILabel!
    @IBOutlet weak var kw_Away_lbl: UILabel!
    @IBOutlet weak var pin_img: UIImageView!
    
    var providerdict = NSDictionary()
    
    @IBOutlet var prfimg: UIImageView!
    @IBOutlet var about: UILabel!
    @IBOutlet var rating: FloatRatingView!
    var driverLocation = CLLocation()
    var isBookLater = false
    @IBOutlet weak var navbackimg: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        starrating.rating = 4.0
        
        //self.name.text = customer_name + "" + customer_lname
        // Do any additional setup after loading the view.
        
        print("chkAPPDELEGATE.pickupLocation.distance(from: driverLocation)\(APPDELEGATE.pickupLocation.distance(from: driverLocation))")
        
        let img = providerdict.object(forKey: "pro_pic") as? String
        
        if (img != nil) && !(img == "") {
            
            let imageUrl: String? = BASEAPI.IMGURL1+img!
            prfimg.sd_setImage(with: URL(string: imageUrl!), placeholderImage: #imageLiteral(resourceName: "user(1)"))
            
        }
        else {
            prfimg.sd_setImage(with: URL(string: ""), placeholderImage: #imageLiteral(resourceName: "user(1)"))
        }
        
        prfimg.layer.cornerRadius = (prfimg.frame.size.width) / 2
        prfimg.layer.masksToBounds = true
        
        if let fname = providerdict["fname"] {
            
            name.text = providerdict.object(forKey: "fname") as? String
            
        }
        
        if let lname = providerdict["lname"] {
            
            name.text = name.text! + " " + (providerdict.object(forKey: "lname") as! String)
            
        }
        
        var rating1 = "0"
        
        if let rating = providerdict["rating"] {
            
            rating1 = "\(providerdict["rating"]!)"
            
        }
        
        rating.rating = Double(rating1)!
        
//        if APPDELEGATE.isBookLater == false{
            
            self.kilometer.isHidden = false
            self.kw_Away_lbl.isHidden = false
            self.pin_img.isHidden = false
        print("chkdriverLocation\(driverLocation)")
        
        let dist = APPDELEGATE.pickupLocation.distance(from: driverLocation)
        
        let distanceBetweenLocations = Utility.convertCLLocationDistanceToKiloMeters(targetDistance: dist)
        
        print("dist \(dist) \(distanceBetweenLocations)")
        
        kilometer.text = "\(round(distanceBetweenLocations)) Miles"
        print("chkkilometer.text\(kilometer.text)")
        
        
   // }
//        else{
//            self.kilometer.isHidden = true
//            self.kw_Away_lbl.isHidden = true
//            self.pin_img.isHidden = true
//            //kilometer.text = "0.0 km"
//        }
        
        
        
        if let service_desc = providerdict["service_desc"] {
            
            var service_des = "\(service_desc)"
            
            if service_des == "" {
                
                service_des = "Driver Information".localized + "\n\n ---"
                
            }
            
            else {
                
                about.text = "Driver Information".localized + "\n\n" + service_des
                
            }
            
        }
        
        else {
            
            about.text = "Driver Information".localized + "\n\n ---"
            
        }
        
        let gradient = CAGradientLayer()
        let sizeLength = UIScreen.main.bounds.size.height * 2
        let defaultNavigationBarFrame = CGRect(x: 0, y: 0, width: sizeLength, height: 138)
        
        gradient.frame = defaultNavigationBarFrame
        let color1 = UIColor.init(hexString: "#00d5ff")
        let color2 = UIColor.init(hexString: "#00d5ff")
       //let color3 = UIColor.init(hexString: "81223d")
        
        gradient.colors = [color1!.cgColor,color2!.cgColor]//,color3!.cgColor
        
        navbackimg.image = self.image(fromLayer: gradient)
        
    }
    func image(fromLayer layer: CALayer) -> UIImage {
        UIGraphicsBeginImageContext(layer.frame.size)
        
        layer.render(in: UIGraphicsGetCurrentContext()!)
        
        let outputImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return outputImage!
    }
    
    @IBOutlet var starrating: FloatRatingView!
    @IBAction func back(_ sender: Any) {
           self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func next(_ sender: Any) {
        let booking = STORYBOARD.instantiateViewController(withIdentifier: "bookings")
        
     
        self.present(booking, animated: true, completion: nil)
        
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
