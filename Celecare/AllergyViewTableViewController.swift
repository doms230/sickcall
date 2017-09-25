//
//  AllergyViewTableViewController.swift
//  Celecare
//
//  Created by Dominic Smith on 9/24/17.
//  Copyright © 2017 Celecare LLC. All rights reserved.
//

import UIKit

class AllergyViewTableViewController: UITableViewController {
    
    @IBOutlet weak var sulfaSwitch: UISwitch!
    @IBOutlet weak var penSwitch: UISwitch!
    @IBOutlet weak var medOtherSwitch: UISwitch!
    
    @IBOutlet weak var shelfishSwitch: UISwitch!
    @IBOutlet weak var wheatSwitch: UISwitch!
    @IBOutlet weak var soySwitch: UISwitch!
    @IBOutlet weak var nutSwitch: UISwitch!
    @IBOutlet weak var dairySwitch: UISwitch!
    @IBOutlet weak var eggSwitch: UISwitch!
    @IBOutlet weak var foodOtherSwitch: UISwitch!
    
    
    var gender: String!
    var height: String!
    var weight: String!
    var birthday: String!
    
    var medAllergies = [String]()
    var foodAllergies = [String]()
    
    var medHistory: String!
    var ongoingMedIssues: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Info 2/3"
        
        let nextButton = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextAction(_:)))
        self.navigationItem.setRightBarButton(nextButton, animated: true)
        
        for allergy in medAllergies{
            switch allergy{
            case "sulfa":
                sulfaSwitch.setOn(true, animated: true)
                break
                
            case "penicillin":
                penSwitch.setOn(true, animated: true)
                break
                
            case "other":
                medOtherSwitch.setOn(true, animated: true)
                break
                
            default:
                break
            }
        }
        
        for object in foodAllergies{
            switch object{
            case "shellfish":
                shelfishSwitch.setOn(true, animated: true)
                break
                
            case "wheat":
                wheatSwitch.setOn(true, animated: true)
                break
                
            case "soy":
                soySwitch.setOn(true, animated: true)
                break
                
            case "dairy":
                dairySwitch.setOn(true, animated: true)
                break
                
            case "nut":
                nutSwitch.setOn(true, animated: true)
                break
                
            case "egg":
                eggSwitch.setOn(true, animated: true)
                break
                
            case "other":
                foodOtherSwitch.setOn(true, animated: true)
                break
                
            default:
                break
            }
        }
        
    }
    

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let desti = segue.destination as! MedHistoryViewController
        desti.gender = gender
        desti.height = height
        desti.weight = weight
        desti.birthday = birthday
        
        if medAllergies.count == 0{
            desti.medAllergies = []
            
        } else {
            desti.medAllergies = medAllergies
        }
        
        if foodAllergies.count == 0{
            desti.foodAllergies = []
            
        } else {
            desti.foodAllergies = foodAllergies
            
        }
        
        desti.medHistory = self.medHistory
        desti.ongoingMedIssues = self.ongoingMedIssues
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
    
    @objc func nextAction(_ sender: UIBarButtonItem){
        // Do any additional setup after loading the view.
        performSegue(withIdentifier: "showHistory", sender: self)
        
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



}
