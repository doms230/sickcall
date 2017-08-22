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
import NVActivityIndicatorView

class AdvisorContainerViewController: SOContainerViewController,NVActivityIndicatorViewable {

    var didAnswer = false
    var isAdvisor = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NVActivityIndicatorView.DEFAULT_TYPE = .ballScaleMultiple
        NVActivityIndicatorView.DEFAULT_COLOR = uicolorFromHex(0xF4FF81)
        NVActivityIndicatorView.DEFAULT_BLOCKER_SIZE = CGSize(width: 60, height: 60)
        NVActivityIndicatorView.DEFAULT_BLOCKER_BACKGROUND_COLOR = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        
        startAnimating()
        
        self.menuSide = .left
        
        if isAdvisor{
            let query = PFQuery(className: "Post")
            query.whereKey("advisorUserId", equalTo: PFUser.current()!.objectId!)
            query.whereKey("isAnswered", equalTo: false)
            query.whereKey("isRemoved", equalTo: false)
            query.addAscendingOrder("createdAt")
            query.getFirstObjectInBackground {
                (object: PFObject?, error: Error?) -> Void in
                self.stopAnimating()
                
                if error != nil{
                    self.topViewController = self.storyboard?.instantiateViewController(withIdentifier: "dashboard")
                    
                } else {
                    self.topViewController = self.storyboard?.instantiateViewController(withIdentifier: "question")
                }
                
                self.sideViewController = self.storyboard?.instantiateViewController(withIdentifier: "sidebar")
            }
            
        } else {
            self.topViewController = self.storyboard?.instantiateViewController(withIdentifier: "new")
            self.sideViewController = self.storyboard?.instantiateViewController(withIdentifier: "sidebar")
            
        }
    }
    
    func uicolorFromHex(_ rgbValue:UInt32)->UIColor{
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }
}
