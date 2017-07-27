//
//  PersonalTableViewController.swift
//  Celecare
//
//  Created by Dominic Smith on 7/26/17.
//  Copyright © 2017 Celecare LLC. All rights reserved.
//

import UIKit

class PersonalTableViewController: UITableViewController {
    
    
    @IBOutlet weak var ssnTextField: UITextField!
    @IBOutlet weak var birthdayTextField: UIButton!
    
    var prompt : UIAlertController!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "ID 1/3"

        let nextButton = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextAction(_:)))
        self.navigationItem.setRightBarButton(nextButton, animated: true)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
    }
    
    func nextAction(_ sender: UIBarButtonItem){
        performSegue(withIdentifier: "showAddress", sender: self)
    }
    
    @IBAction func birthdayAction(_ sender: UIButton) {
        prompt = UIAlertController(title: "What's your birdat?", message: "", preferredStyle: .actionSheet)
        
        //date jaunts
        let datePickerView  : UIDatePicker = UIDatePicker()
        // datePickerView.date = date!
        datePickerView.datePickerMode = UIDatePickerMode.date
        datePickerView.addTarget(self, action: #selector(PersonalTableViewController.datePickerAction(_:)), for: UIControlEvents.valueChanged)
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
        
        birthdayTextField.setTitle(formattedDate, for: .normal)
        birthdayTextField.setTitleColor(.black, for: .normal)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
