//
//  NewQuestionViewController.swift
//  Celecare
//
//  Created by Dom Smith on 8/7/17.
//  Copyright © 2017 Celecare LLC. All rights reserved.
//

import UIKit
import UserNotifications
import SCLAlertView

class NewQuestionViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        clearTmpDirectory()
        
        let current = UNUserNotificationCenter.current()
        current.getNotificationSettings(completionHandler: { (settings) in
            if settings.authorizationStatus == .notDetermined {
                //UNUserNotificationCenter.current().delegate = self
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
                    (granted, error) in

                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        })
    }
    
    @IBAction func continueAction(_ sender: UIButton) {
        performSegue(withIdentifier: "showBasicInfo", sender: self)
    }
    
    @IBAction func callAction(_ sender: UIButton) {
        if let url = URL(string: "tel://911)"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    func clearTmpDirectory(){
        let path = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
        let manager = FileManager.default
        let files = try? manager.contentsOfDirectory(atPath: path.path)
        files?.forEach { (file) in
            let temp = path.appendingPathComponent(file)
            try? manager.removeItem(at: temp)
            
            // --- you can use do{} catch{} for error handling ---//
        }
    }
}
