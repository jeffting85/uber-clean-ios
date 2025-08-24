//
//  DocumentViewController.swift
//  TowRoute Provider
//
//  Created by Uplogic Technologies on 15/06/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import Alamofire

class DocumentViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet var workbtn: UIButton!
    @IBOutlet var boarderlab: UILabel!
    
    @IBOutlet var rightarrow: UIImageView!
    @IBOutlet var downimg: UIImageView!
    @IBOutlet var managebtn: UIButton!
    @IBOutlet var userimg: UIImageView!
    @IBOutlet weak var documents_lbl: UILabel!
    
    var image_pic = false
    var viewArray = [[String:Any]]()
    var pickedImage = UIImageView()
    var reject = ""
    var imageid = ""
    var imagename = ""
    @IBOutlet weak var imagetableView: UITableView!
    
    @IBOutlet weak var documentnameTxtfld: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        workbtn.layer.cornerRadius = 5
        workbtn.layer.borderWidth = 1
        workbtn.layer.borderColor = UIColor.lightGray.cgColor
        
       // boarderlab.layer.cornerRadius = 5
       // boarderlab.layer.borderWidth = 1
      //  boarderlab.layer.borderColor = UIColor.lightGray.cgColor
        
        self.rightarrow.transform = CGAffineTransform(rotationAngle: (90 * .pi) / 180.0)
        viewDocuments()
        imagetableView.dataSource = self
        imagetableView.delegate = self
        
        if LanguageManager.shared.currentLanguage == .ar{
            self.documents_lbl.textAlignment = .right
        }
        else{
            self.documents_lbl.textAlignment = .left
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
       
        if image_pic == true{
            
            image_pic = false
            
            let refreshAlert = UIAlertController(title: "Image Upload!".localized, message: "Do You Want Upload Document?".localized, preferredStyle: UIAlertControllerStyle.alert)
            
            refreshAlert.addAction(UIAlertAction(title: "No".localized, style: .cancel, handler: { (action: UIAlertAction!) in
                print("Handle Cancel Logic here")
            }))
            
            refreshAlert.addAction(UIAlertAction(title: "Yes".localiz(), style: .default, handler: { (action: UIAlertAction!) in
                print("Handle Ok logic here")
                if self.reject == ""
                {
                    self.editAct()
                }
                else
                {
                    self.reupload()
                }
                
            }))
            
            self.present(refreshAlert, animated: true, completion: nil)
        }
        
        
    }
    
    var show = false

    @IBAction func showAct(_ sender: Any) {
    
        if viewArray.isEmpty
        {
            self.showAlertView(message: "No Documents Available".localized)
            
        }
        
        else if show == false {
            
            show = true
          //  boarderlab.isHidden = false
           // downimg.isHidden = false
            imagetableView.isHidden = false
           // managebtn.isHidden = false
            
            UIView.animate(withDuration:0.5, animations: {
                self.rightarrow.transform = CGAffineTransform(rotationAngle: (270.0 * .pi) / 180.0)
            })
            
        }
        
        else {
            
            show = false
          //  boarderlab.isHidden = true
           // downimg.isHidden = true
            imagetableView.isHidden = true
         //   managebtn.isHidden = true
            
            UIView.animate(withDuration:0.5, animations: {
                self.rightarrow.transform = CGAffineTransform(rotationAngle: (90.0 * .pi) / 180.0)
            })
            
            
            
        }
        
    }
    
    @IBAction func manageAct(_ sender: Any) {
        
        reject = ""
        adddocument()
    }
    
    func adddocument()
    {
        if reject == "rejected"
        {
            
            MediaPicker.shared.showMediaPicker(imageView: pickedImage, placeHolder: nil) { (img, check) in
                
                if check == true {
                    
                    self.image_pic = true
                   
                }
                
            }
            
            
            
        }
       
        else if viewArray.count == 5
        {
            self.showAlertView(message: "Documents Upload Limit Reached".localized)
        }
        
        else if documentnameTxtfld.text == ""
        {
            self.showAlertView(message: "Please Enter Document Name".localiz())
        }
     else
        {
            
            MediaPicker.shared.showMediaPicker(imageView: pickedImage, placeHolder: nil) { (img, check) in
                
                if check == true {
                    
                    self.image_pic = true
                    
                }
                
            }
            
        }
        
        
        /*  if APPDELEGATE.driverapproved == true {
            
            self.showAlertView(message: "Oops!! You cannot change your documents currently, Kindly contact your admin for further details.".localized)
            return
            
        }
        
        
        let availPage = storyboard?.instantiateViewController(withIdentifier:"uploaddocument")
        availPage?.title = "Upload document"
        self.navigationController?.pushViewController(availPage!, animated: true)*/
        
        
        
        
        
    }
    
    var documentInteractionController: UIDocumentInteractionController!
    
    @IBAction func viewdocumentAct(_ sender: Any) {
    
        
       if userimg.image == #imageLiteral(resourceName: "download")
       {
        
        }
        else
       {
        let yourVC = self.storyboard?.instantiateViewController(withIdentifier: "ViewDocumentViewController") as! ViewDocumentViewController
        yourVC.document = userimg.image!
         self.navigationController?.pushViewController(yourVC, animated: true)
        }
        
//        let farevc = STORYBOARD.instantiateViewController(withIdentifier: "ViewDocumentViewController") as! ViewDocumentViewController
//        farevc.document = userimg.image!
//        self.topMostViewController().view.window?.addSubview(farevc.view)
//        self.topMostViewController().addChildViewController(farevc)
//        farevc.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
//        farevc.view.alpha = 0
//        UIView.animate(withDuration: 0.25, animations: {
//
//            farevc.view.alpha = 1
//            farevc.view.transform = CGAffineTransform(scaleX: 1, y: 1)
//
//        })
        
    }
    
    func viewDocuments()
    {
          let userdict = USERDEFAULTS.getLoggedUserDetails()
         let userid = userdict["id"] as! String
         let params = ["driver_id": userid] as [String : Any]
        
        APIManager.shared.viewDocument(params: params as [String : AnyObject], callback: { (response) in
            
            
            if case let msg as String = response?["message"], msg == "Unauthenticated." {
                
                APIManager.shared.refreshToken(params: params as [String : AnyObject]) { (response) in
                    
                    if case let access_token as String = response?["access_token"] {
                        
                        APPDELEGATE.bearerToken = access_token
                        
                        USERDEFAULTS.set(access_token, forKey: "access_token")
                        
                        self.viewDocuments()
                        
                    }
                        
                    else {
                        
                        self.showAlertView(title: "TOWROUTE PROVIDER".localized, message: "Your session has expired. Please log in again", callback: { (check) in
                            
                            NotificationCenter.default.removeObserver(self)
                            
                            APPDELEGATE.updateLoginView()
                            
                        })
                        
                    }
                    
                }
                
            }
                
           
            
            if case let msg as String = response?["message"], msg == "success"{
                
              
                
                if let details = response?["result"] {
                   
                    self.viewArray = details as! [[String : Any]]
                    print(self.viewArray)
                   
                        self.imagetableView.reloadData()
                    
                }
            
            }
            
            else {
                if case let msg as String = response?["message"]
                {
                self.showAlertView(message: msg.localized)
            }
            }
            
            
        })
    }
    
    func editAct() {
        
        let imageData = pickedImage.image?.jpeg(.low)
        
        let imageStr = imageData?.base64EncodedString()
        
        let userdict = USERDEFAULTS.getLoggedUserDetails()
        
        let userid = userdict["id"] as! String
        
        let currentTimeStamp = NSDate().timeIntervalSince1970.toString()
        let filename = "\(currentTimeStamp)_img.jpg"
        
        let params = ["id": userid,
                      "certificate": filename,
                      "file_binary_data": imageStr!,
                      "proof_name": documentnameTxtfld.text!] as [String : Any]
        
        
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
                    
                    let doc_name = self.documentnameTxtfld.text! as String
                    print("chkdoc_name\(doc_name)")
                    self.documentnameTxtfld.text = ""
                    self.viewDocuments()
                    self.showAlertView(message: doc_name + " updated successfully.".localized) //default alert msg "Driver Certificate updated successfully."
                    
                    
                }
                    
             
                else {
                    self.showAlertView(message: msg.localized)
                }
                
            }
            else
            {
                 if case let msg as String = response?["message"]
                
                 {
                    self.showAlertView(message: msg.localized)
                 }
                
                
            }
            
            
        })
        
    }
    
    func reupload() {
        
        let imageData = pickedImage.image?.jpeg(.low)
        
        let imageStr = imageData?.base64EncodedString()
        
        let userdict = USERDEFAULTS.getLoggedUserDetails()
        
        let userid = userdict["id"] as! String
        
        let currentTimeStamp = NSDate().timeIntervalSince1970.toString()
        let filename = "\(currentTimeStamp)_img.jpg"
        
        let params = ["driver_id": userid,
                      "certificate": filename,
                      "document_proof": imageStr!,
                      "type": imagename,"id":imageid] as [String : Any]
        
        print(params)
        APIManager.shared.certificateReUploadDriver(params: params as [String : AnyObject], callback: { (response) in
            print(response)
            if case let msg as String = response?["message"], msg == "Unauthenticated." {
                
                APIManager.shared.refreshToken(params: params as [String : AnyObject]) { (response) in
                    
                    if case let access_token as String = response?["access_token"] {
                        
                        APPDELEGATE.bearerToken = access_token
                        
                        USERDEFAULTS.set(access_token, forKey: "access_token")
                        
                        self.reupload()
                        
                    }
                        
                    else {
                        
                        self.showAlertView(title: "TOWROUTE PROVIDER".localized, message: "Your session has expired. Please log in again", callback: { (check) in
                            
                            NotificationCenter.default.removeObserver(self)
                            
                            APPDELEGATE.updateLoginView()
                            
                        })
                        
                    }
                    
                }
                
            }
            
            
            
            if case let msg as String = response?["message"]{
               
                if msg == "success"{
                    self.viewDocuments()
                    self.showAlertView(message: "Driver Certificate updated successfully.".localized)
                    
                }
                else {
                    self.showAlertView(message: msg.localized)
                }
                
            }
            else
            {
                if case let msg as String = response?["message"]
                {
                    self.showAlertView(message: msg.localized)
                }
            }
            
            
        })
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    //    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    //        return 80.0
    //    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! imagecell
       
        var dict = viewArray[indexPath.row]
        if let img = dict["proof_image"] as? String
        {
            
         let imgURL = URL(string: BASEAPI.PRFIMGURL + img)
      
            let placeholder = UIImage(named: "placeholder.png")
            cell.documentImg.af_setImage(withURL: imgURL!, placeholderImage: placeholder)
            
        }
            
            
//            Alamofire.request(imgURL!, method: .get).responseImage { response in
//                print(response)
//                guard let image = response.result.value else {
//                    // Handle error
//                    return
//                }
            
            //   cell.documentImg.image = image
                
                
       // }
        
      
        if let proof = dict["proof_name"] as? String
        {
            cell.documentname.text = proof
        }
        if let reason = dict["approved_status"] as? String
        {
            
            if reason == "0"
            {
                cell.rejectedLbl.isHidden = true
                cell.stausLbl.text = "Pending".localized
            }
            else if reason == "1"
            {
               cell.rejectedLbl.isHidden = true
               cell.stausLbl.text = "Approved".localized
            }
            else if reason == "2"
            {
                cell.rejectedLbl.isHidden = false
                if let reject = dict["reason"] as? String
                {
                cell.stausLbl.text = reject
                }
                else
                {
                    cell.stausLbl.text = "Rejected".localized
                }
            }
            
            
        }
        
       
        cell.documentImg.isUserInteractionEnabled = true
       
        
        
        return cell
    }
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var dict = viewArray[indexPath.row]
        
        if let reason = dict["approved_status"] as? String
        {
            if reason == "2"
            {
                reject = "rejected"
               
                if let id = dict["id"] as? Int
                {
                    imageid = "\(id)"
                }
                if let name = dict["proof_name"] as? String
                {
                    imagename = name
                }
                adddocument()
                
            }
                
            else
            {
                if let img = dict["proof_image"] as? String
                {
                    
                    let imgURL = URL(string: BASEAPI.PRFIMGURL + img)
                    Alamofire.request(imgURL!, method: .get).responseImage { response in
                        print(response)
                        guard let image = response.result.value else {
                            // Handle error
                            return
                        }
                        
                        let yourVC = self.storyboard?.instantiateViewController(withIdentifier: "ViewDocumentViewController") as! ViewDocumentViewController
                        yourVC.document = image
                        self.navigationController?.pushViewController(yourVC, animated: true)
                        
                    }
                }
            }
        }
        
        
        
        
        
        
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
class imagecell : UITableViewCell
{
    @IBOutlet weak var documentname: UILabel!
    
    @IBOutlet weak var documentImg: UIImageView!
    
    @IBOutlet weak var stausLbl: UILabel!
    @IBOutlet weak var rejectedLbl: UILabel!
}
