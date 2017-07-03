//
//  EmailViewController.swift
//  Celecare
//
//  Created by Mac Owner on 6/30/17.
//  Copyright © 2017 Celecare LLC. All rights reserved.
//

import UIKit
import Parse

class EmailViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    var phoneNumber: String! 
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let desti = segue.destination as! NewProfileViewController
        desti.phoneNumber = phoneNumber
        desti.email = emailField.text! 
        
        
    }
    
    
    
    @IBAction func nextAction(_ sender: UIButton) {
        //TODO: verify that email isn't already in use ***
        self.performSegue(withIdentifier: "showNewProfile", sender: self)
        
    }



}
