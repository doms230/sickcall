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
        performSegue(withIdentifier: "showBasicInfo", sender: self)
    }
    
    @IBAction func callAction(_ sender: UIButton) {
        let alert = UIAlertController(title: "Call 911?", message: "", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Call", style: .default, handler: { action in
            if let url = URL(string: "tel://911)"), UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel" , style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}
