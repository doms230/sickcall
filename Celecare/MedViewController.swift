//
//  MedViewController.swift
//  Celecare
//
//  Created by Mac Owner on 7/2/17.
//  Copyright © 2017 Celecare LLC. All rights reserved.
//

import UIKit
import Parse

class MedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableJaunt: UITableView!
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var medTableView: UITextField!
    var medNames = [String]()
    var medDuration = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUserData()
    }
    
    //mark - tableview
    
    /*func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Plans"
    }*/
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
       return medNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =  tableView.dequeueReusableCell(withIdentifier: "medReuse", for: indexPath) as! MainTableViewCell
        
            cell.medLabel.text = medNames[indexPath.row]
            cell.medDuration.text = medDuration[indexPath.row]
        
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
    
    func chooseMedDuration(medName:String){
        //show action pop up of med duration
        
        let chooseMed = UIAlertController(title: "How Long?", message: "", preferredStyle: .actionSheet)
        
        let oneWeek = UIAlertAction(title: "1 Week", style: .default) { (action) in
            self.medNames.insert(medName, at: 0)
            self.medDuration.insert("1 week", at: 0)
            self.tableJaunt.reloadData()
            self.medTableView.text = " "
        }
        
        let oneMonth = UIAlertAction(title: "1 month", style: .default) { (action) in
            self.medNames.insert(medName, at: 0)
            self.medDuration.insert("1 month", at: 0)
            self.tableJaunt.reloadData()
            self.medTableView.text = " "
        }
        
        let threeMonth = UIAlertAction(title: "3 months", style: .default) { (action) in
            self.medNames.insert(medName, at: 0)
            self.medDuration.insert("3 months", at: 0)
            self.tableJaunt.reloadData()
            self.medTableView.text = " "
        }
        
        let oneYear = UIAlertAction(title: "1 year", style: .default) { (action) in
            self.medNames.insert(medName, at: 0)
            self.medDuration.insert("1 year", at: 0)
            self.tableJaunt.reloadData()
            self.medTableView.text = " "
        }
        chooseMed.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        chooseMed.addAction(oneWeek)
        chooseMed.addAction(oneMonth)
        chooseMed.addAction(threeMonth)
        chooseMed.addAction(oneYear)
        present(chooseMed, animated: true, completion: nil)
        
    }
    
    func loadUserData(){
        let query = PFQuery(className:"_User")
        query.getObjectInBackground(withId: (PFUser.current()?.objectId)!) {
            (object: PFObject?, error: Error?) -> Void in
            if error == nil && object != nil {
                
               self.medNames = object?["medications"] as! Array<String>
               self.medDuration = object?["medDurations"] as! Array<String>
                self.tableJaunt.reloadData()
               // object?.saveInBackground()
                
            } else {
                print(error!)
            }
        }
    }
    
    @IBAction func doneAction(_ sender: UIBarButtonItem) {
        let query = PFQuery(className:"_User")
        query.getObjectInBackground(withId: (PFUser.current()?.objectId)!) {
            (object: PFObject?, error: Error?) -> Void in
            if error == nil && object != nil {
                
                object?["medications"] = self.medNames
                object?["medDurations"] = self.medDuration
                object?.saveInBackground {
                    (success: Bool, error: Error?) -> Void in
                    if (success) {
                        //segue to main storyboard
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let controller = storyboard.instantiateViewController(withIdentifier: "container") as UIViewController
                        self.present(controller, animated: true, completion: nil)
                    }
                }
                
            } else {
                print(error!)
            }
        }
    }
    
    @IBAction func addMedAction(_ sender: UIButton) {
        chooseMedDuration(medName: medTableView.text!)
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
