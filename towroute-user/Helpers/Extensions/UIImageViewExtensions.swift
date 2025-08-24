//
//  UIImageViewExtensions.swift
//  Cab Share
//
//  Created by Uplogic-user on 26/11/16.
//  Copyright © 2016 Uplogic. All rights reserved.
//

import UIKit
import AlamofireImage


//MARK:UiImageView
extension UIImageView{
    
    func setImage(urlstring : String,Placeholder : String){
        let url = URL(string: urlstring)
        if(url != nil){
        //let placeholderImage = UIImage(named: Placeholder)!
        
        self.af_setImage(withURL : url!,
                         placeholderImage: Placeholder.isEmpty ? UIImage() : UIImage(named: Placeholder)!,
                         filter : nil,
                         imageTransition: .noTransition)
        }
        else{
            self.image = UIImage(named: Placeholder)!
        }
    }
    
    func setImage(urlstring : String,placeholderImage : UIImage){
        if let url = URL(string: urlstring) {
        
            self.af_setImage(withURL : url,
                             placeholderImage: placeholderImage,
                             filter : nil,
                             imageTransition: .noTransition)
        }
    }
    
    func setImage(urlstring : String){
        let url = URL(string: urlstring)
        if(url != nil){
        let filter = AspectScaledToFillSizeCircleFilter(size: CGSize(width: self.width, height: self.height))
        self.af_setImage(withURL : url!,
                         placeholderImage: UIImage(named: "Avatar"),
                         filter : filter,
                         imageTransition: .noTransition)
        }
    }
    
    func setImageURL(urlstring : String){
        let url = URL(string: urlstring)
        if(url != nil){
            
            self.af_setImage(withURL : url!,
                             placeholderImage: UIImage(),
                             filter : nil,
                             imageTransition: .noTransition)
        }
    }
    
    //MARK: - Rounded Corners
    public func roundSquareImage() {
        self.clipsToBounds = true
        self.layer.cornerRadius = self.frame.size.width / 2
    }
    
    func animateBorder() {
        let colorAnimation = CABasicAnimation(keyPath: "borderColor")
        colorAnimation.fromValue = UIColor.clear.cgColor
        colorAnimation.toValue = Color.appgreen.value.cgColor
        self.layer.borderColor = Color.appgreen.value.cgColor
        
        let widthAnimation = CABasicAnimation(keyPath: "borderWidth")
        widthAnimation.fromValue = 0
        widthAnimation.toValue = 2
        widthAnimation.duration = 4
        self.layer.borderWidth = 2
        
        let bothAnimations = CAAnimationGroup()
        bothAnimations.duration = 0.5
        bothAnimations.animations = [colorAnimation, widthAnimation]
        bothAnimations.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        self.layer.add(bothAnimations, forKey: "color and width")
        
    }
    
}

extension UIImage {
    
    //MARK:- Use current image for pattern of color
    public func withColor(_ tintColor: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        
        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: 0, y: self.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        context?.setBlendMode(CGBlendMode.normal)
        
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height) as CGRect
        context?.clip(to: rect, mask: self.cgImage!)
        tintColor.setFill()
        context?.fill(rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()! as UIImage
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    func resizeImage(newWidth: CGFloat) -> UIImage {
        
        let scale = newWidth / self.size.width
        let newHeight = self.size.height * scale
        //UIGraphicsBeginImageContext(CGSize(width: newWidth,height: newHeight))
        UIGraphicsBeginImageContextWithOptions(CGSize(width: newWidth,height: newHeight), false, self.scale)
        self.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }
    
    /// Returns the data for the specified image in JPEG format.
    /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
    /// - returns: A data object containing the JPEG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
    func jpeg(_ quality: JPEGQuality) -> Data? {
        return UIImageJPEGRepresentation(self, quality.rawValue)
    }
    
}
