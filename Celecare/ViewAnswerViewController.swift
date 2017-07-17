//
//  ViewAnswerViewController.swift
//  Celecare
//
//  Created by Mac Owner on 7/17/17.
//  Copyright © 2017 Celecare LLC. All rights reserved.
//

import UIKit
import Parse
import MobileCoreServices
import AVKit
import AVFoundation

class ViewAnswerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var tableJaunt: UITableView!
    
    //advisor 
    var advisorUserImage: String!
    var advisorUsername: String!
    var advisorUserId: String!
    
    //question info
    var healthConcern: String!
    var healthDuration: String!
    var objectId: String!
    var videoScreenShot: String!
    var videoFile: PFFile!
    
    
    //answer info
    var recommendation: String!
    var answerVideoFile: PFFile!
    var answerVideoScreenShot: String!
    
    //video
    var player: AVPlayer!
    var playerController: AVPlayerViewController!
    
    //mich 
    let screenSize: CGRect = UIScreen.main.bounds
    var messageFrame: UIView!
    var selectedIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableJaunt.register(MainTableViewCell.self, forCellReuseIdentifier: "advisorReuse")
        self.tableJaunt.register(MainTableViewCell.self, forCellReuseIdentifier: "segmentReuse")
        self.tableJaunt.register(MainTableViewCell.self, forCellReuseIdentifier: "questionReuse")
        self.tableJaunt.register(MainTableViewCell.self, forCellReuseIdentifier: "answerReuse")
        self.tableJaunt.register(MainTableViewCell.self, forCellReuseIdentifier: "loadingReuse")
        
        self.tableJaunt.estimatedRowHeight = 50
        self.tableJaunt.rowHeight = UITableViewAutomaticDimension
        
        loadData()

        // Do any additional setup after loading the view.
    }
        
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if healthConcern != nil{
            return 3

        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // let cell = tableView.dequeueReusableCell(withIdentifier: "statusReuse", for: indexPath) as! AdvisorTableViewCell
        //cell.statusLabel.text = "You're offline"
        
        var cell: MainTableViewCell!
        if healthConcern != nil{
            
            if indexPath.row == 0{
                cell = tableView.dequeueReusableCell(withIdentifier: "advisorReuse", for: indexPath) as! MainTableViewCell
                cell.selectionStyle = .none
                tableView.separatorStyle = .none
                cell.backgroundColor = uicolorFromHex(0xe8e6df)
                cell.advisorImage.kf.setImage(with: URL(string: self.advisorUserImage))
                cell.advisorName.text = self.advisorUsername
                
            } else if indexPath.row == 1{
                cell = tableView.dequeueReusableCell(withIdentifier: "segmentReuse", for: indexPath) as! MainTableViewCell
                cell.selectionStyle = .none
                tableView.separatorStyle = .none
                cell.segment.tintColor = uicolorFromHex(0x180d22)
                cell.segment.addTarget(self, action: #selector(ViewAnswerViewController.segmentAction(_:)), for: .valueChanged)
                //add segment actions here
                
            } else  {
                if selectedIndex == 0{
                    cell = tableView.dequeueReusableCell(withIdentifier: "questionReuse", for: indexPath) as! MainTableViewCell
                    cell.selectionStyle = .none
                    tableView.separatorStyle = .none
                   // cell.videoButton.image =
                    cell.healthConcern.text = self.healthConcern
                    cell.healthDuration.text = self.healthDuration
                    cell.videoButton.kf.setImage(with: URL(string: self.videoScreenShot))
                    //cell.videoButton.addTarget(self, action: #selector(AdvisorQuestionsViewController.showQuestion(_:)), for: .touchUpInside)
                } else {
                    cell = tableView.dequeueReusableCell(withIdentifier: "answerReuse", for: indexPath) as! MainTableViewCell
                    cell.selectionStyle = .none
                    tableView.separatorStyle = .none
                    //cell.answerVideoButton.setImage(UIImage(named:"appy"))
                    cell.recommendation.text = self.recommendation
                    cell.answerVideoButton.kf.setImage(with: URL(string: self.answerVideoScreenShot))
                    //cell.videoButton.addTarget(self, action: #selector(AdvisorQuestionsViewController.showQuestion(_:)), for: .touchUpInside)
                }
            }
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "loadingReuse", for: indexPath) as! MainTableViewCell
           // cell.statusLabel.text = "You're in queue"
        }
        
        //cell.questionLabel.text = questions[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //segue to question jautn
        if indexPath.row == 2{
            if selectedIndex == 0{
                playVideo(videoJaunt: videoFile)

            } else {
                playVideo(videoJaunt: answerVideoFile)
            }
        }
        //selectedIndex = indexPath.row
        //self.performSegue(withIdentifier: "showVitals", sender: self)
    }
    
    func segmentAction(_ sender: UISegmentedControl){
        selectedIndex = sender.selectedSegmentIndex
        tableJaunt.reloadData()
    }
    
    func loadData(){
        /*  var healthConcern: String!
         var HealthDuration: String!
         var objectId: String!
         var patientUserId: String!
         var videoScreenShot: PFFile!
         var patientUserImage: PFFile!
         var patientUsername: String!*/
        
        let query = PFQuery(className: "Post")
        query.whereKey("objectId", equalTo: objectId)
        query.getFirstObjectInBackground {
            (object: PFObject?, error: Error?) -> Void in
            if error == nil || object != nil {
                self.healthConcern = object?["summary"] as! String
                self.healthDuration = object?["duration"] as! String
                //self.objectId = object?.objectId
                let imageFile: PFFile = object!["videoScreenShot"] as! PFFile
                self.videoScreenShot = imageFile.url
                self.videoFile = object!["video"] as! PFFile
                
                self.advisorUserId = object!["advisorUserId"] as! String
                
                let answerImageFile: PFFile = object!["answerScreenShot"] as! PFFile
                self.answerVideoScreenShot = answerImageFile.url
                self.answerVideoFile = object!["answer"] as! PFFile
                self.recommendation = object!["recommendation"] as! String
                
                //TODO: if unanswered, skip this and reload tableview
                self.loadAdvisor()
            }
        }
    }
    
    func loadAdvisor(){
        let query = PFQuery(className: "_User")
        query.whereKey("objectId", equalTo: self.advisorUserId)
        query.getFirstObjectInBackground {
            (object: PFObject?, error: Error?) -> Void in
            if error == nil || object != nil {
                
                let imageFile: PFFile = object!["Profile"] as! PFFile
                self.advisorUserImage = imageFile.url
                
                self.advisorUsername = object!["DisplayName"] as! String
                self.tableJaunt.reloadData()
            }
        }
    }
    
    //video
    
    func playVideo(videoJaunt: PFFile){
        
        progressBarDisplayer("")
        
        let exitButton = UIButton(frame: CGRect(x: 10,y: 20,width: 25, height: 25))
        //exitButton.setTitle("X", for: .normal)
        //exitButton.setTitleColor(UIColor.black, for: .normal)
        exitButton.setImage(UIImage(named: "exit"), for: .normal)
        // exitButton.backgroundColor = UIColor.white
        exitButton.layer.cornerRadius = 25/2
        exitButton.clipsToBounds = true
        exitButton.addTarget(self, action: #selector(ViewAnswerViewController.exitPost(_:)), for: .touchUpInside)
        
        playerController = AVPlayerViewController()
        
        //add bring video player/UIComponents to to front
        // self.addChildViewController(playerController)
        // self.view.addSubview(playerController.view)
        // self.playerController.view.layer.zPosition = 1
        
        //self.view.bringSubview(toFront: self.postTime)
        //self.view.addSubview(self.postTime)
        
        //load date
        /* let formattedEnd = DateFormatter.localizedString(from: timeJaunt, dateStyle: .medium, timeStyle: .short)
         self.postTime.setTitle(" \(formattedEnd) \(self.selectedicon!) \(self.selectedicon!)", for: UIControlState())
         self.postTime.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 16)!
         self.view.bringSubview(toFront: self.exitButton)
         self.view.addSubview(self.exitButton)*/
        //  self.view.bringSubview(toFront: exitButton)
        //self.view.addSubview(exitButton)
        
        playerController.view.addSubview(exitButton)
        
        playerController.view.frame = self.view.bounds
        playerController.showsPlaybackControls = false
        
        //retrieve video file Mark - FIX THIS
        videoJaunt.getDataInBackground {
            (videoData: Data?, error: Error?) -> Void in
            if error == nil {
                if let videoData = videoData {
                    //self.selectedVideoData = videoData
                    //convert video file to playable format
                    let documentsPath : AnyObject = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask,true)[0] as AnyObject
                    let destinationPath:String = documentsPath.appending("/file.mov")
                    try? videoData.write ( to: URL(fileURLWithPath: destinationPath as String), options: [.atomic])
                    let playerItem = AVPlayerItem(asset: AVAsset(url: URL(fileURLWithPath: destinationPath as String)))
                    self.player = AVPlayer(playerItem: playerItem)
                    
                    // play video
                    self.playerController.player = self.player
                    //self.player.play()
                    
                    self.present(self.playerController, animated: true) {
                        self.messageFrame.removeFromSuperview()
                        self.player.play()
                    }
                    
                    NotificationCenter.default.addObserver(self,
                                                           selector: #selector(ViewAnswerViewController.playerItemDidReachEnd(_:)),
                                                           name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                                           object: self.player.currentItem)
                }
            }
        }
    }
    
    func playerItemDidReachEnd( _ notification: Notification) {
        //player.seek(to: kCMTimeZero)
        //player.play()
        
        //enable because advisor has watched the whole video
        
        // answerButton.isEnabled = true

    }
    
    func exitPost(_ sender: UIButton){
        if player != nil{
            player.pause()
        }
        
        self.playerController.dismiss(animated: true, completion: nil)
        //playerController.view.removeFromSuperview()
        sender.removeFromSuperview()
        // postTime.removeFromSuperview()
    }
    
    //mich
    func progressBarDisplayer(_ message: String) {
        
        messageFrame = UIView(frame: CGRect(x: view.frame.midX - 90, y: view.frame.midY - 25 , width: 50, height: 50))
        messageFrame.layer.cornerRadius = 15
        messageFrame.backgroundColor = UIColor(white: 0, alpha: 0.7)
        
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.white)
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityIndicator.startAnimating()
        
        messageFrame.addSubview(activityIndicator)
        view.addSubview(messageFrame)
    }

    func uicolorFromHex(_ rgbValue:UInt32)->UIColor{
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }
}
