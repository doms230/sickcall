//
//  AnswerViewController.swift
//  Celecare
//
//  Created by Mac Owner on 7/10/17.
//  Copyright © 2017 Celecare LLC. All rights reserved.
//

import UIKit
import Parse
import MobileCoreServices
import AVKit
import AVFoundation

class AnswerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var unAnsweredObjectId = [String]()
    var unAnsweredQuestionTitle = [String]()
    var unAnsweredVideoFile = [PFFile]()
    
    @IBOutlet weak var segmentJaunt: UISegmentedControl!
    
    var player: AVPlayer!
    var playerController: AVPlayerViewController!
    
    let screenSize: CGRect = UIScreen.main.bounds
    
    @IBOutlet weak var tableJaunt: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    
    @IBAction func segmentAction(_ sender: UISegmentedControl) {
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if segmentJaunt.selectedSegmentIndex == 0{
            return self.unAnsweredObjectId.count

        } else {
            //TODO: answered questions... add proper
            return 0
        }        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "questionsReuse", for: indexPath) as! MainTableViewCell
        
        if segmentJaunt.selectedSegmentIndex == 0{
            cell.questionTitleLabel.text = unAnsweredQuestionTitle[indexPath.row]
        } else {
            //answerjaunts
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if segmentJaunt.selectedSegmentIndex == 0{
            playVideo(videoJaunt: unAnsweredVideoFile[indexPath.row])
        } else {
            //answered jaunt
        }
        
    }
    
    //data
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
                        self.unAnsweredObjectId.append(object.objectId!)
                        self.unAnsweredVideoFile.append(object["video"] as! PFFile)
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
    
    //video

    func playVideo(videoJaunt: PFFile){
        
        let exitButton = UIButton(frame: CGRect(x: 10,y: 20,width: 25, height: 25))
        //exitButton.setTitle("X", for: .normal)
        //exitButton.setTitleColor(UIColor.black, for: .normal)
        exitButton.setImage(UIImage(named: "exit"), for: .normal)
       // exitButton.backgroundColor = UIColor.white
        exitButton.layer.cornerRadius = 25/2
        exitButton.clipsToBounds = true
        exitButton.addTarget(self, action: #selector(AnswerViewController.exitPost(_:)), for: .touchUpInside)
                
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
                        self.player.play()
                    }
                    
                    NotificationCenter.default.addObserver(self,
                                                           selector: #selector(AnswerViewController.playerItemDidReachEnd(_:)),
                                                           name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                                           object: self.player.currentItem)
                }
            }
        }
    }
    
    func playerItemDidReachEnd( _ notification: Notification) {
        player.seek(to: kCMTimeZero)
        player.play()
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
    

}
