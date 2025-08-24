//
//  customclass.swift
//  Slide
//
//  Created by Uplogic Technologies on 07/08/17.
//  Copyright © 2017 Uplogic Technologies. All rights reserved.
//

import Foundation

enum validator {
    case empty
    case passwordlength
    case email
}

class model {
    
    class func validator(checkvalue: [String], checkfor: [validator]) -> (errorId:Int,error:Bool) {
        
        for (index, element) in checkfor.enumerated() {
        
            if element == .empty {
                
                if checkvalue[index] == "" {
                    
                    return (index,true)
                    
                }
                
            }
            
            else if element == .email {
                
                if !(isValidEmail(testStr: checkvalue[index])) {
                    
                    return (index,true)
                    
                }
                
            }
            
            else if element == .passwordlength {
                
                if checkvalue[index].characters.count < 6 {
                    
                    return (index,true)
                    
                }
                
            }
            
        }
        
        return (0,false)
        
    }
    
    class func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    class func phnovalidate(value: String) -> Bool {
        let PHONE_REGEX = "^((\\+)|(00))[0-9]{6,14}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: value)
        return result
    }
    
}
