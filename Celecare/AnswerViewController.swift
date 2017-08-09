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
import Kingfisher
import NVActivityIndicatorView

class AnswerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NVActivityIndicatorViewable {
    
    var questionImages = [String]()
    var questions = [String]()
    var questionDurations = [String]()
    var questionStatus = [String]()
    var dateUploaded = [String]()
    var objectId = [String]()
    
    @IBOutlet weak var profileImage: UIButton!
    
    let screenSize: CGRect = UIScreen.main.bounds
    
    @IBOutlet weak var tableJaunt: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "My Questions"
        
        self.tableJaunt.register(MainTableViewCell.self, forCellReuseIdentifier: "myQuestionsReuse")
        self.tableJaunt.register(MainTableViewCell.self, forCellReuseIdentifier: "noQuestionsReuse")
        self.tableJaunt.estimatedRowHeight = 50
        self.tableJaunt.rowHeight = UITableViewAutomaticDimension
        self.tableJaunt.backgroundColor = uicolorFromHex(0xe8e6df)
        
        NVActivityIndicatorView.DEFAULT_TYPE = .ballScaleMultiple
        NVActivityIndicatorView.DEFAULT_COLOR = uicolorFromHex(0xF4FF81)
        NVActivityIndicatorView.DEFAULT_BLOCKER_SIZE = CGSize(width: 60, height: 60)
        NVActivityIndicatorView.DEFAULT_BLOCKER_BACKGROUND_COLOR = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        
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
        
        if let indexPath = tableJaunt.indexPathForSelectedRow{
            let desti = segue.destination as! ViewAnswerViewController
            desti.objectId = objectId[indexPath.row]
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if objectId.count > 0{
            return self.objectId.count

        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: MainTableViewCell!
        
        if objectId.count > 0{
            cell = tableView.dequeueReusableCell(withIdentifier: "myQuestionsReuse", for: indexPath) as! MainTableViewCell
            
            cell.backgroundColor = uicolorFromHex(0xe8e6df)
            cell.selectionStyle = .none
            self.tableJaunt.separatorStyle = .singleLine
            
            cell.questionImage.kf.setImage(with: URL(string: questionImages[indexPath.row]), placeholder: UIImage(named: "appy"))
            cell.questionLabel.text = questions[indexPath.row]
            cell.questionLabel.textColor = uicolorFromHex(0x180d22)
            cell.durationLabel.text = questionDurations[indexPath.row]
            cell.durationLabel.textColor = uicolorFromHex(0x180d22)
            cell.statusLabel.text = questionStatus[indexPath.row]
            cell.statusLabel.textColor = uicolorFromHex(0x180d22)
            cell.dateUploadedLabel.text = dateUploaded[indexPath.row]
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "noQuestionsReuse", for: indexPath) as! MainTableViewCell
            cell.backgroundColor = uicolorFromHex(0xe8e6df)
            cell.selectionStyle = .none
            self.tableJaunt.separatorStyle = .none
            
        }
        
        //let
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showAnswer", sender: self)
    }
    
    @IBAction func profileImageAction(_ sender: UIButton) {
        if let container = self.so_containerViewController {
            container.isSideViewControllerPresented = true
        }
    }
    
    //data
    func loadData(){
        startAnimating()
        let query = PFQuery(className:"Post")
        query.whereKey("userId", equalTo: PFUser.current()!.objectId!)
        query.whereKey("isRemoved", equalTo: false)
        query.addDescendingOrder("createdAt")
        query.findObjectsInBackground {
            (objects: [PFObject]?, error: Error?) -> Void in
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) scores.")
                // Do something with the found objects
                if let objects = objects {
                    for object in objects {
                        self.objectId.append(object.objectId!)
                        let url = object["videoScreenShot"] as! PFFile
                        self.questionImages.append(url.url!)
                        self.questions.append(object["summary"] as! String)
                        
                        let isAnswered = object["isAnswered"] as! Bool
                        if isAnswered{
                            self.questionStatus.append("Answered")
                            
                        } else {
                            self.questionStatus.append("Pending Answer")
                        }
                        
                        self.questionDurations.append(object["duration"] as! String)
                        
                        let rawCreatedAt = object.createdAt
                        let createdAt = DateFormatter.localizedString(from: rawCreatedAt!, dateStyle: .short, timeStyle: .short)
                        
                        self.dateUploaded.append(createdAt)
                    }
                   // print(self.unAnsweredQuestionTitle[0])
                    
                    self.tableJaunt.reloadData()
                    self.stopAnimating()

                }
            } else {
                // Log details of the failure
                print("Error: \(error!)")
            }
        }
    }
    
    func uicolorFromHex(_ rgbValue:UInt32)->UIColor{
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }
}
