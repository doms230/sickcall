//
//  V2ViewAnswerViewController.swift
//  Celecare
//
//  Created by Dom Smith on 8/14/17.
//  Copyright © 2017 Celecare LLC. All rights reserved.
//

import UIKit
import SlackTextViewController
import Parse
import NVActivityIndicatorView
import MobileCoreServices
import AVKit
import AVFoundation
import SCLAlertView
import ParseLiveQuery

class V2ViewAnswerViewController: SLKTextViewController,NVActivityIndicatorViewable {
    
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
    var videoJaunt: PFFile!
    var videoPreview: String!
    
    var playerItem: AVPlayerItem!
    var player: AVPlayer!
    var playerController: AVPlayerViewController!
    
    var cancelQuestionView: SCLAlertView!
    
    /*** In case user presses play before video is loaded */
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
        
        self.tableView?.register(ViewAnswerTableViewCell.self, forCellReuseIdentifier: "patientReuse")
        self.tableView?.register(ViewAnswerTableViewCell.self, forCellReuseIdentifier: "advisorReuse")
        self.tableView?.estimatedRowHeight = 50
        self.tableView?.rowHeight = UITableViewAutomaticDimension
        self.tableView?.separatorStyle = .none
        self.isInverted = false
        self.textView.isHidden = true
        
        //set up indicator view
        NVActivityIndicatorView.DEFAULT_TYPE = .ballScaleMultiple
        NVActivityIndicatorView.DEFAULT_COLOR = uicolorFromHex(0xee1848)
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
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let desti = segue.destination as! AdvisorMedsViewController
        desti.patientUserId = PFUser.current()?.objectId
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.patientUsername == nil{
            return 0
            
        } else if isAnswered {
            return 2
            
        } else {
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
            //cell.videoPreview.image = UIImage(named: "appy")
            cell.vitalsButton.backgroundColor = uicolorFromHex(0x8c81ff)
            cell.vitalsButton.addTarget(self, action: #selector(self.vitalsAction(_:)), for: .touchUpInside)
            
            //TODO: Uncomment
            //cell.videoButton.kf.setImage(with: URL(string: self.videoPreview), for: .normal)
            
            cell.videoButton.addTarget(self, action: #selector(self.loadPlayJaunt(_:)), for: .touchUpInside)
            //cell.videoButton.backgroundColor = uicolorFromHex(0xE8E6DF)
            
            //cell.videoImage.kf.setImage(with: URL(string: self.videoPreview))
            cell.videoImage.image = UIImage(named: "appy")
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "advisorReuse", for: indexPath) as! ViewAnswerTableViewCell
            cell.selectionStyle = .none
            cell.advisorImage.image = UIImage(named: "appy")
            //cell.advisorImage.kf.setImage(with: URL(string: self.advisorUserImage))
            cell.advisorName.text = self.advisorUsername
            
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
    
    func loadPlayJaunt(_ sender: UIButton){
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
                //self.stopAnimating()
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
    
    func cancelQuestion(_ sender: UIBarButtonItem){
        cancelQuestionView.showNotice("Cancel Question?", subTitle: "")
    }
    
    func vitalsAction(_ sender: UIButton){
        self.performSegue(withIdentifier: "showVitals", sender: self)
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
