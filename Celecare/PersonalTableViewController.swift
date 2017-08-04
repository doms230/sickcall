//
//  PersonalTableViewController.swift
//  Celecare
//
//  Created by Dominic Smith on 7/26/17.
//  Copyright © 2017 Celecare LLC. All rights reserved.
//

import UIKit
import Parse
import Alamofire
import SwiftyJSON

class PersonalTableViewController: UITableViewController {
    
    
    @IBOutlet weak var ssnTextField: UITextField!
    @IBOutlet weak var birthdayTextField: UIButton!
    var day: String!
    var month: String!
    var year: String!
    
    var line1: String!
    var line2: String!
    var state: String!
    var city: String!
    var postalCode: String!
    
    var firstName: String!
    var lastName: String!
    
    var prompt : UIAlertController!
    
    //
    var baseURL = "http://192.168.1.75:5000/payments/updatePersonalInfo"
    var isActive = false
    
//ssn.substring(from:ssn.index(ssn.endIndex, offsetBy: -4))
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Identity Verification"

        let nextButton = UIBarButtonItem(title: "Update", style: .plain, target: self, action: #selector(nextAction(_:)))
        self.navigationItem.setRightBarButton(nextButton, animated: true)
        
        let query = PFQuery(className: "Advisor")
        query.whereKey("userId", equalTo: PFUser.current()!.objectId!)
        query.getFirstObjectInBackground {
            (object: PFObject?, error: Error?) -> Void in
            if error == nil || object != nil {
                self.firstName = object!["first"] as! String
                self.lastName = object!["last"] as! String
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
    }
    
    func nextAction(_ sender: UIBarButtonItem){
       /* */
        let ssn = ssnTextField.text!
        
        let p: Parameters = [
            "personal_id_number": ssn,
            "city": city,
            "line1": line1,
            "line2": line2,
            "postal_code": postalCode,
            "state": state,
            "day": day,
            "month": month,
            "year": year,
            "first_name": firstName,
            "last_name": lastName,
        ]
        
        Alamofire.request(self.baseURL, method: .post, parameters: p, encoding: JSONEncoding.default).validate().responseJSON { response in switch response.result {
        case .success(let data):
            let json = JSON(data)
            print("JSON: \(json)")
            /* if let id = json["id"].string {
             }*/
            
            let storyboard = UIStoryboard(name: "Advisor", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "container") as UIViewController
            self.present(controller, animated: true, completion: nil)
            if let status = json["raw"]["statusCode"].string{
                let message = json["raw"]["message"].string
                if status.hasPrefix("4"){
                     self.postAlert("Something Went Wrong", message: message! )
                    
                } else {
                    let storyboard = UIStoryboard(name: "Advisor", bundle: nil)
                    let controller = storyboard.instantiateViewController(withIdentifier: "container") as UIViewController
                    self.present(controller, animated: true, completion: nil)
                }
            }
            print("Validation Successful")
            //self.performSegue(withIdentifier: "showCurrentMeds", sender: self)
            
        case .failure(let error):
            print(error)
            // self.messageFrame.removeFromSuperview()
            // self.postAlert("Charge Unsuccessful", message: error.localizedDescription )
            
            }
        }
    }
    
    @IBAction func birthdayAction(_ sender: UIButton) {
        prompt = UIAlertController(title: "What's your birthday?", message: "", preferredStyle: .actionSheet)
        
        //date jaunts
        let datePickerView  : UIDatePicker = UIDatePicker()
        // datePickerView.date = date!
        datePickerView.datePickerMode = UIDatePickerMode.date
        datePickerView.addTarget(self, action: #selector(PersonalTableViewController.datePickerAction(_:)), for: UIControlEvents.valueChanged)
        prompt.view.addSubview(datePickerView)
        
        let datePicker = UIAlertAction(title: "", style: UIAlertActionStyle.default) {
            UIAlertAction in
        }
        
        datePicker.isEnabled = false
        
        prompt.addAction(datePicker)
        //prompt.addAction(okay)
        
        let height:NSLayoutConstraint = NSLayoutConstraint(item: prompt.view, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.view.frame.height * 0.6)
        
        prompt.view.addConstraint(height);
        
        let okayJaunt = UIAlertAction(title: "Okay", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            
        }
        
        prompt.addAction(okayJaunt)
        
        present(prompt, animated: true, completion: nil)
    }
    
    func datePickerAction(_ sender: UIDatePicker){
        let timeFormatter = DateFormatter()
        timeFormatter.dateStyle = .short
        
        let formattedDate = timeFormatter.string(from: sender.date)
        
        birthdayTextField.setTitle(formattedDate, for: .normal)
        birthdayTextField.setTitleColor(.black, for: .normal)
        
        let calendar = Calendar.current
        
        year = "\(calendar.component(.year, from: sender.date))"
        month = "\(calendar.component(.month, from: sender.date))"
        day = "\(calendar.component(.day, from: sender.date))"
        print(year)
        print(month)
        print("day: " + day)
    }
    
    func postAlert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message,
                                      preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    /*

    */

}
