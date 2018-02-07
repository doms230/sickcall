//
//  MainSidebarViewController.swift
//  Sickcall
//
//  Created by Dominic Smtih on 7/19/17.
//  Copyright © 2017 Sickcall LLC All rights reserved.
//

import UIKit
import Parse
import Kingfisher

class MainSidebarViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var nameString: String!
    var imageString: String!
    
    @IBOutlet weak var tableView: UITableView!
    
    var isAdvisor = false
    
    //profile info is sent to edit profile... so if user taps before loaded, will crash
    var hasProfileLoaded = false
    
    lazy var titleButton: UIButton = {
        let button =  UIButton(frame: CGRect(x: 0, y: 0, width: 150, height: 40))
        button.setTitle("", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 16)
        button.isEnabled = false
        return button
    }()
    
    lazy var titleImage: UIImageView = {
        let button =  UIImageView(frame: CGRect(x: -10, y: 5, width: 30, height: 30))
        button.layer.cornerRadius = 15
        button.clipsToBounds = true
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(MainTableViewCell.self, forCellReuseIdentifier: "profileReuse")
        self.tableView.estimatedRowHeight = 50
        self.tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .none

        let query = PFQuery(className: "_User")
        query.whereKey("objectId", equalTo: PFUser.current()!.objectId!)
        query.getFirstObjectInBackground {
            (object: PFObject?, error: Error?) -> Void in
            if error == nil || object != nil {
                let imageFile: PFFile = object!["Profile"] as! PFFile
                
                let name = object!["DisplayName"] as! String
                self.titleButton.setTitle("\(name)", for: .normal)
                self.nameString = name
                
                let image = imageFile.url!
                self.imageString = image
                self.titleImage.kf.setImage(with: URL(string: image ))
                self.titleButton.addSubview(self.titleImage)
                
                let leftItem = UIBarButtonItem(customView: self.titleButton)
                
                self.navigationItem.setLeftBarButton(leftItem, animated: true)
                self.tableView.reloadData()
                self.loadAdvisor()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let desti = segue.destination as! EditProfileViewController
        desti.nameString = nameString
        desti.imageString = imageString
        desti.isAdvisor = isAdvisor
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if hasProfileLoaded{
            return 1
            
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileReuse", for: indexPath) as! MainTableViewCell

        cell.editProfileButton.addTarget(self, action: #selector(self.editProfile(_:)), for: .touchUpInside)
        cell.supportButton.addTarget(self, action: #selector(supportAction(_:)), for: .touchUpInside)
        cell.shareButton.addTarget(self, action: #selector(self.shareAction(_:)), for: .touchUpInside)
        cell.selectionStyle = .none
        return cell
    }
    
    @objc func editProfile(_ sender: UIButton){
        self.performSegue(withIdentifier: "showEditProfile", sender: self)
    }
    
    @objc func supportAction(_ sender: UIButton) {
        let url = URL(string : "https://www.sickcallhealth.com/advisor/app" )
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }
    
    @objc func shareAction(_ sender: UIButton){
        let textItem = "Find out how serious your health concern is through Sickcall!"
        let linkItem : NSURL = NSURL(string: "https://www.sickcallhealth.com/app")!
        
        let activityViewController : UIActivityViewController = UIActivityViewController(
            activityItems: [linkItem, textItem], applicationActivities: nil)
        
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func loadAdvisor(){
        let query = PFQuery(className: "Advisor")
        query.whereKey("userId", equalTo: PFUser.current()!.objectId!)
        query.getFirstObjectInBackground {
            (object: PFObject?, error: Error?) -> Void in
            self.hasProfileLoaded = true
            if error == nil || object != nil {
                let isActive = object?["isActive"] as! Bool
                
                if isActive{
                    self.isAdvisor = true
                }
                self.tableView.reloadData()
                
            } else {
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func signoutAction(_ sender: UIBarButtonItem) {
        PFUser.logOut()
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "welcome")
        self.present(controller, animated: true, completion: nil)
    }
    
}
