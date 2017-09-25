//
//  BasicInfoTableViewController.swift
//  Celecare
//
//  Created by Dominic Smith on 9/24/17.
//  Copyright © 2017 Celecare LLC. All rights reserved.
//

import UIKit
import Parse
import Kingfisher
import SidebarOverlay

class BasicInfoTableViewController: UITableViewController {
    
    @IBOutlet weak var questionSubjectTextfield: UITextField!
    
    var healthConcernDuration = "Today"
    
    @IBOutlet weak var todaySwitch: UISwitch!
    @IBOutlet weak var yesterdaySwitch: UISwitch!
    @IBOutlet weak var pastWeekSwitch: UISwitch!
    @IBOutlet weak var pastMonthSwitch: UISwitch!
    @IBOutlet weak var pastYearSwitch: UISwitch!
    @IBOutlet weak var moreThanYearSwitch: UISwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nextButton = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextAction(_:)))
        self.navigationItem.setRightBarButton(nextButton, animated: true)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let desti = segue.destination as! QuestionViewController
        desti.healthConcernDuration = healthConcernDuration
        desti.healthConcernSummary = questionSubjectTextfield.text
    }
    
   /* override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }*/


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
            performSegue(withIdentifier: "showQuestion", sender: self)
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



}
