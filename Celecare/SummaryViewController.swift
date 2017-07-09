//
//  SummaryViewController.swift
//  Celecare
//
//  Created by Mac Owner on 7/4/17.
//  Copyright © 2017 Celecare LLC. All rights reserved.
//

import UIKit
import Parse

import MobileCoreServices
import AVKit
import AVFoundation

class SummaryViewController: UIViewController {
    
    //post info
    var healthConcernDuration: String!
    var healthConcernSummary: String!
    var videoFile: PFFile!
    var pickedFile: URL!
    
    @IBOutlet weak var questionSummary: UILabel!
    @IBOutlet weak var healthDurationLabel: UILabel!
    @IBOutlet weak var questionVideoButton: UIButton!
    
    //bools
    var isVideoCompressed = false
    var hasUserPaid = false
    var isVideoSaved = false
    
    //progress bar
    var messageFrame: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        questionSummary.text = healthConcernSummary
        healthDurationLabel.text = healthConcernDuration
        questionVideoButton.setBackgroundImage(self.videoPreviewImage(), for: .normal)
        questionVideoButton.layer.cornerRadius = 3
        questionVideoButton.clipsToBounds = true 
        
        // Do any additional setup after loading the view.
        
        /*self.videoFile.saveInBackground {
            (success: Bool, error: Error?) -> Void in
            if (success) {
                self.isVideoSaved = true
                print("video saved")
                
            }else{
                // self.mapJaunt.removeAnnotation(tempPin)
                let newTwitterHandlePrompt = UIAlertController(title: "Post Failed", message: "Check internet connection and try again. Contact help@hiikey.com if the issue persists.", preferredStyle: .alert)
                newTwitterHandlePrompt.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                self.present(newTwitterHandlePrompt, animated: true, completion: nil)
            }
        }*/
        
        compressAction(videoFile: pickedFile)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func postIt(){
        
        let newQuestion = PFObject(className: "Post")
        
        newQuestion["userId"] = PFUser.current()?.objectId
        newQuestion["video"] = videoFile
        newQuestion["duration"] = healthConcernDuration
        newQuestion["summary"] = healthConcernSummary
        newQuestion["isAnswered"] = false
        newQuestion["isReserved"] = false
        newQuestion["isRemoved"] = false
        newQuestion.saveEventually{
            (success: Bool, error: Error?) -> Void in
            if (success) {

                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "main") as UIViewController
                self.present(controller, animated: true, completion: nil)
                
            } else {
                // self.mapJaunt.removeAnnotation(pin)
                let newTwitterHandlePrompt = UIAlertController(title: "Post Failed", message: "Check internet connection and try again. Contact help@hiikey.com if the issue persists.", preferredStyle: .alert)
                newTwitterHandlePrompt.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                
                self.present(newTwitterHandlePrompt, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func askQuestionAction(_ sender: UIButton) {
        
        //do pay checkout jaunts
        //also do something where activity spinner shows up
        progressBarDisplayer("")
        hasUserPaid = true

        if isVideoCompressed{
            self.postIt()
        }
    }
    
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
                self.videoFile.saveInBackground {
                    (success: Bool, error: Error?) -> Void in
                    if (success) {
                        self.isVideoCompressed = true
                        
                        if self.hasUserPaid{
                            self.postIt()
                        }
                        
                        print("video saved")
                        
                    }else{
                        // self.mapJaunt.removeAnnotation(tempPin)
                        let newTwitterHandlePrompt = UIAlertController(title: "Post Failed", message: "Check internet connection and try again. Contact help@hiikey.com if the issue persists.", preferredStyle: .alert)
                        newTwitterHandlePrompt.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                        self.present(newTwitterHandlePrompt, animated: true, completion: nil)
                    }
                }
                
                //self.performSegue(withIdentifier: "showCheckout", sender: self)
                
                break
            case .failed:
                //do something saying jaunt failed
                break
            case .cancelled:
                break
            }
        }
    }
    
    //
    @IBAction func questionVideoAction(_ sender: UIButton) {
        // Find the video in the app's document directory
        
       /* guard let path = Bundle.main.path(forResource: "video", ofType:"m4v") else {
            debugPrint("video.m4v not found")
            return
        }*/
        
        let player = AVPlayer(url: pickedFile)
        let playerController = AVPlayerViewController()
        playerController.player = player
        present(playerController, animated: true) {
            player.play()
        }
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
    
    func videoPreviewImage() -> UIImage? {
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
            return nil
        }
    }
}
