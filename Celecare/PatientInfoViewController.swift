//
//  PatientInfoViewController.swift
//  Celecare
//
//  Created by Dom Smith on 8/7/17.
//  Copyright © 2017 Celecare LLC. All rights reserved.
//

import UIKit

class PatientInfoViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var genderButton: UIButton!
    var genders = ["", "Female", "Male", "Other"]
    var selectedGender: String!
    
    @IBOutlet weak var birthdayButton: UIButton!
    var day: String!
    var month: String!
    var year: String!
    var selectedBirthday: String!
    
    @IBOutlet weak var heightButton: UIButton!
    var heightFt = ["", "0'", "1'", "2'", "3'", "4'", "5'", "6'", "7'", "8'" ]
    var heightIn = ["", "0\"", "1\"", "2\"", "3\"", "4\"", "5\"", "6\"", "7\"", "8\"", "9\"", "10\"", "11\""]
    var selectedHeightFt: String!
    var selectedHeightIn: String!
    
    @IBOutlet weak var weightButton: UIButton!
    var weight = [String]()
    var selectedWeight: String!
    
    //
    var whichPicker = "gender"
    var prompt : UIAlertController!
    var pickerPrompt: UIAlertController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.title = "Info 1/3"
        let nextButton = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextAction(_:)))
        self.navigationItem.setRightBarButton(nextButton, animated: true)
        
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
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let desti = segue.destination as! AllergyViewController
        desti.gender = genderButton.titleLabel?.text!
        desti.birthday = birthdayButton.titleLabel?.text!
        desti.height = heightButton.titleLabel?.text!
        desti.weight = weightButton.titleLabel?.text!
    }
    
    // button actions
    
    func nextAction(_ sender: UIBarButtonItem){
        // Do any additional setup after loading the view.
        performSegue(withIdentifier: "showAllergies", sender: self)

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
    
    func datePickerAction(_ sender: UIDatePicker){
        
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
                self.genderButton.setTitle(" \(self.selectedGender!)", for: .normal)
                break
                
            case "height":
                self.heightButton.setTitle(" \(self.selectedHeightFt!) \(self.selectedHeightIn!)", for: .normal)
                break
                
            case "weight":
                self.weightButton.setTitle(" \(self.selectedWeight!) lbs", for: .normal)
                break
                
            default:
                break
            }
        }
        
        prompt.addAction(okayJaunt)
        
        present(prompt, animated: true, completion: nil)
    }
}
