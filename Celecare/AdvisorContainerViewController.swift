//
//  AdvisorContainerViewController.swift
//  Celecare
//
//  Created by Mac Owner on 7/11/17.
//  Copyright © 2017 Celecare LLC. All rights reserved.
//

import UIKit
import SidebarOverlay
import Parse

class AdvisorContainerViewController: SOContainerViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.menuSide = .left

       /* let query = PFQuery(className: "_User")
        query.whereKey("objectId", equalTo: PFUser.current()!.objectId!)
        query.getFirstObjectInBackground {
            (object: PFObject?, error: Error?) -> Void in
            if error == nil || object != nil {
                if object?["isAdvisor"] as! Bool{
                    self.topViewController = self.storyboard?.instantiateViewController(withIdentifier: "dashboard")
                    
                } else{
                    self.topViewController = self.storyboard?.instantiateViewController(withIdentifier: "new")

                }
                self.sideViewController = self.storyboard?.instantiateViewController(withIdentifier: "sidebar")
                
            }
        }*/
        
        self.topViewController = self.storyboard?.instantiateViewController(withIdentifier: "question")
        
        self.sideViewController = self.storyboard?.instantiateViewController(withIdentifier: "sidebar")
        

        //dashboard --other controller
    }
}
