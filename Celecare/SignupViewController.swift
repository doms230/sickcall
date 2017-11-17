//
//  SignupViewController.swift
//  Sickcall
//
//  Created by Dom Smith on 8/23/17.
//  Copyright © 2017 Sickcall LLC All rights reserved.
//

import UIKit
import Parse
import SCLAlertView
import NVActivityIndicatorView
import SnapKit
import BulletinBoard
import FacebookCore
import FacebookLogin
import ParseFacebookUtilsV4

class SignupViewController: UIViewController,NVActivityIndicatorViewable {

    var image: UIImage!
    var retreivedImage: PFFile!
    //propic
    
    var uploadedImage: PFFile!
    
    //UI components
    
    //validate jaunts
    var valPassword = false
    var valEmail = false
    var isSwitchOn = false
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 30)
        label.text = "Sign Up"
        label.textColor = UIColor.black
        label.numberOfLines = 0
        return label
    }()
    
    lazy var emailText: UITextField = {
        let label = UITextField()
        label.placeholder = "Email"
        label.font = UIFont(name: "HelveticaNeue", size: 17)
        label.backgroundColor = .white
        label.borderStyle = .roundedRect
        label.clearButtonMode = .whileEditing
        label.keyboardType = .emailAddress
        return label
    }()
    
    lazy var passwordText: UITextField = {
        let label = UITextField()
        label.placeholder = "Password"
        label.font = UIFont(name: "HelveticaNeue", size: 17)
        label.backgroundColor = .white
        label.borderStyle = .roundedRect
        label.clearButtonMode = .whileEditing
        label.isSecureTextEntry = true 
        return label
    }()
    
    lazy var signupButton: UIButton = {
        let button = UIButton()
        button.setTitle("Signup", for: .normal)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 20)
        button.setTitleColor(.blue, for: .normal)
        button.titleLabel?.textAlignment = .right
        //label.numberOfLines = 0
        return button
    }()
    
    var welcomePage: PageBulletinItem!
    lazy var welcomeManager: BulletinManager = {
        
        welcomePage = PageBulletinItem(title: "How Sickcall works")
        welcomePage.image = UIImage(named: "settings")
        
        welcomePage.descriptionText = "Spend up to 1 minute explaining your health concern in detail"
        welcomePage.shouldCompactDescriptionText = true
        welcomePage.actionButtonTitle = "Next"
        welcomePage.alternativeButtonTitle = "Get Started"
        welcomePage.interfaceFactory.tintColor = uicolorFromHex(0x006a52)// green
        welcomePage.interfaceFactory.actionButtonTitleColor = .white
        welcomePage.isDismissable = true
        welcomePage.actionHandler = { (item: PageBulletinItem) in
            self.welcomePage.manager?.dismissBulletin()
            self.affordablemanger.prepare()
            self.affordablemanger.presentBulletin(above: self)
        }
        welcomePage.alternativeHandler = { (item: PageBulletinItem) in
            self.welcomePage.manager?.dismissBulletin()
            self.emailText.becomeFirstResponder()
        }
        return BulletinManager(rootItem: self.welcomePage)
        
    }()
    
    var affordablePage: PageBulletinItem!
    lazy var affordablemanger: BulletinManager = {
        
        affordablePage = PageBulletinItem(title: "How Sickcall works")
        affordablePage.image = UIImage(named: "settings")
        
        affordablePage.descriptionText = "Your Sickcall nurse advisor will respond with a low, medium, or high serious level and some information on what may be going on."
        affordablePage.actionButtonTitle = "Got It"
        affordablePage.interfaceFactory.tintColor = uicolorFromHex(0x006a52)// green
        affordablePage.interfaceFactory.actionButtonTitleColor = .white
        affordablePage.isDismissable = true
        affordablePage.actionHandler = { (item: PageBulletinItem) in
            self.affordablePage.manager?.dismissBulletin()
            self.emailText.becomeFirstResponder()
        }

        return BulletinManager(rootItem: self.affordablePage)
        
    }()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        //print(numberToSend[0])
        
        let exitItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(SignupViewController.exitAction(_:)))
        self.navigationItem.leftBarButtonItem = exitItem
        
        let facebookItem = UIBarButtonItem(image: UIImage(named: "facebook"), style: .plain, target: self, action: #selector(facebookAction(_:)))
        self.navigationItem.rightBarButtonItem = facebookItem
        
        self.welcomeManager.prepare()
        self.welcomeManager.presentBulletin(above: self)
        
        self.view.addSubview(titleLabel)
        self.view.addSubview(emailText)
        self.view.addSubview(passwordText)
        self.view.addSubview(signupButton)
        signupButton.addTarget(self, action: #selector(next(_:)), for: .touchUpInside)
        
        titleLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.view).offset(100)
            make.left.equalTo(self.view).offset(10)
            make.right.equalTo(self.view).offset(-10)
        }
        
        emailText.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.equalTo(self.view).offset(10)
            make.right.equalTo(self.view).offset(-10)
        }
        
        passwordText.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(emailText.snp.bottom).offset(10)
            make.left.equalTo(self.view).offset(10)
            make.right.equalTo(self.view).offset(-10)
        }
        signupButton.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(passwordText.snp.bottom).offset(10)
            make.left.equalTo(self.view).offset(10)
            make.right.equalTo(self.view).offset(-10)
        }
        
        NVActivityIndicatorView.DEFAULT_TYPE = .ballScaleMultiple
        NVActivityIndicatorView.DEFAULT_COLOR = uicolorFromHex(0x006a52)
        NVActivityIndicatorView.DEFAULT_BLOCKER_SIZE = CGSize(width: 60, height: 60)
        NVActivityIndicatorView.DEFAULT_BLOCKER_BACKGROUND_COLOR = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        
        let proPic = UIImageJPEGRepresentation(UIImage(named: "appy")!, 0.5)
        uploadedImage = PFFile(name: "defaultProfile_ios.jpeg", data: proPic!)
        uploadedImage?.saveInBackground()
        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    @objc func next(_ sender: UIButton){
        emailText.resignFirstResponder()
        passwordText.resignFirstResponder()
        
        let emailString = emailText.text?.lowercased()
        
        if validateEmail() && validatePassword(){
            startAnimating()
            
            newUser(username: emailString!, password: passwordText.text!, email: emailString!, imageFile:
                uploadedImage)
        }
    }
    
    func newUser( username: String,
                  password: String, email: String, imageFile: PFFile ){
        let user = PFUser()
        user.username = username
        user.password = password
        user.email = email
        user["DisplayName"] = "Sickcaller"
        user["Profile"] = imageFile
        user["foodAllergies"] = []
        user["gender"] = " "
        user["height"] = " "
        user["medAllergies"] = []
        user["weight"] = " "
        user["birthday"] = " "
        user["beatsPM"] = " "
        user["healthIssues"] = " "
        user["respsPM"] = " "
        user["medHistory"] = " "
        user.signUpInBackground{ (succeeded: Bool, error: Error?) -> Void in
            self.stopAnimating()
            if error != nil {
                // let errorString = erro_userInfofo["error"] as? NSString
                //
                print(error!)
                SCLAlertView().showError("Oops", subTitle: "Email already taken.")
                
            } else {
                let installation = PFInstallation.current()
                installation?["user"] = PFUser.current()
                installation?["userId"] = PFUser.current()?.objectId
                installation?.saveEventually()
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let initialViewController = storyboard.instantiateViewController(withIdentifier: "main")
                self.present(initialViewController, animated: true, completion: nil)
            }
        }
    }
    
    //MARK: Validate jaunts
    
    func validatePassword() -> Bool{
        if passwordText.text!.isEmpty{
            passwordText.attributedPlaceholder = NSAttributedString(string:"Field required",
                                                                     attributes:[NSAttributedStringKey.foregroundColor: UIColor.red])
            valPassword = false
            
        } else{
            print("true")
            valPassword = true
        }
        
        return valPassword
    }
    
    func validateEmail() -> Bool{
        let emailString : NSString = emailText.text! as NSString
        if emailText.text!.isEmpty{
            emailText.attributedPlaceholder = NSAttributedString(string:"Field required",
                                                                  attributes:[NSAttributedStringKey.foregroundColor: UIColor.red])
            valEmail = false
            view.endEditing(true)
            
        } else if !emailString.contains("@"){
            emailText.text = ""
            emailText.attributedPlaceholder = NSAttributedString(string:"Valid email required",
                                                                  attributes:[NSAttributedStringKey.foregroundColor: UIColor.red])
            valEmail = false
            view.endEditing(true)
            
        } else if !emailString.contains("."){
            emailText.text = ""
            emailText.attributedPlaceholder = NSAttributedString(string:"Valid email required",
                                                                  attributes:[NSAttributedStringKey.foregroundColor: UIColor.red])
            valEmail = false
            view.endEditing(true)
            
        } else{
            valEmail = true
        }
        return valEmail
    }
    
    @objc func switchAction(_ sender: UISwitch) {
        if sender.isOn{
            isSwitchOn = true
            
        } else {
            isSwitchOn = false 
        }
    }
    
    @objc func exitAction(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "welcome") as UIViewController
        self.present(controller, animated: true, completion: nil)
    }
    
    @objc func facebookAction(_ sender: UIBarButtonItem){
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
}
