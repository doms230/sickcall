//
//  ViewAnswerViewController.swift
//  Celecare
//
//  Created by Mac Owner on 7/17/17.
//  Copyright © 2017 Celecare LLC. All rights reserved.
//

import UIKit
import Parse
import NVActivityIndicatorView

import MobileCoreServices
import AVKit
import AVFoundation

class ViewAnswerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NVActivityIndicatorViewable {
    
    @IBOutlet weak var tableJaunt: UITableView!
    
    //advisor 
    var advisorUserImage: String!
    var advisorUsername: String!
    var advisorUserId: String!
    
    //answer info
    var level: String!
    var comments: String!
    var objectId: String!
    
    //question
    var videoJaunt: PFFile!
    var playerItem: AVPlayerItem!
    var player: AVPlayer!
    var playerController: AVPlayerViewController!
    
    /*** In case user presses play before video is loaded */
    var didPressPlay = false
    
    //mich 
    let screenSize: CGRect = UIScreen.main.bounds
    
    var isAnswered = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let playVideoButton = UIBarButtonItem(title: "Play", style: .plain, target: self, action: #selector(playVideo(_:)))
        self.navigationItem.setRightBarButton(playVideoButton, animated: true)
        
        self.tableJaunt.register(MainTableViewCell.self, forCellReuseIdentifier: "answerReuse")
        self.tableJaunt.register(MainTableViewCell.self, forCellReuseIdentifier: "pendingReuse")
        self.tableJaunt.estimatedRowHeight = 50
        self.tableJaunt.rowHeight = UITableViewAutomaticDimension
        tableJaunt.separatorStyle = .none
        //tableJaunt.backgroundColor = uicolorFromHex(0xe8e6df)
        
        NVActivityIndicatorView.DEFAULT_TYPE = .ballScaleMultiple
        NVActivityIndicatorView.DEFAULT_COLOR = uicolorFromHex(0xF4FF81)
        NVActivityIndicatorView.DEFAULT_BLOCKER_SIZE = CGSize(width: 60, height: 60)
        NVActivityIndicatorView.DEFAULT_BLOCKER_BACKGROUND_COLOR = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)

        if isAnswered{
            loadAdvisor()
        }
        
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
                    self.playerItem = AVPlayerItem(asset: AVAsset(url: URL(fileURLWithPath: destinationPath as String)))
                    self.player = AVPlayer(playerItem: self.playerItem)
                    self.playerController = AVPlayerViewController()
                    self.playerController.player = self.player
                    
                    if self.didPressPlay{
                        self.loadPlayJaunt()
                    }
                }
            }
        }
    }
        
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {        
        var cell: MainTableViewCell!
        if isAnswered{
            if advisorUsername != nil{
                cell = tableView.dequeueReusableCell(withIdentifier: "answerReuse", for: indexPath) as! MainTableViewCell
                cell.selectionStyle = .none
                //cell.backgroundColor = uicolorFromHex(0xe8e6df)
                cell.advisorImage.kf.setImage(with: URL(string: self.advisorUserImage))
                cell.advisorName.text = self.advisorUsername
                cell.advisorName.textColor = uicolorFromHex(0x180d22)
                
                cell.commentsTitle.textColor = uicolorFromHex(0x190d22)
                cell.comments.text = self.comments
                cell.comments.textColor = uicolorFromHex(0x190d22)
                cell.recommendationTitle.textColor = uicolorFromHex(0x190d22)
                cell.recommendation.text = self.level
                cell.recommendation.textColor = uicolorFromHex(0x190d22)
                
            } else {
                cell = tableView.dequeueReusableCell(withIdentifier: "pendingReuse", for: indexPath) as! MainTableViewCell
                cell.selectionStyle = .none
                //cell.backgroundColor = uicolorFromHex(0xe8e6df)
                cell.pendingLabel.isHidden = true
            }
            
        } else{
            cell = tableView.dequeueReusableCell(withIdentifier: "pendingReuse", for: indexPath) as! MainTableViewCell
            cell.selectionStyle = .none
            //cell.backgroundColor = uicolorFromHex(0xe8e6df)
            cell.pendingLabel.textColor = uicolorFromHex(0x180d22)
            cell.pendingLabel.isHidden = false
        }
        
        return cell
    }
    
    func playVideo(_ sender: UIBarButtonItem){
        self.startAnimating()
        if playerItem != nil{
            loadPlayJaunt()
            
        } else {
            didPressPlay = true
        }
    }
    
    func loadPlayJaunt(){
        player.seek(to: kCMTimeZero)
        stopAnimating()
        self.present(playerController, animated: true) {
            self.player.play()
        }
    }
    
    func loadAdvisor(){
        startAnimating()
        let query = PFQuery(className: "_User")
        query.whereKey("objectId", equalTo: self.advisorUserId)
        query.getFirstObjectInBackground {
            (object: PFObject?, error: Error?) -> Void in
            if error == nil || object != nil {
                
                let imageFile: PFFile = object!["Profile"] as! PFFile
                self.advisorUserImage = imageFile.url
                
                self.advisorUsername = object!["DisplayName"] as! String
                self.tableJaunt.reloadData()
                self.stopAnimating()
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
