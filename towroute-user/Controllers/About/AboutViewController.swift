//
//  AboutViewController.swift
//  TowRoute User
//
//  Created by Admin on 08/06/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    
    @IBOutlet var about: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "ABOUT".localized
        privac()
        //  addMenu()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backact(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func privac(){
        
        let userdict = USERDEFAULTS.getLoggedUserDetails()
        
        let userid = userdict["id"] as! String
        
        let params = ["page_name":"About Us",
                      "token":APPDELEGATE.bearerToken]
        
        print("params \(params)")
        
        APIManager.shared.privacypolicy(params: params as [String : AnyObject]) { (response) in
            
            
            print("responsse\(response)")
            
            if case let data as NSArray = response?["data"]{
                print("datea\(data)")
                
                for descri in data{
                     let des = descri as! NSDictionary
                                                         
                                                         
                                                         if LanguageManager.shared.currentLanguage == .ar{
                                                           
                                                             let desvalue = des.value(forKey: "meta_description")
                                                             
                                                             print("dessi\(desvalue)")
                                                             
                                                             self.about.text =  desvalue as! String
                                                             
                                                         }
                                                         else
                                                         {
                                                           
                                                            let desvalue: String = des.value(forKey: "description") as! String
                                                            
                                                            print("dessi\(desvalue)")
                                                            
                                                            self.about.attributedText =  desvalue.convertHtmlToAttributedStringWithCSS(font: UIFont(name: "Arial", size: 16), csscolor: "black", lineheight: 5, csstextalign: "justify")
                                                         }
                }
            }
                
            else if case let msg as String = response?["message"], msg == "Pages listed successfully." {
                
                APIManager.shared.refreshToken(params: params as [String : AnyObject]) { (response) in
                    
                    if case let access_token as String = response?["access_token"] {
                        
                        APPDELEGATE.bearerToken = access_token
                        
                        USERDEFAULTS.set(access_token, forKey: "access_token")
                        
                        //   self.privac()
                        
                    }
                }
            }
            
            
            
        }
        
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
extension String {
    private var convertHtmlToNSAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else {
            return nil
        }
        do {
            return try NSAttributedString(data: data,options: [.documentType: NSAttributedString.DocumentType.html,.characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        }
        catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    public func convertHtmlToAttributedStringWithCSS(font: UIFont? , csscolor: String , lineheight: Int, csstextalign: String) -> NSAttributedString? {
        guard let font = font else {
            return convertHtmlToNSAttributedString
        }
        let modifiedString = "<style>body{font-family: '\(font.fontName)'; font-size:\(font.pointSize)px; color: \(csscolor); line-height: \(lineheight)px; text-align: \(csstextalign); }</style>\(self)";
        guard let data = modifiedString.data(using: .utf8) else {
            return nil
        }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        }
        catch {
            print(error)
            return nil
        }
    }
}
