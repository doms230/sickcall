//
//  SummaryViewController.swift
//  Sickcall
//
//  Created by Mac Owner on 7/4/17.
//  Copyright © 2017 Socialgroupe Incorporated All rights reserved.
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

class SummaryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, STPAddCardViewControllerDelegate, NVActivityIndicatorViewable {
    
 var tableJaunt: UITableView!
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
    
    //payments
    var baseURL = "https://celecare.herokuapp.com/payments/createCharge"
    var questionURL = "https://celecare.herokuapp.com/posts/assignQuestion"
    var tokenId: String!
    var creditCard = "Credit Card"
    var ccImage = UIImage(named: "new")
    var didChooseCC: Bool!
    
    //bools
    var isVideoCompressed = false
    var hasUserPaid = false
    var isVideoSaved = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Summary"
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(askQuestionAction(_:)))
        self.navigationItem.setRightBarButton(doneButton, animated: true)
        self.tableJaunt = UITableView(frame: self.view.bounds)
        self.tableJaunt.dataSource = self
        self.tableJaunt.delegate = self
        self.tableJaunt.register(MainTableViewCell.self, forCellReuseIdentifier: "checkoutReuse")
        self.tableJaunt.estimatedRowHeight = 50
        self.tableJaunt.rowHeight = UITableViewAutomaticDimension
        self.tableJaunt.separatorStyle = .none
        self.view.addSubview(self.tableJaunt)
        
        //TODO: Uncomment
        image = self.videoPreviewImage()
        
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

    //tableview
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "checkoutReuse", for: indexPath) as! MainTableViewCell
        cell.selectionStyle = .none
        
        cell.summaryTitle.text = healthConcernSummary
        //cell.summaryView.backgroundColor = uicolorFromHex(0xe8e6df)
        cell.summaryView.addTarget(self, action: #selector(questionVideoAction(_:)), for: .touchUpInside)
        cell.durationLabel.text = healthConcernDuration
        cell.videoButton.setImage(image, for: .normal)
        //cell.videoButton.addTarget(self, action: #selector(self.questionVideoAction(_:)), for: .touchUpInside)
        //cell.checkoutView.backgroundColor = uicolorFromHex(0xe8e6df)
        cell.checkoutView.addTarget(self, action: #selector(self.choosePaymentAction(_:)), for: .touchUpInside)
        cell.totalLabel.text = "$6.99"
        cell.creditCardButton.setTitle(creditCard, for: .normal)
        cell.creditCardButton.setImage(ccImage, for: .normal)
        //cell.creditCardButton.addTarget(self, action: #selector(self.choosePaymentAction(_:)), for: .touchUpInside)

        return cell
    }
    
    //UI Action
    
    @objc func askQuestionAction(_ sender: UIBarButtonItem) {
        if tokenId != nil{
            startAnimating()
            createCharge()

        } else {
           //self.paymentCard.setTitleColor(.red, for: .normal)
            SCLAlertView().showError("No Credit Card", subTitle: "Enter credit card info before checkout.")
        }
    }
    
    @objc func choosePaymentAction(_ sender: UIButton) {
        let addCardViewController = STPAddCardViewController()
        addCardViewController.delegate = self
        // STPAddCardViewController must be shown inside a UINavigationController.
        let navigationController = UINavigationController(rootViewController: addCardViewController)
        self.present(navigationController, animated: true, completion: nil)
    }
    
    //
    @objc func questionVideoAction(_ sender: UIButton) {
        
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
        if let exportSession = AVAssetExportSession(asset: urlAsset, presetName: AVAssetExportPresetMediumQuality) {
            exportSession.outputURL = outputURL
            exportSession.outputFileType = AVFileType.mov
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
                       // self.cleanup(outputFileURL: compressedURL)
                        //self.cleanup(outputFileURL: videoFile)
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
        creditCard = (token.card?.last4)!
        ccImage = token.card?.image
        self.tableJaunt.reloadData()
        self.dismiss(animated: true, completion: nil)
    }
    
    func createCharge(){
        //TODO: add application charge and extra charge for stripe fee j
        let p: Parameters = [            
            "description": "\(String(describing: PFUser.current()?.email!))'s health question",
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
            let controller = storyboard.instantiateViewController(withIdentifier: "main") as! UITabBarController
            controller.selectedIndex = 1
            self.present(controller, animated: true, completion: nil)
        }
    }
    func uicolorFromHex(_ rgbValue:UInt32)->UIColor{
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }
}
