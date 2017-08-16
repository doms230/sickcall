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
    //var nameJaunt: String!
    //var imageJaunt: String!
    
    @IBOutlet weak var tableJaunt: UITableView!
    
    lazy var userView: UIButton = {
        let button =  UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 16)
        button.isEnabled = false
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
              //  self.imageJaunt = imageFile.url!
               // self.nameJaunt = object!["DisplayName"] as? String
                
                self.userView.kf.setImage(with: URL(string: imageFile.url!), for: .normal)
                self.userView.setTitle(object!["DisplayName"] as? String, for: .normal)
                
                let leftItem = UIBarButtonItem(customView: self.userView)
                
                self.navigationItem.setLeftBarButton(leftItem, animated: true)
                self.tableJaunt.reloadData()
                
            } else {
                
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileReuse", for: indexPath) as! MainTableViewCell
       // cell.userName.text = nameJaunt
       // cell.userImage.kf.setImage(with: URL(string: self.imageJaunt))
        cell.editProfileButton.addTarget(self, action: #selector(self.editProfile(_:)), for: .touchUpInside)
        cell.advisorButton.addTarget(self, action: #selector(self.switchAction(_:)), for: .touchUpInside)
        
        return cell
    }
    
    func switchAction(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Advisor", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "container") as UIViewController
        self.present(controller, animated: true, completion: nil)
    }
    
    func editProfile(_ sender: UIButton){
        
    }
}
