//
//  DashboardViewController.swift
//  Celecare
//
//  Created by Mac Owner on 7/14/17.
//  Copyright © 2017 Celecare LLC. All rights reserved.
//

import UIKit
import Parse

class DashboardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var medLabel = [String]()
    var medDuration = [String]()
    var userId: String!
    var objectId: String!
    var videoFile: PFFile!
    
    let screenSize: CGRect = UIScreen.main.bounds
    
    var selectedIndex = 0
    
    var answerButton: UIButton!
    
    var advisorRec = ""
    
    var isOnline = false
    
    @IBOutlet weak var tableJaunt: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableJaunt.register(AdvisorTableViewCell.self, forCellReuseIdentifier: "statusReuse")
        self.tableJaunt.estimatedRowHeight = 50
        self.tableJaunt.rowHeight = UITableViewAutomaticDimension
        
        let button =  UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        //button.backgroundColor = UIColor.redColor()
        button.setTitle("Offline", for: .normal)
        button.setTitleColor(uicolorFromHex(0x180d22), for: .normal)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 16)
        // button.addTarget(self, action: #selector(ScheduleViewController.editProfileAction(_:)), for: UIControlEvents.touchUpInside)
        self.navigationItem.titleView = button
        
        //let verificationID = UserDefaults.standard.string(forKey: "status")
        if UserDefaults.standard.object(forKey: "status") != nil{
            isOnline = UserDefaults.standard.bool(forKey: "status")
            
        }
        
        loadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "statusReuse", for: indexPath) as! AdvisorTableViewCell
    
        
        //do something to see if person is online or not 
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //segue to question jautn
        /*if indexPath.section == 0{
         playVideo(videoJaunt: videoFile)
         selectedIndex = indexPath.row
         }        */
        
        if isOnline{
            UserDefaults.standard.set(true, forKey: "status")
            
        } else {
            UserDefaults.standard.set(false, forKey: "status")
        }
    }
    
    //TODO: change userId to something proper
    func loadData(){
        let userId = PFUser.current()?.objectId
        let query = PFQuery(className: "_User")
        query.whereKey("objectId", equalTo: userId!)
        query.getFirstObjectInBackground {
            (object: PFObject?, error: Error?) -> Void in
            if error != nil || object == nil {
                
                
            } else {
                self.tableJaunt.reloadData()
                
            }
        }
    }
    

    
    func uicolorFromHex(_ rgbValue:UInt32)->UIColor{
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }

}
