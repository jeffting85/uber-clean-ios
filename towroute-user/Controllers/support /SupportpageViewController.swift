//
//  SupportpageViewController.swift
//  TowRoute User
//
//  Created by Admin on 08/06/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class SupportpageViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    
    var menus = ["About Us".localized, "Privacy Policy".localized, "Terms & Conditions".localized] // ,"Contact Us", "Help"]
    
    var menuimages = [#imageLiteral(resourceName: "care-about-environment"),#imageLiteral(resourceName: "lock"),#imageLiteral(resourceName: "air-conditioner"),#imageLiteral(resourceName: "phone-with-message"),#imageLiteral(resourceName: "circular-info-sign")]
    
    @IBOutlet var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "SUPPORT".localized
        //addMenu()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backact(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        // self.dismiss(animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menus.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SupportCell") as! SupportCell
        cell.name.text = menus[indexPath.row]
        cell.supportimg.image = menuimages[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
            
        case 0:
            
            let about = storyboard?.instantiateViewController(withIdentifier:"about")
            self.navigationController?.pushViewController(about!, animated: true)
            break
            
        case 1:
            
            let privacy = storyboard?.instantiateViewController(withIdentifier:"privacy")
            self.navigationController?.pushViewController(privacy!, animated: true)
            break
            
        case 2:
            
            let terms = storyboard?.instantiateViewController(withIdentifier:"terms")
            self.navigationController?.pushViewController(terms!, animated: true)
            break
            
            
        case 3:
            
            let contact = storyboard?.instantiateViewController(withIdentifier:"contact")
            self.navigationController?.pushViewController(contact!, animated: true)
            break
            
        case 4:
            
            let contact = storyboard?.instantiateViewController(withIdentifier:"contact")
            self.navigationController?.pushViewController(contact!, animated: true)
            break
            
        default:
            break
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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


class SupportCell: UITableViewCell{
    
    @IBOutlet var supportimg: UIImageView!
    @IBOutlet var name: UILabel!
    
}
