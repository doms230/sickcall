//
//  WelcomeViewController.swift
//  Sickcall
//
//  Created by Dom Smith on 6/29/17.
//  Copyright © 2017 Sickcall LLC All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin
import ParseFacebookUtilsV4
import Parse
import NVActivityIndicatorView
import Kingfisher
import SCLAlertView
import SnapKit

class WelcomeViewController: UIViewController,NVActivityIndicatorViewable {
    
    var image: UIImage!
    var retreivedImage: PFFile!
    let screenSize: CGRect = UIScreen.main.bounds

    lazy var appImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "appy")
        return image
    }()
    
    lazy var appName: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 30)
        label.text = "Sickcall"
        label.numberOfLines = 0
        return label
    }()
    
    lazy var appEx: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 35)
        label.text = "Ask health related questions"
        label.numberOfLines = 0
        return label
    }()
    
    lazy var featureImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "rocket")
        return image
    }()
    
    lazy var appFeature: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 15)
        label.text = "Get a reply within 15 mintues from our U.S. registered nurse advisors"
        label.numberOfLines = 0
        return label
    }()
    
    lazy var featureImage1: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "check")
        return image
    }()
    
    lazy var appFeature1: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 15)
        label.text = "All nurse advisors are verified through their states' board of nursing verifcation checks."
        label.numberOfLines = 0
        return label
    }()
    
    lazy var featureImage2: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "key")
        return image
    }()
    
    lazy var appFeature2: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 15)
        label.text = "We’re HIPAA compliant. Our Sickcall advisors only have access to your question while answering and their access is revoked afterwards"
        label.numberOfLines = 0
        return label
    }()
    
    lazy var signinButton: UIButton = {
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 20)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 3
        button.clipsToBounds = true
        //label.numberOfLines = 0
        return button
    }()
    
    lazy var signupButton: UIButton = {
        let button = UIButton()
        button.setTitle("Get Started", for: .normal)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 20)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 3
        button.clipsToBounds = true
        //label.numberOfLines = 0
        return button
    }()
    
    lazy var facebookButton: UIButton = {
        let button = UIButton()
        button.setTitle(" Login with Facebook", for: .normal)
        button.setImage(UIImage(named: "facebook"), for: .normal)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 20)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 3
        button.clipsToBounds = true
        //label.numberOfLines = 0
        return button
    }()
    
    lazy var termsButton: UIButton = {
        let button = UIButton()
        button.setTitle("By continuing, you agree to our terms and privacy policy", for: .normal)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 11)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 3
        button.clipsToBounds = true
        //label.numberOfLines = 0
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NVActivityIndicatorView.DEFAULT_TYPE = .ballScaleMultiple
        NVActivityIndicatorView.DEFAULT_COLOR = uicolorFromHex(0x006a52)
        NVActivityIndicatorView.DEFAULT_BLOCKER_SIZE = CGSize(width: 60, height: 60)
        NVActivityIndicatorView.DEFAULT_BLOCKER_BACKGROUND_COLOR = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        
        self.view.addSubview(appImage)
        self.view.addSubview(appName)
        appName.textColor = uicolorFromHex(0x006a52)
        self.view.addSubview(appEx)
        self.view.addSubview(appFeature)
        self.view.addSubview(featureImage)
        self.view.addSubview(appFeature1)
        self.view.addSubview(featureImage1)
        self.view.addSubview(appFeature2)
        self.view.addSubview(featureImage2)
        self.view.addSubview(signinButton)
        signinButton.addTarget(self, action: #selector(signInAction(_:)), for: .touchUpInside)
        self.view.addSubview(signupButton)
        signinButton.setTitleColor(uicolorFromHex(0x006a52), for: .normal)  
        
        signupButton.backgroundColor = uicolorFromHex(0x006a52)
        signupButton.addTarget(self, action: #selector(signupAction(_:)), for: .touchUpInside)
       /* self.view.addSubview(facebookButton)
        facebookButton.backgroundColor = uicolorFromHex(0x0950D0)
        facebookButton.addTarget(self, action: #selector(facebookAction(_:)), for: .touchUpInside)*/
        self.view.addSubview(termsButton)
        termsButton.addTarget(self, action: #selector(termsAction(_:)), for: .touchUpInside)
        
        appImage.snp.makeConstraints { (make) -> Void in
            make.height.width.equalTo(50)
            make.top.equalTo(self.view).offset(30)
            make.left.equalTo(self.view).offset(20)
        }
        
        appName.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.view).offset(35)
            make.left.equalTo(self.appImage.snp.right)
        }
        
        appEx.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.appName.snp.bottom).offset(20)
            make.left.equalTo(self.view).offset(20)
            make.right.equalTo(self.view).offset(-20)
        }
        
        featureImage.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(25)
            make.top.equalTo(self.appEx.snp.bottom).offset(20)
            make.left.equalTo(self.view).offset(20)
        }
        
        appFeature.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.appEx.snp.bottom).offset(20)
            make.left.equalTo(self.featureImage.snp.right).offset(5)
            make.right.equalTo(self.view).offset(-20)
        }
        
        featureImage1.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(25)
            make.top.equalTo(self.appFeature.snp.bottom).offset(20)
            make.left.equalTo(self.view).offset(20)
        }
        
        appFeature1.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.appFeature.snp.bottom).offset(20)
            make.left.equalTo(self.featureImage1.snp.right).offset(5)
            make.right.equalTo(self.view).offset(-20)
        }
        
        featureImage2.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(25)
            make.top.equalTo(self.appFeature1.snp.bottom).offset(20)
            make.left.equalTo(self.view).offset(20)
        }
        
        appFeature2.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.appFeature1.snp.bottom).offset(20)
            make.left.equalTo(self.featureImage2.snp.right).offset(5)
            make.right.equalTo(self.view).offset(-20)
        }
        
        signinButton.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(50)
            make.left.equalTo(self.view).offset(10)
            make.right.equalTo(self.view).offset(-10)
            make.bottom.equalTo(self.signupButton.snp.top).offset(-10)
        }
        
        signupButton.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(50)
            make.top.equalTo(signinButton.snp.bottom).offset(10)
            make.left.equalTo(self.view).offset(10)
            make.right.equalTo(self.view).offset(-10)
        }
        
        /*facebookButton.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(50)
            make.top.equalTo(signupButton.snp.bottom).offset(10)
            make.left.equalTo(self.view).offset(10)
            make.right.equalTo(self.view).offset(-10)
        }*/
        
        termsButton.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.signupButton.snp.bottom).offset(10)
            make.left.equalTo(self.view).offset(10)
            make.right.equalTo(self.view).offset(-10)
            make.bottom.equalTo(self.view).offset(-20)
        }
    }

    @objc func signInAction(_ sender: UIButton) {
        self.performSegue(withIdentifier: "showSignin", sender: self)
    }

    @objc func signupAction(_ sender: UIButton) {
        self.performSegue(withIdentifier: "showSignup", sender: self)
    }
    
    @objc func facebookAction(_ sender: UIButton) {
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
                                            
                                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                            let initialViewController = storyboard.instantiateViewController(withIdentifier: "main")
                                            self.present(initialViewController, animated: true, completion: nil)                                        }
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
    
    @objc func termsAction(_ sender: UIButton) {
        UIApplication.shared.open(URL(string: "https://www.sickcallhealth.com/terms" )!, options: [:], completionHandler: nil)
    }

}
