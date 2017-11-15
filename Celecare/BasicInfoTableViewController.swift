//
//  BasicInfoTableViewController.swift
//  Celecare
//
//  Created by Dominic Smith on 9/24/17.
//  Copyright © 2017 Sickcall LLC All rights reserved.
//

import UIKit
import Parse
import Kingfisher

import MobileCoreServices
import AVKit
import AVFoundation

import BulletinBoard

class BasicInfoTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //video stuff
    var videoFile: URL!
    let imagePicker: UIImagePickerController! = UIImagePickerController()
    let saveFileName = "/test.mp4"
    
    @IBOutlet weak var questionSubjectTextfield: UITextField!
    
    var healthConcernDuration = "Today"
    
    @IBOutlet weak var todaySwitch: UISwitch!
    @IBOutlet weak var yesterdaySwitch: UISwitch!
    @IBOutlet weak var pastWeekSwitch: UISwitch!
    @IBOutlet weak var pastMonthSwitch: UISwitch!
    @IBOutlet weak var pastYearSwitch: UISwitch!
    @IBOutlet weak var moreThanYearSwitch: UISwitch!
    
    lazy var nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("Next", for: .normal)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 20)
        button.setTitleColor(.white, for: .normal)
        //label.numberOfLines = 0
        return button
    }()
    
    lazy var bulletinManager: BulletinManager = {
        
        let page = PageBulletinItem(title: "In 60 seconds")
        page.image = UIImage(named: "video")
        
        page.descriptionText = "Explain your health concern in detail. Show yourself or any affected areas to help your nurse advisor provide you with accurate information."
        page.actionButtonTitle = "Got It"
        page.interfaceFactory.tintColor = uicolorFromHex(0x006a52)// green
        page.interfaceFactory.actionButtonTitleColor = .white
        page.isDismissable = true
        page.actionHandler = { (item: PageBulletinItem) in
            page.manager?.dismissBulletin()
            self.showVideo()
            UserDefaults.standard.set(true, forKey: "recordInfo")
        }
        return BulletinManager(rootItem: page)
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nextButton = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextAction(_:)))
        self.navigationItem.setRightBarButton(nextButton, animated: true)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let desti = segue.destination as! SummaryViewController
        desti.healthConcernDuration = healthConcernDuration
        desti.healthConcernSummary = questionSubjectTextfield.text
        desti.pickedFile = videoFile
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
     @objc func nextAction(_ sender: UIBarButtonItem) {
        if validateTitle(){
            //performSegue(withIdentifier: "showQuestion", sender: self)
            
            if UserDefaults.standard.object(forKey: "recordInfo") == nil{
                bulletinManager.prepare()
                bulletinManager.presentBulletin(above: self)
                
            } else {
                self.showVideo()
            }
        }
    }
    
    //how long have you felt this way switch actions
    
    @IBAction func todaySwitchAction(_ sender: UISwitch) {
        if sender.isOn{
            yesterdaySwitch.setOn(false, animated: true)
            pastWeekSwitch.setOn(false, animated: true)
            pastMonthSwitch.setOn(false, animated: true)
            pastYearSwitch.setOn(false, animated: true)
            moreThanYearSwitch.setOn(false, animated: true)
            healthConcernDuration = "Today"
            
        } else {
            todaySwitch.setOn(true, animated: true)
        }
    }
    
    @IBAction func yesterdaySwitchAction(_ sender: UISwitch) {
        if sender.isOn{
            todaySwitch.setOn(false, animated: true)
            pastWeekSwitch.setOn(false, animated: true)
            pastMonthSwitch.setOn(false, animated: true)
            pastYearSwitch.setOn(false, animated: true)
            moreThanYearSwitch.setOn(false, animated: true)
            healthConcernDuration = "Yesterday"
            
        } else {
            yesterdaySwitch.setOn(true, animated: true)
        }
        
    }
    @IBAction func pastWeekSwitchAction(_ sender: UISwitch) {
        if sender.isOn{
            yesterdaySwitch.setOn(false, animated: true)
            todaySwitch.setOn(false, animated: true)
            pastMonthSwitch.setOn(false, animated: true)
            pastYearSwitch.setOn(false, animated: true)
            moreThanYearSwitch.setOn(false, animated: true)
            healthConcernDuration = "This past week"
            
        } else {
            pastWeekSwitch.setOn(true, animated: true)
        }
    }
    @IBAction func pastMonthSwitchAction(_ sender: UISwitch) {
        if sender.isOn{
            yesterdaySwitch.setOn(false, animated: true)
            todaySwitch.setOn(false, animated: true)
            pastWeekSwitch.setOn(false, animated: true)
            pastYearSwitch.setOn(false, animated: true)
            moreThanYearSwitch.setOn(false, animated: true)
            healthConcernDuration = "This past month"
            
        } else {
            pastMonthSwitch.setOn(true, animated: true)
        }
    }
    @IBAction func pastYearSwitchAction(_ sender: UISwitch) {
        if sender.isOn{
            yesterdaySwitch.setOn(false, animated: true)
            todaySwitch.setOn(false, animated: true)
            pastWeekSwitch.setOn(false, animated: true)
            pastMonthSwitch.setOn(false, animated: true)
            moreThanYearSwitch.setOn(false, animated: true)
            healthConcernDuration = "This past year"
            
        } else {
            pastYearSwitch.setOn(true, animated: true)
        }
    }
    @IBAction func moreThanYearSwitchAction(_ sender: UISwitch) {
        if sender.isOn{
            yesterdaySwitch.setOn(false, animated: true)
            todaySwitch.setOn(false, animated: true)
            pastWeekSwitch.setOn(false, animated: true)
            pastMonthSwitch.setOn(false, animated: true)
            pastYearSwitch.setOn(false, animated: true)
            healthConcernDuration = "More than a year"
            
        } else {
            moreThanYearSwitch.setOn(true, animated: true)
        }
    }
    
    func validateTitle() -> Bool{
        var isValidated = false
        
        if questionSubjectTextfield.text!.isEmpty{
            questionSubjectTextfield.attributedPlaceholder = NSAttributedString(string:"Field required",
                                                                                attributes:[NSAttributedStringKey.foregroundColor: UIColor.red])
            isValidated = false
            
        } else{
            print("true")
            isValidated = true
        }
        
        return isValidated
    }
    
    func postAlert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message,
                                      preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    //////video ///
    
    func showVideo(){
        if (UIImagePickerController.isSourceTypeAvailable(.camera)) {
            if UIImagePickerController.availableCaptureModes(for: .rear) != nil {
                
                imagePicker.sourceType = .camera
                imagePicker.cameraDevice = .front
                imagePicker.mediaTypes = [kUTTypeMovie as String]
                imagePicker.allowsEditing = false
                imagePicker.videoMaximumDuration = 60
                imagePicker.videoQuality = .typeMedium
                imagePicker.delegate = self
                
                present(imagePicker, animated: true, completion: {})
            } else {
                postAlert("Rear camera doesn't exist", message: "Application cannot access the camera.")
            }
        } else {
            postAlert("Camera inaccessable", message: "Application cannot access the camera.")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("Got a video")
        
        if let pickedVideo:URL = (info[UIImagePickerControllerMediaURL] as? URL) {
            
            videoFile = pickedVideo
            
            imagePicker.dismiss(animated: true, completion: {
                // Anything you want to happen when the user saves an video
                self.performSegue(withIdentifier: "showCheckout", sender: self)
            })
            
        } else {
            //TODO: something happened
        }
    }
    
    // Called when the user selects cancel
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("User canceled image")
        dismiss(animated: true, completion: {
            // Anything you want to happen when the user selects cancel
        })
    }
    
    func uicolorFromHex(_ rgbValue:UInt32)->UIColor{
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }
    
}
