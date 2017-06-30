//
//  VerifyViewController.swift
//  Celecare
//
//  Created by Mac Owner on 6/29/17.
//  Copyright © 2017 Celecare LLC. All rights reserved.
//

import UIKit
import Firebase
import Parse 

class VerifyViewController: UIViewController {
    
    @IBOutlet weak var code: UITextField!
    //var verificationID: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        

    }



    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func nextAction(_ sender: UIButton) {
        
        let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")

        
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID!,
            verificationCode: self.code.text!)
        
        Auth.auth().signIn(with: credential) { (user, error) in
            if let error = error {
                print(error)
                return
                
            } else {
                
                print("user signed in")
                
                //****************************************
                //if already user, skip to Main.Storyboard
                
                /*let usernameQuery = PFQuery(className: "_User")
                usernameQuery.whereKey("username", equalTo: usernameField.text! )
                // usernameQuery("email", equalTo: emailField.text!  )
                usernameQuery.findObjectsInBackground{
                    (objects: [PFObject]?, error: Error?) -> Void in
                    
                    if objects?.count == 0{
                        //self.performSegue(withIdentifier: "showNewProfile", sender: self)
                        let emailQuery = PFQuery(className: "_User")
                        emailQuery.whereKey("email", equalTo: self.emailField.text!  )
                        emailQuery.findObjectsInBackground{
                            (objects: [PFObject]?, error: Error?) -> Void in
                            if objects?.count == 0{
                                self.performSegue(withIdentifier: "showNewProfile", sender: self)
                                
                            } else {
                                
                                self.showAlert("Email already in use", message: "")
                            }
                        }
                    } else {
                        self.showAlert("Username already in use", message: "")
                    }
                }*/
                
                
            }
            // User is signed in
            // ...
        }
        
    }

}
