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

` ` ` `

