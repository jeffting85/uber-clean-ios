//
//  mainViewController.swift
//  Eventhubdesigns
//
//  Created by Admin on 21/03/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import AVFoundation
import Stripe

class mainViewController: UIViewController {

    var player: AVPlayer?
    
    var timer: Timer!
    
    var langOption = ["English","Arabic"]
    var curOption = ["GBP"]
    var curWithCountry = ["GBP (£)"]
    
    
    @IBOutlet var splashimg: UIImageView!
    @IBOutlet var videoview: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
       // loadVideo()
        
        let params = ["":""] as [String : AnyObject]
               self.appSetting(params: params)
        
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.update), userInfo: nil, repeats: false)
        
    }
    
        @objc func update() {
           
            if USERDEFAULTS.bool(forKey: "login already") {
                let accesstoken = USERDEFAULTS.value(forKey: "access_token")
                APPDELEGATE.bearerToken = accesstoken as! String
                
                var userdict = USERDEFAULTS.getLoggedUserDetails()
                driver_id = (userdict["id"] as? String)!
                
                if let invite_code = userdict["invite_code"] {
                    
                    print("invite_code \(invite_code)")
                    
                    invitecode = "\(invite_code)"
                    
                }
                
                APPDELEGATE.updateHomeView()
            }
            else {
               APPDELEGATE.updateLoginView()
            }
            
        }
    
    @IBAction func skipact(_ sender: Any) {
        
        timer.invalidate()
        timer = nil
        
        update()
        
    }
    
    func appSetting(params: [String : AnyObject]) {
        
        print("params \(params)")
        
        APIManager.shared.appSetting(params: params, callback: { (response) in
            
            if case let key as NSDictionary = response?["app_setting"]
            {
                
                if let timeraccept = key["timedelay_accept"] {
                    
                    let timervalue = timeraccept
                    print("Check App Setting Timer \(timervalue)")
                    tripdelayaccept = timeraccept as! Int
                    print("Check tripdelayaccept \(tripdelayaccept)")
                    
                }
                
                
            }
            
            if case let currency as NSArray = response?["currency"] {
                
                 currarr = currency
                
                self.curOption.removeAll()
                
                self.curWithCountry.removeAll()
                
                               currency_name.removeAll()
                               curr_symbol.removeAll()
                               convertion_ratio_value.removeAll()
                
                for cur in currency {
                    
                    let dict = cur as! NSDictionary
                    
                    let curstr = dict.object(forKey: "short_name") as! String
                    
                    self.curOption.append(curstr)
                    
                    let currency = dict.object(forKey: "currency") as! String
                    
                    let curname = currency + " (" + curstr + ")"
                    
                    self.curWithCountry.append(curname)
                    
                    
                    let currencystr = dict.object(forKey: "currency") as! String
                    let currencycode = dict.object(forKey: "symbol") as! String
                    let currency_conv_ratio = dict.object(forKey: "converions_ratio") as! String
                    
                    currency_name.append(currencystr)
                    curr_symbol.append(currencycode)
                    convertion_ratio_value.append(currency_conv_ratio)
                    
                    print("chckcurrency_name\(currency_name)")
                    print("chckcurr_symbol\(curr_symbol)")
                    print("chckconvertion_ratio_value\(convertion_ratio_value)")
                    
                }
                
            }
            
            if case let currency as NSArray = response?["language"] {
                
                langarr = currency
                 
                 //self.langOption.removeAll()
                 lang_id.removeAll()
                 lang_name.removeAll()
                 lang_Shrtform.removeAll()
                 
                 
                 for cur in currency {
                     
                     let dict = cur as! NSDictionary
                     
                     print("chckdict\(dict)")
                 
                     let langstr = dict.object(forKey: "language_name") as! String
                     let langcode = dict.object(forKey: "language_code") as! String
                     let language_id = dict.object(forKey: "id") as! NSNumber
                 
                     
                     
                     //self.langOption.append(curstr)
                     lang_id.append("\(language_id)")
                     lang_name.append(langstr)
                     lang_Shrtform.append(langcode)
                     
                   print("chcklang_id\(lang_id)")
                     print("chcklang_name\(lang_name)")
                     print("chcklang_Shrtform\(lang_Shrtform)")
                   
                     
                 }
                
            }
            
            if case let msg as NSArray = response?["sms_templates"]{
            print("came in\(msg)")

            for message in msg{



            let dict = message as! NSDictionary

            msgcontent = dict.object(forKey: "sms_content") as! String
            msgcontent_ar = dict.object(forKey: "sms_content_french") as! String
            msgsubject = dict.object(forKey: "sms_subject") as! String
            msgsubject_ar = dict.object(forKey: "sms_subject_french") as! String

            print("chkmsgcontent\(msgcontent)")
            print("chkmsgcontent_ar\(msgcontent_ar)")
            print("chkmsgsubject\(msgsubject)")
            print("chkmsgsubject_ar\(msgsubject_ar)")

            }

            }
            if case let key as NSDictionary = response?["app_setting"]
            {
                
                if let publishkey = key["payment_publisher_key"] {
                    
                    let keys = "\(publishkey)"
                    print("user key \(keys)")
                    Stripe.setDefaultPublishableKey(keys)
                   
                    
                }
                
                
            }
            
            
        })
        
    }
        private func loadVideo() {
            
            //this line is important to prevent background music stop
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient)
            } catch { }
            
            let path = Bundle.main.path(forResource: "TowRoute_new_white_background_no audio", ofType:"mp4")
            
            player = AVPlayer(url: URL(fileURLWithPath: path!))
            let playerLayer = AVPlayerLayer(player: player)
            
            playerLayer.frame = self.view.frame
            playerLayer.videoGravity = AVLayerVideoGravity.resizeAspect
            playerLayer.zPosition = -1
            
            self.videoview.layer.addSublayer(playerLayer)
            
            // player?.seek(to: kCMTimeZero)
            player?.play()
            splashimg.isHidden = true
            
        // Do any additional setup after loading the view.
    } 
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        print("deinit mainViewController")
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

