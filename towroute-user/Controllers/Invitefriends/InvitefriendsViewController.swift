//
//  InvitefriendsViewController.swift
//  TowRoute User
//
//  Created by Admin on 07/06/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class InvitefriendsViewController: UIViewController {
    
    @IBOutlet var invitecodetxt: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        invitecodetxt.text = invitecode
        self.title = "INVITE FRIENDS".localized
        //addMenu()
        // Do any additional setup after loading the view.
    }
    @IBAction func backact(_ sender: Any) {
        
        //self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func shareact(_ sender: Any) {
        
        let c = "Hello I am using TowRoute. Its an amazing app. Signup using below referral code and enjoy job. My Referral Code:".localized
        let text = "\(c) \(invitecode!)"
        
        // set up activity view controller
        let textToShare = [ text ]
        
        
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
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
