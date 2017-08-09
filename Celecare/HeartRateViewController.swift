//
//  HeartRateViewController.swift
//  Celecare
//
//  Created by Dom Smith on 8/8/17.
//  Copyright © 2017 Celecare LLC. All rights reserved.
//

import UIKit
import SCLAlertView

class HeartRateViewController: UIViewController {
    @IBOutlet weak var startButton: UIButton!

    @IBOutlet weak var heartRateImage: UIImageView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var bpmLabel: UILabel!
    var didPressStart = false
    var beatsPM: Int!
    
    //used to record the amount of times user taps button
    var taps = 0
    
    //timer jaunts FF8781
    var countdownTimer: Timer!
    var totalTime = 15
    
    var nextButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = " Vitals 1/2"
        
        nextButton = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextAction(_:)))
        self.navigationItem.setRightBarButton(nextButton, animated: true)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let desti = segue.destination as! RespRateViewController
        desti.beatsPM = "\(beatsPM)"
    }
    
    func nextAction(_ sender: UIBarButtonItem){
        if didPressStart{
            endTimer()
        } else {
            performSegue(withIdentifier: "showRespRate", sender: self)
        }
    }

    @IBAction func startAction(_ sender: UIButton) {
        if !didPressStart{
            taps = 0
            didPressStart = true
            sender.setTitle("0", for: .normal)
            sender.backgroundColor = uicolorFromHex(0xFF8781)
            nextButton.title = "Reset"
            nextButton.tintColor = uicolorFromHex(0xFF8781)
            
            countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
            
        } else {
            taps += 1
            sender.setTitle("\(taps)", for: .normal)
        }
    }
    
    func updateTime() {
        timerLabel.text = "\(timeFormatted(totalTime))"
        
        if totalTime != 0 {
            totalTime -= 1
        } else {
            endTimer()
        }
    }
    
    func endTimer() {
        if totalTime == 0{
            beatsPM = taps * 4
            SCLAlertView().showSuccess("Your BPM is \(beatsPM!)", subTitle: "")
            bpmLabel.text = "\(beatsPM!) Beats per Minute (BPM)"
            bpmLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
        }

        countdownTimer.invalidate()
        didPressStart = false
        startButton.setTitle("Start", for: .normal)
        startButton.backgroundColor = uicolorFromHex(0xF4FF81)
        nextButton.title = "Next"
        nextButton.tintColor = uicolorFromHex(0x180d22)
        timerLabel.text = "00:15"
        totalTime = 15
    }
    
    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        //     let hours: Int = totalSeconds / 3600
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    func uicolorFromHex(_ rgbValue:UInt32)->UIColor{
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }
}
