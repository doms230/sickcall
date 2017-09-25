//
//  MedHistoryViewController.swift
//  Celecare
//
//  Created by Dominic Smith on 9/24/17.
//  Copyright © 2017 Celecare LLC. All rights reserved.
//

import UIKit
import SlackTextViewController
import Parse
import NVActivityIndicatorView
import MobileCoreServices
import AVKit
import AVFoundation
import SCLAlertView
import ParseLiveQuery

class MedHistoryViewController: SLKTextViewController, NVActivityIndicatorViewable {
    
    var gender: String!
    var height: String!
    var weight: String!
    var birthday: String!
    
    var medAllergies = [String]()
    var foodAllergies = [String]()
    
    var medHistory: String!
    var ongoingMedIssues: String!
    
    //used to determine which is being edited
    var textViewTag = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView?.register(MainTableViewCell.self, forCellReuseIdentifier: "medHistoryReuse")
        self.tableView?.estimatedRowHeight = 50
        self.tableView?.rowHeight = UITableViewAutomaticDimension
        self.tableView?.separatorStyle = .singleLine
        self.isInverted = false
        self.rightButton.isEnabled = true
        self.leftButton.setTitle("left", for: .normal)
        self.setTextInputbarHidden(true, animated: true)
        self.rightButton.setTitle("Add", for: .normal)
        self.textInputbar.bringSubview(toFront: self.rightButton)
        self.textInputbar.bringSubview(toFront: self.textView)
        self.title = "Info 3/3"
        let nextButton = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextAction(_:)))
        self.navigationItem.setRightBarButton(nextButton, animated: true)
        
        NVActivityIndicatorView.DEFAULT_TYPE = .ballScaleMultiple
        NVActivityIndicatorView.DEFAULT_COLOR = uicolorFromHex(0x159373)
        NVActivityIndicatorView.DEFAULT_BLOCKER_SIZE = CGSize(width: 60, height: 60)
        NVActivityIndicatorView.DEFAULT_BLOCKER_BACKGROUND_COLOR = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.textView.becomeFirstResponder()
        self.setTextInputbarHidden(false, animated: true)
        
        if indexPath.row == 0{
            self.textView.text = medHistory
            self.textView.placeholder = "Medical History"
            textViewTag = 0
            
        } else {
            self.textView.text = ongoingMedIssues
            self.textView.placeholder = "Ongoing Health Issues"
            textViewTag = 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: MainTableViewCell!
        cell = tableView.dequeueReusableCell(withIdentifier: "medHistoryReuse", for: indexPath) as! MainTableViewCell
        cell.selectionStyle = .none
        cell.addLabel.textColor = uicolorFromHex(0x159373)
        if indexPath.row == 0{
            cell.medHistoryLabel.text = "Medical History"
            cell.MedHistoryContent.text = medHistory
            cell.addLabel.text = "Add medical history"
            
        } else {
            cell.medHistoryLabel.text = "Ongoing Health Issues"
            cell.MedHistoryContent.text = ongoingMedIssues
            cell.addLabel.text = "Add ongoing health issues"
        }
        
        return cell
    }
    
    @objc func medHistoryAction(_ sender: UIButton){
        self.textView.becomeFirstResponder()
        self.setTextInputbarHidden(false, animated: true)
        
        if sender.tag == 0{
            self.textView.text = medHistory
            self.textView.placeholder = "Medical History"
            textViewTag = 0
            
        } else {
            self.textView.text = ongoingMedIssues
            self.textView.placeholder = "Ongoing Health Issues"
            textViewTag = 1
        }
    }
    
    

    
    override func didPressRightButton(_ sender: Any!) {
        print("te")
        self.textView.resignFirstResponder()
        self.setTextInputbarHidden(true, animated: true)
        if textViewTag == 0{
            
            medHistory = self.textView.text
            
        } else {
            
            ongoingMedIssues = self.textView.text
        }
        self.tableView?.reloadData()
        self.textView.text = ""
        
        super.didPressRightButton(sender)
    }
    
    override func canPressRightButton() -> Bool {
        return super.canPressRightButton()
    }
    

    /*@objc func test(_ sender: UIButton){
        self.textView.resignFirstResponder()
        self.textView.isHidden = true
        if textViewTag == 0{
            medHistory = self.textView.text
            
        } else {
            ongoingMedIssues = self.textView.text
        }
        self.tableView?.reloadData()
        self.textView.text = ""
    } */
    
    
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
                object!["medHistory"] = self.medHistory
                object!["healthIssues"] = self.ongoingMedIssues
                object?.saveInBackground {
                    (success: Bool, error: Error?) -> Void in
                    self.stopAnimating()
                    if (success) {
                        self.performSegue(withIdentifier: "showQuestion", sender: self)
                        
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
