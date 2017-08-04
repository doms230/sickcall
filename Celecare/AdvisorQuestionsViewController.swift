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

class AdvisorQuestionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var profileImage: UIButton!
    
    @IBOutlet weak var tableJaunt: UITableView!
    
    //question
    var healthConcern: String!
    var healthDuration: String!
    var objectId: String!
    var patientUserId: String!
    var videoScreenShot: String!
    var patientUserImage: String!
    var patientUsername: String!
    var videoFile: PFFile!
    
    //answer 
    var answerVideoScreenShot: PFFile! 
    
    //video
    var player: AVPlayer!
    var playerController: AVPlayerViewController!
    var playButton: UIButton!
    
    let imagePicker: UIImagePickerController! = UIImagePickerController()
    let saveFileName = "/test.mp4"
    
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
        
        self.title = "Questions"
        
       loadData()
        
        self.tableJaunt.register(AdvisorTableViewCell.self, forCellReuseIdentifier: "patientReuse")
        self.tableJaunt.register(AdvisorTableViewCell.self, forCellReuseIdentifier: "segmentReuse")
        self.tableJaunt.register(AdvisorTableViewCell.self, forCellReuseIdentifier: "infoReuse")
        self.tableJaunt.register(AdvisorTableViewCell.self, forCellReuseIdentifier: "medReuse")
        self.tableJaunt.register(AdvisorTableViewCell.self, forCellReuseIdentifier: "statusReuse")
        
        self.tableJaunt.estimatedRowHeight = 50
        self.tableJaunt.rowHeight = UITableViewAutomaticDimension
    }
    
   /* override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //send user's phone number to Verify View Controller
        let desti = segue.destination as! AdvisorMedsViewController
        desti.userId = questionUserIds[selectedIndex]
        desti.videoFile = videoFile[selectedIndex]
        desti.objectId = questionObjectIds[selectedIndex]
        
    }*/
    
    @IBAction func statusAction(_ sender: UIBarButtonItem) {
        //here, there will be something that logs when user went online and that he/she is online
        //playVideo(videoJaunt: videoFile)
      //  vitalsController = AdvisorMedsViewController()
      //  self.present(vitalsController, animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if objectId != nil{
            return 2
            
        }else {
            return 1
        }
        /*if objectId != nil{
            if selectedIndex == 0{
                return 2
                
            } else {
               // return patientMedications.count + 2
                return testMedications.count
            }
        } else {
            return 1
        }*/
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       // let cell = tableView.dequeueReusableCell(withIdentifier: "statusReuse", for: indexPath) as! AdvisorTableViewCell
        //cell.statusLabel.text = "You're offline"
        
        var cell: AdvisorTableViewCell!
        if objectId != nil{
            
            if indexPath.row == 0{
                cell = tableView.dequeueReusableCell(withIdentifier: "patientReuse", for: indexPath) as! AdvisorTableViewCell
                cell.selectionStyle = .none
                tableView.separatorStyle = .none
                cell.backgroundColor = uicolorFromHex(0xe8e6df)
                cell.patientImage.kf.setImage(with: URL(string: self.patientUserImage))
                cell.patientName.text = self.patientUsername
                
            } else if indexPath.row == 1{
                cell = tableView.dequeueReusableCell(withIdentifier: "infoReuse", for: indexPath) as! AdvisorTableViewCell
                cell.selectionStyle = .none
                tableView.separatorStyle = .none
                cell.videoButton.image = UIImage(named:"appy")
                cell.healthConcern.text = self.healthConcern
                cell.healthDuration.text = self.healthDuration
                cell.videoButton.kf.setImage(with: URL(string: self.videoScreenShot))
            }
            
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "statusReuse", for: indexPath) as! AdvisorTableViewCell
            cell.statusLabel.text = "Loading"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        playVideo(videoJaunt: videoFile)
    }
    
    func loadData(){
        
        let query = PFQuery(className: "Post")
        query.whereKey("advisorUserId", equalTo: PFUser.current()!.objectId!)
        query.whereKey("isAnswered", equalTo: false)
        query.whereKey("isRemoved", equalTo: false)
        query.getFirstObjectInBackground {
            (object: PFObject?, error: Error?) -> Void in
            if error == nil || object != nil {
                self.healthConcern = object?["summary"] as! String
                self.healthDuration = object?["duration"] as! String
                self.objectId = object?.objectId
                let imageFile: PFFile = object!["videoScreenShot"] as! PFFile
                self.videoScreenShot = imageFile.url
                self.videoFile = object!["video"] as! PFFile
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
                self.tableJaunt.reloadData()
            }
        }
    }
    
    func uicolorFromHex(_ rgbValue:UInt32)->UIColor{
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }
    
    func segmentAction(_ sender: UISegmentedControl){
        tableJaunt.reloadData()
    }
    
    
    
    //video
    
    func setVideoUI(){
        playerController.view.addSubview(answerButton)
        answerButton.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(50)
            make.left.equalTo(playerController.view).offset(10)
            make.right.equalTo(playerController.view).offset(-10)
            make.bottom.equalTo(playerController.view).offset(-5)
        }
        answerButton.addTarget(self, action: #selector(AdvisorQuestionsViewController.answerAction(_:)), for: .touchUpInside)
    }
    
    func playVideo(videoJaunt: PFFile){
        
        progressBarDisplayer("")
    
        
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
                    //self.player.play()
                    
                    self.present(self.playerController, animated: true) {
                        self.messageFrame.removeFromSuperview()
                        self.player.play()
                    }
                    
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
        sender.removeFromSuperview()
        // postTime.removeFromSuperview()
    }
    
    func answerAction(_ sender: UIButton){
        //answer ish
        if player != nil{
            player.pause()
        }
        self.playerController.dismiss(animated: true, completion: nil)
        self.recordAnswer()
    }
    
    func recordAnswer(){
        if (UIImagePickerController.isSourceTypeAvailable(.camera)) {
            if UIImagePickerController.availableCaptureModes(for: .rear) != nil {
                
                imagePicker.sourceType = .camera
                imagePicker.mediaTypes = [kUTTypeMovie as String]
                imagePicker.allowsEditing = false
                imagePicker.videoMaximumDuration = 60
                imagePicker.videoQuality = .typeHigh
                imagePicker.delegate = self
                
                present(imagePicker, animated: true, completion: {})
            } else {
                //postAlert("Rear camera doesn't exist", message: "Application cannot access the camera.")
            }
        } else {
            //postAlert("Camera inaccessable", message: "Application cannot access the camera.")
        }
    }
    
    // MARK: UIImagePickerControllerDelegate delegate methods
    // Finished recording a video
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("Got a video")
        
        if let pickedVideo:URL = (info[UIImagePickerControllerMediaURL] as? URL) {

            
            compressAction(videoFile: pickedVideo)
            let proPic = UIImageJPEGRepresentation(self.videoPreviewImage(pickedFile: pickedVideo)!, 0.5)
            self.answerVideoScreenShot = PFFile(name: "answerVideoScreenShot.jpeg", data: proPic!)
            
            imagePicker.dismiss(animated: true, completion: {
                // Anything you want to happen when the user saves an video
                //self.performSegue(withIdentifier: "showCheckout", sender: self)
            })
            
        } else {
            //TODO: something happened
        }
    }
    
    // Called when the user selects cancel
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("User canceled image")
        dismiss(animated: true, completion: {
            // Anything you want to happen when the user selects cancel
        })
    }
    
    //video compression
    func compressVideo(_ inputURL: URL, outputURL: URL, handler:@escaping (_ session: AVAssetExportSession)-> Void) {
        let urlAsset = AVURLAsset(url: inputURL, options: nil)
        if let exportSession = AVAssetExportSession(asset: urlAsset, presetName: AVAssetExportPresetHighestQuality) {
            exportSession.outputURL = outputURL
            exportSession.outputFileType = AVFileTypeQuickTimeMovie
            exportSession.shouldOptimizeForNetworkUse = true
            exportSession.exportAsynchronously { () -> Void in
                handler(exportSession)
            }
        }
    }
    
    func compressAction(videoFile: URL){
        let compressedURL = URL(fileURLWithPath: NSTemporaryDirectory() + UUID().uuidString + ".mp4")
        compressVideo(videoFile, outputURL: compressedURL) { (session) in
            switch session.status {
            case .unknown:
                break
            case .waiting:
                break
            case .exporting:
                break
            case .completed:
                
                let data = try? Data(contentsOf: compressedURL)
                self.videoFile = PFFile(name:"media.mp4", data:data!)!
                
                let query = PFQuery(className: "Post")
                query.whereKey("objectId", equalTo: self.objectId)
                query.getFirstObjectInBackground {
                    (object: PFObject?, error: Error?) -> Void in
                    if error != nil || object == nil {
                        
                        
                    } else {
                        object?["answer"] = self.videoFile
                        object?["answerScreenShot"] = self.answerVideoScreenShot
                        object?["isAnswered"] = true
                        object?["advisorUserId"] = PFUser.current()?.objectId
                        object?.saveInBackground {
                            (success: Bool, error: Error?) -> Void in
                            if (success) {
                                self.cleanup(outputFileURL: videoFile)
                                self.cleanup(outputFileURL: compressedURL)
                                //segue to main storyboard
                                let storyboard = UIStoryboard(name: "Advisor", bundle: nil)
                                let controller = storyboard.instantiateViewController(withIdentifier: "container") as UIViewController
                                self.present(controller, animated: true, completion: nil)
                            }
                        }
                    }
                }
                
                break
            case .failed:
                //do something saying jaunt failed
                break
            case .cancelled:
                break
            }
        }
    }
    
    //mich
    func postAlert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message,
                                      preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
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
    
    func videoPreviewImage(pickedFile: URL) -> UIImage? {
        //let filePath = NSString(string: "~/").expandingTildeInPath.appending("/Documents/").appending(fileName)
        
        //let vidURL = NSURL(fileURLWithPath:filePath)
        let asset = AVURLAsset(url: pickedFile)
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        
        let timestamp = CMTime(seconds: 2, preferredTimescale: 60)
        
        do {
            let imageRef = try generator.copyCGImage(at: timestamp, actualTime: nil)
            return UIImage(cgImage: imageRef)
        }
        catch let error as NSError
        {
            print("Image generation failed with error \(error)")
            //self.image = UIImage(named: "appy")
            return nil
        }
    }
    
    func cleanup(outputFileURL: URL ) {
        print("started clean up")
        let path = outputFileURL.path
        
        if FileManager.default.fileExists(atPath: path) {
            do {
                try FileManager.default.removeItem(atPath: path)
                print("removed temp file")
            }
            catch {
                print("Could not remove file at url: \(outputFileURL)")
            }
            
        } else {
            print("couldn't find file")
        }
        
       /* if let currentBackgroundRecordingID = backgroundRecordingID {
            backgroundRecordingID = UIBackgroundTaskInvalid
            
            if currentBackgroundRecordingID != UIBackgroundTaskInvalid {
                UIApplication.shared.endBackgroundTask(currentBackgroundRecordingID)
            }
        }*/
    }
}
