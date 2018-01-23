# Sickcall
### Health answers from U.S. Registered Nurses

Features
======
* Use video to explain your health concern in detail
* Get a reply from a U.S. registered nurse with a low, medium, or high serious level
* Get additional info based off of your symptoms

Demo: 

<a href="http://www.youtube.com/watch?feature=player_embedded&v=m6YOx5oYY0o
" target="_blank"><img src="http://img.youtube.com/vi/m6YOx5oYY0o/0.jpg" 
alt="Sickcall run through" width="240" height="180" border="10" /></a>

Component Libraries
======

Frameworks
-
##### Table of Contents
 [AVFoundation and AVKit](https://github.com/doms230/sickcall#avfoundation)
 
 [UserNotifications](https://github.com/doms230/sickcall#usernotifications)

### AVFoundation and AVKit
 * Used to record and playback the video that you record for your health concern.
 
 ```swift
 //Video variables and constants
 var videoFile: URL!
 let imagePicker: UIImagePickerController! = UIImagePickerController()
 let saveFileName = "/test.mp4"
 
 //code to show view for recording video 
 if (UIImagePickerController.isSourceTypeAvailable(.camera)) {
    if UIImagePickerController.availableCaptureModes(for: .rear) != nil {
         imagePicker.sourceType = .camera
         imagePicker.cameraDevice = .front
         imagePicker.mediaTypes = [kUTTypeMovie as String]
         imagePicker.allowsEditing = false
         imagePicker.videoMaximumDuration = 60
         imagePicker.videoQuality = .typeMedium
         imagePicker.delegate = self
         present(imagePicker, animated: true, completion: {})
 
        } else {
        //there was a problem, show alert 
         //postAlert("Rear camera doesn't exist", message: "Application cannot access the camera.")
        }
     
    } else {
    //there was a problem, show alert
     //postAlert("Camera inaccessable", message: "Application cannot access the camera.")
    }
    
    //user finished recording video, go to checkout
func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
    if let pickedVideo:URL = (info[UIImagePickerControllerMediaURL] as? URL) {
        videoFile = pickedVideo
        imagePicker.dismiss(animated: true, completion: {
        self.performSegue(withIdentifier: "showCheckout", sender: self)
        })
    
    } else {
    //video pick failed, dismiss
    imagePicker.dismiss(animated: true, completion: nil)
    }
}
 ```
 
```swift

//checkout
//compress video to lower file size for the database
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

//generate screenshot from video
func videoPreviewImage() -> UIImage? {
    let asset = AVURLAsset(url: pickedFile)
    let generator = AVAssetImageGenerator(asset: asset)
    generator.appliesPreferredTrackTransform = true
    let timestamp = CMTime(seconds: 2, preferredTimescale: 60)
    do {
        let imageRef = try generator.copyCGImage(at: timestamp, actualTime: nil)
        return UIImage(cgImage: imageRef)
    }

    catch{
        self.image = UIImage(named: "appy")
        return nil
    }
}
```

### UserNotifications
* Used to register push notifications to the user's phone

Sickcall shows a custom alert detailing why they show enable notifications. It would be really annoying to get this message everytime you open the app so a UserDefault is set to record when the user is shown the alert for the first time.

```swift
if UserDefaults.standard.object(forKey: "notifications") == nil{
    //prepare the custom external framework BulletinBoard alert
    self.notificationsManager.prepare()
    self.notificationsManager.presentBulletin(above: self)
}

//show custom BulletinBoard alert
lazy var notificationsManager: BulletinManager = {
    let page = PageBulletinItem(title: "Notifications")
    page.image = UIImage(named: "bell")
    page.descriptionText = "Sickcall uses notifications to let you know when you nurse advisor replies to your health concern."
    page.actionButtonTitle = "Okay"
    page.interfaceFactory.tintColor = color.sickcallGreen()
    page.interfaceFactory.actionButtonTitleColor = .white
    page.isDismissable = true
    page.actionHandler = { (item: PageBulletinItem) in
        page.manager?.dismissBulletin()
        //show alert asking to enable notifications
         UserDefaults.standard.set(true, forKey: "notifications")
         let current = UNUserNotificationCenter.current()
         current.getNotificationSettings(completionHandler: { (settings) in
             if settings.authorizationStatus == .notDetermined {
                 UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
                 (granted, error) in

                 UIApplication.shared.registerForRemoteNotifications()
                 }
             }
         })
     }
     return BulletinManager(rootItem: page)

}()

```
External Libraries
-
External Libraries made Sickcall so much better. Thank you. Besides Google Search, I found many of these libraries from [iOS Cookies](http://www.ioscookies.com/). Check it out!

##### Table of Contents
 * [Stripe](https://github.com/doms230/sickcall#stripe)
 * [Alamofire & Swifty JSON](https://github.com/doms230/sickcall#alamofire)
 * [SnapKit](https://github.com/doms230/sickcall#snapkit)
 * [Parse](https://github.com/doms230/sickcall#parse)
 * [Facebook SDK](https://github.com/doms230/sickcall#facebooksdk)
 * [Kingfisher](https://github.com/doms230/sickcall#kingfisher)
 * [SCLAlertView](https://github.com/doms230/sickcall#sclalertview)
 * [BulletinBoard](https://github.com/doms230/sickcall#bulletinboard)
 * [NVActivityIndicatorView](https://github.com/doms230/sickcall#nvactivityindicatorview)
 
### [Stripe](https://stripe.com/)
* I used Stripe to process payments.

Stripe provides a nice plugin UI that collects the user's payment information

```swift

func choosePaymentAction() {
    let addCardViewController = STPAddCardViewController()
    addCardViewController.delegate = self
    // STPAddCardViewController must be shown inside a UINavigationController.
    let navigationController = UINavigationController(rootViewController: addCardViewController)
    self.present(navigationController, animated: true, completion: nil)
}

```
Once the user updates their payment, Stripe encypts the data and creates a token with all the payment information. I update the UI with the user's payment info so they know that their information was captured. This includes the last 4 digits of the card and an image of the type of card such as Visa.

```swift
func addCardViewController(_ addCardViewController: STPAddCardViewController, didCreateToken token: STPToken, completion: @escaping STPErrorBlock) {
    tokenId = token.tokenId;
    creditCard = (token.card?.last4)!
    ccImage = token.card?.image
    addLabel = "Change"
    self.tableView.reloadData()
    self.dismiss(animated: true, completion: nil)
}
```
### [Alamofire](https://github.com/Alamofire/Alamofire) & [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON)
* Alamofire and SwiftyJSON made the process of securely sending and retrieving payments data up to Sickcall's Node.js server ALOT easier.


The block of code below grabs the price from the server. The server responds with a JSON and is parsed using SwiftyJSON.

```swift
func loadPrice(){
    self.startAnimating()

    Alamofire.request(self.priceURL, method: .get, encoding: JSONEncoding.default).validate().responseJSON { response in
        switch response.result {
        case .success(let data):
            let json = JSON(data)

            self.booking_fee = json["booking_fee"].int!
            self.nurse_fee = json["advisor_fee"].int!
            self.total = self.booking_fee + self.nurse_fee

            self.tableView.reloadData()
            self.stopAnimating()

        case .failure(let error):
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
```

The block of code below is a method that sent the payments data to server.
```swift

func createCharge(){

    var baseURL = "https://celecare.herokuapp.com/payments/createTestCharge"
    //price total in cents
    var total = 699
    
    var tokenId = abc123
    
    let p: Parameters = [
    "total": total,
    "description": "\(String(describing: PFUser.current()!.email!))'s Sickcall",
    "token": tokenId,
    "email": PFUser.current()!.email!
    ]

    Alamofire.request(self.baseURL, method: .post, parameters: p, encoding: JSONEncoding.default).validate().responseJSON { response in
        switch response.result {
            case .success(let data):
            let json = JSON(data)

            if let status = json["statusCode"].int{
            let message = json["message"].string
            SCLAlertView().showError("Something Went Wrong", subTitle: message!)

            } else {
                self.chargeId = json["id"].string
                self.hasUserPaid = true
                if self.isVideoCompressed{
                    self.postIt()
                }
            }

            case .failure(let error):
            SCLAlertView().showError("Charge Unsuccessful", subTitle: error.localizedDescription)
        }
    }
}
```
The block below is using Alamofire to send the health concern objectId up to the server where the user's nurse advisor will be determined.
```swift
var questionURL = "https://celecare.herokuapp.com/posts/assignQuestion"
var objectId = abc123

func assignQuestion(objectId: String){
    Alamofire.request(self.questionURL, method: .post, parameters: ["id": objectId], encoding: JSONEncoding.default).validate().response{response in
        self.stopAnimating()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "main") as! UITabBarController
        controller.selectedIndex = 1
        self.present(controller, animated: true, completion: nil)
    }
}
```

### [SnapKit](https://github.com/SnapKit/SnapKit)

*  SnapKit is A Swift Autolayout DSL for iOS & OS X

SnapKit is one of my favorite libraries. I'm not a fan of dragging and dropping elements because it never works well accross different devices. Without SnapKit you end up spending a lot of time trying to get the layout right.

Here's a code snippet of SnapKit in action in Sickcall from the  [loginViewController](https://github.com/doms230/sickcall/blob/master/Celecare/LoginViewController.swift)

```swift
    titleLabel.snp.makeConstraints { (make) -> Void in
        make.top.equalTo(self.view).offset(100)
        make.left.equalTo(self.view).offset(10)
        make.right.equalTo(self.view).offset(-10)
    }

    emailText.snp.makeConstraints { (make) -> Void in
        make.top.equalTo(titleLabel.snp.bottom).offset(10)
        make.left.equalTo(self.view).offset(10)
        make.right.equalTo(self.view).offset(-10)
    }

    passwordText.snp.makeConstraints { (make) -> Void in
        make.top.equalTo(emailText.snp.bottom).offset(10)
        make.left.equalTo(self.view).offset(10)
        make.right.equalTo(self.view).offset(-10)
    }

    signButton.snp.makeConstraints { (make) -> Void in
        make.top.equalTo(passwordText.snp.bottom).offset(10)
        make.right.equalTo(self.view).offset(-10)
    }
    
    forgotPasswordButton.snp.makeConstraints { (make) -> Void in
        make.top.equalTo(passwordText.snp.bottom).offset(10)
        make.left.equalTo(self.view).offset(10)
    }
```

### [Parse](https://github.com/parse-community)

* Parse made it easy for me to store and query data in a mongoDB


The code snippet below is an example of posting a new question [SummaryViewController](https://github.com/doms230/sickcall/blob/master/Celecare/SummaryViewController.swift)

```swift
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
        self.assignQuestion(objectId: newQuestion.objectId!)

        } else {
        SCLAlertView().showError("Post UnSuccessful", subTitle: "Check internet connection and try again.")
        }
    }
}
```
The code snippet below loads the user's questions [V2AnswerViewController](https://github.com/doms230/sickcall/blob/master/Celecare/V2ViewAnswerViewController.swift)
```swift
//load data
func loadData(){
    let query = PFQuery(className:"Post")
    query.whereKey("userId", equalTo: PFUser.current()!.objectId!)
    query.whereKey("isRemoved", equalTo: false)
    query.addDescendingOrder("createdAt")
    query.findObjectsInBackground {
    (objects: [PFObject]?, error: Error?) -> Void in
        if error == nil {
            if let objects = objects {
                for object in objects {
                    self.objectId.append(object.objectId!)
                    let url = object["videoScreenShot"] as! PFFile
                    self.questionImages.append(url.url!)
                    self.questions.append(object["summary"] as! String)

                    let isAnswered = object["isAnswered"] as! Bool
                    self.isAnswered.append(isAnswered)
                        if isAnswered{
                            self.questionStatus.append("Answered")
                            self.advisorUserId.append(object["advisorUserId"] as! String)

                        } else {
                            self.questionStatus.append("Pending Answer")
                            self.advisorUserId.append("nil")
                        }

                    self.questionDurations.append(object["duration"] as! String)

                    let rawCreatedAt = object.createdAt
                    let createdAt = DateFormatter.localizedString(from: rawCreatedAt!, dateStyle: .short, timeStyle: .short)

                    self.dateUploaded.append(createdAt)

                    //
                    self.level.append(object["level"] as! String)
                    self.comments.append(object["comment"] as! String)
                    self.questionVideos.append(object["video"] as! PFFile)
                }

            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
            self.stopAnimating()
        
            }
        }
    }
}
```
### [Facebook SDK](https://developers.facebook.com/docs/swift)
* I used Facebook login for a quick and easy login experience

[SignupViewController](https://github.com/doms230/sickcall/blob/master/Celecare/SignupViewController.swift)
```swift
@objc func facebookAction(_ sender: UIBarButtonItem){
    PFFacebookUtils.logInInBackground(withReadPermissions: ["public_profile","email"]){
        (user: PFUser?, error: Error?) -> Void in
        self.startAnimating()
        
            if user.isNew{
                let request = FBSDKGraphRequest(graphPath: "me",parameters: ["fields": "id, name, first_name, last_name, email, gender, picture.type(large)"], tokenString: FBSDKAccessToken.current().tokenString, version: nil, httpMethod: "GET")
                    let _ = request?.start(completionHandler: { (connection, result, error) in
                    guard let userInfo = result as? [String: Any] else { return } //handle the error

                    //The url is nested 3 layers deep into the result so it's pretty messy
                        if let imageURL = ((userInfo["picture"] as? [String: Any])?["data"] as? [String: Any])?["url"] as? String {

                        if let url = URL(string: imageURL){
                            if let data = NSData(contentsOf: url){
                            self.image = UIImage(data: data as Data)
                            }
                        }
                        let proPic = UIImageJPEGRepresentation(self.image, 0.5)
                        
                        //save new user to database once facebook profile photo is retrieved
                        self.retreivedImage = PFFile(name: "profile_ios.jpeg", data: proPic!)
                        self.retreivedImage?.saveInBackground{
                        (success: Bool, error: Error?) -> Void in
                            if (success){
                                user.email = userInfo["email"] as! String?
                                user["DisplayName"] = userInfo["first_name"] as! String?
                                user["Profile"] = self.retreivedImage
                                user["foodAllergies"] = []
                                user["gender"] = userInfo["gender"] as! String?
                                user["height"] = " "
                                user["medAllergies"] = []
                                user["weight"] = " "
                                user["birthday"] = " "
                                user["beatsPM"] = " "
                                user["healthIssues"] = " "
                                user["respsPM"] = " "
                                user["medHistory"] = " "
                                user.saveEventually{
                                (success: Bool, error: Error?) -> Void in
                                    if(success){
                                        self.stopAnimating()
                                        self.goHome()
                                    }
                                }
                            }
                        }
                    }
                })
            } else {
            self.stopAnimating()
            self.goHome()
            }
            
        } else {
        self.stopAnimating()
        }
    }
}

```

### [Kingfisher](https://github.com/onevcat/Kingfisher)
* Kingfisher handles downloading and caching images for you.

### [SCLAlertView](https://github.com/vikmeup/SCLAlertView-Swift)
* Custom animated Alertview

### [BulletinBoard](https://github.com/alexaubry/BulletinBoard)
* General-purpose contextual cards for iOS

### [NVActivityIndicatorView](https://github.com/ninjaprox/NVActivityIndicatorView)
* A collection of awesome loading animations









