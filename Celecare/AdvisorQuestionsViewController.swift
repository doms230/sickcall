//
//  AdvisorQuestionsViewController.swift
//  Celecare
//
//  Created by Mac Owner on 7/11/17.
//  Copyright © 2017 Celecare LLC. All rights reserved.
//

import UIKit
import Parse
import SidebarOverlay
import MobileCoreServices
import AVKit
import AVFoundation

class AdvisorQuestionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var profileImage: UIButton!
    
    @IBOutlet weak var tableJaunt: UITableView!
    
    var questions = [String]()
    var videoFile = [PFFile]()
    var questionObjectIds = [String]()
    var questionUserIds = [String]()
    
    var player: AVPlayer!
    var playerController: AVPlayerViewController!
    
    let screenSize: CGRect = UIScreen.main.bounds
    
    var selectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let query = PFQuery(className: "_User")
        query.whereKey("objectId", equalTo: PFUser.current()!.objectId!)
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
        
        //send user's phone number to Verify View Controller
        let desti = segue.destination as! AdvisorMedsViewController
        desti.userId = questionUserIds[selectedIndex]
        desti.videoFile = videoFile[selectedIndex]
        
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "questionReuse", for: indexPath) as! AdvisorTableViewCell
        
        cell.questionLabel.text = questions[indexPath.row]

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //segue to question jautn
        selectedIndex = indexPath.row
        self.performSegue(withIdentifier: "showVitals", sender: self)
    }
    
    @IBAction func menuAction(_ sender: UIButton) {
        if let container = self.so_containerViewController {
            container.isSideViewControllerPresented = true
        }
    }
    
    func loadData(){
        let query = PFQuery(className:"Post")
        query.whereKey("userId", equalTo: PFUser.current()!.objectId!)
        query.whereKey("isRemoved", equalTo: false)
        query.whereKey("isAnswered", equalTo: false)
        query.findObjectsInBackground {
            (objects: [PFObject]?, error: Error?) -> Void in
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) scores.")
                // Do something with the found objects
                if let objects = objects {
                    for object in objects {
                        self.questions.append(object["summary"] as! String)
                        self.questionObjectIds.append(object.objectId!)
                        self.videoFile.append(object["video"] as! PFFile)
                        self.questionUserIds.append(object["userId"] as! String)
                    }
                    self.tableJaunt.reloadData()
                }
            } else {
                // Log details of the failure
                print("Error: \(error!)")
            }
        }
    }
    
    //video


}
