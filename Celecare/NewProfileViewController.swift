//
//  NewProfileViewController.swift
//  Celecare
//
//  Created by Mac Owner on 7/2/17.
//  Copyright © 2017 Celecare LLC. All rights reserved.
//

import UIKit
import Parse

class NewProfileViewController: UIViewController ,UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var userImage: UIButton!
    
    var email: String!
    var phoneNumber: String!
    
    //image picker stuff
    
    var uploadedImage: PFFile!
    
    let imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let proPic = UIImageJPEGRepresentation(UIImage(named: "appy")!, 0.5)
        uploadedImage = PFFile(name: "defaultProfile_ios.jpeg", data: proPic!)
        
        imagePicker.delegate = self
        

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func nextAction(_ sender: UIButton) {
        //create new Profile.. send to med info
        
        newUser(displayName: userName.text!, username: email!, password: phoneNumber, email: email!, imageFile: uploadedImage)
        
    }
    
    func newUser( displayName: String, username: String,
                  password: String, email: String, imageFile: PFFile ){
        let user = PFUser()
        user.username = username
        user.password = password
        user.email = email
        user["DisplayName"] = displayName
        user["Profile"] = imageFile
        user["phoneNumber"] = phoneNumber
        user.signUpInBackground{ (succeeded: Bool, error: Error?) -> Void in
            if error != nil {
                // let errorString = erro_userInfofo["error"] as? NSString
                //
                print(error!)
                
            } else {
                
                //associate current user with device
                let installation = PFInstallation.current()
                installation?["user"] = PFUser.current()
                installation?["userId"] = PFUser.current()?.objectId
                //installation.setDeviceTokenFromData(deviceToken)
                installation?.saveEventually()
                
                //segue to main storyboard 
                /*let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "main") as UIViewController
                self.present(controller, animated: true, completion: nil)*/
                
                self.performSegue(withIdentifier: "showCurrentMeds", sender: self)
                
            }
        }
    }
    
    //Image picker functions
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        dismiss(animated: true, completion: nil)
        
        userImage.setTitle("", for: .normal)
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
        //imagePicker.cameraDevice = .front
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    //
    /*func progressBarDisplayer() {
        
        let messageFrame = UIView(frame: CGRect(x: view.frame.midX, y: view.frame.midY - 25 , width: 50, height: 50))
        messageFrame.layer.cornerRadius = 15
        messageFrame.backgroundColor = UIColor(white: 0, alpha: 0.7)
        
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.white)
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityIndicator.startAnimating()
        
        messageFrame.addSubview(activityIndicator)
        view.addSubview(messageFrame)
    }*/
    
    

}
