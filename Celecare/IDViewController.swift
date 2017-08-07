//
//  IDViewController.swift
//  Celecare
//
//  Created by Dom Smith on 8/6/17.
//  Copyright © 2017 Celecare LLC. All rights reserved.
//

import UIKit
import Parse
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView

class IDViewController: UIViewController, NVActivityIndicatorViewable {
    
    //Name Values from QualificationsViewController
    var firstName: String!
    var lastName: String!
    var licenseNumber: String!
    var licenseType: String!
    var state: String!
    
    @IBOutlet weak var birthdayButton: UIButton!
    @IBOutlet weak var ssnButton: UITextField!
    var day: String!
    var month: String!
    var year: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nextButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneAction(_:)))
        self.navigationItem.setRightBarButton(nextButton, animated: true)
        
        NVActivityIndicatorView.DEFAULT_TYPE = .ballScaleMultiple
        NVActivityIndicatorView.DEFAULT_COLOR = uicolorFromHex(0xF4FF81)
        NVActivityIndicatorView.DEFAULT_BLOCKER_SIZE = CGSize(width: 60, height: 60)
        NVActivityIndicatorView.DEFAULT_BLOCKER_BACKGROUND_COLOR = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)

        // Do any additional setup after loading the view.
    }

    func doneAction(_ sender: UIBarButtonItem){
        startAnimating()
        if validateLicenseNumber() && validateLicenseTypeButton() && validateStateButton(){
            performSegue(withIdentifier: "showId", sender: self)
            
        } else {
            stopAnimating()
        }
    }
    
    @IBAction func birthdayAction(_ sender: UIButton) {

    }
    
    


}
