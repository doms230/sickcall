//
//  DashboardViewController.swift
//  Celecare
//
//  Created by Mac Owner on 7/14/17.
//  Copyright © 2017 Celecare LLC. All rights reserved.
//

import UIKit
import Parse
import SidebarOverlay
import ParseLiveQuery
import SnapKit

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
    
    @IBOutlet weak var profileImage: UIButton!
    
    @IBOutlet weak var tableJaunt: UITableView!
    
    let liveQueryClient = ParseLiveQuery.Client()
    private var subscription: Subscription<Post>?
    var questionsQuery: PFQuery<Post>{
        return (Post.query()!
            .whereKey("advisorUserId", equalTo: PFUser.current()!.objectId!) as! PFQuery<Post> )
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startQuestionSubscription()
        
        self.title = "Dashboard"
        
        self.tableJaunt.register(AdvisorTableViewCell.self, forCellReuseIdentifier: "dashboardReuse")
        self.tableJaunt.estimatedRowHeight = 50
        self.tableJaunt.rowHeight = UITableViewAutomaticDimension
        self.tableJaunt.backgroundColor = uicolorFromHex(0xe8e6df)
        
        let query = PFQuery(className: "_User")
        query.whereKey("objectId", equalTo: PFUser.current()!.objectId!)
        query.getFirstObjectInBackground {
            (object: PFObject?, error: Error?) -> Void in
            if error != nil || object == nil {
                
                
            } else {
                let imageFile: PFFile = object!["Profile"] as! PFFile
                self.profileImage.kf.setImage(with: URL(string: imageFile.url!), for: .normal)
                self.profileImage.layer.cornerRadius = 30 / 2
                self.profileImage.clipsToBounds = true
                
            }
        }
        
       /* let button =  UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        //button.backgroundColor = UIColor.redColor()
        button.setTitle("Offline", for: .normal)
        button.setTitleColor(uicolorFromHex(0x180d22), for: .normal)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 16)
        // button.addTarget(self, action: #selector(ScheduleViewController.editProfileAction(_:)), for: UIControlEvents.touchUpInside)
        self.navigationItem.titleView = button*/
        
        loadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "dashboardReuse", for: indexPath) as! AdvisorTableViewCell
        
        cell.backgroundColor = uicolorFromHex(0xe8e6df)
        
        //cell.getPaidButton.backgroundColor = uicolorFromHex(0x180d22)
        
        if isOnline{
            cell.queueLabel.text = "You're in queue for a question"
            cell.statusButton.setTitle("Online", for: .normal)
            cell.statusButton.backgroundColor = uicolorFromHex(0x180d22)
            cell.statusButton.setTitleColor(.white, for: .normal)
            
        } else {
            cell.queueLabel.text = "Start answering questions to make money"
            cell.statusButton.setTitle("Go Online", for: .normal)
            cell.statusButton.backgroundColor = .white
            cell.statusButton.setTitleColor(.black, for: .normal)
        }
        
        cell.statusButton.addTarget(self, action: #selector(DashboardViewController.statusAction(_:)), for: .touchUpInside)
        
        //do something to see if person is online or not
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //segue to question jautn
        /*if indexPath.section == 0{
         playVideo(videoJaunt: videoFile)
         selectedIndex = indexPath.row
         }        */
    }
    
    func statusAction(_ sender: UIButton){
        if isOnline{
            isOnline = false
            
        } else {
            isOnline = true
        }
        
        let userId = PFUser.current()?.objectId
        let query = PFQuery(className: "_User")
        query.whereKey("objectId", equalTo: userId!)
        query.getFirstObjectInBackground {
            (object: PFObject?, error: Error?) -> Void in
            if error == nil || object != nil {
                
                object?["isOnline"] = self.isOnline
                if self.isOnline{
                    object?["questionQueue"] = Date()
                }
                
                object?.saveInBackground {
                    (success: Bool, error: Error?) -> Void in
                    if (success) {
                        //do something 
                    }
                }
                
                self.tableJaunt.reloadData()
                
            } else{
                //your offline message
            }
        }
    }
    
    @IBAction func menuAction(_ sender: UIButton) {
        if let container = self.so_containerViewController {
            container.isSideViewControllerPresented = true
        }
    }
    
    //live query
   /* */
    
    func startQuestionSubscription(){
        self.subscription = self.liveQueryClient
            .subscribe(self.questionsQuery)
            .handle(Event.updated) { _, object in
                //loaduser info here
                
                //insert new message below the host's description message
               // let createdAt = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .short)
                
                //print(object.objectId!)
                let storyboard = UIStoryboard(name: "Advisor", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "question") as UIViewController
                self.present(controller, animated: true, completion: nil)
        }
    }
     
    //TODO: change userId to something proper
    func loadData(){
        let userId = PFUser.current()?.objectId
        let query = PFQuery(className: "_User")
        query.whereKey("objectId", equalTo: userId!)
        query.getFirstObjectInBackground {
            (object: PFObject?, error: Error?) -> Void in
            if error == nil || object != nil {
                if object?["isOnline"] as! Bool{
                    self.isOnline = true
                }
                
                self.tableJaunt.reloadData()
                
            } else{
                //you're not connected to the internet message
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
