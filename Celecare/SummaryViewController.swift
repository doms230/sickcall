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

import Stripe
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView
import SCLAlertView

class SummaryViewController: UIViewController, STPAddCardViewControllerDelegate, NVActivityIndicatorViewable {
    
    //post info
    var healthConcernDuration: String!
    var healthConcernSummary: String!
    var videoFile: PFFile!
    var pickedFile: URL!
    var screenshotImage: PFFile!
    var image: UIImage!
    var chargeId: String!
    
    //user 
    var customerId: String!
    
    @IBOutlet weak var questionSummary: UILabel!
    @IBOutlet weak var healthDurationLabel: UILabel!
    @IBOutlet weak var questionVideoButton: UIButton!
    
    //payments
    var baseURL = "https://celecare.herokuapp.com/payments/createCharge"
    var questionURL = "https://celecare.herokuapp.com/posts/assignQuestion"
    var tokenId: String!
    
    @IBOutlet weak var paymentImage: UIImageView!
    @IBOutlet weak var paymentCard: UIButton!
    
    //bools
    var isVideoCompressed = false
    var hasUserPaid = false
    var isVideoSaved = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MyAPIClient implements STPEphemeralKeyProvider (see above)
        //let customerContext = STPCustomerContext(keyProvider: MyAPIClient.sharedClient)
        
        //TODO: Uncomment
        image = self.videoPreviewImage()
        
        questionSummary.text = healthConcernSummary
        healthDurationLabel.text = healthConcernDuration
        questionVideoButton.setBackgroundImage(image, for: .normal)
        questionVideoButton.layer.cornerRadius = 3
        questionVideoButton.clipsToBounds = true
        
        
        let imageJaunt = UIImageJPEGRepresentation(image!, 0.5)
        screenshotImage  = PFFile(name: "screenshot.jpeg", data: imageJaunt!)
        self.screenshotImage.saveInBackground {
            (success: Bool, error: Error?) -> Void in
            if (success) {
             
                
            }else{
            }
        }
        
        
        compressAction(videoFile: pickedFile)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    //UI Action
    
    @IBAction func askQuestionAction(_ sender: UIButton) {
        
        if tokenId != nil{
            startAnimating()
            createCharge()

        } else {
            self.paymentCard.setTitleColor(.red, for: .normal)
        }
    }
    
    @IBAction func choosePaymentAction(_ sender: UIButton) {
        let addCardViewController = STPAddCardViewController()
        addCardViewController.delegate = self
        // STPAddCardViewController must be shown inside a UINavigationController.
        let navigationController = UINavigationController(rootViewController: addCardViewController)
        self.present(navigationController, animated: true, completion: nil)
    }
    
    //
    @IBAction func questionVideoAction(_ sender: UIButton) {
        
        let player = AVPlayer(url: pickedFile)
        let playerController = AVPlayerViewController()
        playerController.player = player
        present(playerController, animated: true) {
            player.play()
        }
    }
    
    //video
    
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
                        self.cleanup(outputFileURL: compressedURL)
                        self.cleanup(outputFileURL: videoFile)
                        if self.hasUserPaid{
                            self.postIt()
                        }
                        
                        print("video saved")
                        
                    }else{
                        print(error!)
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
    
    //payments
    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func addCardViewController(_ addCardViewController: STPAddCardViewController, didCreateToken token: STPToken, completion: @escaping STPErrorBlock) {
        
        tokenId = token.tokenId;

        paymentCard.setTitle(token.card?.last4(), for: .normal)
        paymentCard.setTitleColor(.blue, for: .normal)
        paymentImage.image = token.card?.image
        self.dismiss(animated: true, completion: nil)
    }
    
    func createCharge(){
        //TODO: add application charge and extra charge for stripe fee j
        let p: Parameters = [            
            "description": "Health Concern for \(PFUser.current()!.objectId!)",
            "token": tokenId,
            "email": PFUser.current()!.email!
        ]
        
        Alamofire.request(self.baseURL, method: .post, parameters: p, encoding: JSONEncoding.default).validate().responseJSON { response in
            switch response.result {
            case .success(let data):
                let json = JSON(data)
                print("JSON: \(json)")
                
                if let status = json["statusCode"].int{
                    print(status)
                    let message = json["message"].string
                    SCLAlertView().showError("Something Went Wrong", subTitle: message!)
                    
                } else {
                    self.chargeId = json["id"].string
                    self.hasUserPaid = true
                    if self.isVideoCompressed{
                        self.postIt()
                    }
                }
                
                print("Validation Successful")
                
                //self.performSegue(withIdentifier: "showCurrentMeds", sender: self)
                
            case .failure(let error):
                print(error)
                SCLAlertView().showError("Charge Unsuccessful", subTitle: error.localizedDescription)
            }
        }
    }
    
    //data
    func postIt(){
        
        let newQuestion = PFObject(className: "Post")
        newQuestion["userId"] = PFUser.current()?.objectId
        newQuestion["video"] = videoFile
        newQuestion["videoScreenShot"] = self.screenshotImage
        newQuestion["duration"] = healthConcernDuration
        newQuestion["summary"] = healthConcernSummary
        newQuestion["level"] = ""
        newQuestion["comment"] = ""
        newQuestion["advisorUserId"] = ""
        newQuestion["isAnswered"] = false
        newQuestion["isRemoved"] = false
        newQuestion["chargeId"] = self.chargeId
        newQuestion.saveEventually{
            (success: Bool, error: Error?) -> Void in
            if (success) {
                print(newQuestion.objectId!)
                
                self.assignQuestion(objectId: newQuestion.objectId!)
                
            } else {
                print(error!)
                SCLAlertView().showError("Post UnSuccessful", subTitle: "Check internet connection and try again.")
            }
        }
    }
    
    //mich
    
    func videoPreviewImage() -> UIImage? {

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
            self.image = UIImage(named: "appy")
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
    }
    
    func assignQuestion(objectId: String){
        //startAnimating()
        Alamofire.request(self.questionURL, method: .post, parameters: ["id": objectId], encoding: JSONEncoding.default).validate().response{response in
            self.stopAnimating()
            print(response)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "main")
            self.present(controller, animated: true, completion: nil)
            

        }
    }
    
}
