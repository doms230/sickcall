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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
  /*  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

            let desti = segue.destination as! VerifyViewController
            
            desti.verificationId = self.verificationId
        
    }*/
 
    
    
    @IBAction func nextAction(_ sender: UIButton) {
        PhoneAuthProvider.provider().verifyPhoneNumber("+1\(phoneNumber.text!)") { (verificationID, error) in
            if let error = error {
                print(error.localizedDescription)
                //self.showMessagePrompt()
                return
                
            } else {
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
}
