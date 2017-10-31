//
//  PatientInfoViewController.swift
//  Sickcall
//
//  Created by Dom Smith on 8/7/17.
//  Copyright © 2017 Socialgroupe Incorporated All rights reserved.
//

import UIKit
import Parse
import SnapKit
import BulletinBoard
import UserNotifications

class PatientInfoViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var genderButton: UIButton!
    var genders = ["", "Female", "Male", "Non-Conforming"]
    var selectedGender = ""
    
    @IBOutlet weak var birthdayButton: UIButton!
    var day: String!
    var month: String!
    var year: String!
    var selectedBirthday: String!
    
    @IBOutlet weak var heightButton: UIButton!
    var heightFt = [ "0", "1'", "2'", "3'", "4'", "5'", "6'", "7'", "8'" ]
    var heightIn = [ "0\"", "1\"", "2\"", "3\"", "4\"", "5\"", "6\"", "7\"", "8\"", "9\"", "10\"", "11\""]
    var selectedHeightFt = "0'"
    var selectedHeightIn = "0\""
    
    @IBOutlet weak var weightButton: UIButton!
    var weight = [String]()
    var selectedWeight = ""
    
    //
    var whichPicker = "gender"
    var prompt : UIAlertController!
    var pickerPrompt: UIAlertController!
    
    var medAllergy = [String]()
    var foodAllergy = [String]()
    var medHistory: String!
    var ongoingMedIssues: String!
    
    lazy var startButton: UIButton = {
        let button = UIButton()
        button.setTitle("Next", for: .normal)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 20)
        button.setTitleColor(.white, for: .normal)
        //label.numberOfLines = 0
        return button
    }()
    
    lazy var bulletinManager: BulletinManager = {
        
        let page = PageBulletinItem(title: "Medical Information")
        page.image = UIImage(named: "heart")
        
        page.descriptionText = "Providing your medical information helps your nurse advisor send you accurate information about your health concern."
        page.actionButtonTitle = "Okay"
        page.interfaceFactory.tintColor = uicolorFromHex(0x006a52)// green
        page.interfaceFactory.actionButtonTitleColor = .white
        page.isDismissable = true
        page.actionHandler = { (item: PageBulletinItem) in
            self.bulletinManager.dismissBulletin()
            UserDefaults.standard.set(true, forKey: "medInfo")
            self.notificationsManager.prepare()
            self.notificationsManager.presentBulletin(above: self)
        }
        return BulletinManager(rootItem: page)
    }()
    
    lazy var notificationsManager: BulletinManager = {
        
        let page = PageBulletinItem(title: "Notifications")
        page.image = UIImage(named: "bell")
        
        page.descriptionText = "Sickcall uses notifications to let you know about important updates, like when your nurse advisor replies to your health concern."
        page.actionButtonTitle = "Okay"
        page.interfaceFactory.tintColor = uicolorFromHex(0x006a52)// green
        page.interfaceFactory.actionButtonTitleColor = .white
        page.isDismissable = true
        page.actionHandler = { (item: PageBulletinItem) in
            page.manager?.dismissBulletin()
            UserDefaults.standard.set(true, forKey: "notifications")
            let current = UNUserNotificationCenter.current()
            current.getNotificationSettings(completionHandler: { (settings) in
                if settings.authorizationStatus == .notDetermined {
                    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
                        (granted, error) in
                        
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                }
            })
        }
        return BulletinManager(rootItem: page)
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      if UserDefaults.standard.object(forKey: "medInfo") == nil{
            self.bulletinManager.prepare()
            self.bulletinManager.presentBulletin(above: self)
        
        } else if UserDefaults.standard.object(forKey: "notifications") == nil{
            self.notificationsManager.prepare()
            self.notificationsManager.presentBulletin(above: self)
        }
        
        self.title = "Info 1/3"
        let nextButton = UIBarButtonItem(title: "911", style: .plain, target: self, action: #selector(emergencyAction(_:)))
        self.navigationItem.setRightBarButton(nextButton, animated: true)
        
        self.view.addSubview(startButton)
        startButton.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(50)
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
            make.bottom.equalTo(self.view).offset(-49)
        }
        
        clearTmpDirectory()
        
        startButton.backgroundColor = uicolorFromHex(0x006a52)
        startButton.addTarget(self, action: #selector(nextAction(_:)), for: .touchUpInside)
        
        genderButton.layer.cornerRadius = 3
        genderButton.clipsToBounds = true
        
        birthdayButton.layer.cornerRadius = 3
        birthdayButton.clipsToBounds = true
        
        heightButton.layer.cornerRadius = 3
        heightButton.clipsToBounds = true
        
        weightButton.layer.cornerRadius = 3
        weightButton.clipsToBounds = true
        
        var i = 0
        while i < 1000{
            weight.append("\(i)")
            i += 1
        }
        
        //app will crash if user hasn't selected fields 
        genderButton.setTitle(" ", for: .normal)
        birthdayButton.setTitle(" ", for: .normal)
        heightButton.setTitle(" ", for: .normal)
        weightButton.setTitle(" ", for: .normal)
        
        let query = PFQuery(className: "_User")
        query.whereKey("objectId", equalTo: PFUser.current()!.objectId!)
        query.getFirstObjectInBackground {
            (object: PFObject?, error: Error?) -> Void in
            if error == nil || object != nil {
                self.genderButton.setTitle(object?["gender"] as? String, for: .normal)
                self.birthdayButton.setTitle(object?["birthday"] as? String, for: .normal)
                self.heightButton.setTitle(object?["height"] as? String, for: .normal)
                self.weightButton.setTitle(object?["weight"] as? String, for: .normal)
                self.medAllergy = object?["medAllergies"] as! Array<String>
                self.foodAllergy = object?["foodAllergies"] as! Array<String>
                self.medHistory = object?["medHistory"] as! String
                self.ongoingMedIssues = object?["healthIssues"] as! String
                
            } else {
                self.genderButton.setTitle("", for: .normal)
                self.birthdayButton.setTitle(" ", for: .normal)
                self.heightButton.setTitle(" ", for: .normal)
                self.weightButton.setTitle(" ", for: .normal)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let desti = segue.destination as! AllergyViewTableViewController
        desti.gender = genderButton.titleLabel?.text!
        desti.birthday = birthdayButton.titleLabel?.text!
        desti.height = heightButton.titleLabel?.text!
        desti.weight = weightButton.titleLabel?.text!
        desti.foodAllergies = foodAllergy
        desti.medAllergies = medAllergy
        desti.medHistory = self.medHistory
        desti.ongoingMedIssues = self.ongoingMedIssues
        
    }
    
    // button actions
    
    @objc func nextAction(_ sender: UIButton){
        // Do any additional setup after loading the view.
        performSegue(withIdentifier: "showAllergies", sender: self)

    }
    
    @objc func emergencyAction(_ sender: UIBarButtonItem){
        if let url = URL(string: "tel://911)"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func genderAction(_ sender: UIButton) {
        whichPicker = "gender"
        picker(type: "gender")
        
    }
    
    @IBAction func birthdayAction(_ sender: UIButton) {
        prompt = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        
        //date jaunts
        let datePickerView  : UIDatePicker = UIDatePicker()
        // datePickerView.date = date!
        datePickerView.datePickerMode = UIDatePickerMode.date
        datePickerView.addTarget(self, action: #selector(PatientInfoViewController.datePickerAction(_:)), for: UIControlEvents.valueChanged)
        prompt.view.addSubview(datePickerView)
        
        let datePicker = UIAlertAction(title: "", style: UIAlertActionStyle.default) {
            UIAlertAction in
        }
        
        datePicker.isEnabled = false
        
        prompt.addAction(datePicker)
        //prompt.addAction(okay)
        
        let height:NSLayoutConstraint = NSLayoutConstraint(item: prompt.view, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.view.frame.height * 0.6)
        
        prompt.view.addConstraint(height);
        
        let okayJaunt = UIAlertAction(title: "Okay", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
        }
        
        prompt.addAction(okayJaunt)
        
        present(prompt, animated: true, completion: nil)
    }
    
    @objc func datePickerAction(_ sender: UIDatePicker){
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateStyle = .short
        
        let formattedDate = timeFormatter.string(from: sender.date)
        
        birthdayButton.setTitle(" \(formattedDate)", for: .normal)
        birthdayButton.setTitleColor(.black, for: .normal)
        
        let calendar = Calendar.current
        year = "\(calendar.component(.year, from: sender.date))"
        month = "\(calendar.component(.month, from: sender.date))"
        day = "\(calendar.component(.day, from: sender.date))"
        
    }
    
    @IBAction func heightAction(_ sender: UIButton) {
        whichPicker = "height"
        picker(type: "height")
    }
    
    @IBAction func weightAction(_ sender: UIButton) {
        whichPicker = "weight"
        picker(type: "weight")
    }
    
    //
    //picker view stuff
    
    // data method to return the number of column shown in the picker.
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        if whichPicker == "gender"{
            return 1
            
        }else {
            return 2
        }
    }
    
    // data method to return the number of row shown in the picker.
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        switch whichPicker{
        case "gender":
            return genders.count
            
        case "height":
            if component == 0{
                return heightFt.count
                
            } else {
                return heightIn.count
            }
            
        case "weight":
            if component == 0{
                return weight.count
                
            } else {
                return 1
            }
            
        default:
            return 0
        }
    }
    
    // delegate method to return the value shown in the picker
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        switch whichPicker{
        case "gender":
            return genders[row]
            
        case "height":
            if component == 0{
                return heightFt[row]
                
            } else {
                return heightIn[row]
            }
            
        case "weight":
            if component == 0{
                return weight[row]
                
            } else {
                return "lbs"
            }
            
        default:
            return ""
        }
    }
    
    // delegate method called when the row was selected.
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch whichPicker{
        case "gender":
            selectedGender = genders[row]
            
        case "height":
            if component == 0{
                selectedHeightFt = heightFt[row]
                
            } else {
                selectedHeightIn = heightIn[row]
            }
            
        case "weight":
            if component == 0{
                selectedWeight = weight[row]
            }
            
        default:
            break
        }
    }
    
    func picker(type: String){
        
        //
        let prompt = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        
        let statePickerView: UIPickerView = UIPickerView()
        statePickerView.delegate = self
        statePickerView.dataSource = self
        prompt.view.addSubview(statePickerView)
        
        let space = UIAlertAction(title: "", style: UIAlertActionStyle.default) {
            UIAlertAction in
        }
        
        space.isEnabled = false
        
        prompt.addAction(space)
        //prompt.addAction(okay)
        
        let height:NSLayoutConstraint = NSLayoutConstraint(item: prompt.view, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.view.frame.height * 0.6)
        
        prompt.view.addConstraint(height);
        
        let okayJaunt = UIAlertAction(title: "Okay", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            switch type{
            case "gender":
                self.genderButton.setTitle(" \(self.selectedGender)", for: .normal)
                break
                
            case "height":
                self.heightButton.setTitle(" \(self.selectedHeightFt) \(self.selectedHeightIn)", for: .normal)
                break
                
            case "weight":
                self.weightButton.setTitle(" \(self.selectedWeight) lbs", for: .normal)
                break
                
            default:
                break
            }
        }
        
        prompt.addAction(okayJaunt)
        
        present(prompt, animated: true, completion: nil)
    }
    
    func clearTmpDirectory(){
        let path = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
        let manager = FileManager.default
        let files = try? manager.contentsOfDirectory(atPath: path.path)
        files?.forEach { (file) in
            let temp = path.appendingPathComponent(file)
            try? manager.removeItem(at: temp)
            
            // --- you can use do{} catch{} for error handling ---//
        }
    }
    
    func uicolorFromHex(_ rgbValue:UInt32)->UIColor{
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }
}
