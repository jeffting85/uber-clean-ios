//
//  Extension.swift
//  Noor
//
//  Created by Uplogic-user on 19/05/17.
//  Copyright © 2017 Uplogic. All rights reserved.
//

import UIKit
import ReachabilitySwift

typealias alertBlock = (_ response: Bool) -> Void

extension NSObject{
    
    func isArabic() -> Bool{
        if let language = Bundle.main.preferredLocalizations.first {
            return (language != "en")
        }
        return false
    }
    //MARK: - Get topviewcontroller
    public func topMostViewController() -> UIViewController {
        return self.topMostViewController(withRootViewController: (UIApplication.shared.keyWindow?.rootViewController!)!)
    }
    
    public func topMostViewController(withRootViewController rootViewController: UIViewController) -> UIViewController {
        if (rootViewController is UITabBarController) {
            let tabBarController = (rootViewController as! UITabBarController)
            return self.topMostViewController(withRootViewController: tabBarController.selectedViewController!)
        }
        else if (rootViewController is UINavigationController) {
            let navigationController = (rootViewController as! UINavigationController)
            return self.topMostViewController(withRootViewController: navigationController.visibleViewController!)
        }
        else if rootViewController.presentedViewController != nil {
            let presentedViewController = rootViewController.presentedViewController!
            return self.topMostViewController(withRootViewController: presentedViewController)
        }
        else {
            return rootViewController
        }
        
    }
    
    
    //MARK: - Check Internet Connection
    func hasInternet() -> Bool {
        let reachability = Reachability.init()
        let networkStatus: Int = reachability!.currentReachabilityStatus.hashValue
        return (networkStatus != 0)
    }
    
    //MARK: - Show Nointernet Alertview
    func showAlertView() {
        let alertMessage = UIAlertController(title: "Mobile Data is Turned Off", message: "Turn on mobile data or use Wi-Fi to access data.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok".localized, style: .default, handler: nil)
        let settingsAction = UIAlertAction(title: "Settings", style: .default, handler: nil)
        //alertMessage.addAction(settingsAction)
        alertMessage.addAction(okAction)
        
        topMostViewController().present(alertMessage, animated: true, completion: nil)
    }
    
    func showAlertView(message: String){
        let alert = UIAlertController(title: "TowRoute".localized, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok".localized.localized, style: .default, handler: nil)
        alert.addAction(okAction)
        topMostViewController().present(alert, animated: true, completion: nil)
    }
    func showAlertView(title: String,message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK".localized, style: .default, handler: nil)
        alert.addAction(okAction)
        topMostViewController().present(alert, animated: true, completion: nil)
    }
    
    func showAlertView(title: String,message: String,callback: @escaping alertBlock){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok".localized, style: .default) { (action) in
            callback(true)
        }
        alert.addAction(okAction)
        topMostViewController().present(alert, animated: true, completion: nil)
    }
    
    func showAlertViewWithReturn(title: String,message: String,callback: @escaping alertBlock) -> UIAlertController{
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok".localized, style: .default) { (action) in
            callback(true)
        }
        alert.addAction(okAction)
        topMostViewController().present(alert, animated: true, completion: nil)
        return alert
    }
    
    func showAlertView(title: String,message: String,title1: String,title2: String,callback: @escaping alertBlock){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: title1, style: .default) { (action) in
            callback(true)
        }
        let cancelAction = UIAlertAction(title: title2, style: .default) { (action) in
            callback(false)
        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        topMostViewController().present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Check response as Dictionary
    
    func isDictionary(response: AnyObject) -> Bool {
        if let result = response as? [String: AnyObject] {
            
            return self.isStatusOk(response: result)
        }
        else {
            return false
        }
    }
    
    //MARK: - Check response Status
    func isStatusOk(response: [String: AnyObject]) -> Bool {
        return response["status"] as? Bool ?? false
    }
}

extension String {
    var localized: String {        
        return NSLocalizedString(self, comment: "")
    }
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    func toCurrentTimeZone() -> Date{
        print("Before :\(self)")
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        let date = formatter.date(from: self) ?? Date()
        let sdateFormatter = DateFormatter()
        sdateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        sdateFormatter.timeZone = TimeZone.current
        print("After :\(sdateFormatter.string(from: date).toFullDate())")
        return sdateFormatter.string(from: date).toFullDate()
    }
    func toFullDate() -> Date{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.date(from: self) ?? Date()
    }
    func removeSpaceandLowerCase() -> String {
        var trimmedString = self.trimmingCharacters(in: .whitespaces)
        trimmedString = trimmedString.lowercased()
        return trimmedString
    }
    func checkStringContains(checkString: String) -> Bool {
        
        // Check if it contains checkString
        
        if self.range(of: checkString) != nil {
            return true
        }
        else {
            return false
        }
    }
    func subString( _ startIdx:Int, _ length:Int ) -> String {
        
        var result = ""
        
        let start = startIdx
        let end = startIdx + length
        
        var charArray = Array( self.characters )
        
        for idx in start ..< end {
            
            result.append( charArray[ idx ] )
        }
        
        return result
    }
    
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedStringKey.font: font], context: nil)
        return boundingBox.height
    }
    
}

/*extension UIViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate
{
    //MARK:- IMAGEPICKER
    func camera()
    {
        let myPickerController = UIImagePickerController()
        myPickerController.sourceType = .camera
        myPickerController.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
        self.present(myPickerController, animated: true, completion: { _ in })
    }
    
    func photoLibrary()
    {
        let myPickerController = UIImagePickerController()
        myPickerController.sourceType = .photoLibrary
        myPickerController.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
        self.present(myPickerController, animated: true, completion: { _ in })
    }
    
    func addPhotoActionSheet() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera".localized, style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.camera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Gallery".localized, style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.photoLibrary()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
        
    }
}*/

extension UIButton{
    func border(color: UIColor = .black,borderWidth:CGFloat = 1){
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = borderWidth
    }
}

extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        
        return boundingBox.height
    }
    
    func width(withConstraintedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        
        return boundingBox.width
    }
}

extension String {
    var isNumeric: Bool {
        guard self.characters.count > 0 else { return false }
        let nums: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        return Set(self.characters).isSubset(of: nums)
    }
}
