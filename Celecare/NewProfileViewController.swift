//
//  NewProfileViewController.swift
//  Celecare
//
//  Created by Mac Owner on 7/2/17.
//  Copyright © 2017 Celecare LLC. All rights reserved.
//#F2F2F5 -type off white jaunt beige color

import UIKit
import Parse
import NVActivityIndicatorView
import SCLAlertView

class NewProfileViewController: UIViewController ,UIImagePickerControllerDelegate, UINavigationControllerDelegate,NVActivityIndicatorViewable{
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var userImage: UIButton!
        
    var userNameString: String!
    var emailString: String!
    var passwordString: String!
    //image picker stuff
    
    var uploadedImage: PFFile!
    
    let imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "2/2"
        let doneItem = UIBarButtonItem(title: "Sign up", style: .plain, target: self, action: #selector(NewProfileViewController.signUpAction(_:)))
        self.navigationItem.rightBarButtonItem = doneItem
        
        let proPic = UIImageJPEGRepresentation(UIImage(named: "appy")!, 0.5)
        uploadedImage = PFFile(name: "defaultProfile_ios.jpeg", data: proPic!)
        
        userImage.layer.cornerRadius = 50
        userImage.clipsToBounds = true 
        
        imagePicker.delegate = self
        
        NVActivityIndicatorView.DEFAULT_TYPE = .ballScaleMultiple
        NVActivityIndicatorView.DEFAULT_COLOR = uicolorFromHex(0x159373)
        NVActivityIndicatorView.DEFAULT_BLOCKER_SIZE = CGSize(width: 60, height: 60)
        NVActivityIndicatorView.DEFAULT_BLOCKER_BACKGROUND_COLOR = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
    }
    
    func signUpAction(_ sender: UIBarButtonItem) {
        //create new Profile.. send to med info
        startAnimating()
        newUser(displayName: userName.text!, username: emailString!, password: passwordString, email: emailString!, imageFile: uploadedImage)
        
    }
    
    func newUser( displayName: String, username: String,
                  password: String, email: String, imageFile: PFFile ){
        let user = PFUser()
        user.username = username
        user.password = password
        user.email = email
        user["DisplayName"] = displayName
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
                SCLAlertView().showError("Oops", subTitle: "We couldn't sign you up. Check internet connection and try again")
                
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
    
    //Image picker functions
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        dismiss(animated: true, completion: nil)
        
        //userImage.setTitle("", for: .normal)
        userImage.setBackgroundImage(chosenImage, for: .normal)
        //tableJaunt.reloadData()
        
        let proPic = UIImageJPEGRepresentation(chosenImage, 0.5)
        uploadedImage = PFFile(name: "profile_ios.jpeg", data: proPic!)
        uploadedImage?.saveInBackground {
            (success: Bool, error: Error?) -> Void in
            if (success) {
                
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func uploadProfilePicAction(_ sender: UIButton) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType =  .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func uicolorFromHex(_ rgbValue:UInt32)->UIColor{
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }
}
