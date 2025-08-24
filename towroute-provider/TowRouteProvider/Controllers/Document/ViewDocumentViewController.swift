//
//  ViewDocumentViewController.swift
//  TowRoute Provider
//
//  Created by Vengatesh UPLOGIC on 01/06/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class ViewDocumentViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    var document = UIImage()
    override func viewDidLoad() {
        super.viewDidLoad()
        
  imageView.image = document
  imageView.layer.masksToBounds = true
  imageView.layer.cornerRadius = 5
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
