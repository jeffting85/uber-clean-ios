//
//  UploadDocumentViewController.swift
//  TowRoute Provider
//
//  Created by Uplogic Technologies on 15/06/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class UploadDocumentViewController: UIViewController {

    @IBOutlet var documentimg: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    var image_pic = false
    
    @IBAction func imguploadact(_ sender: Any) {
    
        MediaPicker.shared.showMediaPicker(imageView: documentimg, placeHolder: nil) { (img, check) in
            
            if check == true {
                
                self.image_pic = true
                
            }
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if image_pic == true{
            
            image_pic = false
            
            let refreshAlert = UIAlertController(title: "Image Upload!".localized, message: "Do You Want Upload Document?".localized, preferredStyle: UIAlertControllerStyle.alert)
            
            refreshAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
                print("Handle Cancel Logic here")
            }))
            
            refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
                print("Handle Ok logic here")
                self.editAct()
            }))
            
            self.present(refreshAlert, animated: true, completion: nil)
        }
        
    }
    
    func editAct() {
        
        let imageData = documentimg.image?.jpeg(.low)
        
        let imageStr = imageData?.base64EncodedString()
        
        let userdict = USERDEFAULTS.getLoggedUserDetails()
        
        let userid = userdict["id"] as! String
        
        let currentTimeStamp = NSDate().timeIntervalSince1970.toString()
        let filename = "\(currentTimeStamp)_img.jpg"
        
        let params = ["id": userid,
                      "certificate": filename,
                      "file_binary_data": imageStr!] as [String : Any]
        
        APIManager.shared.certificateUploadDriver(params: params as [String : AnyObject], callback: { (response) in
            
            if case let msg as String = response?["message"], msg == "Unauthenticated." {
                
                APIManager.shared.refreshToken(params: params as [String : AnyObject]) { (response) in
                    
                    if case let access_token as String = response?["access_token"] {
                        
                        APPDELEGATE.bearerToken = access_token
                        
                        USERDEFAULTS.set(access_token, forKey: "access_token")
                        
                        self.editAct()
                        
                    }
                    
                    else {
                        
                        self.showAlertView(title: "TOWROUTE PROVIDER".localized, message: "Your session has expired. Please log in again", callback: { (check) in
                            
                            NotificationCenter.default.removeObserver(self)
                            
                            APPDELEGATE.updateLoginView()
                            
                        })
                        
                    }
                    
                }
                
            }
                
            else if case let details as NSDictionary = response?["data"] {
                
            }
            
            if case let msg as String = response?["message"], msg != "Unauthenticated."{
                
                if case let details as NSDictionary = response?["data"] {
                    
                    var myuserinfo = USERDEFAULTS.getLoggedUserDetails()
                    
                    if let driver_certificate = details["driver_certificate"] {
                        
                        let driver_cert = "\(driver_certificate)"
                        
                        myuserinfo.updateValue(driver_cert, forKey: "driver_cert")
                        
                    }
                    
                    USERDEFAULTS.saveLoginDetails(logininfo: myuserinfo as! [String: String])
                    
                }
                
                if msg == "driver Certificate updated successfully."{
                    self.showAlertView(message: "Driver Certificate updated successfully.".localized)
                }else {
                    self.showAlertView(message: msg.localized)
                }
                
            }
            
            
        })
        
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
