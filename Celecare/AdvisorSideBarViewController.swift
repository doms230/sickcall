//
//  AdvisorSideBarViewController.swift
//  Celecare
//
//  Created by Mac Owner on 7/11/17.
//  Copyright © 2017 Celecare LLC. All rights reserved.
//

import UIKit
import Parse

class AdvisorSideBarViewController: UIViewController {
    @IBOutlet weak var imageJaunt: UIImageView!
    @IBOutlet weak var nameJaunt: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        let query = PFQuery(className: "_User")
        query.whereKey("objectId", equalTo: "D9W37sOaeR")
        query.getFirstObjectInBackground {
            (object: PFObject?, error: Error?) -> Void in
            if error != nil || object == nil {
                
                
            } else {
                let imageFile: PFFile = object!["Profile"] as! PFFile
                self.imageJaunt.kf.setImage(with: URL(string: imageFile.url!))
                self.imageJaunt.layer.cornerRadius = 50
                self.imageJaunt.clipsToBounds = true
                
                self.nameJaunt.text = object!["DisplayName"] as? String
            }
        }
    }
    
    @IBAction func switchAction(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "main") as UIViewController
        self.present(controller, animated: true, completion: nil)
    }
    
    
    @IBAction func bankInfoAction(_ sender: UIButton) {
                self.performSegue(withIdentifier: "showBankInfo", sender: self)
    }
    
    @IBAction func personalInfoAction(_ sender: UIButton) {
                self.performSegue(withIdentifier: "showPersonalInfo", sender: self)
    }
        
}
