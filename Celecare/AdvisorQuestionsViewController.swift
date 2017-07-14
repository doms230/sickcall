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

class AdvisorQuestionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var profileImage: UIButton!
    
    @IBOutlet weak var tableJaunt: UITableView!
    
   /* var questions = [String]()
    var videoFile = [PFFile]()
    var questionObjectIds = [String]()
    var questionUserIds = [String]()
    var questionVideoShoot = [PFFile]()
    var questionUserImage = [PFFile]()
    var questionUserName = [String]()*/
    
    var healthConcern: String!
    var healthDuration: String!
    var objectId: String!
    var patientUserId: String!
    var videoScreenShot: String!
    var patientUserImage: String!
    var patientUsername: String!
    var videoFile: PFFile!
    
    var player: AVPlayer!
    var playerController: AVPlayerViewController!
    
    var vitalsController: AdvisorMedsViewController!
    let screenSize: CGRect = UIScreen.main.bounds
    
    var selectedIndex = 0
    var answerButton: UIButton!
    var vitalsButton: UIButton!
    var playButton: UIButton!
    
    var advisorRec = ""
    
    let imagePicker: UIImagePickerController! = UIImagePickerController()
    let saveFileName = "/test.mp4"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Questions"
        
        let query = PFQuery(className: "_User")
        query.whereKey("objectId", equalTo: PFUser.current()!.objectId!)
        query.getFirstObjectInBackground {
            (object: PFObject?, error: Error?) -> Void in
            if error != nil || object == nil {
                
                
            } else {
                let imageFile: PFFile = object!["Profile"] as! PFFile
                self.profileImage.kf.setImage(with: URL(string: imageFile.url!), for: .normal)
                self.profileImage.layer.cornerRadius = 30 / 2
                self.profileImage.clipsToBounds = true
                
            }
        }
        
       loadData()
        
        self.tableJaunt.register(AdvisorTableViewCell.self, forCellReuseIdentifier: "patientReuse")
        self.tableJaunt.register(AdvisorTableViewCell.self, forCellReuseIdentifier: "segmentReuse")
        self.tableJaunt.register(AdvisorTableViewCell.self, forCellReuseIdentifier: "infoReuse")
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
        vitalsController = AdvisorMedsViewController()
        self.present(vitalsController, animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       // let cell = tableView.dequeueReusableCell(withIdentifier: "statusReuse", for: indexPath) as! AdvisorTableViewCell
        //cell.statusLabel.text = "You're offline"
        
        var cell: AdvisorTableViewCell!
        if objectId != nil{
            if indexPath.row == 0{
                cell = tableView.dequeueReusableCell(withIdentifier: "patientReuse", for: indexPath) as! AdvisorTableViewCell
                cell.backgroundColor = uicolorFromHex(0x180d22)
                cell.patientImage.kf.setImage(with: URL(string: self.patientUserImage))
                cell.patientName.text = self.patientUsername
                
            } else if indexPath.row == 1{
                cell = tableView.dequeueReusableCell(withIdentifier: "segmentReuse", for: indexPath) as! AdvisorTableViewCell
                cell.segment.tintColor = uicolorFromHex(0x180d22)
                //add segment actions here
                
            } else if indexPath.row == 2{
                cell = tableView.dequeueReusableCell(withIdentifier: "infoReuse", for: indexPath) as! AdvisorTableViewCell
                cell.videoButton.setImage(UIImage(named:"appy"), for: .normal)
                cell.healthConcern.text = self.healthConcern
                cell.healthDuration.text = self.healthDuration
                cell.videoButton.kf.setImage(with: URL(string: self.videoScreenShot), for: .normal)
                //cell.videoButton.addTarget(self, action: #selector(AdvisorQuestionsViewController.showQuestion(_:)), for: .touchUpInside)
            }
            
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "statusReuse", for: indexPath) as! AdvisorTableViewCell
            cell.statusLabel.text = "You're in queue"
        }
        
        //cell.questionLabel.text = questions[indexPath.row]

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //segue to question jautn
        if indexPath.row == 2{
            playVideo(videoJaunt: videoFile)
        }
        //selectedIndex = indexPath.row
        //self.performSegue(withIdentifier: "showVitals", sender: self)
    }
    
    @IBAction func menuAction(_ sender: UIButton) {
        if let container = self.so_containerViewController {
            container.isSideViewControllerPresented = true
        }
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
    
    
    //video
    
    
    func playVideo(videoJaunt: PFFile){
        
        let exitButton = UIButton(frame: CGRect(x: 10,y: 20,width: 25, height: 25))
        //exitButton.setTitle("X", for: .normal)
        //exitButton.setTitleColor(UIColor.black, for: .normal)
        exitButton.setImage(UIImage(named: "exit"), for: .normal)
        // exitButton.backgroundColor = UIColor.white
        exitButton.layer.cornerRadius = 25/2
        exitButton.clipsToBounds = true
        exitButton.addTarget(self, action: #selector(AdvisorQuestionsViewController.exitPost(_:)), for: .touchUpInside)
        
        answerButton = UIButton(frame: CGRect(x: 10,y: screenSize.height - 75,width: screenSize.width - 20, height: 50))
        answerButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
        //answerButton.isEnabled = false
        answerButton.setTitle("Answer", for: .normal)
        answerButton.setTitleColor(uicolorFromHex(0x180d22), for: .normal)
        // exitButton.setImage(UIImage(named: "exit"), for: .normal)
        answerButton.backgroundColor = UIColor.white
        answerButton.layer.cornerRadius = 3
        answerButton.clipsToBounds = true
        answerButton.addTarget(self, action: #selector(AdvisorQuestionsViewController.answerAction(_:)), for: .touchUpInside)
        
        vitalsButton = UIButton(frame: CGRect(x: screenSize.width - 65,y: 15,width: 50, height: 50))
        vitalsButton.setTitleColor(UIColor.black, for: .normal)
        vitalsButton.setImage(UIImage(named: "vitals"), for: .normal)
        vitalsButton.layer.cornerRadius = 25
        vitalsButton.clipsToBounds = true
        vitalsButton.addTarget(self, action: #selector(AdvisorQuestionsViewController.vitalsAction(_:)), for: .touchUpInside)
        
        playButton = UIButton(frame: CGRect(x: screenSize.width / 2 - 50,y: screenSize.height / 2 - 50, width: 100, height: 100))
        playButton.setTitleColor(UIColor.black, for: .normal)
        playButton.setImage(UIImage(named: "play"), for: .normal)
        playButton.layer.cornerRadius = 50
        playButton.clipsToBounds = true
        playButton.addTarget(self, action: #selector(AdvisorQuestionsViewController.playAction(_:)), for: .touchUpInside)
        
        
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
        //player.seek(to: kCMTimeZero)
        //player.play()
        
        //enable because advisor has watched the whole video
        
       // answerButton.isEnabled = true
        playerController.view.addSubview(answerButton)
        playerController.view.addSubview(vitalsButton)
        playerController.view.addSubview(playButton)
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
        chooseRec()
    }
    
    func vitalsAction(_ sender: UIButton){
        //playerController.present(AdvisorMedsViewController, animated: true, completion: nil)
        //performSegue(withIdentifier: "showVitals", sender: self)
    }
    
    func playAction(_ sender: UIButton){
        answerButton.removeFromSuperview()
        vitalsButton.removeFromSuperview()
        playButton.removeFromSuperview()
        player.seek(to: kCMTimeZero)
        player.play()
    }
    
    func chooseRec(){
        //show action pop up of med duration
        
        let chooseMed = UIAlertController(title: "What's your recommendation?", message: "You'll explain your recommendation via video next", preferredStyle: .actionSheet)
        
        let otcSolution = UIAlertAction(title: "Over The Counter Solution", style: .default) { (action) in
            self.recordAnswer()
            self.advisorRec = "Over The Counter Solution"
        }
        
        let doctorAppointment = UIAlertAction(title: "Doctor's Appointment", style: .default) { (action) in
            self.recordAnswer()
            self.advisorRec = "Doctor's Appointment"
            
        }
        
        let urgent = UIAlertAction(title: "E.R. or Urgent Care", style: .default) { (action) in
            self.recordAnswer()
            self.advisorRec = "Emergency Room or Urgent Care"
            
        }
        
        chooseMed.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        chooseMed.addAction(otcSolution)
        chooseMed.addAction(doctorAppointment)
        chooseMed.addAction(urgent)
        present(chooseMed, animated: true, completion: nil)
        
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
            // Save video to the main photo album
            /* let selectorToCall = #selector(QuestionViewController.videoWasSavedSuccessfully(_:didFinishSavingWithError:context:))
             UISaveVideoAtPathToSavedPhotosAlbum(pickedVideo.relativePath, self, selectorToCall, nil)
             
             // Save the video to the app directory so we can play it later
             let videoData = try? Data(contentsOf: pickedVideo)
             let paths = NSSearchPathForDirectoriesInDomains(
             FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
             let documentsDirectory: URL = URL(fileURLWithPath: paths[0])
             let dataPath = documentsDirectory.appendingPathComponent(saveFileName)
             try! videoData?.write(to: dataPath, options: [])
             print("Saved to " + dataPath.absoluteString)*/
            
            compressAction(videoFile: pickedVideo)
            //videoFile = pickedVideo
            
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
    
    /*
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
     
     if let currentBackgroundRecordingID = backgroundRecordingID {
     backgroundRecordingID = UIBackgroundTaskInvalid
     
     if currentBackgroundRecordingID != UIBackgroundTaskInvalid {
     UIApplication.shared.endBackgroundTask(currentBackgroundRecordingID)
     }
     }
     }
     
     */
    
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
                        object?["isAnswered"] = true
                        object?["rec"] = self.advisorRec
                        object?.saveInBackground {
                            (success: Bool, error: Error?) -> Void in
                            if (success) {
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

}
