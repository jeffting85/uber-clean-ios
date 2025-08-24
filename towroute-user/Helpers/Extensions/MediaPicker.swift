//
//  MediaPicker.swift
//  HighburDriver
//
//  Created by vgs-user on 13/01/17.
//  Copyright © 2017 vgs. All rights reserved.
//

import UIKit

typealias MediaCompletionBlock = (_ image: UIImage?,_ status: Bool) -> Void

class MediaPicker: NSObject,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    static let shared = MediaPicker()
    var mediaImageView: UIImageView!
    var mediaCompletionBlock: MediaCompletionBlock?
    var isEditing = false
    
    func showMediaPicker(imageView: UIImageView,placeHolder: UIImage?){
        self.mediaImageView = imageView
        let alertMessage = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let camera = UIAlertAction(title: "Take Photo".localized, style: .default) { (action) in
            self.showCamera()
        }
        let photos = UIAlertAction(title: "Choose Photo".localized, style: .default) { (action) in
            self.showPhotoLibrary()
        }
        /*let remove = UIAlertAction(title: "Remove Photo", style: .default) { (action) in
            
            imageView.image = placeHolder
            if(self.mediaCompletionBlock != nil){
                self.mediaCompletionBlock!(nil,false)
            }
        }*/
        let cancel = UIAlertAction(title: "Cancel".localized, style: .cancel) { (action) in
            
        }
        alertMessage.addAction(camera)
        alertMessage.addAction(photos)
        //if(imageView.image != placeHolder){
            //alertMessage.addAction(remove)
        //}
        alertMessage.addAction(cancel)
        topMostViewController().present(alertMessage, animated: true, completion: nil)
    }
    
    func showMediaPicker(imageView: UIImageView,placeHolder: UIImage?,editing: Bool = false,completion: @escaping MediaCompletionBlock){
        isEditing = editing
        mediaCompletionBlock = completion
        self.showMediaPicker(imageView: imageView, placeHolder: placeHolder)
    }
    
    func showCamera(completion: @escaping MediaCompletionBlock){
        mediaImageView = nil
        mediaCompletionBlock = completion
        showCamera()
    }
    
    func showPhotoLibrary(completion: @escaping MediaCompletionBlock){
        mediaImageView = nil
        mediaCompletionBlock = completion
        showPhotoLibrary()
    }
    
    func showCamera(){
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary){
            
            let imag = UIImagePickerController()
            self.configPicker(imag: imag)
            imag.sourceType = UIImagePickerControllerSourceType.camera;
           // imag.allowsEditing = true
            topMostViewController().present(imag, animated: true, completion: nil)
        }
    }
    
    func showPhotoLibrary(){
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary){
            let imag = UIImagePickerController()
            self.configPicker(imag: imag)
            imag.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            topMostViewController().present(imag, animated: true, completion: nil)
        }
    }
    
    func configPicker(imag : UIImagePickerController){
        imag.navigationBar.isTranslucent = false
        imag.navigationBar.barTintColor = UIColor.black // Background color
        imag.navigationBar.tintColor = UIColor.white// Cancel button ~ any UITabBarButton items
        imag.navigationBar.titleTextAttributes = [
            NSAttributedStringKey.foregroundColor : UIColor.white
        ]
        imag.delegate = self
        imag.allowsEditing = isEditing
    }
    
    //MARK:- UIImagePickerControllerDelegate
    /*func imagePickerController(_ picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!) {
     //let image_crop : UIImage = editingInfo[UIImagePickerControllerEditedImage] as! UIImage
     let resizeimage = self.resizeImage(image: image, newWidth: self.mediaImageView.width)
     self.mediaImageView.image = resizeimage
     if(mediaCompletionBlock != nil){
     mediaCompletionBlock!(resizeimage,true)
     mediaCompletionBlock = nil
     }
     topMostViewController().dismiss(animated: true, completion: nil)
     }*/
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if(isEditing){
            if let image = info[UIImagePickerControllerEditedImage] as? UIImage
            {
                //let resizeimage = self.resizeImage(image: image, newWidth: self.mediaImageView.width)
                if(self.mediaImageView != nil){
                    self.mediaImageView.image = image
                }
                
                if(mediaCompletionBlock != nil){
                    mediaCompletionBlock!(image,true)
                    mediaCompletionBlock = nil
                    isEditing = false
                }
            }
        }
        else{
            if let image = info[UIImagePickerControllerOriginalImage] as? UIImage
            {
                //let resizeimage = self.resizeImage(image: image, newWidth: self.mediaImageView.width)
                if(self.mediaImageView != nil){
                    self.mediaImageView.image = image
                }
                
                if(mediaCompletionBlock != nil){
                    mediaCompletionBlock!(image,true)
                    mediaCompletionBlock = nil
                }
            }
        }
        topMostViewController().dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        if(mediaCompletionBlock != nil){
            mediaCompletionBlock!(nil,false)
            mediaCompletionBlock = nil
        }
        topMostViewController().dismiss(animated: true, completion: nil)
    }
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        //UIGraphicsBeginImageContext(CGSize(width: newWidth,height: newHeight))
        UIGraphicsBeginImageContextWithOptions(CGSize(width: newWidth*2,height: newHeight*2), false, image.scale)
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth*2, height: newHeight*2))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}
