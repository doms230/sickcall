//
//  BasicInfoViewController.swift
//  Celecare
//
//  Created by Mac Owner on 7/4/17.
//  Copyright © 2017 Celecare LLC. All rights reserved.
//

import UIKit

class BasicInfoViewController: UIViewController {
    
    
    @IBOutlet weak var questionSubjectTextfield: UITextField!
    
    var healthConcernDuration: String!
    
    @IBOutlet weak var todaySwitch: UISwitch!
    @IBOutlet weak var yesterdaySwitch: UISwitch!
    @IBOutlet weak var pastWeekSwitch: UISwitch!
    @IBOutlet weak var pastMonthSwitch: UISwitch!
    @IBOutlet weak var pastYearSwitch: UISwitch!
    @IBOutlet weak var moreThanYearSwitch: UISwitch!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    @IBAction func nextAction(_ sender: UIButton) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let desti = segue.destination as! QuestionViewController
        desti.healthConcernDuration = healthConcernDuration
        desti.healthConcernSummary = questionSubjectTextfield.text
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
        }
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
