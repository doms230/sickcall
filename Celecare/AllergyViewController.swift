//
//  AllergyViewController.swift
//  Celecare
//
//  Created by Dom Smith on 8/8/17.
//  Copyright © 2017 Celecare LLC. All rights reserved.
//

import UIKit

class AllergyViewController: UIViewController {
    
    var gender: String!
    var height: String!
    var weight: String!
    var birthday: String!
    
    var medAllergies = [String]()
    var foodAllergies = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Info 2/3"

    }
    
    //med allergy actions
    @IBAction func sulfaAction(_ sender: UISwitch) {
        medAllergy(sender: sender, allergy: "sulfa")
    }
    
    @IBAction func penicillinAction(_ sender: UISwitch) {
        medAllergy(sender: sender, allergy: "penicillin")
    }

    @IBAction func medOtherAction(_ sender: UISwitch) {
        medAllergy(sender: sender, allergy: "other")
    }
    
    
    //food allergy actions
    
    @IBAction func shellfishAction(_ sender: UISwitch) {
        foodAllergy(sender: sender, allergy: "shellfish")
    }
    
    @IBAction func soyAction(_ sender: UISwitch) {
        foodAllergy(sender: sender, allergy: "soy")
    }
    
    @IBAction func dairyAction(_ sender: UISwitch) {
        foodAllergy(sender: sender, allergy: "dairy")
    }

    @IBAction func wheatAction(_ sender: UISwitch) {
        foodAllergy(sender: sender, allergy: "wheat")
    }

    @IBAction func nutAction(_ sender: UISwitch) {
        foodAllergy(sender: sender, allergy: "nut")
    }
    
    @IBAction func eggAction(_ sender: UISwitch) {
        foodAllergy(sender: sender, allergy: "egg")
    }
    
    @IBAction func foodOtherAction(_ sender: UISwitch) {
        foodAllergy(sender: sender, allergy: "other")
    }
    
    func medAllergy(sender: UISwitch, allergy: String){
        if sender.isOn{
            medAllergies.append(allergy)
            
        } else {
            var i = 0
            for object in medAllergies{
                if object == allergy{
                    medAllergies.remove(at: i)
                }
                i += 1
            }
        }
    }
    
    func foodAllergy(sender: UISwitch, allergy: String){
        if sender.isOn{
            foodAllergies.append(allergy)
            
        } else {
            var i = 0
            for object in foodAllergies{
                if object == allergy{
                    foodAllergies.remove(at: i)
                }
                i += 1
            }
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
