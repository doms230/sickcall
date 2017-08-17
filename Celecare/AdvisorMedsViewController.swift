//
//  AdvisorMedsViewController.swift
//  Celecare
//
//  Created by Mac Owner on 7/11/17.
//  Copyright © 2017 Celecare LLC. All rights reserved.
//

import UIKit
import Parse

class AdvisorMedsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var vitalTitles = [String]()
    var vitalContent = [String]()
    
    var patientUserId: String! 
    
    @IBOutlet weak var tableJaunt: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableJaunt.register(AdvisorTableViewCell.self, forCellReuseIdentifier: "infoReuse")
        self.tableJaunt.estimatedRowHeight = 50
        self.tableJaunt.rowHeight = UITableViewAutomaticDimension

        loadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vitalTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "infoReuse", for: indexPath) as! AdvisorTableViewCell
        
        cell.selectionStyle = .none
        tableView.separatorStyle = .none
        cell.questionTitle.text = vitalTitles[indexPath.row]
        cell.questionContent.text = vitalContent[indexPath.row]
        
        return cell
    }
    
    //TODO: change userId to something proper
    func loadData(){
        let query = PFQuery(className: "_User")
        query.whereKey("objectId", equalTo: self.patientUserId)
        query.getFirstObjectInBackground {
            (object: PFObject?, error: Error?) -> Void in
            if error == nil || object != nil {
                
                self.vitalTitles.append("Gender")
                self.vitalContent.append(object?["gender"] as! String)
                
                self.vitalTitles.append("Birthday")
                self.vitalContent.append(object?["birthday"] as! String)
                
                self.vitalTitles.append("Height")
                self.vitalContent.append(object?["height"] as! String)
                
                self.vitalTitles.append("Weight")
                self.vitalContent.append(object?["weight"] as! String)
                
                
                self.vitalTitles.append("Heart Beats Per Minute")
                self.vitalContent.append(object?["beatsPM"] as! String)
                self.vitalTitles.append("Breates Per Minute")
                self.vitalContent.append(object?["respsPM"] as! String)
                
                self.vitalTitles.append("Medical History")
                self.vitalContent.append(object?["medHistory"] as! String)
                self.vitalTitles.append("Ongoing Health Issues")
                self.vitalContent.append(object?["healthIssues"] as! String)
                
                self.tableJaunt.reloadData()
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
