//
//  NewQuestionViewController.swift
//  Celecare
//
//  Created by Dom Smith on 8/7/17.
//  Copyright © 2017 Celecare LLC. All rights reserved.
//

import UIKit

class NewQuestionViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func continueAction(_ sender: UIButton) {
        //performSegue(withIdentifier: "showBasicInfo", sender: self)
        performSegue(withIdentifier: "showVitals", sender: self)
    }
    
    
}
