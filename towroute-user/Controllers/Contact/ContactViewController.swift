//
//  ContactViewController.swift
//  TowRoute User
//
//  Created by Admin on 08/06/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import Material
import JVFloatLabeledTextField

class ContactViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet var reason: JVFloatLabeledTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //addMenu()
        // Do any additional setup after loading the view.
    }
    @IBAction func backact(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
