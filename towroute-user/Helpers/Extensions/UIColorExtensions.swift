//
//  UIColorExtensions.swift
//  Trader
//
//  Created by vgs-user on 17/02/17.
//  Copyright © 2017 vgs. All rights reserved.
//

import UIKit

extension UIColor{
    
    //MARK: - init method with RGB values from 0 to 255, instead of 0 to 1. With alpha(default:1)
    public convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat = 1) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
    }
    
    //MARK: - init method with hex string and alpha(default: 1)
    public convenience init?(hexString: String, alpha: CGFloat = 1.0) {
        var formatted = hexString.replacingOccurrences(of: "0x", with: "")
        formatted = formatted.replacingOccurrences(of: "#", with: "")
        if let hex = Int(formatted, radix: 16) {
            let red = CGFloat(CGFloat((hex & 0xFF0000) >> 16)/255.0)
            let green = CGFloat(CGFloat((hex & 0x00FF00) >> 8)/255.0)
            let blue = CGFloat(CGFloat((hex & 0x0000FF) >> 0)/255.0)
            
            self.init(red: red, green: green, blue: blue, alpha: alpha)        }
        else {
            return nil
        }
    }    
    
}

enum Color {
    case navPrimary
    case appRed
    case appGreen
    case applightGreen
    case navSecondary
    case appblue
    case appblueLight
    case appgreen
    case appOrange
    case appBlack
    case lightgrey
    case grey
    case outgoing
    case incoming
}

extension Color {
    var value: UIColor {
    var instanceColor = UIColor.clear
        switch self {
        case .navPrimary:
            instanceColor = UIColor(r: 64.0, g: 64.0, b: 65.0)
        case .appRed:
            instanceColor = UIColor(r: 237.0, g: 28.0, b: 36.0)
        case .appGreen:
            instanceColor = UIColor(r: 89.0, g: 211.0, b: 137.0)
        case .applightGreen:
            instanceColor = UIColor(r: 106, g: 232, b: 156)
        case .navSecondary:
            instanceColor = UIColor(r: 128.0, g: 130.0, b: 133.0)        
        case .appblue:
            instanceColor = UIColor(r: 25.0, g: 118.0, b: 210.0)
        case .appblueLight:
            instanceColor = UIColor(r: 25.0, g: 118.0, b: 210.0, a: 0.50)
        case .appgreen:
            instanceColor = UIColor(r: 76.0, g: 175.0, b: 80.0)
        case .appOrange:
            instanceColor = UIColor(r: 255.0, g: 87.0, b: 34.0)
        case .appBlack:
            instanceColor = UIColor(r: 33.0, g: 33.0, b: 33.0)
        case .lightgrey:
            instanceColor = UIColor(r: 117.0, g: 117.0, b: 117.0, a: 0.50)
        case .grey:
            instanceColor = UIColor(r: 158.0, g: 158.0, b: 158.0)
        case .outgoing:
            instanceColor = UIColor(r: 187.0, g: 222.0, b: 251.0)
        case .incoming:
            instanceColor = UIColor(r: 227.0, g: 242.0, b: 253.0, a: 0.9)
        }
        return instanceColor
    }    
    
}
