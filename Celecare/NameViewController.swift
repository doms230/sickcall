//
//  NameViewController.swift
//  Celecare
//
//  Created by Dom Smith on 8/5/17.
//  Copyright © 2017 Celecare LLC. All rights reserved.
//

import UIKit
import Parse
import SidebarOverlay
import Kingfisher
import NVActivityIndicatorView
import SCLAlertView

class NameViewController: UIViewController, NVActivityIndicatorViewable {

    @IBOutlet weak var lastNameText: UITextField!
    @IBOutlet weak var firstNameText: UITextField!
    
    @IBOutlet weak var profileImage: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "1/3"
        
        let query = PFQuery(className: "_User")
        query.whereKey("objectId", equalTo: PFUser.current()!.objectId!)
        query.getFirstObjectInBackground {
            (object: PFObject?, error: Error?) -> Void in
            if error == nil || object != nil {
                let imageFile: PFFile = object!["Profile"] as! PFFile
                self.profileImage.kf.setImage(with: URL(string: imageFile.url!), for: .normal)
                self.profileImage.layer.cornerRadius = 30 / 2
                self.profileImage.clipsToBounds = true
            }
        }
        
        NVActivityIndicatorView.DEFAULT_TYPE = .ballScaleMultiple
        NVActivityIndicatorView.DEFAULT_COLOR = uicolorFromHex(0xF4FF81)
        NVActivityIndicatorView.DEFAULT_BLOCKER_SIZE = CGSize(width: 60, height: 60)
        NVActivityIndicatorView.DEFAULT_BLOCKER_BACKGROUND_COLOR = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "HelveticaNeue", size: 20)!,
            kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
            kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
            showCloseButton: false
        )
        
        let successView = SCLAlertView(appearance: appearance)
        successView.addButton("Okay") {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "main") as UIViewController
            self.present(controller, animated: true, completion: nil)
        }

        // Do any additional setup after loading the view.
        startAnimating()
        let adQuery = PFQuery(className: "Advisor")
        adQuery.whereKey("userId", equalTo: PFUser.current()!.objectId!)
        adQuery.getFirstObjectInBackground {
            (object: PFObject?, error: Error?) -> Void in
            self.stopAnimating()
            if error == nil || object != nil {
                let isActive = object?["isActive"] as! Bool
                if !isActive {
                    successView.showNotice("In Review", subTitle: "We're still reviewing your information. We'll email you at \(PFUser.current()!.email!) when we have finished.")
                }
            }
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let desti = segue.destination as! QualificationsViewController
        desti.firstName = firstNameText.text
        desti.lastName = lastNameText.text
    }
    
    //make keyboard go away 
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    @IBAction func nextAction(_ sender: UIBarButtonItem) {
        //startAnimating()
        if validateFirstName() && validateLastName(){
            performSegue(withIdentifier: "showLicense", sender: self)
            
        }
    }
    
    @IBAction func profileAction(_ sender: UIButton) {
        if let container = self.so_containerViewController {
            container.isSideViewControllerPresented = true
        }
    }
    
    //validation tests
    func validateFirstName() ->Bool{
        var isValidated = false
        //let usernameJaunt = username.text?.characters.split{$0 == " "}.map(String.init)
        
        if firstNameText.text!.isEmpty{
            
            firstNameText.attributedPlaceholder = NSAttributedString(string:"Field required",
                                                                attributes:[NSForegroundColorAttributeName: UIColor.red])
            
        } else{
            isValidated = true
        }
        return isValidated
    }
    
    func validateLastName() ->Bool{
        var isValidated = false
        //let usernameJaunt = username.text?.characters.split{$0 == " "}.map(String.init)
        
        if lastNameText.text!.isEmpty{
            
            lastNameText.attributedPlaceholder = NSAttributedString(string:"Field required",
                                                                     attributes:[NSForegroundColorAttributeName: UIColor.red])
            
        } else{
            isValidated = true
        }
        return isValidated
    }
    
    func uicolorFromHex(_ rgbValue:UInt32)->UIColor{
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }
}
