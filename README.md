#  Sickcall
### Health answers from U.S. Registered Nurses

Features
======
* Use video to explain your health concern in detail
* Get a reply from a U.S. registered nurse with a low, medium, or high serious level
* Get additional info based off of your symptoms

Component Libraries
======

Frameworks
-
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

```swift

//Sickcall show a custom alert detailing why they show enable notifications.
//It would be really annoying to get this message everytime you open the app so a UserDefault
//is set to record when the is shown the alert
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
Once the user updates their payment, Stripe encypts the data and creates a token with all the payment information. I update the UI with the user's payment info so they know that their information was capture. This includes the last 4 digits of the card and an image of the type of card such as Visa.

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





