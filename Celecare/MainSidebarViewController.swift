//
//  MainSidebarViewController.swift
//  Celecare
//
//  Created by Mac Owner on 7/10/17.
//  Copyright © 2017 Celecare LLC. All rights reserved.
//

import UIKit
import Parse
import Kingfisher

class MainSidebarViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var nameJaunt: String!
    var imageJaunt: String!
    
    @IBOutlet weak var tableJaunt: UITableView!
    
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
        
        self.tableJaunt.register(MainTableViewCell.self, forCellReuseIdentifier: "profileReuse")
        self.tableJaunt.estimatedRowHeight = 50
        self.tableJaunt.rowHeight = UITableViewAutomaticDimension
        tableJaunt.separatorStyle = .none

        let query = PFQuery(className: "_User")
        query.whereKey("objectId", equalTo: PFUser.current()!.objectId!)
        query.getFirstObjectInBackground {
            (object: PFObject?, error: Error?) -> Void in
            if error == nil || object != nil {
                let imageFile: PFFile = object!["Profile"] as! PFFile
                
                let name = object!["DisplayName"] as! String
                self.titleButton.setTitle("\(name)", for: .normal)
                self.nameJaunt = name
                
                let image = imageFile.url!
                self.imageJaunt = image 
                self.titleImage.kf.setImage(with: URL(string: image ))
                self.titleButton.addSubview(self.titleImage)
                
                
                let leftItem = UIBarButtonItem(customView: self.titleButton)
                
                self.navigationItem.setLeftBarButton(leftItem, animated: true)
                self.tableJaunt.reloadData()
                self.loadAdvisor()
                
            } else {
                
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let desti = segue.destination as! EditProfileViewController
        desti.nameJaunt = nameJaunt
        desti.imageJaunt = imageJaunt
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
        cell.advisorButton.addTarget(self, action: #selector(self.switchAction(_:)), for: .touchUpInside)
        if isAdvisor{
            cell.advisorButton.setTitle(" Switch To Advisor", for: .normal)
            
        } else {
            cell.advisorButton.setTitle(" Become Advisor", for: .normal)
        }
        return cell
    }
    
    func switchAction(_ sender: UIButton) {
        //to determine which side to put advisor on when they get on the app
        UserDefaults.standard.set("advisor", forKey: "side")
        
        let storyboard = UIStoryboard(name: "Advisor", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "container") as! AdvisorContainerViewController
        controller.isAdvisor = isAdvisor
        self.present(controller, animated: true, completion: nil)
        
    }
    
    func editProfile(_ sender: UIButton){
        self.performSegue(withIdentifier: "showEditProfile", sender: self)
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
                self.tableJaunt.reloadData()
                
            } else {
                self.tableJaunt.reloadData()
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
