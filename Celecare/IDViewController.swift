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
import DateTimePicker
import SCLAlertView

class IDViewController: UIViewController, NVActivityIndicatorViewable {
    
    //Name Values from QualificationsViewController
    var firstName: String!
    var lastName: String!
    var licenseNumber: String!
    var licenseType: String!
    var state: String!
    
    
    @IBOutlet weak var yearText: UITextField!
    @IBOutlet weak var monthText: UITextField!
    @IBOutlet weak var dayText: UITextField!
    @IBOutlet weak var ssnButton: UITextField!
    
    var successView: SCLAlertView!

    
    var didSelectBirthday = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "3/3"
        
        let nextButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneAction(_:)))
        self.navigationItem.setRightBarButton(nextButton, animated: true)
        
        NVActivityIndicatorView.DEFAULT_TYPE = .ballScaleMultiple
        NVActivityIndicatorView.DEFAULT_COLOR = uicolorFromHex(0xF4FF81)
        NVActivityIndicatorView.DEFAULT_BLOCKER_SIZE = CGSize(width: 60, height: 60)
        NVActivityIndicatorView.DEFAULT_BLOCKER_BACKGROUND_COLOR = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        
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

        // Do any additional setup after loading the view.
    }

    func doneAction(_ sender: UIBarButtonItem){
        self.yearText.resignFirstResponder()
        self.monthText.resignFirstResponder()
        self.dayText.resignFirstResponder()
        self.ssnButton.resignFirstResponder()
        
        startAnimating()
        if validateDay() && validateMonth() && validateYear() && validateSSN(){
            let newAdvisor = PFObject(className: "Advisor")
            newAdvisor["userId"] = PFUser.current()?.objectId
            newAdvisor["first"] = firstName
            newAdvisor["last"] = lastName
            newAdvisor["licenseNumber"] = licenseNumber
            newAdvisor["licenseType"] = licenseType
            newAdvisor["state"] = state
            newAdvisor["birthdayday"] = dayText.text!
            newAdvisor["birthdaymonth"] = monthText.text!
            newAdvisor["birthdayyear"] = yearText.text!
            newAdvisor["ssn"] = ssnButton.text
            newAdvisor["status"] = "un-verified"
            newAdvisor.saveEventually{
                (success: Bool, error: Error?) -> Void in
                self.stopAnimating()
                if (success) {

                    self.successView.showSuccess("Success", subTitle: "Thank You! Our SickCall team will verify your information and get back to you via your SickCall email.")

                } else {
                    SCLAlertView().showError("Post Failed", subTitle: "Check internet connection and try again. Contact help@sickcallhealth.com if the issue persists.")
                    // self.mapJaunt.removeAnnotation(pin)
                    /*let newTwitterHandlePrompt = UIAlertController(title: "Post Failed", message: "Check internet connection and try again. Contact help@celecareapp.com if the issue persists.", preferredStyle: .alert)
                    newTwitterHandlePrompt.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                    
                    self.present(newTwitterHandlePrompt, animated: true, completion: nil)*/
                }
            }
        } else {
            stopAnimating()
        }
        
    }
    
    //validate
    func validateDay() ->Bool{
        var isValidated = false
        //let usernameJaunt = username.text?.characters.split{$0 == " "}.map(String.init)
        
        if dayText.text!.isEmpty{
            dayText.attributedPlaceholder = NSAttributedString(string:"Field required",
                                                                 attributes:[NSForegroundColorAttributeName: UIColor.red])
        } else if dayText.text?.characters.count != 2{
            dayText.text = ""
            dayText.attributedPlaceholder = NSAttributedString(string:"Wrong Format. try 01 etc.",
                                                               attributes:[NSForegroundColorAttributeName: UIColor.red])
            
        }else{
            isValidated = true
        }
        return isValidated
    }
    
    func validateMonth() ->Bool{
        var isValidated = false
        //let usernameJaunt = username.text?.characters.split{$0 == " "}.map(String.init)
        
        if monthText.text!.isEmpty{
            monthText.attributedPlaceholder = NSAttributedString(string:"Field required",
                                                               attributes:[NSForegroundColorAttributeName: UIColor.red])
        } else if monthText.text?.characters.count != 2{
            monthText.text = ""
            monthText.attributedPlaceholder = NSAttributedString(string:"Wrong Format. try 01 etc.",
                                                               attributes:[NSForegroundColorAttributeName: UIColor.red])
            
        }else{
            isValidated = true
        }
        return isValidated
    }
    
    func validateYear() ->Bool{
        var isValidated = false
        //let usernameJaunt = username.text?.characters.split{$0 == " "}.map(String.init)
        
        if yearText.text!.isEmpty{
            yearText.attributedPlaceholder = NSAttributedString(string:"Field required",
                                                               attributes:[NSForegroundColorAttributeName: UIColor.red])
        } else if yearText.text?.characters.count != 4{
            yearText.text = ""
            yearText.attributedPlaceholder = NSAttributedString(string:"Wrong Format. try 1994 etc.",
                                                               attributes:[NSForegroundColorAttributeName: UIColor.red])
            
        }else{
            isValidated = true
        }
        return isValidated
    }
    
    func validateSSN() ->Bool{
        var isValidated = false
        //let usernameJaunt = username.text?.characters.split{$0 == " "}.map(String.init)
        
        if ssnButton.text!.isEmpty{
            
            ssnButton.attributedPlaceholder = NSAttributedString(string:"Field required",
                                                                    attributes:[NSForegroundColorAttributeName: UIColor.red])
            
        } else if (ssnButton.text?.characters.count)! != 4{
            ssnButton.text = ""
            ssnButton.attributedPlaceholder = NSAttributedString(string:"last 4 digits of your social security number",
                                                                 attributes:[NSForegroundColorAttributeName: UIColor.red])
        }else{
            isValidated = true
        }
        return isValidated
    }
    
    //mich.
    func uicolorFromHex(_ rgbValue:UInt32)->UIColor{
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }

}
