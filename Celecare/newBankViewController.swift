//
//  newBankViewController.swift
//  Sickcall
//
//  Created by Dominic Smith on 10/17/17.
//  Copyright © 2017 Sickcall LLC. All rights reserved.
//

import UIKit
import Parse
import Alamofire
import SwiftyJSON
import SnapKit
import NVActivityIndicatorView
import SCLAlertView

class newBankViewController: UIViewController, NVActivityIndicatorViewable {
    
    lazy var accountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 17)
        label.text = "Account Number"
        label.textColor = UIColor.black
        label.backgroundColor = .clear
        label.numberOfLines = 0
        return label
    }()
    
    lazy var bAccountText: UITextField = {
        let label = UITextField()
        label.placeholder = "Account Number"
        label.backgroundColor = .white
        label.font = UIFont(name: "HelveticaNeue", size: 17)
        label.clearButtonMode = .whileEditing
        label.borderStyle = .roundedRect
        label.keyboardType = .numberPad
        return label
    }()
    
    lazy var routingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 17)
        label.text = "Routing Number"
        label.textColor = UIColor.black
        label.backgroundColor = .clear
        label.numberOfLines = 0
        return label
    }()
    
    lazy var bRoutingtext: UITextField = {
        let label = UITextField()
        label.placeholder = "Routing Number"
        label.backgroundColor = .white
        label.font = UIFont(name: "HelveticaNeue", size: 17)
        label.clearButtonMode = .whileEditing
        label.borderStyle = .roundedRect
        label.keyboardType = .numberPad
        return label
    }()
    
    var connectId: String!
    var baseURL = "https://celecare.herokuapp.com/payments/newAccount"
    var first_name: String!
    var last_name: String!
    var personal_id_number: String!
    var dobDay: Int!
    var dobMonth: Int!
    var dobYear: Int!
    var routing: String!
    var account: String!
    var email: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nextButton = UIBarButtonItem(title: "Update", style: .plain, target: self, action: #selector(doneAction(_:)))
        self.navigationItem.setRightBarButton(nextButton, animated: true)
        
        configureBank()
        
        NVActivityIndicatorView.DEFAULT_TYPE = .ballScaleMultiple
        NVActivityIndicatorView.DEFAULT_COLOR = uicolorFromHex(0x159373)
        NVActivityIndicatorView.DEFAULT_BLOCKER_SIZE = CGSize(width: 60, height: 60)
        NVActivityIndicatorView.DEFAULT_BLOCKER_BACKGROUND_COLOR = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        
        // Do any additional setup after loading the view.
        
        let userId = PFUser.current()?.objectId
        let query = PFQuery(className: "Advisor")
        query.whereKey("userId", equalTo: userId!)
        query.getFirstObjectInBackground {
            (object: PFObject?, error: Error?) -> Void in
            if error == nil || object != nil {
                
                object?["connectId"]  = self.connectId
                object?.saveInBackground {
                    (success: Bool, error: Error?) -> Void in
                    if (success) {
                        //segue back
                    }
                }
                
            } else{
                //you're not connected to the internet message
            }
        }
    }
    
    @objc func doneAction(_ sender: UIBarButtonItem){
    
        let userId = PFUser.current()?.objectId
        let query = PFQuery(className: "Advisor")
        query.whereKey("userId", equalTo: userId!)
        query.getFirstObjectInBackground {
            (object: PFObject?, error: Error?) -> Void in
            if error == nil || object != nil {
                
                 object?["connectId"]  = self.connectId
                object?.saveInBackground {
                    (success: Bool, error: Error?) -> Void in
                    if (success) {
                       //segue back
                    }
                }
            } else{
                //you're not connected to the internet message
            }
        }
    }
    
    func getAccountInfo(){
        //class won't compile with textfield straight in parameters so has to be put to string first
       /* let p: Parameters = [
            "account_Id": connectId,
            ]
        let url = "https://celecare.herokuapp.com/payments/account"
        Alamofire.request(url, parameters: p, encoding: URLEncoding.default).validate().responseJSON { response in switch response.result {
        case .success(let data):
            let json = JSON(data)
            print("JSON: \(json)")
            self.stopAnimating()
            
            if let status = json["statusCode"].int{
                print(status)
                let message = json["message"].string
                SCLAlertView().showError("Something Went Wrong", subTitle: message!)
                
            } else if let last4 = json["external_accounts"]["data"][0]["last4"].string{
                self.accountTextField.text = "****\(last4)"
                self.routingTextField.text = json["external_accounts"]["data"][0]["routing_number"].string
            }
            
        case .failure(let error):
            self.stopAnimating()
            print(error)
            SCLAlertView().showError("Something Went Wrong", subTitle: "")
            
            }
        }*/
    }
    
    func configureBank(){
        self.view.addSubview(accountLabel)
        self.view.addSubview(bAccountText)
        self.view.addSubview(routingLabel)
        self.view.addSubview(bRoutingtext)
        
        accountLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.view).offset(20)
            make.left.equalTo(self.view).offset(10)
            make.right.equalTo(self.view).offset(-10)
        }
        
        bAccountText.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(accountLabel.snp.bottom).offset(5)
            make.left.equalTo(self.view).offset(10)
            make.right.equalTo(self.view).offset(-10)
        }
        
        routingLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(bAccountText.snp.bottom).offset(10)
            make.left.equalTo(self.view).offset(10)
            make.right.equalTo(self.view).offset(-10)
        }
        
        bRoutingtext.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(routingLabel.snp.bottom).offset(5)
            make.left.equalTo(self.view).offset(10)
            make.right.equalTo(self.view).offset(-10)
            make.bottom.equalTo(self.view).offset(-20)
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
