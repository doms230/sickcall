//
//  MedHistoryTableViewController.swift
//  Sickcall
//
//  Created by Dom Smith on 8/8/17.
//  Copyright © 2017 Sickcall All rights reserved.
//

import UIKit
import Parse
import NVActivityIndicatorView
import SCLAlertView

class MedHistoryTableViewController: UITableViewController, NVActivityIndicatorViewable {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Info 3/3"
        let nextButton = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextAction(_:)))
        self.navigationItem.setRightBarButton(nextButton, animated: true)
        
        NVActivityIndicatorView.DEFAULT_TYPE = .ballScaleMultiple
        NVActivityIndicatorView.DEFAULT_COLOR = uicolorFromHex(0x159373)
        NVActivityIndicatorView.DEFAULT_BLOCKER_SIZE = CGSize(width: 60, height: 60)
        NVActivityIndicatorView.DEFAULT_BLOCKER_BACKGROUND_COLOR = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        
        medHistoryText.text = medHistory
        healthIssuesText.text = ongoingMedIssues
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }

    var gender: String!
    var height: String!
    var weight: String!
    var birthday: String!
    
    var medAllergies = [String]()
    var foodAllergies = [String]()
    
    var medHistory: String!
    var ongoingMedIssues: String!
    
    @IBOutlet weak var medHistoryText: UITextView!
    @IBOutlet weak var healthIssuesText: UITextView!
    
    @objc func nextAction(_ sender: UIBarButtonItem){
        // Do any additional setup after loading the view.
        startAnimating()
        let query = PFQuery(className: "_User")
        query.whereKey("objectId", equalTo: PFUser.current()!.objectId!)
        query.getFirstObjectInBackground {
            (object: PFObject?, error: Error?) -> Void in
            if error != nil || object == nil {
                self.stopAnimating()
                SCLAlertView().showError("Medical Info Update Failed", subTitle: "Check internet connection and try again. Contact help@sickcallhealth.com if the issue persists.")
                
            } else {
                object?["gender"] = self.gender
                object?["height"] = self.height
                object?["weight"] = self.weight
                object?["birthday"] = self.birthday
                object?["medAllergies"] = self.medAllergies
                object?["foodAllergies"] = self.foodAllergies
                object?.saveInBackground {
                    (success: Bool, error: Error?) -> Void in
                    self.stopAnimating()
                    if (success) {
                        self.performSegue(withIdentifier: "showMedVitals", sender: self)
                        
                    } else {
                        SCLAlertView().showError("Medical Info Update Failed", subTitle: "Check internet connection and try again. Contact help@sickcallhealth.com if the issue persists.")
                    }
                }
            }
        }
    }
    
    //mich.
    func uicolorFromHex(_ rgbValue:UInt32)->UIColor{
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }

}
