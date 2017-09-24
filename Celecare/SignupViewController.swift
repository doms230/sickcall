//
//  SignupViewController.swift
//  Sickcall
//
//  Created by Dom Smith on 8/23/17.
//  Copyright © 2017 Sickcall All rights reserved.
//

import UIKit
import Parse
import SCLAlertView
import NVActivityIndicatorView

class SignupViewController: UIViewController,NVActivityIndicatorViewable {

    //UI components
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    
    //validate jaunts
    var valPassword = false
    var valEmail = false
    
    override func viewDidLoad(){
        super.viewDidLoad()
        //print(numberToSend[0])
        let exitItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(SignupViewController.exitAction(_:)))
        self.navigationItem.leftBarButtonItem = exitItem
        
        let doneItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(SignupViewController.next(_:)))
        self.navigationItem.rightBarButtonItem = doneItem
        
        NVActivityIndicatorView.DEFAULT_TYPE = .ballScaleMultiple
        NVActivityIndicatorView.DEFAULT_COLOR = uicolorFromHex(0x159373)
        NVActivityIndicatorView.DEFAULT_BLOCKER_SIZE = CGSize(width: 60, height: 60)
        NVActivityIndicatorView.DEFAULT_BLOCKER_BACKGROUND_COLOR = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        
        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let desti = segue.destination as! NewProfileViewController
        
        //user info
        desti.emailString = emailField.text!
        desti.passwordString = passwordField.text!

    }
    
    @objc func next(_ sender: UIBarButtonItem){
        if validateEmail() && validatePassword(){
            startAnimating()
            //self.performSegue(withIdentifier: "showNewProfile", sender: self)
            let emailQuery = PFQuery(className: "_User")
            emailQuery.whereKey("email", equalTo: self.emailField.text!  )
            emailQuery.findObjectsInBackground{
                (objects: [PFObject]?, error: Error?) -> Void in
                self.stopAnimating()
                if objects?.count == 0{
                    self.performSegue(withIdentifier: "showNewProfile", sender: self)
                    
                } else {
                    SCLAlertView().showError("Oops", subTitle: "Email already in use")
                }
            }
        }
    }
    
    //MARK: Validate jaunts
    
    func validatePassword() -> Bool{
        if passwordField.text!.isEmpty{
            passwordField.attributedPlaceholder = NSAttributedString(string:"Field required",
                                                                     attributes:[NSAttributedStringKey.foregroundColor: UIColor.red])
            valPassword = false
            
        } else{
            print("true")
            valPassword = true
        }
        
        return valPassword
    }
    
    func validateEmail() -> Bool{
        let emailString : NSString = emailField.text! as NSString
        if emailField.text!.isEmpty{
            emailField.attributedPlaceholder = NSAttributedString(string:"Field required",
                                                                  attributes:[NSAttributedStringKey.foregroundColor: UIColor.red])
            valEmail = false
            view.endEditing(true)
            
        } else if !emailString.contains("@"){
            emailField.text = ""
            emailField.attributedPlaceholder = NSAttributedString(string:"Valid email required",
                                                                  attributes:[NSAttributedStringKey.foregroundColor: UIColor.red])
            valEmail = false
            view.endEditing(true)
            
        } else if !emailString.contains("."){
            emailField.text = ""
            emailField.attributedPlaceholder = NSAttributedString(string:"Valid email required",
                                                                  attributes:[NSAttributedStringKey.foregroundColor: UIColor.red])
            valEmail = false
            view.endEditing(true)
            
        } else{
            valEmail = true
        }
        return valEmail
    }
    
    @objc func exitAction(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "welcome") as UIViewController
        self.present(controller, animated: true, completion: nil)
    }
    
    func uicolorFromHex(_ rgbValue:UInt32)->UIColor{
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }
    
}
