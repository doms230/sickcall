//
//  QualificationsViewController.swift
//  Celecare
//
//  Created by Dom Smith on 8/6/17.
//  Copyright © 2017 Celecare LLC. All rights reserved.
//

import UIKit

class QualificationsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    //Name Values from NameViewController
    var firstName: String!
    var lastName: String!
    
    //Qualifications
    @IBOutlet weak var licenseNumberText: UITextField!
    @IBOutlet weak var licenseTypeButton: UIButton!
    @IBOutlet weak var stateButton: UIButton!
    
    //picker view values
    var whichPicker = "type"
    var statePrompt: UIAlertController!
    var licenseTypePrompt: UIAlertController!
    
    let states = ["","Alabama","Alaska","Arizona","Arkansas","California","Colorado","Connecticut","Delaware","Florida","Georgia","Hawaii","Idaho"," Illinois","Indiana","Iowa","Kansas","Kentucky", "Louisiana","Maine","Maryland","Massachusetts","Michigan","Minnesota","Mississippi","Missouri","Montana","Nebraska","Nevada","New Hampshire","New Jersey","New Mexico","New York","North Carolina","North Dakota","Ohio","Oklahoma","Oregon","Pennsylvania","Rhode Island","South Carolina","South Dakota","Tennessee","Texas","Utah","Vermont","Virginia","Washington","West Virginia","Wisconsin","Wyoming"]
    let types = ["", "RN", "PN", "APRN-CNP", "APRN-CRNA", "APRN-CNS", "APRN-CNM"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "2/3"
        
        let nextButton = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextAction(_:)))
        self.navigationItem.setRightBarButton(nextButton, animated: true)
        
        licenseTypeButton.layer.cornerRadius = 3
        licenseTypeButton.clipsToBounds = true
        
        stateButton.layer.cornerRadius = 3
        stateButton.clipsToBounds = true
        
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let desti = segue.destination as! IDViewController
        desti.firstName = firstName
        desti.lastName = lastName
        desti.licenseNumber = licenseNumberText.text!
        desti.licenseType = licenseTypeButton.titleLabel?.text!
        desti.state = stateButton.titleLabel?.text!
    }
 
    func nextAction(_ sender: UIBarButtonItem){
        if validateLicenseNumber() && validateLicenseTypeButton() && validateStateButton(){
            performSegue(withIdentifier: "showId", sender: self)
        }
    }
    
    @IBAction func licenseTypeAction(_ sender: UIButton) {
        whichPicker = "type"
        licenseTypePrompt = UIAlertController(title: "Choose License Type", message: "", preferredStyle: .actionSheet)
        
        let statePickerView: UIPickerView = UIPickerView()
        statePickerView.delegate = self
        statePickerView.dataSource = self
        licenseTypePrompt.view.addSubview(statePickerView)
        
        let datePicker = UIAlertAction(title: "", style: UIAlertActionStyle.default) {
            UIAlertAction in
        }
        
        datePicker.isEnabled = false
        
        licenseTypePrompt.addAction(datePicker)
        //prompt.addAction(okay)
        
        let height:NSLayoutConstraint = NSLayoutConstraint(item: licenseTypePrompt.view, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.view.frame.height * 0.6)
        
        licenseTypePrompt.view.addConstraint(height);
        
        let okayJaunt = UIAlertAction(title: "Okay", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            //self.chooseDateAction(type: self.dateType)
        }
        
        licenseTypePrompt.addAction(okayJaunt)
        
        present(licenseTypePrompt, animated: true, completion: nil)
    }
    
    @IBAction func stateAction(_ sender: UIButton) {
        whichPicker = "state"
        
        statePrompt = UIAlertController(title: "Choose State", message: "", preferredStyle: .actionSheet)
        
        let statePickerView: UIPickerView = UIPickerView()
        statePickerView.delegate = self
        statePickerView.dataSource = self
        statePrompt.view.addSubview(statePickerView)
        
        let space = UIAlertAction(title: "", style: UIAlertActionStyle.default) {
            UIAlertAction in
        }
        
        space.isEnabled = false
        
        statePrompt.addAction(space)
        //prompt.addAction(okay)
        
        let height:NSLayoutConstraint = NSLayoutConstraint(item: statePrompt.view, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.view.frame.height * 0.6)
        
        statePrompt.view.addConstraint(height);
        
        let okayJaunt = UIAlertAction(title: "Okay", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            //self.chooseDateAction(type: self.dateType)
        }
        
        statePrompt.addAction(okayJaunt)
        
        present(statePrompt, animated: true, completion: nil)
    }
    
    //picker view stuff
    
    // data method to return the number of column shown in the picker.
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // data method to return the number of row shown in the picker.
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if whichPicker == "type"{
            return types.count
            
        }else {
            return states.count
        }
    }
    
    // delegate method to return the value shown in the picker
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if whichPicker == "type"{
            return types[row]
            
        }else {
            return states[row]
            
        }
    }
    
    // delegate method called when the row was selected.
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if whichPicker == "type"{
            licenseTypeButton.setTitle(" \(types[row])", for: .normal)
            licenseTypeButton.setTitleColor(.black, for: .normal)
            //licenseTypePrompt.dismiss(animated: true, completion: nil)
            
        }else {
            stateButton.setTitle(" \(states[row])", for: .normal)
            stateButton.setTitleColor(.black, for: .normal)
            //statePrompt.dismiss(animated: true, completion: nil)
        }
    }
    
    //validation tests 
    func validateLicenseNumber() ->Bool{
        var isValidated = false
        //let usernameJaunt = username.text?.characters.split{$0 == " "}.map(String.init)
        
        if licenseNumberText.text!.isEmpty{
            
            licenseNumberText.attributedPlaceholder = NSAttributedString(string:" Field required",
                                                                    attributes:[NSForegroundColorAttributeName: UIColor.red])
            
        } else{
            isValidated = true
        }
        return isValidated
    }
    
    func validateLicenseTypeButton() ->Bool{
        var isValidated = false
        //let usernameJaunt = username.text?.characters.split{$0 == " "}.map(String.init)
        
        if licenseTypeButton.titleLabel?.text == " "{
            licenseTypeButton.setTitle(" Field Required", for: .normal)
            licenseTypeButton.setTitleColor(.red, for: .normal)
            
        } else{
            isValidated = true
        }
        return isValidated
    }
    
    func validateStateButton() ->Bool{
        var isValidated = false
        //let usernameJaunt = username.text?.characters.split{$0 == " "}.map(String.init)
        
        if stateButton.titleLabel?.text == " "{
            stateButton.setTitle(" Field Required", for: .normal)
            stateButton.setTitleColor(.red, for: .normal)
            
        } else{
            isValidated = true
        }
        return isValidated
    }
    
    //mich.
    func uicolorFromHex(_ rgbValue:UInt32)->UIColor{
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }
}
