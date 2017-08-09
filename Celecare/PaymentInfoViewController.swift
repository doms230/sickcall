//
//  PaymentInfoViewController.swift
//  Celecare
//
//  Created by Mac Owner on 7/6/17.
//  Copyright © 2017 Celecare LLC. All rights reserved.
//

import UIKit


class PaymentInfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var paymentMethods = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    
    //mark - tableview
    
    /*func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
     return "Plans"
     }*/
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
            //payment methods
        if section == 0{
            return paymentMethods.count
            
            //apple pay
        } else if section == 1 {
            return 1
            
            // add payment method
        } else {
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cardReuse", for: indexPath) as! MainTableViewCell
        
        //payment methods
     /*   if indexPath.section == 0{
            
            
            
        //apple pay
        } else if indexPath.section == 1 {
            cell.paymentLogo.image = UIImage(named: "applepay")
            cell.paymentLabel.text = "Apple Pay"
            
            
        //add payment method
        } else {
            cell.paymentLogo.image = UIImage(named: "add")
            cell.paymentLabel.text = "Add credit card"
            
        }*/
        
        
        /*if eventObjectId.count == 0{
         
         cell = tableView.dequeueReusableCell(withIdentifier: "nothingScheduledReuse", for: indexPath) as! MainTableViewCell
         self.tableJaunt.separatorStyle = .none
         
         if !refresh.isRefreshing{
         cell.noPlansLabel.isHidden = false
         cell.noPlansExplain.isHidden = false
         }
         
         } else {
         cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as! MainTableViewCell
         
         self.tableJaunt.separatorStyle = .singleLine
         
         cell.selectionStyle = .none
         if eventImage[indexPath.row] != " "{
         cell.eventImage.kf.setImage(with: URL(string: eventImage[indexPath.row])! , placeholder: UIImage(named: "appy"), options: nil, progressBlock: nil, completionHandler: nil)
         } else {
         
         cell.eventDescription.snp.makeConstraints { (make) -> Void in
         make.top.equalTo(cell.eventDate.snp.bottom).offset(20)
         make.left.equalTo(cell).offset(10)
         make.right.equalTo(cell).offset(-10)
         make.bottom.equalTo(cell).offset(-20)
         }
         }
         
         cell.eventTitle.text = eventTitle[indexPath.row]
         cell.eventDate.text = eventStartDate[indexPath.row]
         cell.eventDescription.text = eventDescription[indexPath.row]
         }*/
        
        return cell
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
