//
//  APIManager.swift
//  Noor
//
//  Created by vgs-user on 19/05/17.
//  Copyright © 2017 vgs. All rights reserved.
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
    
    
    func notificationToDriver(params: [String: AnyObject]?,callback: @escaping responseCompletionBlock){
        apiRequest(stringApi: LoginAPI.notificationToDriver, method: .post, parameters: params) { (apiresponse) -> Void in
            callback(apiresponse)
        }
    }
    
    func cancelNotificationToDriver(params: [String: AnyObject]?,callback: @escaping responseCompletionBlock){
        apiRequest(stringApi: LoginAPI.cancelNotificationToDriver, method: .post, parameters: params) { (apiresponse) -> Void in
            callback(apiresponse)
        }
    }
    
    
    func forgotPassword(params: [String: AnyObject]?,callback: @escaping responseCompletionBlock){
        apiRequest(stringApi: LoginAPI.forgotPassword, method: .post, parameters: params) { (apiresponse) -> Void in
            callback(apiresponse)
        }
    }
    
    func otpVerify(params: [String: AnyObject]?,callback: @escaping responseCompletionBlock){
        apiRequest(stringApi: LoginAPI.otpVerify, method: .post, parameters: params) { (apiresponse) -> Void in
            callback(apiresponse)
        }
    }
    
    
    func changePassword(params: [String: AnyObject]?,callback: @escaping responseCompletionBlock){
        apiRequest(stringApi: LoginAPI.changePassword, method: .post, parameters: params) { (apiresponse) -> Void in
            callback(apiresponse)
        }
    }
    
    func loginUser(params: [String: AnyObject]?,callback: @escaping responseCompletionBlock){
        apiRequest(stringApi: LoginAPI.userLogin, method: .post, parameters: params) { (apiresponse) -> Void in
            callback(apiresponse)
        }
    }
    func privacypolicy(params: [String: AnyObject]?,callback: @escaping responseCompletionBlock){
        apiRequest(stringApi: LoginAPI.privacypolicy, method: .post, parameters: params) { (apiresponse) -> Void in
            callback(apiresponse)
        }
    }
    func registerUser(params: [String: AnyObject]?,callback: @escaping responseCompletionBlock){
        apiRequest(stringApi: LoginAPI.userRegister, method: .post, parameters: params) { (apiresponse) -> Void in
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
    
    
    func updateProfile(params: [String: AnyObject]?,callback: @escaping responseCompletionBlock){
        apiRequest(stringApi: LoginAPI.updateProfile, method: .post, parameters: params) { (apiresponse) -> Void in
            callback(apiresponse)
        }
    }
    
    
    func vehicleCategory(params: [String: AnyObject]?,callback: @escaping responseCompletionBlock){
        apiRequest(stringApi: LoginAPI.vehicleCategory, method: .post, parameters: params) { (apiresponse) -> Void in
            callback(apiresponse)
        }
    }
    
    func profileView(params: [String: AnyObject]?,callback: @escaping responseCompletionBlock){
        apiRequest(stringApi: LoginAPI.profileView, method: .post, parameters: params) { (apiresponse) -> Void in
            callback(apiresponse)
        }
    }
    
    func subCategories(params: [String: AnyObject]?,callback: @escaping responseCompletionBlock){
        apiRequest(stringApi: LoginAPI.subCategories, method: .post, parameters: params) { (apiresponse) -> Void in
            callback(apiresponse)
        }
    }
    
    func viewAdvertisement(params: [String: AnyObject]?,callback: @escaping responseCompletionBlock){
        apiRequest(stringApi: LoginAPI.viewAdvertisement, method: .post, parameters: params) { (apiresponse) -> Void in
            callback(apiresponse)
        }
    }
    
    func sociallog(params: [String: AnyObject]?,callback: @escaping responseCompletionBlock){
        apiRequest(stringApi: LoginAPI.sociallog, method: .post, parameters: params) { (apiresponse) -> Void in
            callback(apiresponse)
        }
    }
    
    func imageupload(params: [String: AnyObject]?,callback: @escaping responseCompletionBlock){
        apiRequest(stringApi: LoginAPI.imageupload, method: .post, parameters: params) { (apiresponse) -> Void in
            callback(apiresponse)
        }
    }
    func refreshToken(params: [String: AnyObject]?,callback: @escaping responseCompletionBlock){
        apiRequest(stringApi: LoginAPI.refreshToken, method: .post, parameters: params) { (apiresponse) -> Void in
            callback(apiresponse)
        }
    }
    func profileImageUpload(params: [String: AnyObject]?,callback: @escaping responseCompletionBlock){
        
        apiRequest(stringApi: LoginAPI.profilePicEdit, method: .post, parameters: params) { (apiresponse) -> Void in
            callback(apiresponse)
        }
        
    }
    
    func profileEdit(params: [String: AnyObject]?,callback: @escaping responseCompletionBlock){
        apiRequest(stringApi: LoginAPI.profileEdit, method: .post, parameters: params) { (apiresponse) -> Void in
            callback(apiresponse)
        }
    }
    
    func categories(params: [String: AnyObject]?,callback: @escaping responseCompletionBlock){
        apiRequest(stringApi: LoginAPI.categories, method: .post, parameters: params) { (apiresponse) -> Void in
            callback(apiresponse)
        }
    }
    
    func customerOnGoing(params: [String: AnyObject]?,callback: @escaping responseCompletionBlock){
        apiRequest(stringApi: LoginAPI.customerOnGoing, method: .post, parameters: params) { (apiresponse) -> Void in
            callback(apiresponse)
        }
    }
    
    func customerAddMoney(params: [String: AnyObject]?,callback: @escaping responseCompletionBlock){
        apiRequest(stringApi: LoginAPI.customerAddMoney, method: .post, parameters: params) { (apiresponse) -> Void in
            callback(apiresponse)
        }
    }
    
    func availabilityCheckService(params: [String: AnyObject]?,callback: @escaping responseCompletionBlock){
        apiRequest(stringApi: LoginAPI.availabilityCheckService, method: .post, parameters: params) { (apiresponse) -> Void in
            callback(apiresponse)
        }
    }
    
    func scheduledBooking(params: [String: AnyObject]?,callback: @escaping responseCompletionBlock){
        apiRequest(stringApi: LoginAPI.scheduledBooking, method: .post, parameters: params) { (apiresponse) -> Void in
            callback(apiresponse)
        }
    }
    
    func pastJobs(params: [String: AnyObject]?,callback: @escaping responseCompletionBlock){
        apiRequest(stringApi: LoginAPI.pastJobs, method: .post, parameters: params) { (apiresponse) -> Void in
            callback(apiresponse)
        }
    }
    
    func upcomingJobs(params: [String: AnyObject]?,callback: @escaping responseCompletionBlock){
        apiRequest(stringApi: LoginAPI.upcomingJobs, method: .post, parameters: params) { (apiresponse) -> Void in
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
    
    func customerTripPayment(params: [String: AnyObject]?,callback: @escaping responseCompletionBlock){
        apiRequest(stringApi: LoginAPI.customerTripPayment, method: .post, parameters: params) { (apiresponse) -> Void in
            callback(apiresponse)
        }
    }
    
   
    
    func customerBalancePayment(params: [String: AnyObject]?,callback: @escaping responseCompletionBlock){
        apiRequest(stringApi: LoginAPI.customerBalancePayment, method: .post, parameters: params) { (apiresponse) -> Void in
            callback(apiresponse)
        }
    }
    
    
    func cancelJobs(params: [String: AnyObject]?,callback: @escaping responseCompletionBlock){
        apiRequest(stringApi: LoginAPI.cancelJobs, method: .post, parameters: params) { (apiresponse) -> Void in
            callback(apiresponse)
        }
    }
    
    func declineJob(params: [String: AnyObject]?,callback: @escaping responseCompletionBlock){
        apiRequest(stringApi: LoginAPI.declineJob, method: .post, parameters: params) { (apiresponse) -> Void in
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
    
    func checkPromoCode(params: [String: AnyObject]?,callback: @escaping responseCompletionBlock){
        apiRequest(stringApi: LoginAPI.checkPromoCode, method: .post, parameters: params, showloading: true) { (apiresponse) -> Void in
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
        
        else if stringApi == BASEAPI.URL + "/updateprofile"
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

