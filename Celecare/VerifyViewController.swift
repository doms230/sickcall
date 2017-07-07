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
    var phoneNumber: String! 
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
        //send user's phone number to EmailViewController 
        let desti = segue.destination as! EmailViewController
        desti.phoneNumber = phoneNumber
        
    }
 
    @IBAction func nextAction(_ sender: UIButton) {
        
        //verify phone number with code send to user's phone
        let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")

        
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID!,
            verificationCode: self.code.text!)
        
        Auth.auth().signIn(with: credential) { (user, error) in
            if let error = error {
                print(error)
                return
                
            } else {
                
                //Verified, segue to EmailViewController
                print("user signed in")
                
                let query = PFQuery(className: "_User")
                query.whereKey("phoneNumber", equalTo: self.phoneNumber)
                query.getFirstObjectInBackground {
                    (object: PFObject?, error: Error?) -> Void in
                    if error != nil || object == nil {
                        print("The getFirstObject request failed.")
                        self.performSegue(withIdentifier: "showEmail", sender: self)
                    } else {
                        // The find succeeded.
                        print("Successfully retrieved the object.")
                        let username = object?["username"] as! String
                        self.login(username: username, password: self.phoneNumber)
                    }
                }                                
            }
        }
    }
    
    func login(username: String, password: String)  {
        PFUser.logInWithUsername(inBackground: username, password: password) {
            (user: PFUser?, error: Error?) -> Void in
            if user != nil {
                
                //associate current user with device
                let installation = PFInstallation.current()
                installation?["user"] = PFUser.current()
                installation?["userId"] = PFUser.current()?.objectId
                //installation.setDeviceTokenFromData(deviceToken)
                installation?.saveEventually()
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "main") as UIViewController
                //segue to home screen
                self.present(controller, animated: true, completion: nil)
                
            } else {
               // self.showAlert("Login Attempt Unsuccessful", message: "Check username and password combo.")
                print("fail")
            }
        }
    }
    

}
