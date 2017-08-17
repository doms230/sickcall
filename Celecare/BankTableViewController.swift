//
//  BankTableViewController.swift
//  Celecare
//
//  Created by Dominic Smith on 7/26/17.
//  Copyright © 2017 Celecare LLC. All rights reserved.
//

//get bank info and post it above

import UIKit
import Parse
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView
import SCLAlertView

class BankTableViewController: UITableViewController, NVActivityIndicatorViewable {
    
    //payments
    var baseURL = "https://celecare.herokuapp.com/payments/bank"
    //var baseURL = "http://192.168.1.75:5000/payments/updateBankInfo"

    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var routingTextField: UITextField!
    var connectId: String!
    
    var successView: SCLAlertView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NVActivityIndicatorView.DEFAULT_TYPE = .ballScaleMultiple
        NVActivityIndicatorView.DEFAULT_COLOR = uicolorFromHex(0xF4FF81)
        NVActivityIndicatorView.DEFAULT_BLOCKER_SIZE = CGSize(width: 60, height: 60)
        NVActivityIndicatorView.DEFAULT_BLOCKER_BACKGROUND_COLOR = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        
        self.title = "Bank Info"
        let nextButton = UIBarButtonItem(title: "Update", style: .plain, target: self, action: #selector(nextAction(_:)))
        self.navigationItem.setRightBarButton(nextButton, animated: true)
        nextButton.tag = 0
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(nextAction(_:)))
        self.navigationItem.setLeftBarButton(cancelButton, animated: true)
        cancelButton.tag = 1
        
        startAnimating()
        let query = PFQuery(className: "_User")
        query.whereKey("objectId", equalTo: PFUser.current()!.objectId!)
        query.getFirstObjectInBackground {
            (object: PFObject?, error: Error?) -> Void in
            if error == nil || object != nil {
                self.connectId = object!["connectId"] as! String
                self.getAccountInfo()
            }
        }
        
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "HelveticaNeue", size: 20)!,
            kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
            kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
            showCloseButton: false
        )
        
        successView = SCLAlertView(appearance: appearance)
        successView.addButton("Okay") {
            let storyboard = UIStoryboard(name: "Advisor", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "container") as UIViewController
            self.present(controller, animated: true, completion: nil)
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
        //loading view
        
        if sender.tag == 0{
            accountTextField.resignFirstResponder()
            routingTextField.resignFirstResponder()
            startAnimating()
            
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
                self.stopAnimating()
                if let status = json["statusCode"].int{
                    print(status)
                    let message = json["message"].string
                    
                    //self.errorMessage("Something Went Wrong", message: message! )
                    SCLAlertView().showError("Something Went Wrong", subTitle: message!)
                    
                } else {
                    let bankName = json["external_accounts"]["data"][0]["bank_name"].string
                    let bankLast4 = json["external_accounts"]["data"][0]["last4"].string
                    //self.successMessage(bankName!, bankLast4: bankLast4!)
                    self.successView.showSuccess("Success", subTitle: "Your funds will be deposited to \(bankName) ****\(bankLast4) from now on.")
                }
                print("Validation Successful")
                //self.performSegue(withIdentifier: "showCurrentMeds", sender: self)
                
            case .failure(let error):
                print(error)
                // self.messageFrame.removeFromSuperview()
                // self.postAlert("Charge Unsuccessful", message: error.localizedDescription )
                SCLAlertView().showError("Error", subTitle: error as! String)
                }
            }
            
        } else {
            //cancel
            let storyboard = UIStoryboard(name: "Advisor", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "container") as UIViewController
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    
    func getAccountInfo(){
        
        //class won't compile with textfield straight in parameters so has to be put to string first
        let p: Parameters = [
            "account_Id": connectId,
            ]
        let url = "https://celecare.herokuapp.com/payments/account"
        Alamofire.request(url, parameters: p, encoding: URLEncoding.default).validate().responseJSON { response in switch response.result {
        case .success(let data):
            let json = JSON(data)
            print("JSON: \(json)")
            self.stopAnimating()
            
            //can't get status code for some reason
            if let status = json["statusCode"].int{
                print(status)
                let message = json["message"].string
                SCLAlertView().showError("Something Went Wrong", subTitle: message!)
                
            } else {
                
                //self.successView.showSuccess("Success", subTitle: "You've updated your address.")
                //let bankName = json["external_accounts"]["data"][0]["bank_name"].string
                let last4 = json["external_accounts"]["data"][0]["last4"].string
                
                self.accountTextField.text = "****\(last4!)"
                self.routingTextField.text = json["external_accounts"]["data"][0]["routing_number"].string
            }
            
        case .failure(let error):
            self.stopAnimating()
            print(error)
            SCLAlertView().showError("Something Went Wrong", subTitle: "")
            // self.messageFrame.removeFromSuperview()
            // self.postAlert("Charge Unsuccessful", message: error.localizedDescription )
            
            }
        }
    }
    
    func uicolorFromHex(_ rgbValue:UInt32)->UIColor{
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }
    
    
}
