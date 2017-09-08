//
//  LoginViewController.swift
//  Celecare
//
//  Created by Mac Owner on 6/29/17.
//  Copyright © 2017 Celecare LLC. All rights reserved.
//

import UIKit
import Parse
import SCLAlertView
import NVActivityIndicatorView

class LoginViewController: UIViewController,NVActivityIndicatorViewable {
    
    var valUsername = false
    var valPassword = false
    var valEmail = false
    
    var signupHidden = true
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    var forgotPasswordView: SCLAlertView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let exitItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(LoginViewController.exitAction(_:)))
        self.navigationItem.leftBarButtonItem = exitItem
        
        NVActivityIndicatorView.DEFAULT_TYPE = .ballScaleMultiple
        NVActivityIndicatorView.DEFAULT_COLOR = uicolorFromHex(0x159373)
        NVActivityIndicatorView.DEFAULT_BLOCKER_SIZE = CGSize(width: 60, height: 60)
        NVActivityIndicatorView.DEFAULT_BLOCKER_BACKGROUND_COLOR = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
    }
    
    @IBAction func forgotPasswordAction(_ sender: UIBarButtonItem) {
        forgotPasswordUI()
        forgotPasswordView.showEdit("Forgot Password", subTitle: "Enter in your Sickcall email")
    }
    
    @IBAction func loginAction(_ sender: UIButton) {
        returningUser( password: password.text!, username: (email.text!))
    }
    
    func validateUsername() ->Bool{
        
        //Validate username
        
        if email.text!.isEmpty{
            
            email.attributedPlaceholder = NSAttributedString(string:"Field required",
                                                                attributes:[NSForegroundColorAttributeName: UIColor.red])
            valUsername = false
            
        } else{
            valUsername = true
        }
        return valUsername
    }
    
    func validatePassword() -> Bool{
        
        if password.text!.isEmpty{
            password.attributedPlaceholder = NSAttributedString(string:"Field required",
                                                                attributes:[NSForegroundColorAttributeName: UIColor.red])
            valPassword = false
            
        } else{
            valPassword = true
        }
        
        return valPassword
    }
    
    func returningUser( password: String, username: String){
        
        startAnimating()
        
        let userJaunt = username.trimmingCharacters(
            in: NSCharacterSet.whitespacesAndNewlines
        )
        
        PFUser.logInWithUsername(inBackground: userJaunt, password:password) {
            (user: PFUser?, error: Error?) -> Void in
            if user != nil {
                
                //associate current user with device
                let installation = PFInstallation.current()
                installation?["user"] = PFUser.current()
                installation?["userId"] = PFUser.current()?.objectId
                installation?.saveEventually()
                
                self.determineNextScreen()
                
            } else {
                self.stopAnimating()
                SCLAlertView().showError("Login Attemmpt Unsuccessful", subTitle: "Check username and password combo.")
            }
        }
    }
    
    func forgotPasswordUI(){
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "HelveticaNeue", size: 20)!,
            kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
            kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
            showCloseButton: true
        )
        
        forgotPasswordView = SCLAlertView(appearance: appearance)
        let txt = forgotPasswordView.addTextField("Sickcall email")
        forgotPasswordView.addButton("Reset"){
            let blockQuery = PFQuery(className: "_User")
            blockQuery.whereKey("email", equalTo: "\(txt.text!)")
            blockQuery.findObjectsInBackground{
                (objects: [PFObject]?, error: Error?) -> Void in
                if objects?.count != 0{
                    PFUser.requestPasswordResetForEmail(inBackground: "\(txt.text!)")
                    SCLAlertView().showSuccess("Check your inbox", subTitle: "Click on the link from noreply@sickcallhealth.com")
                } else {
                    SCLAlertView().showNotice("Oops", subTitle: "Couldn't find an email associated with \(txt.text!)")
                }
            }
        }
    }
    
    func determineNextScreen(){
        let query = PFQuery(className: "Advisor")
        query.whereKey("userId", equalTo: PFUser.current()!.objectId!)
        query.getFirstObjectInBackground {
            (object: PFObject?, error: Error?) -> Void in
            self.stopAnimating()
            if error == nil || object != nil {
                if object!["isOnline"] as! Bool{
                    let storyboard = UIStoryboard(name: "Advisor", bundle: nil)
                    let initialViewController = storyboard.instantiateViewController(withIdentifier: "container") as! AdvisorContainerViewController
                    initialViewController.isAdvisor = true
                    self.present(initialViewController, animated: true, completion: nil)
                    
                } else {
                    self.checkUserDefaults()
                    
                }
            } else {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let initialViewController = storyboard.instantiateViewController(withIdentifier: "main")
                self.present(initialViewController, animated: true, completion: nil)
            }
        }
    }
    
    //checks to see what user was using Sickcall as last... Advisor or patient
    func checkUserDefaults(){
        if let side = UserDefaults.standard.string(forKey: "side"){
            if side == "patient"{
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let initialViewController = storyboard.instantiateViewController(withIdentifier: "main")
                self.present(initialViewController, animated: true, completion: nil)
                
            } else {
                let storyboard = UIStoryboard(name: "Advisor", bundle: nil)
                let initialViewController = storyboard.instantiateViewController(withIdentifier: "container") as! AdvisorContainerViewController
                initialViewController.isAdvisor = true
                self.present(initialViewController, animated: true, completion: nil)
            }
            
        }else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "main")
            self.present(initialViewController, animated: true, completion: nil)
        }
    }
    
    func exitAction(_ sender: UIBarButtonItem){
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "welcome")
        self.present(initialViewController, animated: true, completion: nil)
    }
    
    func uicolorFromHex(_ rgbValue:UInt32)->UIColor{
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }
    
}
