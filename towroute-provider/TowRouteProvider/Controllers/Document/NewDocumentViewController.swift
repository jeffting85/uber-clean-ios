//
//  NewDocumentViewController.swift
//  TowRoute Provider
//
//  Created by DevTeam3 on 23/07/21.
//  Copyright © 2021 Admin. All rights reserved.
//

import UIKit
import Firebase
import SystemConfiguration
import SDWebImage
import MarqueeLabel
class NewDocumentViewController: UIViewController{
    //,RideHistoryVCDelegate,ProfileVCDelegate
//    var viewModel = RideHistoryViewModel()
//     var ProfileviewModel = ProfileViewModel()
    var document_status = ""
    var image_pic = false
    var selectDocument_id = ""
    var selectdocid =  ""
    var selected_image = ""
    var selectDocument_type = ""
     var selectexpiry_date = ""
    var image_Url = ""
    var select_imageVIew = UIImageView()
    var imgArr = NSMutableArray()
    var arrayOfdict = [[String: Any]]()
    var dict = [String:Any]()
var org_Arr = NSArray()
    var new_count = Int()
    var id_String = [String]()
    var id_image = [String]()
    var lang = ""
    var view_document = false
   var reuploadstatus = false
    @IBOutlet weak var skipBtn: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    var table_Arr = [[String:Any]]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.viewModel.delegate = self
//            self.ProfileviewModel.delegate = self
//      if skipBtnStr == "login" {
//
//        self.skipBtn.isHidden = false
//        }
//      else if skipBtnStr == "vehicle" {
//           self.skipBtn.isHidden = true
//        }
//      else {
//        self.skipBtn.isHidden = true
//        }
        print("chkinsidenewdoumnetpagedocumenytnames\(documentnames)")
   //viewDocument()
        fireCheck()
       
//        if self.org_Arr.isEqual(to: [0]) {
//            print("ARRAYGET")
//        }
//        else {
//
//            self.org_Arr = UserDefaults.standard.object(forKey: "arrImg") as? NSArray ?? [0]
//
//            print("ARRAYNONGET\(self.org_Arr.count)")
//            if self.org_Arr.count > 0 {
//                   for i in 0...self.org_Arr.count - 1 {
//
//                           print("arrayscount\(self.org_Arr.count)")
//                              print("self.org\(self.org_Arr)")
//                           let id_val = self.org_Arr[i] as?  NSDictionary
//                           let id = id_val?.value(forKey: "id") as? String
//                                let image = id_val?.value(forKey: "name") as? String
//                           self.id_String.append(id!)
//                            self.id_image.append(image!)
//
//
//
//
//                   }
         //   }

      //  }
       
   
        
//        if let dict = UserDefaults.standard.value(forKey: "arrImg") {
//
//                             var dict_val = dict as? [[String: Any]]
//
//
//            print("user default value \(dict_val)")
//            self.table_Arr = dict_val!
//
//
//
//                        if self.table_Arr.count > 0 {
//                               for i in 0...self.table_Arr.count - 1 {
//
//                                       print("arrayscount\(self.table_Arr.count)")
//                                          print("self.org\(self.table_Arr)")
//                                       let id_val = self.table_Arr[i] as?  NSDictionary
//                                       let id = id_val?.value(forKey: "id") as? String
//                                            let image = id_val?.value(forKey: "name") as? String
//                                       self.id_String.append(id!)
//                                        self.id_image.append(image!)
//
//
//
//
//                               }
//                        }
//
                            
//            self.tableView.reloadData()
//            print("user default present \(dict_val)")
//
//                         }
//                         else {
//
//
//
//            print("no user default")
//
//
//        }
//
        
        
        
        
        
        // Do any additional setup after loading the view.
    }
    
    func managedoc(){
        let userdict = USERDEFAULTS.getLoggedUserDetails()
        
        let userid = userdict["id"] as! String
        
        let params = ["id": driver_id,
                      "type": "driver",
                      "mode": "api"]
        
        print("params \(params)")
        
        APIManager.shared.ManageDocument(params: params as [String : AnyObject]) { (response) in
            
            
            print("responsseManageDocument\(response)")
               if case let data as NSArray = response?["data"]{
                   print("dateapage \(data)")
                   
                  documentnames.removeAll()
                proof_id.removeAll()
                   for descri in data{
                       
                       let des = descri as! NSDictionary
                       
                       
                   
                         
                       let desvalue = des.value(forKey: "document_name") as! String
                       let desvalue1 = des.value(forKey: "id") as! NSNumber
                           print("documentdesname\(desvalue)")
                           print("documentdesid\(desvalue1)")
                       documentnames.append("\(desvalue)")
                     proof_id.append("\(desvalue1)")
                           print("chkdocumens\(documentnames)")
                           print("chkproofid\(proof_id)")

                   }
                self.tableView.reloadData()

                   
            }
            
      }
    
    }

    
    @IBAction func refresh(_ sender: Any) {
       // fireCheck()
    }
    
    func viewDocument() {
        var answervalues = ""
        if LanguageManager.shared.currentLanguage == .en{
            lang = "en"
        }
        else{
            lang = "pt"
        }
        let params = ["driver_id":driver_id,
                             "language":lang]
       APIManager.shared.ViewDoc(params: params as [String : AnyObject]) { (response) in
      
      
      print("responssepagesupportviewDocument\(response)")
      
      if case let data as NSArray = response?["result"]{
          print("dateapage \(data)")
          
        self.view_document = true
        
      
            
           approvedsts.removeAll()
        reason.removeAll()
        documentnames.removeAll()
        proof_id.removeAll()
        document.removeAll()
            for cur in data {
                
                let dict = cur as! NSDictionary
                
                let curstr = dict.object(forKey: "approved_status") as! String
                approvedsts.append(curstr)
                print("chkapprovedsts\(approvedsts)")
                
                let curstr2 = dict.object(forKey: "document_name") as! String
                documentnames.append(curstr2)
                print("chkdocumentnames\(documentnames)")
                
                let curstr3 =  dict.object(forKey: "id") as! NSNumber
                proof_id.append("\(curstr3)")
                print("chkproof_id\(proof_id)")
               
                let curstr4 =  dict.object(forKey: "document") as! Any
                let arr = curstr4 as! String
                document.append("\(arr)")
                print("chkcurstr4\(document)")
                
                if case let desans = dict.object(forKey: "reason") as? String{
                   print("desanswerif\(desans)")
                    if desans == "" || desans == nil {
                      answervalues = ""
                    }
                    else{
                       answervalues = desans as! String
                    }
                    reason.append("\(answervalues)")
                    print("chk_reason\(reason)")
                }
                
            }

        self.tableView.reloadData()
       // self.managedoc()


          
          }
       }
        
    }
    
    func reuploadProfile() {
        
    }
    @IBAction func back_Act(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func skip_Act(_ sender: Any) {
          // self.navigationController?.popViewController(animated: false)
//        let vc = UIStoryboard.init(name: "User", bundle: Bundle.main).instantiateViewController(withIdentifier: "MapViewController") as? MapViewController
//                                         self.navigationController?.pushViewController(vc!, animated: true)
    }
    func fireCheck() {
    
                 Database.database().reference().child("documents_providers").child(driver_id).observe(DataEventType.value) { (SnapShot: DataSnapshot) in
                    
                       if let dict = SnapShot.value as? NSDictionary {


                        self.document_status = dict["Document_status"] as? String ?? ""
                        print("FIrebaseff\(self.document_status)")
                       // self.document_status = "0"
                            if self.document_status == "0" {
                          //  self.new_count = proof_count
                        }
                        else {
                         self.viewDocument()
                        }
                    
                    }
                    
        }
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


extension NewDocumentViewController : UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // return new_count
        // return proof_count
       // return 10
        return documentnames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                let cell = tableView.dequeueReusableCell(withIdentifier: "DocumentCell") as! DocumentCell
        
         cell.proofNameLbl.text = documentnames[indexPath.row]
       
        
        
    
        cell.uploadPicBtn.tag = indexPath.row
        cell.uploadPicBtn.addTarget(self, action: #selector(connected(sender:)), for: .touchUpInside)
        
        
        let name_id = proof_id[indexPath.row] + driver_id
        print("ufufujfnname_id\(name_id)")
        if let id_new = UserDefaults.standard.value(forKey: name_id) as? String {
            print("ufufujfn\(id_new)")
            cell.proofImg.sd_setImage(with: URL(string: BASEAPI.IMGURL + id_new)) { (image, error, cache, urls) in
                                           if (error != nil) {
                                               cell.proofImg.image = #imageLiteral(resourceName: "SpotnrideLogo")
                                               //self.profileImgView.image =  UIImage(named: "user_icon")
                                           } else {
                                               cell.proofImg.image = image
            
                                           }
                                       }
            
        }
        
        else {
         
        }
        
      
        
        if id_String.contains(name_id) {
    


        }
        else {
            
        }
       print("self.viewdocu\(self.view_document)")
        
        if self.document_status == "1" {
            let status = approvedsts[indexPath.row]
            let reason_text = reason[indexPath.row]
            //self.viewModel.data?.RideHistoryListArray[indexPath.row].approved_status
            print("chkreason_text\(reason_text)")
            print("chk_status \(status)")
            
            
                                if status == "0" {
                                    print("statys\(status)")
                                    cell.reasonLbl.isHidden = false
                                    cell.reasonLbl.text = "Pending".localiz()
                                    cell.reasonLbl.textColor = UIColor.white
                                    cell.reasonLbl.backgroundColor = UIColor.black
                                    cell.uploadPicBtn.isHidden = false
                                    self.reuploadstatus = true
                                }
                                else if status == "1" {
                                    cell.reasonLbl.isHidden = false
                                    cell.reasonLbl.text = "Accepted".localiz()
                                    cell.uploadPicBtn.isHidden = true
                                    cell.reasonLbl.backgroundColor = UIColor.systemGreen
                                   // self.reuploadstatus = false
                                }
            
                                else if status == "2" {
                                    cell.reasonLbl.isHidden = false
                                    cell.reasonLbl.text = "Reject Document & reupload".localiz() + " " + "( Reason :- "  + reason_text + " )"
                                    self.reuploadstatus = true
                                    cell.reasonLbl.type = .continuous
                                    cell.reasonLbl.animationCurve = .easeInOut
                                    cell.uploadPicBtn.isHidden = false
                                     cell.reasonLbl.backgroundColor = UIColor.red
            
                                }
        
            
        }


        
        return cell
    
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DocumentCell") as! DocumentCell
     
    }

    func editAct(img :UIImageView) {
          let imageData = img.image?.jpeg(.low)

          let imageStr = imageData?.base64EncodedString()


          let params1 = ["image": imageStr!]


      }

    @objc func connected(sender: UIButton){
     
                  let buttonTag = sender.tag
                  self.selectDocument_id = proof_id[sender.tag]
       // print("chkdocument\(document)")
        if document == []{
            
        }
        else{
            self.selectdocid = document[sender.tag]
        }
                  
                  
                  self.selectDocument_type = documentnames[sender.tag]
                  self.selectexpiry_date = ""
                  print("selectdoccc\(self.selectDocument_type) selectdocid\(self.selectdocid)")
              let buttonPosition = sender.convert(CGPoint.zero, to: self.tableView)
              let indexPath = self.tableView.indexPathForRow(at:buttonPosition)
              let cell = self.tableView.cellForRow(at: indexPath!) as! DocumentCell
                //  let img_value = self.select_imageVIew.image
                  
                  
                  let  img = documentnames[sender.tag]
                  

                         
                         if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
                         {
//                            MediaPicker.shared.showMediaPicker(imageView: cell.proofImg, placeHolder: nil, sender: sender) { (img, check) in
//                              print("checkaimage\(check)")
//                                 if check == true {
//           // self.apiCall( img: cell.proofImg)
//
//
//                                 }
//
//                             }
                            MediaPicker.shared.showMediaPicker(imageView: cell.proofImg, placeHolder: nil) { (img, check) in
                                 
                                 if check == true {
                                     
                                    self.apiCall( img: cell.proofImg)
                                     
                                 }
                                 
                             }

                             
                         }else{
                             let alert = UIAlertController(title: "Warning".localiz(), message: "You don't have camera".localiz(), preferredStyle: .alert)
                             alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                             self.present(alert, animated: true, completion: nil)
                             
                         }

       

  
    }
    
    func apiCall(img : UIImageView) {
   
        let imageData = img.image?.jpeg(.low)
               
               let imageStr = imageData?.base64EncodedString()
               
               
               
               let params1 = ["image": imageStr!]
        
        
       
         APIManager.shared.imageupload(params: params1 as [String : AnyObject]) { (response) in
        
        
        print("responssepagesupportimageupload\(response)")
        
        if case let data as NSString = response?["result"]{
            print("dateapageimageupload \(data)")
            
            let url = data
            self.selected_image = data as String
            img_url.append((url ?? "") as String)
            print("chkreuploadsts-\(self.reuploadstatus)")
            if self.reuploadstatus == false{
                self.uploadImg(document_id: self.selectDocument_id, document_type: self.selectDocument_type, document: url as String, expiry_date: self.selectexpiry_date)
            }
            else{
                self.reupload(document_id: self.selectDocument_id, document_type: self.selectDocument_type, document: url as String, expiry_date: self.selectexpiry_date,docid: self.selectdocid)
            }
      
            }
        else {
            self.showAlertView(message: "Failure")
        }
      }

    }
    
    func uploadImg(document_id : String,document_type:String,document:String,expiry_date :String) {
        
        //ImgUrl
          let params = ["driver_id":driver_id,
                        "language":lang,
                        "document_id": document_id,
                        "document_type":document_type,
                        "document_type_ar":document_type,
                        "document":document,
                        "expiry_date":expiry_date,
                        "expiry_status":"0"]
         APIManager.shared.ImgUrl(params: params as [String : AnyObject]) { (response) in
        
        
        print("responssepagesupportuploadImg\(response)")
        
        if case let data as NSString = response?["message"]{
            print("dateapageImgUrl \(data)")
            
            if data == "Successfully updated." as? NSString{
                
                if case let res as NSDictionary = response!["result"]{
                    
                    let arr = res["document"]! as! String
                    print("chkarr\(arr)")
                    self.image_Url = BASEAPI.IMGURL + arr as! String
                    UserDefaults.standard.set(self.image_Url, forKey: "proof_image")
                      let image =   UserDefaults.standard.string(forKey: "proof_image") ?? ""
                    
                    if image != "" && self.selectDocument_id != "" {
                        
                        self.dict["id"] = self.selectDocument_id
                        self.dict["name"] = image
                        
                        let arr = self.selectDocument_id + driver_id
                        
                        UserDefaults.standard.set(self.selected_image, forKey: "\(arr)")
                        
                    }
                }
                
            }
//            self.viewDocument()


            
            }
         }

//        self.ProfileviewModel.SendImgUrlAPICall(driver_id: driver_id, document_id: document_id, document_type: document_type, document: document, expiry_date: expiry_date, onSuccess: { (status, msg) in
//
//            if msg == "Successfully updated." {
//                self.image_Url = BASEAPI.DEMOIMGURL + (self.ProfileviewModel.data?.document)! as! String
//              UserDefaults.standard.set(self.image_Url, forKey: "proof_image")
//                let image =   UserDefaults.standard.string(forKey: "proof_image") ?? ""
//
//                if image != "" && self.selectDocument_id != "" {
//
//                    self.dict["id"] = self.selectDocument_id
//                    self.dict["name"] = image
//
//
//                    UserDefaults.standard.set(self.selected_image, forKey: "\(self.selectDocument_id)")
//
//
//
//                      }
//
//
//            }
//            else {
//
//            }
//        }) { (msg) in
//
//        }
    }
    func reupload(document_id : String,document_type:String,document:String,expiry_date :String,docid :String){
        let params = ["driver_id":driver_id,
                      "language":lang,
                      "document_id": docid,
                      "document":document,
                      "expiry_date":expiry_date,
                      "id":document_id]
       APIManager.shared.imgreUpload(params: params as [String : AnyObject]) { (response) in
        if case let data as NSString = response?["message"]{
            print("dateapageImgUrl \(data)")
            
            if data == "Successfully updated." as? NSString{
                
                if case let res as NSDictionary = response!["result"]{
                    
                    let arr = res["document"]! as! String
                    print("chkarr\(arr)")
                    self.image_Url = BASEAPI.IMGURL + arr as! String
                    UserDefaults.standard.set(self.image_Url, forKey: "proof_image")
                      let image =   UserDefaults.standard.string(forKey: "proof_image") ?? ""
                    
                    if image != "" && self.selectDocument_id != "" {
                        
                        self.dict["id"] = self.selectDocument_id
                        self.dict["name"] = image
                        
                        let arr = self.selectDocument_id + driver_id
                        
                        UserDefaults.standard.set(self.selected_image, forKey: "\(arr)")
                        
                    }
                }

                self.viewDocument()
            }
        }
       }
    }
    
    
    
}


class DocumentCell: UITableViewCell {
    
    @IBOutlet weak var uploadPicBtn: UIButton!
    @IBOutlet weak var reasonLbl: MarqueeLabel!
    @IBOutlet weak var proofImg: UIImageView!
    @IBOutlet weak var proofNameLbl: UILabel!
}
