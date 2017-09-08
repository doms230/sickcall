//
//  QuestionViewController.swift
//  Celecare
//
//  Created by Mac Owner on 7/3/17.
//  Copyright © 2017 Celecare LLC. All rights reserved.
//

import UIKit
import Parse

import MobileCoreServices
import AVKit
import AVFoundation

class QuestionViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var videoFile: URL!
    
    var healthConcernDuration: String!
    var healthConcernSummary: String! 
    
    let imagePicker: UIImagePickerController! = UIImagePickerController()
    let saveFileName = "/test.mp4"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let desti = segue.destination as! SummaryViewController
        desti.healthConcernDuration = healthConcernDuration
        desti.healthConcernSummary = healthConcernSummary
        //TODO: uncomment later.. needed
        desti.pickedFile = videoFile
    }
    
    
    @IBAction func askQuestionAction(_ sender: UIButton) {
        
        if (UIImagePickerController.isSourceTypeAvailable(.camera)) {
            if UIImagePickerController.availableCaptureModes(for: .rear) != nil {
                
                imagePicker.sourceType = .camera
                imagePicker.mediaTypes = [kUTTypeMovie as String]
                imagePicker.allowsEditing = false
                imagePicker.videoMaximumDuration = 60
                imagePicker.videoQuality = .typeMedium
                imagePicker.delegate = self
                
                present(imagePicker, animated: true, completion: {})
            } else {
                postAlert("Rear camera doesn't exist", message: "Application cannot access the camera.")
            }
        } else {
            postAlert("Camera inaccessable", message: "Application cannot access the camera.")
        }
    }
    
    
    // MARK: UIImagePickerControllerDelegate delegate methods
    // Finished recording a video
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("Got a video")
        
        if let pickedVideo:URL = (info[UIImagePickerControllerMediaURL] as? URL) {
            
            videoFile = pickedVideo
                        
            imagePicker.dismiss(animated: true, completion: {
                // Anything you want to happen when the user saves an video
                self.performSegue(withIdentifier: "showCheckout", sender: self)
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
    
    func postAlert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message,
                                      preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
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
}
