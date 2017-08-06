//
//  NameViewController.swift
//  Celecare
//
//  Created by Dom Smith on 8/5/17.
//  Copyright © 2017 Celecare LLC. All rights reserved.
//

import UIKit
import Parse

class NameViewController: UIViewController {

    @IBOutlet weak var lastNameText: UITextField!
    @IBOutlet weak var firstNameText: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let query = PFQuery(className: "_User")
        query.whereKey("objectId", equalTo: PFUser.current()!.objectId!)
        query.getFirstObjectInBackground {
            (object: PFObject?, error: Error?) -> Void in
            if error == nil || object != nil {
                let imageFile: PFFile = object!["Profile"] as! PFFile
               /* self.profileImage.kf.setImage(with: URL(string: imageFile.url!), for: .normal)
                self.profileImage.layer.cornerRadius = 30 / 2
                self.profileImage.clipsToBounds = true*/
                
            }
        }

        // Do any additional setup after loading the view.
    }
    
    
    
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     /*   let desti = segue.destination as! AddressViewController
        desti.firstName = nameField.text
        desti.lastName = lastNameField.text*/
    }
    

    @IBAction func nextAction(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func profileAction(_ sender: UIButton) {
    }
    
}
