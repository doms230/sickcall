//
//  BankTableViewController.swift
//  Celecare
//
//  Created by Dominic Smith on 7/26/17.
//  Copyright © 2017 Celecare LLC. All rights reserved.
//

import UIKit
import Parse
import Alamofire
import SwiftyJSON

class BankTableViewController: UITableViewController {
    
    //payments
    //var baseURL = "https://celecare.herokuapp.com/payments/pay"
    var baseURL = "http://192.168.1.75:5000/payments/newAccount"

    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var routingTextField: UITextField!
    
    var firstName: String!
    var lastName: String!
    var ssn: String!
    var birthday: String!
    var line1: String!
    var line2: String!
    var state: String!
    var city: String!
    var postalCode: String!
    var day: String!
    var month: String!
    var year: String!
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Bank 3/3"
        let nextButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(nextAction(_:)))
        self.navigationItem.setRightBarButton(nextButton, animated: true)
        

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
        //class won't compile with textfield straight in parameters so has to be put to string first 
        let accountString =  accountTextField.text!
        let routingString = routingTextField.text!
        
        let p: Parameters = [
         "email": "",
         "personal_id_number": ssn,
         "ssn_last_4": ssn.substring(from:ssn.index(ssn.endIndex, offsetBy: -4)),
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
         "account_number": accountString,
        "routing_number": routingString
         ]
        
        Alamofire.request(self.baseURL, method: .post, parameters: p, encoding: JSONEncoding.default).validate().responseJSON { response in switch response.result {
            case .success(let data):
                let json = JSON(data)
                print("JSON: \(json)")
                /* if let id = json["id"].string {
                 }*/
                
                
              /* if let status = json["raw"]["statusCode"].string{
                    let message = json["raw"]["message"].string
                    if status.hasPrefix("4"){
                       // self.postAlert("Something Went Wrong", message: message! )
                        
                    } else {
                        //do pay checkout jaunts
                        //also do something where activity spinner shows up
                        /*
                         if isVideoCompressed{
                         self.postIt()
                         }*/
                    }
                }*/
                print("Validation Successful")
                //self.performSegue(withIdentifier: "showCurrentMeds", sender: self)
                
            case .failure(let error):
                print(error)
               // self.messageFrame.removeFromSuperview()
               // self.postAlert("Charge Unsuccessful", message: error.localizedDescription )

            }
        }
        
    }
    
    

}
