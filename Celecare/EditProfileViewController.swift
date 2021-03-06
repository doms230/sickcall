//
//  EditProfileViewController.swift
//  Sickcall
//
//  Created by Dominic Smtih on 7/19/17.
//  Copyright © 2017 Sickcall LLC All rights reserved.
//

import UIKit
import Parse
import NVActivityIndicatorView
import Kingfisher
import SnapKit

class EditProfileViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate,NVActivityIndicatorViewable {
    
    let screenSize: CGRect = UIScreen.main.bounds
    
    var color = Color()
    
    lazy var username: UITextField = {
        let label = UITextField()
        label.placeholder = "Name"
        label.backgroundColor = .white
        label.font = UIFont(name: "HelveticaNeue", size: 17)
        label.clearButtonMode = .whileEditing
        label.borderStyle = .roundedRect
        return label
    }()
    
    lazy var image: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 40)
        button.titleLabel?.textAlignment = .left
        button.setTitle("+", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    
    var imageString: String!
    var nameString: String!
    
    //don't let person edit their name if they're an advisor
    var isAdvisor = false 
    
    let imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self

        image.layer.cornerRadius = 50
        image.clipsToBounds = true
        image.kf.setBackgroundImage(with: URL(string: imageString), for: .normal)
        image.addTarget(self, action: #selector(editProfile(_:)), for: .touchUpInside)
        username.text = nameString
        
        self.view.addSubview(username)
        if isAdvisor{
            username.isEnabled = false 
        }
        self.view.addSubview(image)
        
        image.snp.makeConstraints { (make) -> Void in
            make.height.width.equalTo(100)
            make.top.equalTo(self.view).offset(100)
            make.left.equalTo(self.view).offset(screenSize.width / 2 - 50)
        }
        
        username.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(image.snp.bottom).offset(10)
            make.left.equalTo(self.view).offset(10)
            make.right.equalTo(self.view).offset(-10)
        }
        
        NVActivityIndicatorView.DEFAULT_TYPE = .ballScaleMultiple
        NVActivityIndicatorView.DEFAULT_COLOR = color.sickcallGreen()
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
    
    @objc func editProfile(_ sender: UIButton) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
}
