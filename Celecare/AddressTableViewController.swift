//
//  AddressTableViewController.swift
//  Celecare
//
//  Created by Dominic Smith on 7/26/17.
//  Copyright © 2017 Celecare LLC. All rights reserved.
//

import UIKit

class AddressTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var line1TextField: UITextField!
    @IBOutlet weak var line2TextField: UITextField!
    @IBOutlet weak var stateTextField: UIButton!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var postalCodeTextfield: UITextField!
    
    var firstName: String!
    var lastName: String!
    var ssn: String!
    var birthday: String!
    
    var day: String!
    var month: String!
    var year: String!
    
      let states = [ "Alabama","Alaska","Arizona","Arkansas","California","Colorado","Connecticut","Delaware","Florida","Georgia","Hawaii","Idaho"," Illinois","Indiana","Iowa","Kansas","Kentucky", "Louisiana","Maine","Maryland","Massachusetts","Michigan","Minnesota","Mississippi","Missouri","Montana","Nebraska","Nevada","New Hampshire","New Jersey","New Mexico","New York","North Carolina","North Dakota","Ohio","Oklahoma",    "Oregon","Pennsylvania","Rhode Island","South Carolina","South Dakota","Tennessee","Texas","Utah","Vermont","Virginia","Washington","West Virginia","Wisconsin","Wyoming"]
        
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Address"
        let nextButton = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextAction(_:)))
        self.navigationItem.setRightBarButton(nextButton, animated: true)
        
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        /*let desti = segue.destination as! PersonalTableViewController
        desti.line1 = line1TextField.text
        desti.line2 = line2TextField.text
        desti.state = stateTextField.titleLabel?.text 
        desti.city = cityTextField.text
        desti.postalCode = postalCodeTextfield.text*/
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
    
    func nextAction(_ sender: UIBarButtonItem){
        performSegue(withIdentifier: "showId", sender: self)
    }
    
    //
    @IBAction func stateAction(_ sender: UIButton) {
        let prompt = UIAlertController(title: "Choose License Type", message: "", preferredStyle: .actionSheet)
        
        let statePickerView: UIPickerView = UIPickerView()
        statePickerView.delegate = self
        statePickerView.dataSource = self
        prompt.view.addSubview(statePickerView)
        
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
            //self.chooseDateAction(type: self.dateType)
        }
        
        prompt.addAction(okayJaunt)
        
        present(prompt, animated: true, completion: nil)
    }
    
    // data method to return the number of column shown in the picker.
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // data method to return the number of row shown in the picker.
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
       return states.count
    }
    
    // delegate method to return the value shown in the picker
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return states[row]
    }
    
    // delegate method called when the row was selected.
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        stateTextField.setTitle(states[row], for: .normal)
        stateTextField.setTitleColor(.black, for: .normal)
        
    }
}
