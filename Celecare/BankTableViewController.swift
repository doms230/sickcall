//
//  BankTableViewController.swift
//  Celecare
//
//  Created by Dominic Smith on 7/26/17.
//  Copyright © 2017 Celecare LLC. All rights reserved.
//

import UIKit
import Parse
import Alamofire
import SwiftyJSON

class BankTableViewController: UITableViewController {

    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var routingTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Bank 3/3"
        let nextButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(nextAction(_:)))
        self.navigationItem.setRightBarButton(nextButton, animated: true)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
    }
    
    func nextAction(_ sender: UIBarButtonItem){
        
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
