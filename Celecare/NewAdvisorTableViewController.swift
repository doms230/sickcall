//
//  NewAdvisorTableViewController.swift
//  Celecare
//
//  Created by Dominic Smith on 7/25/17.
//  Copyright © 2017 Celecare LLC. All rights reserved.
//

import UIKit
import Parse
import SidebarOverlay
import Kingfisher

class NewAdvisorTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource  {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var licenseNumberField: UITextField!
    @IBOutlet weak var stateButton: UIButton!
    @IBOutlet weak var licenseTypeButton: UIButton!
    
    @IBOutlet weak var profileImage: UIButton!
    
    //use to distinguish between license type picker and state picker
    var whichPicker = "type"
    
    let states = [ "AL","AK","AZ","AR","CA","CO","CT","DE","FL","GA","HI","ID"," IL","IN","IA","KS","KY", "LA","ME","MD","MA","MI","MN","MS","MO","MT","NE","NV","NH","NJ","NM","NY","NC","ND","OH","OK",    "OR","PA","RI","SC","SD","TN","TX","UT","VT","VA","WA","WV","WI","WY"]
    
    let types = ["RN", "PN", "APRN-CNP", "APRN-CRNA", "APRN-CNS", "APRN-CNM"]
    
    var statePrompt: UIAlertController!
    var licenseTypePrompt: UIAlertController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        let query = PFQuery(className: "_User")
        query.whereKey("objectId", equalTo: PFUser.current()!.objectId!)
        query.getFirstObjectInBackground {
            (object: PFObject?, error: Error?) -> Void in
            if error == nil || object != nil {
                let imageFile: PFFile = object!["Profile"] as! PFFile
                self.profileImage.kf.setImage(with: URL(string: imageFile.url!), for: .normal)
                self.profileImage.layer.cornerRadius = 30 / 2
                self.profileImage.clipsToBounds = true
                
            }
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let desti = segue.destination as! PersonalTableViewController
        desti.firstName = nameField.text
        desti.lastName = lastNameField.text
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }
    
    @IBAction func chooseStateAction(_ sender: UIButton) {
            whichPicker = "state"
        
            statePrompt = UIAlertController(title: "Choose State", message: "", preferredStyle: .actionSheet)

            
            let statePickerView: UIPickerView = UIPickerView()
            statePickerView.delegate = self
            statePickerView.dataSource = self
            statePrompt.view.addSubview(statePickerView)
            
            let datePicker = UIAlertAction(title: "", style: UIAlertActionStyle.default) {
                UIAlertAction in
            }
            
            datePicker.isEnabled = false
            
            statePrompt.addAction(datePicker)
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
            licenseTypeButton.setTitle(types[row], for: .normal)
            licenseTypeButton.setTitleColor(.black, for: .normal)
            licenseTypePrompt.dismiss(animated: true, completion: nil)
            
        }else {
            stateButton.setTitle(states[row], for: .normal)
            stateButton.setTitleColor(.black, for: .normal)
            statePrompt.dismiss(animated: true, completion: nil)
        }
    }
    
    //
    
    @IBAction func doneAction(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "showPersonal", sender: self)
      /*  let newAdvisor = PFObject(className: "Advisor")
        newAdvisor["userId"] = PFUser.current()?.objectId
        newAdvisor["first"] = nameField.text
        newAdvisor["last"] = lastNameField.text
        newAdvisor["licenseNumber"] = licenseNumberField.text
        newAdvisor["licenseType"] = licenseTypeButton.titleLabel?.text
        newAdvisor["state"] = stateButton.titleLabel?.text 
        newAdvisor["status"] = "un-verified"
        newAdvisor.saveEventually{
            (success: Bool, error: Error?) -> Void in
            if (success) {
                
                let storyboard = UIStoryboard(name: "Advisor", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "container") as UIViewController
                self.present(controller, animated: true, completion: nil)
                
            } else {
                // self.mapJaunt.removeAnnotation(pin)
                let newTwitterHandlePrompt = UIAlertController(title: "Post Failed", message: "Check internet connection and try again. Contact help@celecareapp.com if the issue persists.", preferredStyle: .alert)
                newTwitterHandlePrompt.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                
                self.present(newTwitterHandlePrompt, animated: true, completion: nil)
            }
        }*/
    }
    
    @IBAction func profileAction(_ sender: UIButton) {
        if let container = self.so_containerViewController {
            container.isSideViewControllerPresented = true
        }
    }
 
    
    /*

    */

}
