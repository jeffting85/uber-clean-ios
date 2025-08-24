//
//  DetailsViewController.swift
//  TowRoute User
//
//  Created by Vengatesh UPLOGIC on 03/07/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    
    
    
    @IBOutlet weak var offerTitle: UILabel!
    @IBOutlet weak var offerExp: UILabel!
    @IBOutlet weak var offerTxtView: UITextView!
    var offertitle = ""
    var offerexp = ""
    var offerdesc = ""
    var titleString = "TowRoute"
    override func viewDidLoad() {
        super.viewDidLoad()

        
        offerTitle.text = offertitle
        offerTxtView.attributedText = offerdesc.convertHtmlToAttributedStringWithCSS(font: UIFont(name: "Arial", size: 16), csscolor: "black", lineheight: 5, csstextalign: "justify")
        offerExp.text = offerexp
       
        
        offerTxtView.isEditable = false
      //self.navigationController?.navigationBar.topItem?.title = ""
        self.title = titleString
        
        
        let color = UIColor.init(hexString: "#00d5ff")
        offerTxtView.layer.borderColor = color?.cgColor
        offerTxtView.layer.borderWidth = 1
       

      //  scrolloutlet.contentSize = CGSize(width: scrolloutlet.width, height: offerDescription.)
        // Do any additional setup after loading the view.
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
