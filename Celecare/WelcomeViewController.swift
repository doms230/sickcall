//
//  WelcomeViewController.swift
//  Sickcall
//
//  Created by Dom Smith on 6/29/17.
//  Copyright © 2017 Sickcall All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin
import ParseFacebookUtilsV4
import Parse
import NVActivityIndicatorView
import Kingfisher
import SCLAlertView

class WelcomeViewController: UIViewController,NVActivityIndicatorViewable {
    
    var image: UIImage!
    var retreivedImage: PFFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NVActivityIndicatorView.DEFAULT_TYPE = .ballScaleMultiple
        NVActivityIndicatorView.DEFAULT_COLOR = uicolorFromHex(0x159373)
        NVActivityIndicatorView.DEFAULT_BLOCKER_SIZE = CGSize(width: 60, height: 60)
        NVActivityIndicatorView.DEFAULT_BLOCKER_BACKGROUND_COLOR = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
    }

    @IBAction func signInAction(_ sender: UIButton) {
        self.performSegue(withIdentifier: "showSignin", sender: self)
    }

    @IBAction func signupAction(_ sender: UIButton) {
        self.performSegue(withIdentifier: "showSignup", sender: self)
    }
    
    @IBAction func facebookAction(_ sender: UIButton) {
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false
        )
        let alertView = SCLAlertView(appearance: appearance)
        
        alertView.addButton("Yes"){
            let storyboard = UIStoryboard(name: "Advisor", bundle: nil)
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "container") as! AdvisorContainerViewController
            initialViewController.isAdvisor = false
            self.present(initialViewController, animated: true, completion: nil)
        }
        alertView.addButton("No") {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "main") as UIViewController
            self.present(controller, animated: true, completion: nil)
        }
        //
        PFFacebookUtils.logInInBackground(withReadPermissions: ["public_profile","email"]){
            (user: PFUser?, error: Error?) -> Void in
            self.startAnimating()
            if let user = user {
                print(user)
                
                let installation = PFInstallation.current()
                installation?["user"] = user
                installation?["userId"] = user.objectId
                installation?.saveEventually()
                
                if user.isNew {
                    
                    let request = FBSDKGraphRequest(graphPath: "me",parameters: ["fields": "id, name, first_name, last_name, email, gender, picture.type(large)"], tokenString: FBSDKAccessToken.current().tokenString, version: nil, httpMethod: "GET")
                    let _ = request?.start(completionHandler: { (connection, result, error) in
                        guard let userInfo = result as? [String: Any] else { return } //handle the error
                        
                        print(userInfo)
                        //The url is nested 3 layers deep into the result so it's pretty messy
                        if let imageURL = ((userInfo["picture"] as? [String: Any])?["data"] as? [String: Any])?["url"] as? String {
                            
                            //self.image.kf.setImage(with: URL(string: imageURL))
                            if let url = URL(string: imageURL) {
                                if let data = NSData(contentsOf: url){
                                    self.image = UIImage(data: data as Data)
                                }
                            }
                            let proPic = UIImageJPEGRepresentation(self.image, 0.5)
                            
                            self.retreivedImage = PFFile(name: "profile_ios.jpeg", data: proPic!)
                            self.retreivedImage?.saveInBackground {
                                (success: Bool, error: Error?) -> Void in
                                if (success) {
                                    user.email = userInfo["email"] as! String?
                                    user["DisplayName"] = userInfo["first_name"] as! String?
                                    user["Profile"] = self.retreivedImage
                                    user["foodAllergies"] = []
                                    user["gender"] = userInfo["gender"] as! String?
                                    user["height"] = " "
                                    user["medAllergies"] = []
                                    user["weight"] = " "
                                    user["birthday"] = " "
                                    user["beatsPM"] = " "
                                    user["healthIssues"] = " "
                                    user["respsPM"] = " "
                                    user["medHistory"] = " "
                                    user.saveEventually{
                                        (success: Bool, error: Error?) -> Void in
                                        if (success) {
                                            self.stopAnimating()
                                            
                                            alertView.showInfo("Are you a registered nurse?", subTitle: "")
                                        }
                                    }
                                }
                            }
                        }
                    })
                } else {
                    self.stopAnimating()
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let initialViewController = storyboard.instantiateViewController(withIdentifier: "main")
                    self.present(initialViewController, animated: true, completion: nil)
                }
            } else {
                self.stopAnimating()
            }
        }
    }
    
    func uicolorFromHex(_ rgbValue:UInt32)->UIColor{
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }    
    
    @IBAction func termsAction(_ sender: UIButton) {
        UIApplication.shared.open(URL(string: "https://www.sickcallhealth.com/terms" )!, options: [:], completionHandler: nil)
    }

}
