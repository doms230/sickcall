//
//  LoginViewController.swift
//  Celecare
//
//  Created by Mac Owner on 6/29/17.
//  Copyright © 2017 Celecare LLC. All rights reserved.
//

import UIKit
import Parse
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var phoneNumber: UITextField!
    
    var verificationId: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

            //send user's phone number to Verify View Controller
            let desti = segue.destination as! VerifyViewController
            desti.phoneNumber = "+1\(phoneNumber.text!)"
        
    }
 
    
    
    @IBAction func nextAction(_ sender: UIButton) {
        //Verify that user has access to phone number
        PhoneAuthProvider.provider().verifyPhoneNumber("+1\(phoneNumber.text!)") { (verificationID, error) in
            if let error = error {
                print(error.localizedDescription)
                //self.showMessagePrompt()
                return
                
            } else {
                //verification code sent to user's phone, segue to verifyViewController 
                
                //self.verificationId = verificationID
                UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
                self.performSegue(withIdentifier: "showVerifyPhone", sender: self)
                //segue to verification jaunt
            }
            // Sign in using the verificationID and the code sent to the user
            // ...
        }
    }
    

    @IBAction func facebookAction(_ sender: UIButton) {
    }
    
    /*
     func keyboardWillShow(_ notification: Notification) {
     
     if let keyboardSize = ((notification as NSNotification).userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
     if view.frame.origin.y == 0{
     self.view.frame.origin.y -= keyboardSize.height
     self.searchBar.frame.origin.y += keyboardSize.height
     }
     else {
     
     }
     }
     }
     
     func keyboardWillHide(_ notification: Notification) {
     if let keyboardSize = ((notification as NSNotification).userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
     if view.frame.origin.y != 0 {
     self.view.frame.origin.y += keyboardSize.height
     self.searchBar.frame.origin.y -= keyboardSize.height
     }
     else {
     
     }
     }
     }
 */
}
