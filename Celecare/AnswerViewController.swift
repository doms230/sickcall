//
//  AnswerViewController.swift
//  Sickcall
//
//  Created by Dominic Smith on 7/10/17.
//  Copyright © 2017 Sickcall LLC All rights reserved.

import UIKit
import Parse
import Kingfisher
import NVActivityIndicatorView

class AnswerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NVActivityIndicatorViewable {
    
    @IBOutlet weak var tableView: UITableView!
    
    var color = Color()
    
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
    
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "My Questions"
        
        startAnimating()

        self.tableView.register(MainTableViewCell.self, forCellReuseIdentifier: "myQuestionsReuse")
        self.tableView.register(MainTableViewCell.self, forCellReuseIdentifier: "noQuestionsReuse")
        self.tableView.estimatedRowHeight = 50
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        NVActivityIndicatorView.DEFAULT_TYPE = .ballScaleMultiple
        NVActivityIndicatorView.DEFAULT_COLOR = color.sickcallGreen()
        NVActivityIndicatorView.DEFAULT_BLOCKER_SIZE = CGSize(width: 60, height: 60)
        NVActivityIndicatorView.DEFAULT_BLOCKER_BACKGROUND_COLOR = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl)
        
        loadData()
    }
    
    @objc func refresh(sender: UIRefreshControl) {
        questionImages.removeAll()
        questions.removeAll()
        questionDurations.removeAll()
        questionStatus.removeAll()
        dateUploaded.removeAll()
        objectId.removeAll()
        comments.removeAll()
        level.removeAll()
        isAnswered.removeAll()
        advisorUserId.removeAll()
        questionVideos.removeAll()
        
        loadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = tableView.indexPathForSelectedRow{
            let desti = segue.destination as! V2ViewAnswerViewController
            desti.objectId = objectId[indexPath.row]
            desti.comments = comments[indexPath.row]
            desti.level = level[indexPath.row]
            desti.isAnswered = isAnswered[indexPath.row]
            desti.advisorUserId = advisorUserId[indexPath.row]
            desti.videoFile = questionVideos[indexPath.row]
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
            self.tableView.separatorStyle = .none
            cell.questionLabel.text = questions[indexPath.row]
            cell.statusLabel.text = questionStatus[indexPath.row]
            
            if isAnswered[indexPath.row]{
                cell.questionView.backgroundColor = color.sickcallGreen()
                
            } else {
                cell.questionView.backgroundColor = color.sickcallBlack()
            }
            
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "noQuestionsReuse", for: indexPath) as! MainTableViewCell
            cell.selectionStyle = .none
            self.tableView.separatorStyle = .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showAnswer", sender: self)
    }
    
    //data
    func loadData(){
        let query = PFQuery(className:"Post")
        query.whereKey("userId", equalTo: PFUser.current()!.objectId!)
        query.whereKey("isRemoved", equalTo: false)
        query.addDescendingOrder("createdAt")
        query.findObjectsInBackground {
            (objects: [PFObject]?, error: Error?) -> Void in
            if error == nil {
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
                    
                    self.tableView.reloadData()
                    self.refreshControl.endRefreshing()
                    self.stopAnimating()
                }
            }
        }
    }
}
