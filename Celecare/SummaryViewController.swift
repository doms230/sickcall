//
//  SummaryViewController.swift
//  Sickcall
//
//  Created by Mac Owner on 7/4/17.
//  Copyright © 2017 Sickcall LLC All rights reserved.
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

import BulletinBoard
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
    var priceURL = "https://celecare.herokuapp.com/payments"
    var tokenId: String!
    var creditCard = "Credit Card"
    var addLabel = "Add"
    var ccImage = UIImage(named: "new")
    var didChooseCC: Bool!
    
    //bools
    var isVideoCompressed = false
    var hasUserPaid = false
    var isVideoSaved = false
    
    var didShare = false
    var booking_fee = 0
    var nurse_fee = 0
    var discount = 0
    var total = 0
    var priceView = SCLAlertView()
    
    let screenSize: CGRect = UIScreen.main.bounds
    
    lazy var bulletinManager: BulletinManager = {
        
        let page = PageBulletinItem(title: "Thank you!")
        page.image = UIImage(named: "info")
        
        page.descriptionText = "Sickcall partners with registered nurses in the United States. We work together to insure that your answers are accurate. By tapping okay, you understand that Sickcall and our nurse advisors are not liable for any actions you take after receiving information through Sickcall."
        page.shouldCompactDescriptionText = true
        page.actionButtonTitle = "Okay"
        page.alternativeButtonTitle = "Terms & Privacy Policy"
        page.interfaceFactory.tintColor = uicolorFromHex(0x006a52)// green
        page.interfaceFactory.actionButtonTitleColor = .white
        page.isDismissable = true
        page.shouldCompactDescriptionText = true
        page.actionHandler = { (item: PageBulletinItem) in
            page.manager?.dismissBulletin()
            self.startAnimating()
            if self.didShare{
                if self.isVideoCompressed{
                    self.postIt()
                }
                
            } else {
                self.createCharge()
            }
        }
        
        page.alternativeHandler = { (item: PageBulletinItem) in
            page.manager?.dismissBulletin()
            let url = URL(string : "https://www.sickcallhealth.com/terms" )
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        }
        return BulletinManager(rootItem: page)
        
    }()
    
    lazy var shareManager: BulletinManager = {
        
        let page = PageBulletinItem(title: "Share")
        page.image = UIImage(named: "share")
        
        page.descriptionText = "Share Sickcall, and ask for free!"
        page.actionButtonTitle = "Share Sickcall"
        page.interfaceFactory.tintColor = uicolorFromHex(0x006a52)// green
        page.interfaceFactory.actionButtonTitleColor = .white
        page.actionHandler = { (item: PageBulletinItem) in
            self.shareAction()
        }
        page.alternativeButtonTitle = " Or pay $\(Double(total) * 0.01)"
        
        page.alternativeHandler = { (item: PageBulletinItem) in
            self.discount = 0
            self.tableJaunt.reloadData()
            page.manager?.dismissBulletin(animated: true )
        }
        return BulletinManager(rootItem: page)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Summary"
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(askQuestionAction(_:)))
        self.navigationItem.setRightBarButton(doneButton, animated: true)
        
        self.tableJaunt = UITableView(frame: self.view.bounds)
        self.tableJaunt.dataSource = self
        self.tableJaunt.delegate = self
        self.tableJaunt.register(MainTableViewCell.self, forCellReuseIdentifier: "summaryReuse")
        self.tableJaunt.register(MainTableViewCell.self, forCellReuseIdentifier: "subtotalReuse")
        self.tableJaunt.register(MainTableViewCell.self, forCellReuseIdentifier: "totalReuse")
        self.tableJaunt.register(MainTableViewCell.self, forCellReuseIdentifier: "ccReuse")
        self.tableJaunt.register(MainTableViewCell.self, forCellReuseIdentifier: "ccDescriptionReuse")
        self.tableJaunt.estimatedRowHeight = 50
        self.tableJaunt.rowHeight = UITableViewAutomaticDimension
        self.tableJaunt.backgroundColor = uicolorFromHex(0xe8e6df)
        self.view.addSubview(self.tableJaunt)
        
        //load price stuff
        self.priceView.addButton("Reload") {
            self.priceView.dismiss(animated: true, completion: nil)
            self.loadPrice()
        }
        self.loadPrice()
        
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
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
            
        } else if didShare {
            return 2
            
        } else {
            return 4
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 && indexPath.row == 2{
            choosePaymentAction()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: MainTableViewCell!
        
        if indexPath.section == 0{
            cell = tableView.dequeueReusableCell(withIdentifier: "summaryReuse", for: indexPath) as! MainTableViewCell
            cell.selectionStyle = .none
            self.tableJaunt.separatorStyle = .none
            cell.summaryTitle.text = healthConcernSummary
            cell.durationLabel.text = healthConcernDuration
            cell.videoButton.setImage(image, for: .normal)
            cell.videoButton.addTarget(self, action: #selector(self.questionVideoAction(_:)), for: .touchUpInside)
            
        } else {
            self.tableJaunt.separatorStyle = .singleLine

            switch indexPath.row{
            case 0:
                cell = tableView.dequeueReusableCell(withIdentifier: "subtotalReuse", for: indexPath) as! MainTableViewCell
                cell.selectionStyle = .none
                //multiplying numbers by 0.1 to convert from cents to dollar amount
                let nursePrice = Double(nurse_fee) * 0.01
                let stringNurse = String(format:"%.2f", nursePrice)
                cell.nursePrice.text = "$\(stringNurse)"
                
                let bookingPrice = Double(booking_fee) * 0.01
                let stringBooking = String(format:"%.2f", bookingPrice)
                cell.bookingPrice.text = "$\(stringBooking)"
                
                let discountPrice = Double(discount) * 0.01
                let stringDiscount = String(format:"%.2f", discountPrice)
                cell.discountPrice.text = "$\(stringDiscount)"
                break
                
            case 1:
                cell = tableView.dequeueReusableCell(withIdentifier: "totalReuse", for: indexPath) as! MainTableViewCell
                cell.selectionStyle = .none
                //gotta convert from cents to dollars
                let totalPrice = Double(total) * 0.01
                let stringPrice = String(format:"%.2f", totalPrice)
                cell.totalPrice.text = "$\(stringPrice)"
                if didShare{
                    self.tableJaunt.separatorStyle = .none
                }
                break
                
            case 2:
                cell = tableView.dequeueReusableCell(withIdentifier: "ccReuse", for: indexPath) as! MainTableViewCell
                cell.selectionStyle = .none
                cell.ccImage.image = ccImage
                cell.ccLabel.text = creditCard
                cell.addLabel.text = addLabel
                self.tableJaunt.separatorStyle = .none
                break
                
            case 3:
                cell = tableView.dequeueReusableCell(withIdentifier: "ccDescriptionReuse", for: indexPath) as! MainTableViewCell
                self.tableJaunt.separatorStyle = .none
                cell.backgroundColor = uicolorFromHex(0xe8e6df)
                
            default:
                break
            }
        }
    
        return cell
    }
    
    //UI Action
    
    @objc func askQuestionAction(_ sender: UIButton) {
        if didShare{
            bulletinManager.prepare()
            bulletinManager.presentBulletin(above: self)
            
        } else {
            if tokenId != nil{
                bulletinManager.prepare()
                bulletinManager.presentBulletin(above: self)
                
            } else {
                SCLAlertView().showError("Credit Card Required", subTitle: "Enter your credit card info before checkout.")
            }
        }
    }
    
    func choosePaymentAction() {
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
        addLabel = "Change"
        self.tableJaunt.reloadData()
        self.dismiss(animated: true, completion: nil)
    }
    
    func createCharge(){
        let p: Parameters = [
            "total": total,
            "description": "\(String(describing: PFUser.current()!.email!))'s Sickcall",
            "token": tokenId,
            "email": PFUser.current()!.email!,
            "didShare": didShare
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
    
    func loadPrice(){
        self.startAnimating()
        Alamofire.request(self.priceURL, method: .get, encoding: JSONEncoding.default).validate().responseJSON { response in
            switch response.result {
            case .success(let data):
                let json = JSON(data)
                
                self.booking_fee = json["booking_fee"].int!
                self.nurse_fee = json["advisor_fee"].int!
                self.discount = json["discount"].int!
                self.total = self.booking_fee + self.nurse_fee
                
                //showPromo
                self.shareManager.prepare()
                self.shareManager.presentBulletin(above: self)
                //
                self.tableJaunt.reloadData()
                self.stopAnimating()
                
            case .failure(let error):
                print(error)
                self.stopAnimating()
                let alert = UIAlertController(title: "Something Went Wrong", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Reload", style: .default, handler: { action in
                    alert.dismiss(animated: true, completion: nil)
                    self.loadPrice()
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func shareAction(){
        let textItem = "I'm getting my health concern assessed by a registered nurse through @sickallhealth !"
        let linkItem : NSURL = NSURL(string: "https://www.sickcallhealth.com/app")!
        // If you want to put an image
        
        let activityViewController : UIActivityViewController = UIActivityViewController(
            activityItems: [linkItem, textItem], applicationActivities: nil)
        
        activityViewController.excludedActivityTypes = [
            .message,
            .copyToPasteboard,
            .mail,
            .addToReadingList,
            UIActivityType(rawValue: "com.apple.mobilenotes.SharingExtension"),
            UIActivityType(rawValue: "com.apple.reminders.RemindersEditorExtension")
        ]
        
        activityViewController.completionWithItemsHandler = { activity, success, items, error in
            print(activity!)
            if activity != nil{
                self.total = self.total - self.discount
                self.didShare = true
                self.tableJaunt.reloadData()
                
            } else {
                self.discount = 0
                self.tableJaunt.reloadData()
            }
        }
        
        self.shareManager.dismissBulletin(animated: true)
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func uicolorFromHex(_ rgbValue:UInt32)->UIColor{
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }
}
