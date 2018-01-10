#  Sickcall
## Health answers from U.S. Registered Nurses

Features
======
* Use video to explain your health concern in detail
* Get a reply from a U.S. registered nurse with a low, medium, or high serious level
* Get additional info based off of your symptoms

Component Libraries
======

Frameworks
-

* AVFoundation and AVKit
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

