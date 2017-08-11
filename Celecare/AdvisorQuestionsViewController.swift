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
import SnapKit
import NVActivityIndicatorView
import SCLAlertView

class AdvisorQuestionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NVActivityIndicatorViewable {

    @IBOutlet weak var profileImage: UIButton!
    
    @IBOutlet weak var tableJaunt: UITableView!
    
    //question
    var healthConcern: String!
    var healthDuration: String!
    var objectId: String!
    var patientUserId: String!
    var patientUserImage: String!
    var patientUsername: String!
    var videoFile: PFFile!
    
    var questionTitles = [String]()
    var questionContent = [String]()
    
    //video
    var player: AVPlayer!
    var playerController: AVPlayerViewController!
    var playButton: UIButton!
    
    var didPressPlay = false
    
    //view question UI
    var answerButton : UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
        //answerButton.isEnabled = false
        button.setTitle("Answer", for: .normal)
        button.setTitleColor(.black, for: .normal)
        // exitButton.setImage(UIImage(named: "exit"), for: .normal)
        button.backgroundColor = UIColor.white
        button.layer.cornerRadius = 3
        button.clipsToBounds = true
        
        return button
        
    }()
    
    var exitButton: UIButton = {
        let exitButton = UIButton()
        //exitButton.setTitle("X", for: .normal)
        //exitButton.setTitleColor(UIColor.black, for: .normal)
        exitButton.setImage(UIImage(named: "exit"), for: .normal)
        // exitButton.backgroundColor = UIColor.white
        exitButton.layer.cornerRadius = 25/2
        exitButton.clipsToBounds = true

        return exitButton
    }()
    
    //mich
    let screenSize: CGRect = UIScreen.main.bounds
    var messageFrame: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // self.title = "Questions"
        
       loadData()
        
        self.tableJaunt.register(AdvisorTableViewCell.self, forCellReuseIdentifier: "patientReuse")
        self.tableJaunt.register(AdvisorTableViewCell.self, forCellReuseIdentifier: "infoReuse")
        self.tableJaunt.register(AdvisorTableViewCell.self, forCellReuseIdentifier: "statusReuse")
        self.tableJaunt.estimatedRowHeight = 50
        self.tableJaunt.rowHeight = UITableViewAutomaticDimension
        
        NVActivityIndicatorView.DEFAULT_TYPE = .ballScaleMultiple
        NVActivityIndicatorView.DEFAULT_COLOR = uicolorFromHex(0xF4FF81)
        NVActivityIndicatorView.DEFAULT_BLOCKER_SIZE = CGSize(width: 60, height: 60)
        NVActivityIndicatorView.DEFAULT_BLOCKER_BACKGROUND_COLOR = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
    }
    
   /* override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //send user's phone number to Verify View Controller
        let desti = segue.destination as! AdvisorMedsViewController
        desti.userId = questionUserIds[selectedIndex]
        desti.videoFile = videoFile[selectedIndex]
        desti.objectId = questionObjectIds[selectedIndex]
        
    }*/
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if objectId != nil{
            return questionTitles.count + 1

        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: AdvisorTableViewCell!
        if objectId != nil{
            
            if indexPath.row == 0{
                cell = tableView.dequeueReusableCell(withIdentifier: "patientReuse", for: indexPath) as! AdvisorTableViewCell
                cell.selectionStyle = .none
                tableView.separatorStyle = .none
               // cell.backgroundColor = uicolorFromHex(0xe8e6df)
                cell.patientImage.kf.setImage(with: URL(string: self.patientUserImage))
                cell.patientName.text = self.patientUsername
                
            } else {
                cell = tableView.dequeueReusableCell(withIdentifier: "infoReuse", for: indexPath) as! AdvisorTableViewCell
                cell.selectionStyle = .none
                tableView.separatorStyle = .none
                cell.questionTitle.text = questionTitles[indexPath.row - 1]
                cell.questionContent.text = questionContent[indexPath.row - 1]
            }
            
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "statusReuse", for: indexPath) as! AdvisorTableViewCell
            cell.statusLabel.text = "Loading"
        }
        
        return cell
    }
    
    func loadData(){
        
        let query = PFQuery(className: "Post")
        query.whereKey("advisorUserId", equalTo: PFUser.current()!.objectId!)
        query.whereKey("isAnswered", equalTo: false)
        query.whereKey("isRemoved", equalTo: false)
        query.getFirstObjectInBackground {
            (object: PFObject?, error: Error?) -> Void in
            if error == nil || object != nil {
               // self.healthConcern = object?["summary"] as! String
                //self.healthDuration = object?["duration"] as! String
                self.questionTitles.append("Health Concern")
                self.questionContent.append(object?["summary"] as! String)
                self.questionTitles.append("Duration")
                self.questionContent.append(object?["duration"] as! String)
                /*self.questionTitles.append("Heart BPM")
                self.questionContent.append(object?["beatsPM"] as! String)
                self.questionTitles.append("Breates PM")
                self.questionContent.append(object?["respsPM"] as! String)*/
                
                self.objectId = object?.objectId
                let videoFile = object!["video"] as! PFFile
                self.getVideo(videoJaunt: videoFile)
                self.patientUserId = object!["userId"] as! String
                
                self.loadUser()
            }
        }
    }
    
    func loadUser(){
        let query = PFQuery(className: "_User")
        query.whereKey("objectId", equalTo: self.patientUserId)
        query.getFirstObjectInBackground {
            (object: PFObject?, error: Error?) -> Void in
            if error == nil || object != nil {
                
                let imageFile: PFFile = object!["Profile"] as! PFFile
                self.patientUserImage = imageFile.url
                
                self.patientUsername = object!["DisplayName"] as! String
                
                self.questionTitles.append("Heart Beats Per Minute")
                self.questionContent.append(object?["beatsPM"] as! String)
                self.questionTitles.append("Breates Per Minute")
                self.questionContent.append(object?["respsPM"] as! String)
                
                self.questionTitles.append("Medical History")
                self.questionContent.append(object?["medHistory"] as! String)
                self.questionTitles.append("Ongoing Health Issues")
                self.questionContent.append(object?["healthIssues"] as! String)
                
                self.tableJaunt.reloadData()
            }
        }
    }
    
    //video
    
    @IBAction func playVideoAction(_ sender: UIButton) {
        startAnimating()
        
        if player != nil{
            stopAnimating()
            self.present(self.playerController, animated: true) {
               // self.messageFrame.removeFromSuperview()
                self.player.play()
            }
        } else {
            didPressPlay = true
        }
    }
    
    func setVideoUI(){
        playerController.view.addSubview(answerButton)
        answerButton.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(50)
            make.left.equalTo(playerController.view).offset(10)
            make.right.equalTo(playerController.view).offset(-10)
            make.bottom.equalTo(playerController.view).offset(-5)
        }
        //answerButton.addTarget(self, action: #selector(AdvisorQuestionsViewController.answerAction(_:)), for: .touchUpInside)
    }
    
    func getVideo(videoJaunt: PFFile){
        
        playerController = AVPlayerViewController()
        
        playerController.view.frame = self.view.bounds
        playerController.showsPlaybackControls = false
        
        playerController.view.addSubview(exitButton)
        exitButton.snp.makeConstraints { (make) -> Void in
            make.height.width.equalTo(50)
            make.top.equalTo(playerController.view).offset(15)
            make.left.equalTo(playerController.view).offset(10)
        }
        exitButton.addTarget(self, action: #selector(AdvisorQuestionsViewController.exitPost(_:)), for: .touchUpInside)
        
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
                    if self.didPressPlay{
                        self.stopAnimating()
                        self.present(self.playerController, animated: true) {
                            self.messageFrame.removeFromSuperview()
                            self.player.play()
                        }
                    }
                    //self.player.play()
                    
                    NotificationCenter.default.addObserver(self,
                                                           selector: #selector(AdvisorQuestionsViewController.playerItemDidReachEnd(_:)),
                                                           name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                                           object: self.player.currentItem)
                }
            }
        }
    }
    
    func playerItemDidReachEnd( _ notification: Notification) {
        player.seek(to: kCMTimeZero)
        player.play()
        
        setVideoUI()
    }
    
    func exitPost(_ sender: UIButton){
        if player != nil{
            player.pause()
        }
        
        self.playerController.dismiss(animated: true, completion: nil)
        //playerController.view.removeFromSuperview()
        //sender.removeFromSuperview()
        // postTime.removeFromSuperview()
    }
    
    //mich
    func uicolorFromHex(_ rgbValue:UInt32)->UIColor{
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }
}
