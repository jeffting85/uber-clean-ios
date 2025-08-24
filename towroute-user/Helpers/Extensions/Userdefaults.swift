//
//  Userdefaults.swift
//  Noor
//
//  Created by Uplogic-user on 21/06/17.
//  Copyright © 2017 Uplogic. All rights reserved.
//

import UIKit

extension UserDefaults{
    struct userdefaults {
        static let login = "logininfo"
        static let shopAdminlogin = "shopAdminlogininfo"
        static let pushToken = "pushToken"
        static let city = "City"
        static let allcity = "AllCity"
        static let guest = "Guest"
        static let header = "headers"
        static let shopAdminheader = "shopAdminheaders"
    }
    
    func saveCity(city: [String: Any]){
        if(city.count > 0){
            self.set(city, forKey: userdefaults.city)
            self.synchronize()
        }
    }
    
    func saveAllCities(cities: [[String: Any]]){
        self.set(cities, forKey: userdefaults.allcity)
        self.synchronize()
    }
    
    
    
    func getCity() -> [String: Any]{
        if let _ = self.object(forKey: userdefaults.city) {
            return self.object(forKey: userdefaults.city) as! [String : Any]
        }
        return [:]
    }
    
    func hasCity() -> Bool {
        let userDetails: [String : Any] = getCity()
        if userDetails.count > 0 {
            return true
        }
        return false
    }
    
    func saveHeaders(headers: [String: String]){
        if(headers.count > 0) {
            self.set(headers, forKey: userdefaults.header)
            self.synchronize()
        }
    }
    
    func getHeaders() -> [String: String]{
        if let headers = self.object(forKey: userdefaults.header){
            return headers as! [String : String]
        }
        return [:]
    }
    
    func saveShopAdminHeaders(headers: [String: String]){
        if(headers.count > 0) {
            self.set(headers, forKey: userdefaults.shopAdminheader)
            self.synchronize()
        }
    }
    
    func getShopAdminHeaders() -> [String: String]{
        if let headers = self.object(forKey: userdefaults.shopAdminheader){
            return headers as! [String : String]
        }
        return [:]
    }
    
    func saveLoginDetails(logininfo : [String : Any]){
        if logininfo.count > 0 {
            
            self.set(logininfo, forKey: userdefaults.login)
            self.synchronize()
        }
    }
    
    func clearLoginDetails(){
        self.removeObject(forKey: userdefaults.login)
        self.removeObject(forKey: userdefaults.header)
        self.synchronize()
    }
    
    func getLoggedUserDetails() -> [String : Any] {
        if let _ = self.object(forKey: userdefaults.login) {
            return self.object(forKey: userdefaults.login) as! [String : AnyObject]
        }
        return [:]
    }
    func loggedIn() -> Bool {
        let userDetails: [String : String] = getHeaders()
        if userDetails.count > 0 {
            return true
        }
        return false
    }
    
    func saveShopAdminLoginDetails(logininfo : [String : Any]){
        if logininfo.count > 0 {
            
            self.set(logininfo, forKey: userdefaults.shopAdminlogin)
            self.synchronize()
        }
    }
    
    func clearShopAdminLoginDetails(){
        self.removeObject(forKey: userdefaults.shopAdminlogin)
        self.removeObject(forKey: userdefaults.shopAdminheader)
        self.synchronize()
    }
    
    func getShopAdminLoggedUserDetails() -> [String : Any] {
        if let _ = self.object(forKey: userdefaults.shopAdminlogin) {
            return self.object(forKey: userdefaults.shopAdminlogin) as! [String : AnyObject]
        }
        return [:]
    }
    func isShopAdminloggedIn() -> Bool {
        let userDetails: [String : String] = getShopAdminHeaders()
        if userDetails.count > 0 {
            return true
        }
        return false
    }
    
    func saveToken(token : String){
        self.set(token, forKey: userdefaults.pushToken)
        self.synchronize()
    }
    
    func getPushToken() -> String {
        if let _ = self.object(forKey: userdefaults.pushToken) {
            return self.object(forKey: userdefaults.pushToken) as! String
        }
        return ""
    }
    
    func saveGuest(status: Bool){
        self.set(status, forKey: userdefaults.guest)
        self.synchronize()
    }
    
    func isGuest() -> Bool{
        return self.object(forKey: userdefaults.guest) as? Bool ?? false
    }
}
