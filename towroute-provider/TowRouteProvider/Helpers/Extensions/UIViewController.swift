//
//  UIViewControllerExtension.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 1/19/15.
//  Copyright (c) 2015 Yuji Hato. All rights reserved.
//

import UIKit


//public weak var delegate: SlideMenuControllerDelegate?

extension UIViewController {

    
    func addMenu(){
        
      //  self.addLeftBarButtonWithImage(#imageLiteral(resourceName: "menu").resizeImage(newWidth: 30).withRenderingMode(.alwaysOriginal))
        
        if LanguageManager.shared.currentLanguage == .en {

         self.addLeftBarButtonWithImage(#imageLiteral(resourceName: "MENU").resizeImage(newWidth: 35).withRenderingMode(.alwaysOriginal))//, _lang: "en"

         }
            else if LanguageManager.shared.currentLanguage == .fi
            {
                self.addLeftBarButtonWithImage(#imageLiteral(resourceName: "MENU").resizeImage(newWidth: 35).withRenderingMode(.alwaysOriginal))//, _lang: "fi"

            }
            else if LanguageManager.shared.currentLanguage == .si
            {
                self.addLeftBarButtonWithImage(#imageLiteral(resourceName: "MENU").resizeImage(newWidth: 35).withRenderingMode(.alwaysOriginal))//, _lang: "si"

            }
         else
         {
             self.addLeftBarButtonWithImage(#imageLiteral(resourceName: "MENU").resizeImage(newWidth: 35).withRenderingMode(.alwaysOriginal))//, _lang: "ar"

         }
    }
    
    func showSimpleAlert(message: String, title: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK".localized, style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func emptyBackButton(){
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    }
    
    func removeBackButton(){
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    
    func isModal() -> Bool {
        if self.presentingViewController != nil {
            return true
        } else if self.navigationController?.presentingViewController?.presentedViewController == self.navigationController  {
            return true
        } else if self.tabBarController?.presentingViewController is UITabBarController {
            return true
        }
        
        return false
    }
    
}

func image(fromLayer layer: CALayer) -> UIImage {
    UIGraphicsBeginImageContext(layer.frame.size)
    
    layer.render(in: UIGraphicsGetCurrentContext()!)
    
    let outputImage = UIGraphicsGetImageFromCurrentImageContext()
    
    UIGraphicsEndImageContext()
    
    return outputImage!
}


extension UIImage {
    func createSelectionIndicator(color: UIColor, size: CGSize, lineWidth: CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(CGRect(origin: CGPoint(x: 0,y :size.height - lineWidth), size: CGSize(width: size.width, height: lineWidth)))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
