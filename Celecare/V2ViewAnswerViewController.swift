//
//  V2ViewAnswerViewController.swift
//  Sickcall
//
//  Created by Dominic Smith on 8/14/17.
//  Copyright © 2017 Sickcall LLC All rights reserved.
//

import UIKit
import Parse
import NVActivityIndicatorView
import MobileCoreServices
import AVKit
import AVFoundation
import SCLAlertView
import ParseLiveQuery

class V2ViewAnswerViewController: UIViewController,NVActivityIndicatorViewable, UITableViewDelegate, UITableViewDataSource {
    
    var tableView: UITableView!
    
    //advisor
    var advisorUserImage: String!
    var advisorUsername: String!
    var advisorUserId: String!
    
    //patient
    var patientUserImage: String!
    var patientUsername: String!
    
    //answer info
    var level: String!
    var comments: String!
    var objectId: String!
    
    //question
    var summary: String!
    var duration: String!
    var videoFile: PFFile!
    var videoPreview: String!
    
    var playerItem: AVPlayerItem!
    var player: AVPlayer!
    var playerController: AVPlayerViewController!
    
    var cancelQuestionView: SCLAlertView!
    
    var didPressPlay = false
    
    //mich
    let screenSize: CGRect = UIScreen.main.bounds
    
    var isAnswered = false
    
    var cancelQuestionButton: UIBarButtonItem!
    
    let liveQueryClient = ParseLiveQuery.Client()
    private var subscription: Subscription<Post>?
    var questionsQuery: PFQuery<Post>{
        return (Post.query()!
            .whereKey("userId", equalTo: PFUser.current()!.objectId!) as! PFQuery<Post> )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView = UITableView(frame: self.view.bounds)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView?.register(ViewAnswerTableViewCell.self, forCellReuseIdentifier: "patientReuse")
        self.tableView?.register(ViewAnswerTableViewCell.self, forCellReuseIdentifier: "advisorReuse")
        self.tableView?.register(ViewAnswerTableViewCell.self, forCellReuseIdentifier: "shareReuse")
        self.tableView?.estimatedRowHeight = 50
        self.tableView?.rowHeight = UITableViewAutomaticDimension
        self.tableView?.separatorStyle = .none
        self.view.addSubview(self.tableView)
        
        //set up indicator view
        NVActivityIndicatorView.DEFAULT_TYPE = .ballScaleMultiple
        NVActivityIndicatorView.DEFAULT_COLOR = uicolorFromHex(0x006a52)
        NVActivityIndicatorView.DEFAULT_BLOCKER_SIZE = CGSize(width: 60, height: 60)
        NVActivityIndicatorView.DEFAULT_BLOCKER_BACKGROUND_COLOR = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        
        //don't let person cancel question if answered because they can't get money back
        if !isAnswered {
            cancelQuestionButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(cancelQuestion(_:)))
            
            self.navigationItem.setRightBarButton(cancelQuestionButton, animated: true)
        }
        
        //loading indicatior
        startAnimating()
        
        loadPatient()
        setUpAlertView()
        getVideo()
        subscribeToUpdates()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.patientUsername == nil{
            return 0
            
        } else if isAnswered {
            return 3
            
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: ViewAnswerTableViewCell!
        
        if self.patientUsername != nil{
            tableView.separatorStyle = .singleLine
        }
        
        if indexPath.row == 0{
            cell = tableView.dequeueReusableCell(withIdentifier: "patientReuse", for: indexPath) as! ViewAnswerTableViewCell
            
            cell.selectionStyle = .none
            cell.patientImage.kf.setImage(with: URL(string: self.patientUserImage))
            cell.patientName.textColor = uicolorFromHex(0x180d22)
            cell.patientName.text = self.patientUsername
            
            cell.summaryBody.text = self.summary
            cell.summaryBody.textColor = uicolorFromHex(0x180d22)
            cell.durationBody.text = self.duration
            cell.durationBody.textColor = uicolorFromHex(0x180d22)

            cell.videoButton.kf.setImage(with: URL(string: self.videoPreview), for: .normal)
            cell.videoButton.addTarget(self, action: #selector(self.loadPlayJaunt(_:)), for: .touchUpInside)
            tableView.separatorStyle = .none
            
        } else if indexPath.row == 1 {
            cell = tableView.dequeueReusableCell(withIdentifier: "shareReuse", for: indexPath) as! ViewAnswerTableViewCell
            cell.shareButton.addTarget(self, action: #selector(shareAction(_:)), for: .touchUpInside)
            cell.shareButton.setBackgroundColor(uicolorFromHex(0x006a52), forState: .normal)
            tableView.separatorStyle = .singleLine
            
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "advisorReuse", for: indexPath) as! ViewAnswerTableViewCell
            cell.selectionStyle = .none
            if advisorUserImage != nil{
                cell.advisorImage.kf.setImage(with: URL(string: self.advisorUserImage))
                cell.advisorName.text = self.advisorUsername
            }
            
            cell.levelLabel.text = self.level
            
            var optionsBody = ""
            
            if self.level == "low"{
                optionsBody = "- Over the counter solution \n - Doctors Appointment"
                cell.levelLabel.backgroundColor = uicolorFromHex(0x81ff96)
                
            } else if self.level == "medium"{
                optionsBody = "- Doctor's appointment \n - Urgent Care"
                cell.levelLabel.backgroundColor = uicolorFromHex(0xf4ff81)
                
            } else if self.level == "high"{
                optionsBody = "- Emergency Room \n - Urgent Care \n - Same Day Doctor's Appointment"
                cell.levelLabel.backgroundColor = uicolorFromHex(0xff8781)
            }
            
            cell.optionsBody.text = optionsBody
            
            cell.commentBody.text = self.comments
        }
        
        return cell
    }
    
    @objc func loadPlayJaunt(_ sender: UIButton){
        startAnimating()
        if playerItem != nil{
            player.seek(to: kCMTimeZero)
            stopAnimating()
            self.present(playerController, animated: true) {
                self.player.play()
            }
            
        } else {
            didPressPlay = true
        }
    }
    
    func loadPatient(){
        let query = PFQuery(className: "_User")
        query.whereKey("objectId", equalTo: PFUser.current()!.objectId!)
        query.getFirstObjectInBackground {
            (object: PFObject?, error: Error?) -> Void in
            if error == nil || object != nil {
                
                let imageFile: PFFile = object!["Profile"] as! PFFile
                self.patientUserImage = imageFile.url
                self.patientUsername = object!["DisplayName"] as! String
                
                self.tableView?.reloadData()
                if self.isAnswered{
                    self.loadAdvisor()
                    
                } else {
                    self.stopAnimating()
                }
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
                self.tableView?.reloadData()
                self.stopAnimating()
            }
        }
    }
    
    @objc func cancelQuestion(_ sender: UIBarButtonItem){
        cancelQuestionView.showNotice("Cancel Question?", subTitle: "")
    }
    
    @objc func vitalsAction(_ sender: UIButton){
        self.performSegue(withIdentifier: "showVitals", sender: self)
    }
    
    @objc func shareAction(_ sender: UIButton){
        let textItem = "I found out my health concern was a \(self.level!) serious level through Sickcall!"
        let linkItem : NSURL = NSURL(string: "https://www.sickcallhealth.com/app")!
        // If you want to put an image
        
        let activityViewController : UIActivityViewController = UIActivityViewController(
            activityItems: [linkItem, textItem], applicationActivities: nil)
        
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func setUpAlertView(){
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "HelveticaNeue", size: 20)!,
            kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
            kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
            showCloseButton: false
        )
        
        cancelQuestionView = SCLAlertView(appearance: appearance)
        cancelQuestionView.addButton("YES") {
            self.startAnimating()
            let query = PFQuery(className: "Post")
            query.whereKey("objectId", equalTo: self.objectId)
            query.getFirstObjectInBackground {
                (object: PFObject?, error: Error?) -> Void in
                if error == nil || object != nil {
                    object?["isRemoved"] = true
                    object?.saveEventually{
                        (success: Bool, error: Error?) -> Void in
                        self.stopAnimating()
                        if (success) {
                            //send notification to advisor that person canceled
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let controller = storyboard.instantiateViewController(withIdentifier: "main") as UIViewController
                            self.present(controller, animated: true, completion: nil)
                            
                        } else {
                            SCLAlertView().showError("Error", subTitle: "Unable to cancel question. Check internet connection and try again.")
                        }
                    }
                }
            }
        }
        cancelQuestionView.addButton("NO"){
            
        }
    }
    
    func getVideo(){
        videoFile.getDataInBackground {
            (videoData: Data?, error: Error?) -> Void in
            if error == nil {
                if let videoData = videoData {
                    //convert video file to playable format
                    let documentsPath : AnyObject = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask,true)[0] as AnyObject
                    let destinationPath:String = documentsPath.appending("/file.mov")
                    try? videoData.write ( to: URL(fileURLWithPath: destinationPath as String), options: [.atomic])
                    self.playerItem = AVPlayerItem(asset: AVAsset(url: URL(fileURLWithPath: destinationPath as String)))
                    self.player = AVPlayer(playerItem: self.playerItem)
                    self.playerController = AVPlayerViewController()
                    self.playerController.player = self.player
                    
                    if self.didPressPlay{
                        self.player.seek(to: kCMTimeZero)
                        self.stopAnimating()
                        self.present(self.playerController, animated: true) {
                            self.player.play()
                        }
                    }
                }
            }
        }
    }
    
    func subscribeToUpdates(){
        //if question is answered while user is looking at screen, update info
        self.subscription = self.liveQueryClient
            .subscribe(self.questionsQuery)
            .handle(Event.updated) { _, object in
                
                let isAnswered = object["isAnswered"] as! Bool
                
                //if question isn't answered
                if isAnswered{
                    self.isAnswered = true
                    self.loadAdvisor()
                    self.level = object["level"] as! String
                    self.comments = object["comment"] as! String
                    self.advisorUserId = object["advisorUserId"] as! String
                    //person can't cancel question once question is answered
                    self.cancelQuestionButton.isEnabled = false
                    self.tableView?.reloadData()
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
