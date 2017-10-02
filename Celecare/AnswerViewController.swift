//
//  AnswerViewController.swift
//  Sickcall
//
//  Created by Mac Owner on 7/10/17.
//  Copyright © 2017 Socialgroupe Incorporated All rights reserved.
//

import UIKit
import Parse
import Kingfisher
import NVActivityIndicatorView

class AnswerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NVActivityIndicatorViewable {
    
    var questionImages = [String]()
    var questions = [String]()
    var questionDurations = [String]()
    var questionStatus = [String]()
    var dateUploaded = [String]()
    var objectId = [String]()
    var comments = [String]()
    var level = [String]()
    var isAnswered = [Bool]()
    var advisorUserId = [String]()
    var questionVideos = [PFFile]()
    
    let screenSize: CGRect = UIScreen.main.bounds
    
    @IBOutlet weak var tableJaunt: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "My Questions"
        
        self.tableJaunt.register(MainTableViewCell.self, forCellReuseIdentifier: "myQuestionsReuse")
        self.tableJaunt.register(MainTableViewCell.self, forCellReuseIdentifier: "noQuestionsReuse")
        self.tableJaunt.estimatedRowHeight = 50
        self.tableJaunt.rowHeight = UITableViewAutomaticDimension
        
        NVActivityIndicatorView.DEFAULT_TYPE = .ballScaleMultiple
        NVActivityIndicatorView.DEFAULT_COLOR = uicolorFromHex(0x159373)
        NVActivityIndicatorView.DEFAULT_BLOCKER_SIZE = CGSize(width: 60, height: 60)
        NVActivityIndicatorView.DEFAULT_BLOCKER_BACKGROUND_COLOR = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        
        loadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = tableJaunt.indexPathForSelectedRow{
            let desti = segue.destination as! V2ViewAnswerViewController
            desti.objectId = objectId[indexPath.row]
            desti.comments = comments[indexPath.row]
            desti.level = level[indexPath.row]
            desti.isAnswered = isAnswered[indexPath.row]
            desti.advisorUserId = advisorUserId[indexPath.row]
            desti.videoJaunt = questionVideos[indexPath.row]
            desti.summary = questions[indexPath.row]
            desti.duration = questionDurations[indexPath.row]
            desti.videoPreview = questionImages[indexPath.row]
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
            
            cell.selectionStyle = .none
            self.tableJaunt.separatorStyle = .none
            
            //cell.questionImage.kf.setImage(with: URL(string: questionImages[indexPath.row]), placeholder: UIImage(named: "appy"))
            //cell.questionImage.kf.setImage(with: URL(string: questionImages[indexPath.row]), for: .)
            cell.questionLabel.text = questions[indexPath.row]
            cell.statusLabel.text = questionStatus[indexPath.row]
            
            if isAnswered[indexPath.row]{
                if level[indexPath.row] == "low"{
                    cell.questionView.backgroundColor = uicolorFromHex(0x159373)
                    
                } else if level[indexPath.row] == "medium"{
                    cell.questionView.backgroundColor = uicolorFromHex(0x936b15)
                } else {
                    cell.questionView.backgroundColor = uicolorFromHex(0x932c15)
                }
                
            } else {
                cell.questionView.backgroundColor = uicolorFromHex(0x180d22)
            }
            
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "noQuestionsReuse", for: indexPath) as! MainTableViewCell
            cell.selectionStyle = .none
            self.tableJaunt.separatorStyle = .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showAnswer", sender: self)
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
                        self.isAnswered.append(isAnswered)
                        if isAnswered{
                            self.questionStatus.append("Answered")
                            self.advisorUserId.append(object["advisorUserId"] as! String)
                        } else {
                            self.questionStatus.append("Pending Answer")
                            self.advisorUserId.append("nil")
                        }
                        
                        self.questionDurations.append(object["duration"] as! String)
                        
                        let rawCreatedAt = object.createdAt
                        let createdAt = DateFormatter.localizedString(from: rawCreatedAt!, dateStyle: .short, timeStyle: .short)
                        
                        self.dateUploaded.append(createdAt)
                        
                        //
                        self.level.append(object["level"] as! String)
                        self.comments.append(object["comment"] as! String)
                        self.questionVideos.append(object["video"] as! PFFile)
                        
                    }
                    
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
