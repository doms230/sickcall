//
//  AnswerViewController.swift
//  Celecare
//
//  Created by Mac Owner on 7/10/17.
//  Copyright © 2017 Celecare LLC. All rights reserved.
//

import UIKit
import Parse
import SidebarOverlay

class AnswerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var unAnsweredObjectId = [String]()
    var unAnsweredQuestionTitle = [String]()
    
    
    @IBOutlet weak var profileImage: UIButton!
    @IBOutlet weak var segmentJaunt: UISegmentedControl!
    
    let screenSize: CGRect = UIScreen.main.bounds
    
    @IBOutlet weak var tableJaunt: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "My Questions"
        
        let query = PFQuery(className: "_User")
        query.whereKey("objectId", equalTo: "D9W37sOaeR")
        query.getFirstObjectInBackground {
            (object: PFObject?, error: Error?) -> Void in
            if error != nil || object == nil {
                
                
            } else {
                let imageFile: PFFile = object!["Profile"] as! PFFile
                self.profileImage.kf.setImage(with: URL(string: imageFile.url!), for: .normal)
                self.profileImage.layer.cornerRadius = 30 / 2
                self.profileImage.clipsToBounds = true
                
            }
        }
        
        loadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let indexPath = tableJaunt.indexPathForSelectedRow{
            let desti = segue.destination as! ViewAnswerViewController
            desti.objectId = unAnsweredObjectId[indexPath.row]
        }
    }
    
    @IBAction func segmentAction(_ sender: UISegmentedControl) {
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.unAnsweredObjectId.count

       /* if segmentJaunt.selectedSegmentIndex == 0{
            return self.unAnsweredObjectId.count

        } else {
            //TODO: answered questions... add proper
            return 0
        }      */
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "questionsReuse", for: indexPath) as! MainTableViewCell
        cell.questionTitleLabel.text = unAnsweredQuestionTitle[indexPath.row]
        
       /* if segmentJaunt.selectedSegmentIndex == 0{
        } else {
            //answerjaunts
        }*/
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       /* if segmentJaunt.selectedSegmentIndex == 0{
            playVideo(videoJaunt: unAnsweredVideoFile[indexPath.row])
        } else {
            //answered jaunt
        }*/
        performSegue(withIdentifier: "showAnswer", sender: self)
    }
    
    @IBAction func profileImageAction(_ sender: UIButton) {
        
        if let container = self.so_containerViewController {
            container.isSideViewControllerPresented = true
        }
    }
    
    
    //data
    func loadData(){
        let query = PFQuery(className:"Post")
        query.whereKey("userId", equalTo: "D9W37sOaeR")
        query.whereKey("isRemoved", equalTo: false)
        //query.whereKey("isAnswered", equalTo: false)
        query.findObjectsInBackground {
            (objects: [PFObject]?, error: Error?) -> Void in
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) scores.")
                // Do something with the found objects
                if let objects = objects {
                    for object in objects {
                        self.unAnsweredObjectId.append(object.objectId!)
                        self.unAnsweredQuestionTitle.append(object["summary"] as! String)
                    }
                   // print(self.unAnsweredQuestionTitle[0])
                    self.tableJaunt.reloadData()
                }
            } else {
                // Log details of the failure
                print("Error: \(error!)")
            }
        }
    }
}
