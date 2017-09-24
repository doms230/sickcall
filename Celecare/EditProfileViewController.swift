//
//  EditProfileViewController.swift
//  Sickcall
//
//  Created by Dominic Smtih on 7/19/17.
//  Copyright © 2017 Sickcall All rights reserved.
//

import UIKit
import Parse
import NVActivityIndicatorView
import Kingfisher

class EditProfileViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate,NVActivityIndicatorViewable {
    
    @IBOutlet weak var image: UIButton!
    @IBOutlet weak var username: UITextField!
    var imageJaunt: String!
    var nameJaunt: String!
    
    let imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self

        image.layer.cornerRadius = 50
        image.clipsToBounds = true
        image.kf.setBackgroundImage(with: URL(string: imageJaunt), for: .normal)
        username.text = nameJaunt
        
        NVActivityIndicatorView.DEFAULT_TYPE = .ballScaleMultiple
        NVActivityIndicatorView.DEFAULT_COLOR = uicolorFromHex(0x159373)
        NVActivityIndicatorView.DEFAULT_BLOCKER_SIZE = CGSize(width: 60, height: 60)
        NVActivityIndicatorView.DEFAULT_BLOCKER_BACKGROUND_COLOR = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        
    }

    @IBAction func updateAction(_ sender: UIBarButtonItem) {
        startAnimating()
        let query = PFQuery(className:"_User")
        query.getObjectInBackground(withId: PFUser.current()!.objectId!) {
            (object: PFObject?, error: Error?) -> Void in
            if error == nil && object != nil {
                object?["DisplayName"] = self.username.text!
                object?.saveEventually {
                    (success: Bool, error: Error?) -> Void in
                    self.stopAnimating()
                    if (success) {
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let controller = storyboard.instantiateViewController(withIdentifier: "main") as UIViewController
                        self.present(controller, animated: true, completion: nil)
                    }
                }
                
            } else {
                print(error!)
            }
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        dismiss(animated: true, completion: nil)
        self.image.setBackgroundImage(chosenImage, for: .normal)
        
        let proPic = UIImageJPEGRepresentation(chosenImage, 0.5)
       let uploadedImage = PFFile(name: "profile_ios.jpeg", data: proPic!)
        uploadedImage?.saveInBackground {
            (success: Bool, error: Error?) -> Void in
            if (success) {
                
                if PFUser.current() != nil{
                    let query = PFQuery(className:"_User")
                    query.getObjectInBackground(withId: PFUser.current()!.objectId!) {
                        (object: PFObject?, error: Error?) -> Void in
                        if error == nil && object != nil {
                            if uploadedImage != nil{
                                object!["Profile"] = uploadedImage
                            }
                            object?.saveEventually()
                            
                        } else {
                            print(error!)
                        }
                    }
                }
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func EditProfile(_ sender: UIButton) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    func uicolorFromHex(_ rgbValue:UInt32)->UIColor{
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }

}
