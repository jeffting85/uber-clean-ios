//
//  ServiceRequestViewController.swift
//  TowRoute Provider
//
//  Created by Uplogic Technologies on 03/07/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import HCSStarRatingView
import Firebase
import AVFoundation

class ServiceRequestViewController: UIViewController {

    @IBOutlet var starrating: HCSStarRatingView!
    @IBOutlet var timerLab: UILabel!
    
    @IBOutlet var pickuplocationlab: UILabel!
    @IBOutlet var instrulab: UILabel!
    @IBOutlet var cusnamelab: UILabel!
    
    @IBOutlet weak var navbackimg: UIImageView!
    var pickuploc = ""
    var instru = ""
    var cusname = ""
    var customer_id = ""
    var main_service = ""
    var main_service_ar = ""
    var sub_service = ""
    var sub_service_ar = ""
    var estimated_distance = ""
    
    var pickup_lat = ""
    var pickup_lng = ""
    var paymode = ""
    var promocode = ""
    var stripetoken = ""
    var drop_lat = ""
    var drop_lon = ""
    var drop_location = ""
    
    @IBOutlet var pickupheightcons: NSLayoutConstraint!
    @IBOutlet weak var dropheightcons: NSLayoutConstraint!
    @IBOutlet weak var serviceLbl: UILabel!
    
    @IBOutlet weak var categoryLbl: UILabel!
    
    var timer = Timer()
    
    var player: AVAudioPlayer?
    
    @IBOutlet weak var droplab: UILabel!
    @IBOutlet weak var dropval: UILabel!
    @IBOutlet weak var specialtopcons: NSLayoutConstraint!
    @IBOutlet weak var est_distance: UILabel!
    @IBOutlet weak var est_view: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        print("chkdroploc\(drop_location)")
        
      
        if LanguageManager.shared.currentLanguage == .ar{
            
            serviceLbl.text = main_service_ar
            categoryLbl.text = sub_service_ar
            
        }
        
        else
        {
            let mainservice = main_service.components(separatedBy: ":")
            let subservice = sub_service.components(separatedBy: ":")
            
            serviceLbl.text = mainservice[1]
            categoryLbl.text = subservice[1]
        }
        
        print("chk_estimated_distance\(estimated_distance)")
        
        if estimated_distance == "NoDistance"{
            est_view.isHidden = true
        }
        else{
           est_view.isHidden = false
            est_distance.text = "\(estimated_distance)"
        }
        
        
        //NoDistance
        
        
        
        timerLab.layer.borderColor = UIColor.white.cgColor
        timerLab.layer.borderWidth = 2.0
        
        starrating.backgroundColor = UIColor.clear
        starrating.emptyStarColor = UIColor(hex: "333333")
        starrating.starBorderColor = UIColor(hex: "ffd204")
        starrating.tintColor = UIColor(hex: "ffd204")
        
        starrating.isEnabled = false
        
        if instru == "" {
            
            instru = "--------"
            
        }
        
        pickuplocationlab.text = pickuploc
        instrulab.text = instru
        print("checkinstrulab\(instrulab.text)")
        cusname = cusname.replacingOccurrences(of: ":", with: " ")
        
        cusnamelab.text = cusname
        
        let syswidth = UIScreen.main.bounds.width
        
        self.pickupheightcons.constant = (self.pickuplocationlab.text?.heightWithConstrainedWidth(width: syswidth, font: self.pickuplocationlab.font))! + 10
        
        if drop_location != "NoDrop"{
            
            droplab.isHidden = false
            dropval.isHidden = false
            dropval.text = drop_location
            
            self.dropheightcons.constant = (self.dropval.text?.heightWithConstrainedWidth(width: syswidth, font: self.dropval.font))! + 10
            
        }
      
        else {
            self.specialtopcons.constant = -67
        }
        
        runTimer()

        playSound()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.locationNotification(notification:)), name: Notification.Name("CancelTrip"), object: nil)
        
        let fireRef = Database.database().reference()
        
        fireRef.child("users").child(customer_id).child("rating").observeSingleEvent(of: DataEventType.value) { (SnapShot: DataSnapshot) in
            
            if let statusval = SnapShot.value {
                
                let rating = "\(statusval)"
                
                print("rating \(rating)")
                
                if rating != "<null>" {
                    
                    self.starrating.value = CGFloat(Double(rating)!)
                    
                }
                
            }
            
        }
        let gradient = CAGradientLayer()
        let sizeLength = UIScreen.main.bounds.size.height * 2
        let defaultNavigationBarFrame = CGRect(x: 0, y: 0, width: sizeLength, height: 100)
        
        gradient.frame = defaultNavigationBarFrame
        let color1 = UIColor.init(hexString: "00d5ff")
        let color2 = UIColor.init(hexString: "ffffff")
        
        gradient.colors = [color1!.cgColor,color2!.cgColor]//,color3!.cgColor
        
        navbackimg.image = image(fromLayer: gradient)
        // Do any additional setup after loading the view.
    }
  
  
    override func viewWillAppear(_ animated: Bool) {
    
        print("viewillappercalled in request page")
       
        
    }
    
    func playSound() {
     
        print("playSound in request page")
      
        DispatchQueue.main.async {
         
            guard let url = Bundle.main.url(forResource: "uber_beep_sound", withExtension: "mp3") else { return }
            
            do {
                
                
                try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, mode: AVAudioSessionModeDefault, options: [.mixWithOthers, .duckOthers])
                            print("Playback OK")
                            try AVAudioSession.sharedInstance().setActive(true)
                
                //try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
                //try AVAudioSession.sharedInstance().setActive(true)
                
                
                
                /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
               
                self.player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
                
                /* iOS 10 and earlier require the following line:
                
                 player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */
                
                guard let player = self.player else { return }
                
                player.numberOfLoops = -1
                
                player.play()
                
            } catch let error {
                print("playsoundcatcherror")
                print(error.localizedDescription)
            }
        
        }
        

    }
    
    var seconds = tripdelayaccept
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(ServiceRequestViewController.updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        
        seconds -= 1
        
        if seconds == 0 {
            
            self.timer.invalidate()
            self.seconds = tripdelayaccept
            
            if player != nil {
                
                player?.stop()
                
            }
            
            // Database.database().reference().child("providers").child(driver_id).child("trips").removeValue()
            Database.database().reference().child("providers").child(driver_id).child("trips").child("service_status").setValue("9")
            Database.database().reference().child("providers").child(driver_id).child("trips").child("service_status").setValue("0")
            
            Database.database().reference().child("users").child(customer_id).child("trips").child("accept_status").setValue("1")
            
            NotificationCenter.default.removeObserver(self)
            
            self.dismiss(animated: true, completion: nil)
            
            // timeoutRequest()
            
        }
        
        if seconds < 10 {
            timerLab.text = "00:0\(seconds)"
        }
        else {
            timerLab.text = "00:\(seconds)"
        }
        
    }
    
    @IBAction func declineAct(_ sender: Any) {
        
    
        self.timer.invalidate()
        self.seconds = tripdelayaccept
        
        if player != nil {
            
            player?.stop()
            
        }
        
        // Database.database().reference().child("providers").child(driver_id).child("trips").removeValue()
        Database.database().reference().child("providers").child(driver_id).child("trips").child("service_status").setValue("9")
        Database.database().reference().child("providers").child(driver_id).child("trips").child("service_status").setValue("0")
        
        Database.database().reference().child("users").child(customer_id).child("trips").child("accept_status").setValue("1")
        
        NotificationCenter.default.removeObserver(self)
        
        self.dismiss(animated: true, completion: nil)
        PushnotificationToCustomer()
        
        
    }
   
    func PushnotificationToCustomer()
    {
        
        let params = ["customer_id": customer_id,
                      "driver_id": driver_id,
                      "mode": "reject"]
        print("paramss\(params)")
        //  APIManager.shared.loginUser(params: params as [String : AnyObject]) { (response) in
        
        APIManager.shared.notificationToCustomer(params: params as [String : AnyObject], callback: { (response) in
            
            if case let status as String = response?["message"] {
                
                print(status)
            }
            
        })
    }
    
    @objc func locationNotification(notification: Notification){
        
        
        self.timer.invalidate()
        self.seconds = tripdelayaccept
        
        if player != nil {
            
            player?.stop()
            
        }
        
        // Database.database().reference().child("providers").child(driver_id).child("trips").removeValue()
//        Database.database().reference().child("providers").child(driver_id).child("trips").child("service_status").setValue("9")
//        Database.database().reference().child("providers").child(driver_id).child("trips").child("service_status").setValue("0")
//
//        Database.database().reference().child("users").child(customer_id).child("trips").child("accept_status").setValue("1")
        
        NotificationCenter.default.removeObserver(self)
        
        
        
        self.showAlertView(title: "TOWROUTE PROVIDER".localized, message: "Customer cancel the service".localized, callback: { (check) in
            
          self.dismiss(animated: true, completion: nil)
            
        })
        
    }
    
    @IBAction func acceptAct(_ sender: Any) {
        
        self.timer.invalidate()
        self.seconds = tripdelayaccept
        
        if player != nil {
            
            player?.stop()
            
        }
        
        NotificationCenter.default.removeObserver(self)
        
        let mainservice = main_service.components(separatedBy: ":")
        let subservice = sub_service.components(separatedBy: ":")
        
        var params = ["mode":"accept",
                      "customer_id":customer_id,
                      "driver_id":driver_id,
                      "customer_location":pickuploc,
                      "service_id":subservice[0],
                      "category":mainservice[0],
                      "customer_lat":pickup_lat,
                      "customer_lon":pickup_lng,
                      "payment_type":paymode,
                      "promocode":promocode,
                      "special_instruction":instru,
                      "drop_lat":drop_lat,
                      "drop_lon":drop_lon,
                      "drop_location":drop_location,
            ] as [String : Any]

        if paymode == "card" {
            
            params["stripe_token"] = stripetoken
            
        }
        
        print("params \(params)")
        
        APIManager.shared.acceptService(params: params as [String : AnyObject]) { (response) in
            
            if case let msg as String = response?["message"], msg == "Unauthenticated." {
                
                APIManager.shared.refreshToken(params: params as [String : AnyObject]) { (response) in
                    
                    if case let access_token as String = response?["access_token"] {
                        
                        APPDELEGATE.bearerToken = access_token
                        
                        USERDEFAULTS.set(access_token, forKey: "access_token")
                        
                        self.acceptAct(self)
                        
                    }
                        
                    else {
                        
                        self.showAlertView(title: "TOWROUTE PROVIDER".localized, message: "Your session has expired. Please log in again", callback: { (check) in
                            
                            NotificationCenter.default.removeObserver(self)
                            
                            APPDELEGATE.updateLoginView()
                            
                        })
                        
                    }
                    
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
