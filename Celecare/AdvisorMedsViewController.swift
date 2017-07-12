//
//  AdvisorMedsViewController.swift
//  Celecare
//
//  Created by Mac Owner on 7/11/17.
//  Copyright © 2017 Celecare LLC. All rights reserved.
//

import UIKit
import Parse
import MobileCoreServices
import AVKit
import AVFoundation

class AdvisorMedsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource   {

    var medLabel = [String]()
    var medDuration = [String]()
    var userId: String!
    
    var videoFile: PFFile! 
    
    var player: AVPlayer!
    var playerController: AVPlayerViewController!
    
    let screenSize: CGRect = UIScreen.main.bounds
    
    var selectedIndex = 0
    
    @IBOutlet weak var tableJaunt: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        loadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
            
        } else {
           return medLabel.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: AdvisorTableViewCell!
        
        if indexPath.section == 0{
            cell = tableView.dequeueReusableCell(withIdentifier: "questionReuse", for: indexPath) as! AdvisorTableViewCell
            
        } else{
            cell = tableView.dequeueReusableCell(withIdentifier: "medicationsReuse", for: indexPath) as! AdvisorTableViewCell
            
            cell.medDuration.text = medDuration[indexPath.row]
            cell.medLabel.text = medLabel[indexPath.row]
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //segue to question jautn
        if indexPath.section == 0{
            playVideo(videoJaunt: videoFile)
            selectedIndex = indexPath.row
        }        
    }

    func playVideo(videoJaunt: PFFile){
        
        let exitButton = UIButton(frame: CGRect(x: 10,y: 20,width: 25, height: 25))
        //exitButton.setTitle("X", for: .normal)
        //exitButton.setTitleColor(UIColor.black, for: .normal)
        exitButton.setImage(UIImage(named: "exit"), for: .normal)
        // exitButton.backgroundColor = UIColor.white
        exitButton.layer.cornerRadius = 25/2
        exitButton.clipsToBounds = true
        exitButton.addTarget(self, action: #selector(AdvisorMedsViewController.exitPost(_:)), for: .touchUpInside)
        
        
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
    
    func loadData(){
        let query = PFQuery(className: "_User")
        query.whereKey("objectId", equalTo: userId)
        query.getFirstObjectInBackground {
            (object: PFObject?, error: Error?) -> Void in
            if error != nil || object == nil {
                
                
            } else {
                self.medLabel = object?["medications"] as! Array<String>
                self.medDuration = object?["medDurations"] as! Array<String>
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
