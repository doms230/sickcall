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

class AdvisorMedsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate   {

    var medLabel = [String]()
    var medDuration = [String]()
    var userId: String!
    var objectId: String!
    var videoFile: PFFile! 
    
    var player: AVPlayer!
    var playerController: AVPlayerViewController!
    
    let screenSize: CGRect = UIScreen.main.bounds
    
    var selectedIndex = 0
    
    var answerButton: UIButton!
    
    var advisorRec = ""
    
    //
    let imagePicker: UIImagePickerController! = UIImagePickerController()
    let saveFileName = "/test.mp4"
    
    @IBOutlet weak var tableJaunt: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        loadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return medLabel.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "medReuse", for: indexPath) as! AdvisorTableViewCell
        
        cell.medicationLabel.text = medDuration[indexPath.row]
        cell.durationLabel.text = medLabel[indexPath.row]
        

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //segue to question jautn
        /*if indexPath.section == 0{
            playVideo(videoJaunt: videoFile)
            selectedIndex = indexPath.row
        }        */
    }
    
    //TODO: change userId to something proper
    func loadData(){
        let userId = PFUser.current()!.objectId!
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

   /* func playVideo(videoJaunt: PFFile){
        
        let exitButton = UIButton(frame: CGRect(x: 10,y: 20,width: 25, height: 25))
        //exitButton.setTitle("X", for: .normal)
        //exitButton.setTitleColor(UIColor.black, for: .normal)
        exitButton.setImage(UIImage(named: "exit"), for: .normal)
        // exitButton.backgroundColor = UIColor.white
        exitButton.layer.cornerRadius = 25/2
        exitButton.clipsToBounds = true
        exitButton.addTarget(self, action: #selector(AdvisorMedsViewController.exitPost(_:)), for: .touchUpInside)
        
        answerButton = UIButton(frame: CGRect(x: screenSize.width - 215,y: screenSize.height - 50,width: 200, height: 50))
        answerButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 16)
        answerButton.isEnabled = false
        answerButton.setTitle("Answer for $0.00", for: .normal)
        answerButton.setTitleColor(UIColor.black, for: .normal)
       // exitButton.setImage(UIImage(named: "exit"), for: .normal)
        answerButton.backgroundColor = UIColor.white
        answerButton.layer.cornerRadius = 3
        answerButton.clipsToBounds = true
        answerButton.addTarget(self, action: #selector(AdvisorMedsViewController.answerAction(_:)), for: .touchUpInside)
        
       let vitalsButton = UIButton(frame: CGRect(x: 15,y: screenSize.height - 50,width: 50, height: 50))
        vitalsButton.setTitleColor(UIColor.black, for: .normal)
         vitalsButton.setImage(UIImage(named: "vitals"), for: .normal)
        vitalsButton.layer.cornerRadius = 25
        vitalsButton.clipsToBounds = true
        //vitalsButton.addTarget(self, action: #selector(AdvisorMedsViewController.answerAction(_:)), for: .touchUpInside)
        
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
        playerController.view.addSubview(answerButton)
        playerController.view.addSubview(vitalsButton)
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
        
        //enable because advisor has watched the whole video
        answerButton.isEnabled = true
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
    }*/
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
