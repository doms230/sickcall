//
//  MedViewController.swift
//  Celecare
//
//  Created by Mac Owner on 7/2/17.
//  Copyright © 2017 Celecare LLC. All rights reserved.
//

import UIKit
import Parse

class MedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var tableJaunt: UITableView!
    
    var medNames = [String]()
    var medDuration = [String]()
    
    var medRows = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        medNames.append("")
        medDuration.append("")
    }

    
    //mark - tableview
    
    /*func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Plans"
    }*/
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0{
            return medRows
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: MedTableViewCell!
        
        if indexPath.section == 0{
             cell = tableView.dequeueReusableCell(withIdentifier: "medication", for: indexPath) as! MedTableViewCell
            
            //medNames.append(cell.medTextField.text!)
           // medDuration.append((cell.medDurationButton.titleLabel?.text!)!)
            
            cell.medDurationButton.addTarget(self, action: #selector(MedViewController.chooseMedDuration(_:)), for: .touchUpInside)
            cell.tag = indexPath.row
            
            cell.medTextField.addTarget(self, action: #selector(MedViewController.textFieldDidEndEditing(_:)), for: .touchUpInside)
            cell.tag = indexPath.row
            
            
        } else {
             cell = tableView.dequeueReusableCell(withIdentifier: "addMed", for: indexPath) as! MedTableViewCell
            
            cell.addMedButton.addTarget(self, action: #selector(MedViewController.addMedRow(_:)), for: .touchUpInside)
            
        }
        
        
        /*if eventObjectId.count == 0{
            
            cell = tableView.dequeueReusableCell(withIdentifier: "nothingScheduledReuse", for: indexPath) as! MainTableViewCell
            self.tableJaunt.separatorStyle = .none
            
            if !refresh.isRefreshing{
                cell.noPlansLabel.isHidden = false
                cell.noPlansExplain.isHidden = false
            }
            
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as! MainTableViewCell
            
            self.tableJaunt.separatorStyle = .singleLine
            
            cell.selectionStyle = .none
            if eventImage[indexPath.row] != " "{
                cell.eventImage.kf.setImage(with: URL(string: eventImage[indexPath.row])! , placeholder: UIImage(named: "appy"), options: nil, progressBlock: nil, completionHandler: nil)
            } else {
                
                cell.eventDescription.snp.makeConstraints { (make) -> Void in
                    make.top.equalTo(cell.eventDate.snp.bottom).offset(20)
                    make.left.equalTo(cell).offset(10)
                    make.right.equalTo(cell).offset(-10)
                    make.bottom.equalTo(cell).offset(-20)
                }
            }
            
            cell.eventTitle.text = eventTitle[indexPath.row]
            cell.eventDate.text = eventStartDate[indexPath.row]
            cell.eventDescription.text = eventDescription[indexPath.row]
        }*/
        
        return cell
    }
    
    /* func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     //if person has access, show event page
     selectedIndex = indexPath.row
     performSegue(withIdentifier: "showEventPage", sender: self)
     }*/
    
    
    //actions
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        medNames[textField.tag] = textField.text!
    }

    
    //TODO: add something where user can't add new med if they haven't added on the previous
    func addMedRow(_ sender: UIButton){
        if medNames[medRows - 1] != ""{
            medRows += 1
            self.tableJaunt.reloadData()
            
        } else {
            let prompt = UIAlertController(title: "Blank Medication Field", message: "Use the blank medication field before adding another.", preferredStyle: .alert)
            
            prompt.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            
            present(prompt, animated: true, completion: nil)
        }

    }
    
    func chooseMedDuration(_ sender: UIButton){
        //show action pop up of med duration
        
        let chooseMed = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        chooseMed.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        
        let oneWeek = UIAlertAction(title: "1 Week", style: .default) { (action) in
            sender.setTitle("1 Week", for: .normal)
            self.medDuration[sender.tag] = "1 week"
        }
        
        let oneMonth = UIAlertAction(title: "1 month", style: .default) { (action) in
            sender.setTitle("1 Month", for: .normal)
            self.medDuration[sender.tag] = "1 month"
        }
        
        let threeMonth = UIAlertAction(title: "3 months", style: .default) { (action) in
            sender.setTitle("3 Months", for: .normal)
            self.medDuration[sender.tag] = "3 months"
        }
        
        let oneYear = UIAlertAction(title: "1 year", style: .default) { (action) in
            sender.setTitle("1 Year", for: .normal)
            self.medDuration[sender.tag] = "1 year"
        }
        
        chooseMed.addAction(oneWeek)
        chooseMed.addAction(oneMonth)
        chooseMed.addAction(threeMonth)
        chooseMed.addAction(oneYear)
        present(chooseMed, animated: true, completion: nil)
        
    }
    
    @IBAction func nextAction(_ sender: UIButton) {
        
        
        
        let query = PFQuery(className:"_User")
        query.getObjectInBackground(withId: (PFUser.current()?.objectId)!) {
            (object: PFObject?, error: Error?) -> Void in
            if error == nil && object != nil {
                
                object?["medications"] = self.medNames
                object?["medDurations"] = self.medDuration
                object?.saveInBackground()
                print("workded")
                
            } else {
                print(error!)
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
