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
    var baseURL = "https://celecare.herokuapp.com/payments/updateBankInfo"
    //var baseURL = "http://192.168.1.75:5000/payments/updateBankInfo"

    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var routingTextField: UITextField!
    var connectId: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Bank Info"
        let nextButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(nextAction(_:)))
        self.navigationItem.setRightBarButton(nextButton, animated: true)
        
        let query = PFQuery(className: "_User")
        query.whereKey("objectId", equalTo: PFUser.current()!.objectId!)
        query.getFirstObjectInBackground {
            (object: PFObject?, error: Error?) -> Void in
            if error == nil || object != nil {
                self.connectId = object!["connectId"] as! String
                
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
        //class won't compile with textfield straight in parameters so has to be put to string first 
        let accountString =  accountTextField.text!
        let routingString = routingTextField.text!
        
        let p: Parameters = [
            "account_Id": connectId,
            "account_number": accountString,
            "routing_number": routingString
         ]
        
        Alamofire.request(self.baseURL, method: .post, parameters: p, encoding: JSONEncoding.default).validate().responseJSON { response in switch response.result {
            case .success(let data):
                let json = JSON(data)
                print("JSON: \(json)")
                /* if let id = json["id"].string {
                 }*/
                

                //can't get status code for some reason
               if let status = json["JSON"]["statusCode"].string{
                print(status)
                    let message = json["JSON"]["message"].string
                    if status.hasPrefix("4"){
                        self.errorMessage("Something Went Wrong", message: message! )
                    }
               } else {
                    let bankName = json["external_accounts"]["data"]["bank_name"].string
                    let bankLast4 = json["external_accounts"]["data"]["last4"].string
                    self.successMessage(bankName!, bankLast4: bankLast4!)
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
    
    func errorMessage(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message,
                                      preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func successMessage(_ bankName: String, bankLast4: String) {
        let alert = UIAlertController(title: "Your bank account was successfully added", message: "Your funds will be deposited to your \(bankName) \\(bankLast4) from now on.",
                                      preferredStyle: UIAlertControllerStyle.alert)
        let okayJaunt = UIAlertAction(title: "Okay", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            let storyboard = UIStoryboard(name: "Advisor", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "container") as UIViewController
            self.present(controller, animated: true, completion: nil)
        }
        
        alert.addAction(okayJaunt)

        self.present(alert, animated: true, completion: nil)
    }
    
    
}
