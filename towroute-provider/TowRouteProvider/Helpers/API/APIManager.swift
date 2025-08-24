//
//  APIManager.swift
//  Noor
//
//  Created by Uplogic-user on 19/05/17.
//  Copyright © 2017 Uplogic. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation
import SVProgressHUD

typealias coordinatesCompletionBlock = (_ coordinate: CLLocationCoordinate2D?) -> Void
typealias responseCompletionBlock = (_ response: AnyObject?) -> Void
typealias readJsonBlock = (_ response: [AnyObject]) -> Void

class APIManager: NSObject {
    static let shared = APIManager()
    
    func imgreUpload(params: [String: AnyObject]?,callback: @escaping responseCompletionBlock){
        apiRequest(stringApi: LoginAPI.imgreUpload, method: .post, parameters: params) { (apiresponse) -> Void in
            callback(apiresponse)
        }
    }
    func imageupload(params: [String: AnyObject]?,callback: @escaping responseCompletionBlock){
           apiRequest(stringApi: LoginAPI.imgUpload, method: .post, parameters: params) { (apiresponse) -> Void in
               callback(apiresponse)
           }
       }// imgUpload
    func ImgUrl(params: [String: AnyObject]?,callback: @escaping responseCompletionBlock){
        apiRequest(stringApi: LoginAPI.imgUrl, method: .post, parameters: params) { (apiresponse) -> Void in
            callback(apiresponse)
        }
    }//imgUrl
    func ViewDoc(params: [String: AnyObject]?,callback: @escaping responseCompletionBlock){
        apiRequest(stringApi: LoginAPI.viewdoc, method: .post, parameters: params) { (apiresponse) -> Void in
            callback(apiresponse)
        }
    }//viewdoc
    func ManageDocument(params: [String: AnyObject]?,callback: @escaping responseCompletionBlock){
           apiRequest(stringApi: LoginAPI.managedocument, method: .post, parameters: params) { (apiresponse) -> Void in
               callback(apiresponse)
           }
       }//managedocument
    func notificationToCustomer(params: [String: AnyObject]?,callback: @escaping responseCompletionBlock){
        apiRequest(stringApi: LoginAPI.notificationToCustomer, method: .post, parameters: params) { (apiresponse) -> Void in
            callback(apiresponse)
        }
    }
    
    func driverlogin(params: [String: AnyObject]?,callback: @escaping responseCompletionBlock){
        apiRequest(stringApi: LoginAPI.driverLogin, method: .post, parameters: params) { (apiresponse) -> Void in
            callback(apiresponse)
        }
    }
    
    func CashPayment(params: [String: AnyObject]?,callback: @escaping responseCompletionBlock){
        apiRequest(stringApi: LoginAPI.cashpayment, method: .post, parameters: params) { (apiresponse) -> Void in
            callback(apiresponse)
        }
    }
    
    func sociallog(params: [String: AnyObject]?,callback: @escaping responseCompletionBlock){
        apiRequest(stringApi: LoginAPI.sociallog, method: .post, parameters: params) { (apiresponse) -> Void in
            callback(apiresponse)
        }
    }
    
    func driverRegister(params: [String: AnyObject]?,callback: @escaping responseCompletionBlock){
        apiRequest(stringApi: LoginAPI.driverRegister, method: .post, parameters: params) { (apiresponse) -> Void in
            callback(apiresponse)
        }
    }
    
    func profileViewDriver(params: [String: AnyObject]?,showloading: Bool = true,callback: @escaping responseCompletionBlock){
        apiRequest(stringApi: LoginAPI.profileViewDriver, method: .post, parameters: params,showloading: showloading) { (apiresponse) -> Void in
            callback(apiresponse)
        }
    }
    
    func updateProfileDriver(params: [String: AnyObject]?,callback: @escaping responseCompletionBlock){
        apiRequest(stringApi: LoginAPI.updateProfileDriver, method: .post, parameters: params) { (apiresponse) -> Void in
            callback(apiresponse)
        }
    }
    
    func checkin(params: [String: AnyObject]?,callback: @escaping responseCompletionBlock){
        apiRequest(stringApi: LoginAPI.checkin, method: .post, parameters: params) { (apiresponse) -> Void in
            callback(apiresponse)
        }
    }
    
    func checkout(params: [String: AnyObject]?,callback: @escaping responseCompletionBlock){
        apiRequest(stringApi: LoginAPI.checkout, method: .post, parameters: params) { (apiresponse) -> Void in
            callback(apiresponse)
        }
    }
    
    func allServicesDriver(params: [String: AnyObject]?,callback: @escaping responseCompletionBlock){
        apiRequest(stringApi: LoginAPI.allServicesDriver, method: .post, parameters: params) { (apiresponse) -> Void in
            callback(apiresponse)
        }
    }
    
    func updateService(params: [String: AnyObject]?,callback: @escaping responseCompletionBlock){
        apiRequest(stringApi: LoginAPI.updateService, method: .post, parameters: params) { (apiresponse) -> Void in
            callback(apiresponse)
        }
    }
    
    func categoriesDriver(params: [String: AnyObject]?,callback: @escaping responseCompletionBlock){
        apiRequest(stringApi: LoginAPI.categoriesDriver, method: .post, parameters: params) { (apiresponse) -> Void in
            callback(apiresponse)
        }
    }
    
    func subCategoriesDriver(params: [String: AnyObject]?,callback: @escaping responseCompletionBlock){
        apiRequest(stringApi: LoginAPI.subCategoriesDriver, method: .post, parameters: params) { (apiresponse) -> Void in
            callback(apiresponse)
        }
    }
    func viewDocument(params: [String: AnyObject]?,callback: @escaping responseCompletionBlock){
        apiRequest(stringApi: LoginAPI.viewDocuments, method: .post, parameters: params) { (apiresponse) -> Void in
            callback(apiresponse)
        }
    }
    func imageUploadDriver(params: [String: AnyObject]?,callback: @escaping responseCompletionBlock){
        apiRequest(stringApi: LoginAPI.imageUploadDriver, method: .post, parameters: params) { (apiresponse) -> Void in
            callback(apiresponse)
        }
    }
    
    func certificateUploadDriver(params: [String: AnyObject]?,callback: @escaping responseCompletionBlock){
        apiRequest(stringApi: LoginAPI.certificateUploadDriver, method: .post, parameters: params) { (apiresponse) -> Void in
            callback(apiresponse)
        }
    }
    func certificateReUploadDriver(params: [String: AnyObject]?,callback: @escaping responseCompletionBlock){
        apiRequest(stringApi: LoginAPI.certificateReUploadDriver, method: .post, parameters: params) { (apiresponse) -> Void in
            callback(apiresponse)
        }
    }
    
    func privacypolicy(params: [String: AnyObject]?,callback: @escaping responseCompletionBlock){
        apiRequest(stringApi: LoginAPI.privacypolicy, method: .post, parameters: params) { (apiresponse) -> Void in
            callback(apiresponse)
        }
    }
    
    func acceptService(params: [String: AnyObject]?,callback: @escaping responseCompletionBlock){
        apiRequest(stringApi: LoginAPI.acceptService, method: .post, parameters: params) { (apiresponse) -> Void in
            callback(apiresponse)
        }
    }
    
    func StripeacceptService(params: [String: AnyObject]?,callback: @escaping responseCompletionBlock){
        apiRequest(stringApi: LoginAPI.stripeacceptService, method: .post, parameters: params) { (apiresponse) -> Void in
            callback(apiresponse)
        }
    }
    
    func refreshToken(params: [String: AnyObject]?,callback: @escaping responseCompletionBlock){
        apiRequest(stringApi: LoginAPI.refreshToken, method: .post, parameters: params) { (apiresponse) -> Void in
            callback(apiresponse)
        }
    }
    
    func pastJobs(params: [String: AnyObject]?,callback: @escaping responseCompletionBlock){
        apiRequest(stringApi: LoginAPI.pastJobs, method: .post, parameters: params) { (apiresponse) -> Void in
            callback(apiresponse)
        }
    }
    
    func upcomingJobs(params: [String: AnyObject]?,showloading: Bool = true,callback: @escaping responseCompletionBlock){
        apiRequest(stringApi: LoginAPI.upcomingJobs, method: .post, parameters: params,showloading: showloading) { (apiresponse) -> Void in
            callback(apiresponse)
        }
    }
    
    func pendingJobs(params: [String: AnyObject]?,showloading: Bool = true,callback: @escaping responseCompletionBlock){
        apiRequest(stringApi: LoginAPI.pendingJobs, method: .post, parameters: params,showloading: showloading) { (apiresponse) -> Void in
            callback(apiresponse)
        }
    }
    
    func acceptJob(params: [String: AnyObject]?,callback: @escaping responseCompletionBlock){
        apiRequest(stringApi: LoginAPI.acceptJob, method: .post, parameters: params) { (apiresponse) -> Void in
            callback(apiresponse)
        }
    }
    
    func declineJob(params: [String: AnyObject]?,callback: @escaping responseCompletionBlock){
        apiRequest(stringApi: LoginAPI.declineJob, method: .post, parameters: params) { (apiresponse) -> Void in
            callback(apiresponse)
        }
    }
    
    func startJob(params: [String: AnyObject]?,callback: @escaping responseCompletionBlock){
        apiRequest(stringApi: LoginAPI.startJob, method: .post, parameters: params) { (apiresponse) -> Void in
            callback(apiresponse)
        }
    }
    
    func viewBankDet(params: [String: AnyObject]?,callback: @escaping responseCompletionBlock){
        apiRequest(stringApi: LoginAPI.viewBankDet, method: .post, parameters: params) { (apiresponse) -> Void in
            callback(apiresponse)
        }
    }
    
    func updateBankDet(params: [String: AnyObject]?,callback: @escaping responseCompletionBlock){
        apiRequest(stringApi: LoginAPI.updateBankDet, method: .post, parameters: params) { (apiresponse) -> Void in
            callback(apiresponse)
        }
    }
    
    func driverAddMoney(params: [String: AnyObject]?,callback: @escaping responseCompletionBlock){
        apiRequest(stringApi: LoginAPI.driverAddMoney, method: .post, parameters: params) { (apiresponse) -> Void in
            callback(apiresponse)
        }
    }
    
    func contactAdd(params: [String: AnyObject]?,callback: @escaping responseCompletionBlock){
        apiRequest(stringApi: LoginAPI.contactAdd, method: .post, parameters: params) { (apiresponse) -> Void in
            callback(apiresponse)
        }
    }
    func contactDelete(params: [String: AnyObject]?,callback: @escaping responseCompletionBlock){
        apiRequest(stringApi: LoginAPI.contactDelete, method: .post, parameters: params) { (apiresponse) -> Void in
            callback(apiresponse)
        }
    }
    func contactGet(params: [String: AnyObject]?,callback: @escaping responseCompletionBlock){
        apiRequest(stringApi: LoginAPI.contactGet, method: .post, parameters: params) { (apiresponse) -> Void in
            callback(apiresponse)
        }
    }
    
    func driverFeedback(params: [String: AnyObject]?,callback: @escaping responseCompletionBlock){
        apiRequest(stringApi: LoginAPI.driverFeedback, method: .post, parameters: params) { (apiresponse) -> Void in
            callback(apiresponse)
        }
    }
    
    func driverFeedbackStore(params: [String: AnyObject]?,callback: @escaping responseCompletionBlock){
        apiRequest(stringApi: LoginAPI.driverFeedbackStore, method: .post, parameters: params) { (apiresponse) -> Void in
            callback(apiresponse)
        }
    }
    
    func updatePassword(params: [String: AnyObject]?,callback: @escaping responseCompletionBlock){
        apiRequest(stringApi: LoginAPI.updatePassword, method: .post, parameters: params) { (apiresponse) -> Void in
            callback(apiresponse)
        }
    }
    
    func verifyMobile(params: [String: AnyObject]?,callback: @escaping responseCompletionBlock){
        apiRequest(stringApi: LoginAPI.verifyMobile, method: .post, parameters: params) { (apiresponse) -> Void in
            callback(apiresponse)
        }
    }
    
    func verifyOtp(params: [String: AnyObject]?,callback: @escaping responseCompletionBlock){
        apiRequest(stringApi: LoginAPI.verifyOtp, method: .post, parameters: params) { (apiresponse) -> Void in
            callback(apiresponse)
        }
    }
    
    func transaction(params: [String: AnyObject]?,callback: @escaping responseCompletionBlock){
        apiRequest(stringApi: LoginAPI.transaction, method: .post, parameters: params) { (apiresponse) -> Void in
            callback(apiresponse)
        }
    }
    
    func cancelJobs(params: [String: AnyObject]?,callback: @escaping responseCompletionBlock){
        apiRequest(stringApi: LoginAPI.cancelJobs, method: .post, parameters: params) { (apiresponse) -> Void in
            callback(apiresponse)
        }
    }
    
    func passwordChange(params: [String: AnyObject]?,callback: @escaping responseCompletionBlock){
        apiRequest(stringApi: LoginAPI.passwordChange, method: .post, parameters: params) { (apiresponse) -> Void in
            callback(apiresponse)
        }
    }
    
    func appSetting(params: [String: AnyObject]?,callback: @escaping responseCompletionBlock){
        apiRequest(stringApi: LoginAPI.appSetting, method: .post, parameters: params, showloading: false) { (apiresponse) -> Void in
            callback(apiresponse)
        }
    }
    
    func verifyEmail(params: [String: AnyObject]?,callback: @escaping responseCompletionBlock){
        apiRequest(stringApi: LoginAPI.verifyEmail, method: .post, parameters: params, showloading: true) { (apiresponse) -> Void in
            callback(apiresponse)
        }
    }
    
    private func apiRequest(stringApi: String,method: HTTPMethod, parameters: [String: AnyObject]?,showloading: Bool = true,encoding: ParameterEncoding = URLEncoding.default,header: [String: String] = [:],callback: @escaping responseCompletionBlock){
        if(!hasInternet()){
            callback([:] as AnyObject)
            self.showAlertView()
            return
        }
        
        if showloading == true {
             SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.clear)
            SVProgressHUD.setContainerView(topMostViewController().view)
            SVProgressHUD.show()
            
        }
        
        let myheader = ["Accept":"application/json",
                        "Authorization":"Bearer "+APPDELEGATE.bearerToken]
        
        print("myheader \(myheader)")
        
        var param = [String : AnyObject]()
        
        if let par = parameters
        {
            param = par
            print("Parameters \(param)")
        }
        print("StringApi \(stringApi)")
        
        if stringApi == BASEAPI.URL + "/appsetting"
        {
            
            
        }
            
        else if stringApi == BASEAPI.URL + "/Categories"
        {
            
        }
            
            else if stringApi == BASEAPI.URL + "/requestService"
            {
                
            }
        
        else if stringApi == BASEAPI.URL + "/updateprofileDriver"
        {
            
        }


           
            
        else
        {
            print("Current Language \(LanguageManager.shared.currentLanguage)")
            
            if (LanguageManager.shared.currentLanguage == .en)
            {
                param["language"] = "1" as AnyObject
            }
            else if (LanguageManager.shared.currentLanguage == .si)
            {
                param["language"] = "2" as AnyObject
            }
        }
        
        
        print("Added Param \(param)")
        
        Alamofire.request(stringApi, method: method,parameters: param,encoding:encoding,headers: myheader).responseJSON {(response )in
            SVProgressHUD.dismiss()
            do {
                let apiResponse: Any = try JSONSerialization.jsonObject(with: response.data!, options: JSONSerialization.ReadingOptions.allowFragments)
                print(apiResponse)
                callback(apiResponse as AnyObject)
            }
            catch {
                callback([:] as AnyObject)
            }
        }
        
    }
    
    // MARK:- POST Image Upload
    private func postFormRequest(stringApi: String, parameters: [String: AnyObject]?,images: [ImageUpload],header: [String: String] = [:], callback: @escaping responseCompletionBlock) {
        
        print("postRequest :",stringApi)
        if(!hasInternet()){
            callback([:] as AnyObject)
            self.showAlertView()
            return
        }
        SVProgressHUD.setContainerView(topMostViewController().view)
        SVProgressHUD.show()
        let URL = try! URLRequest(url: stringApi, method: .post,headers: header)
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            for imageupload in images {
                let currentTimeStamp = NSDate().timeIntervalSince1970.toString()
                let filename = "\(currentTimeStamp)_img.jpg"
                
                if(imageupload.image.size == .zero){                    
                    multipartFormData.append("".data(using: String.Encoding.utf8)!, withName: "")
                }
                else{
                    if let imageData = UIImageJPEGRepresentation(imageupload.image, 0.6) {
                        multipartFormData.append(imageData, withName: imageupload.name, fileName: filename, mimeType: "image/jpeg")
                        
                    }
                }
            }
            
            for (key, value) in parameters! {
                multipartFormData.append((value as! String).data(using: String.Encoding.utf8)!, withName: key)
                
            }
        }, with: URL, encodingCompletion: { (result) in
            
            switch result {
            case .success(let upload, _, _):
                
                upload.responseJSON { response in
                    SVProgressHUD.dismiss()
                    print(response.request!)  // original URL request
                    print(response.response!) // URL response
                    print(response.data!)     // server data
                    print(response.result)   // result of response serialization

                    do {
                        let apiResponse = try JSONSerialization.jsonObject(with: response.data!, options: JSONSerialization.ReadingOptions.allowFragments)
                        print(apiResponse)
                        callback(apiResponse as AnyObject?)
                    }
                    catch {
                        SVProgressHUD.dismiss()
                        callback([:] as AnyObject)
                    }
                }
                
            case .failure(let encodingError):
                SVProgressHUD.dismiss()
                callback([:] as AnyObject)
                print(encodingError)
            }
            
        })
    }
    
    func readJson(callback:readJsonBlock) {
        do {
            if let file = Bundle.main.url(forResource: "countries", withExtension: "json") {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let object = json as? [String: AnyObject] {
                    // json is a dictionary
                    callback([AnyObject]())
                    print(object)
                } else if let object = json as? [AnyObject] {
                    // json is an array
                    print(object)
                    callback(object)
                } else {
                    callback([AnyObject]())
                    print("JSON is invalid")
                }
            } else {
                callback([AnyObject]())
                print("no file")
            }
        } catch {
            callback([AnyObject]())
            print(error.localizedDescription)
        }
    }
    
    func getCoordinates(address: String,callback: @escaping coordinatesCompletionBlock){
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            if(error != nil){
                callback(CLLocationCoordinate2D())
            }
            else{
                if(!(placemarks?.isEmpty)!){
                    callback(placemarks?.first?.location?.coordinate)
                }
                else{
                    callback(CLLocationCoordinate2D())
                }
            }
        }
    }
    
    
}

class ImageUpload{
    var image: UIImage!
    var name: String!
    
    init(uploadimage: UIImage,filename: String){
        image = uploadimage
        name = filename
    }
}

extension Double {
    func format(f: String) -> String {
        return NSString(format: "%\(f)f" as NSString, self) as String
    }
    
    func toString() -> String {
        return String(format: "%f",self)
    }
    
    func toInt() -> Int{
        let temp:Int64 = Int64(self)
        return Int(temp)
    }
}

