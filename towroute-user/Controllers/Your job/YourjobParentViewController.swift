//
//  YourjobParentViewController.swift
//  TowRoute User
//
//  Created by Admin on 07/06/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class YourjobParentViewController: ButtonBarPagerTabStripViewController {
    
    
    let blueInstagramColor = UIColor(red: 37/255.0, green: 111/255.0, blue: 206/255.0, alpha: 1.0)
    let STORYBOARD = UIStoryboard(name: "Main", bundle: nil)
    
    @IBAction func backact(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        // self.dismiss(animated: true, completion: nil)
        
    }
    override func viewDidLoad() {
        
        self.title = "Your Bookings".localized
        
        // change selected bar color
        settings.style.buttonBarBackgroundColor = .white
        settings.style.buttonBarItemBackgroundColor = .white
        settings.style.selectedBarBackgroundColor = UIColor(hexString: "00d5ff")!
        settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 14)
        settings.style.selectedBarHeight = 2.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = UIColor(hexString: "00d5ff")!
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        
        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = UIColor.lightGray //.black
            newCell?.label.textColor = UIColor(hexString: "00d5ff")!
        }
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let WithDrawEarning = STORYBOARD.instantiateViewController(withIdentifier: "past")
        let WithDrawHistory = STORYBOARD.instantiateViewController(withIdentifier: "upcomig")
        return [WithDrawEarning, WithDrawHistory]
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
