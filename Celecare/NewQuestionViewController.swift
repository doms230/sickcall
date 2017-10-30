//
//  NewQuestionViewController.swift
//  Sickcall
//
//  Created by Dominic Smtih on 7/19/17.
//  Copyright © 2017 Socialgroupe Incorporated All rights reserved.
//

import UIKit
import UserNotifications
import SCLAlertView
import SnapKit

class NewQuestionViewController: UIViewController {
    
    var didAskQuestion = false
    
    lazy var signupButton: UIButton = {
        let button = UIButton()
        button.setTitle("Get Started", for: .normal)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 20)
        button.setTitleColor(.white, for: .normal)
        //label.numberOfLines = 0
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(signupButton)
        signupButton.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(50)
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
            make.bottom.equalTo(self.view).offset(-49)
        }
        signupButton.backgroundColor = uicolorFromHex(0x006a52)
        signupButton.addTarget(self, action: #selector(continueAction(_:)), for: .touchUpInside)
        
      /*  if didAskQuestion{
            self.tabBarController?.selectedIndex = 1
        }*/
        
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
    
    @objc func continueAction(_ sender: UIButton) {
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
    
    func uicolorFromHex(_ rgbValue:UInt32)->UIColor{
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }
}
