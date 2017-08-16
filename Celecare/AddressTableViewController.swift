//
//  AddressTableViewController.swift
//  Celecare
//
//  Created by Dominic Smith on 7/26/17.
//  Copyright © 2017 Celecare LLC. All rights reserved.
//

import UIKit
import Parse
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView
import SCLAlertView

class AddressTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource, NVActivityIndicatorViewable {
    
    @IBOutlet weak var line1TextField: UITextField!
    @IBOutlet weak var line2TextField: UITextField!
    @IBOutlet weak var stateTextField: UIButton!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var postalCodeTextfield: UITextField!
    
    var connectId: String!
    
    var successView: SCLAlertView!
    
    var baseURL = "https://celecare.herokuapp.com/payments/address"
    //account
      let states = [ "Alabama","Alaska","Arizona","Arkansas","California","Colorado","Connecticut","Delaware","Florida","Georgia","Hawaii","Idaho"," Illinois","Indiana","Iowa","Kansas","Kentucky", "Louisiana","Maine","Maryland","Massachusetts","Michigan","Minnesota","Mississippi","Missouri","Montana","Nebraska","Nevada","New Hampshire","New Jersey","New Mexico","New York","North Carolina","North Dakota","Ohio","Oklahoma",    "Oregon","Pennsylvania","Rhode Island","South Carolina","South Dakota","Tennessee","Texas","Utah","Vermont","Virginia","Washington","West Virginia","Wisconsin","Wyoming"]
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NVActivityIndicatorView.DEFAULT_TYPE = .ballScaleMultiple
        NVActivityIndicatorView.DEFAULT_COLOR = uicolorFromHex(0xF4FF81)
        NVActivityIndicatorView.DEFAULT_BLOCKER_SIZE = CGSize(width: 60, height: 60)
        NVActivityIndicatorView.DEFAULT_BLOCKER_BACKGROUND_COLOR = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)

        self.title = "Address"
        let doneButton = UIBarButtonItem(title: "Update", style: .plain, target: self, action: #selector(nextAction(_:)))
        self.navigationItem.setRightBarButton(doneButton, animated: true)
        doneButton.tag = 0
        
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
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        /*let desti = segue.destination as! PersonalTableViewController
        desti.line1 = line1TextField.text
        desti.line2 = line2TextField.text
        desti.state = stateTextField.titleLabel?.text 
        desti.city = cityTextField.text
        desti.postalCode = postalCodeTextfield.text*/
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
    
    func nextAction(_ sender: UIBarButtonItem){
        if sender.tag == 0{
            //update address 
            line1TextField.resignFirstResponder()
            line2TextField.resignFirstResponder()
            postalCodeTextfield.resignFirstResponder()
            stateTextField.resignFirstResponder()
            cityTextField.resignFirstResponder()
            startAnimating()
            
            //class won't compile with textfield straight in parameters so has to be put to string first
            let line1String =  line1TextField.text!
            let line2String = line2TextField.text!
            let postalCodeFieldString = postalCodeTextfield.text!
            let stateString = stateTextField.titleLabel!.text!
            let cityString = cityTextField.text!
            let p: Parameters = [
                "account_Id": connectId,
                "city": cityString,
                "line1": line1String,
                "line2": line2String,
                "postal_code": postalCodeFieldString,
                "state": stateString
            ]
            
            Alamofire.request(self.baseURL, method: .post, parameters: p, encoding: JSONEncoding.default).validate().responseJSON { response in switch response.result {
            case .success(let data):
                let json = JSON(data)
                print("JSON: \(json)")
                
                //can't get status code for some reason
                self.stopAnimating()
                if let status = json["statusCode"].int{
                    print(status)
                    let message = json["message"].string
                    SCLAlertView().showError("Something Went Wrong", subTitle: message!)
                    
                } else {
                    self.successView.showSuccess("Success", subTitle: "You've updated your address.")
                }
                
            case .failure(let error):
                SCLAlertView().showError("Something Went Wrong", subTitle: "" )
                // self.messageFrame.removeFromSuperview()
                // self.postAlert("Charge Unsuccessful", message: error.localizedDescription )
                
                }
            }
            
        } else {
            //cancel
            let storyboard = UIStoryboard(name: "Advisor", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "container") as UIViewController
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    //
    @IBAction func stateAction(_ sender: UIButton) {
        let prompt = UIAlertController(title: "Choose License Type", message: "", preferredStyle: .actionSheet)
        
        let statePickerView: UIPickerView = UIPickerView()
        statePickerView.delegate = self
        statePickerView.dataSource = self
        prompt.view.addSubview(statePickerView)
        
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
            //self.chooseDateAction(type: self.dateType)
        }
        
        prompt.addAction(okayJaunt)
        
        present(prompt, animated: true, completion: nil)
    }
    
    // data method to return the number of column shown in the picker.
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // data method to return the number of row shown in the picker.
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
       return states.count
    }
    
    // delegate method to return the value shown in the picker
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return states[row]
    }
    
    // delegate method called when the row was selected.
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        stateTextField.setTitle(states[row], for: .normal)
        stateTextField.setTitleColor(.black, for: .normal)
        
    }
    
    func uicolorFromHex(_ rgbValue:UInt32)->UIColor{
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
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
                self.line1TextField.text = json["legal_entity"]["address"]["line1"].string
                self.line2TextField.text = json["legal_entity"]["address"]["line2"].string
                self.postalCodeTextfield.text = json["legal_entity"]["address"]["postal_code"].string
                let stateString = json["legal_entity"]["address"]["state"].string
                self.stateTextField.setTitle(stateString, for: .normal)
                self.stateTextField.setTitleColor(.black, for: .normal)
                self.cityTextField.text = json["legal_entity"]["address"]["city"].string
                
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
}
