//
//  AdvisorTableViewCell.swift
//  Celecare
//
//  Created by Mac Owner on 7/11/17.
//  Copyright © 2017 Celecare LLC. All rights reserved.
//

import UIKit
import SnapKit

class AdvisorTableViewCell: UITableViewCell {

   
  //  @IBOutlet weak var statusLabel: UILabel!

   // @IBOutlet weak var statusButton: UIButton!
    
    //vitals
    
    @IBOutlet weak var medicationLabel: UILabel!
    
    @IBOutlet weak var durationLabel: UILabel!
    
    //question
    
    lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 30)
        label.textColor = UIColor.black
        label.numberOfLines = 0
        return label
    }()
    
    /*override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        if reuseIdentifier == "statusReuse"{
            self.addSubview(statusLabel)
            statusLabel.snp.makeConstraints { (make) -> Void in
                make.top.equalTo(self).offset(150)
                make.left.equalTo(self).offset(125)
                make.right.equalTo(self).offset(-125)
                make.bottom.equalTo(self).offset(-150)
            }
            
        } 
    }
    
    // We won’t use this but it’s required for the class to compile
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }*/
    
    //dashboard
    
    lazy var paymentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
       // view.layer.cornerRadius = 3
        view.clipsToBounds = true
        return view
    }()
    
    lazy var paymentsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue", size: 25)
        label.text = "Payments"
        label.textAlignment = .center
        label.textColor = UIColor.black
        label.numberOfLines = 0
        return label
    }()
    
    lazy var paymentAmount: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue", size: 40)
        label.text = "$0.00"
        label.textAlignment = .center
        label.textColor = UIColor.black
        label.numberOfLines = 0
        return label
    }()
    
    lazy var getPaidLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue", size: 15)
        label.text = "Payments are deposited to your bank account every Wednesday"
        label.textAlignment = .center
        label.textColor = UIColor.black
        label.numberOfLines = 0
        return label
    }()
    
    /*lazy var getPaidButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 16)
        button.setTitle("Get Paid", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
      //  button.numberOfLines = 0
        return button
    }()*/
    
    lazy var statusButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 16)
        //button.setImage(UIImage(named: "exit"), for: .normal)
        button.backgroundColor = UIColor.white
        button.layer.cornerRadius = 3
        button.clipsToBounds = true
        return button
    }()
    
    lazy var queueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue", size: 14)
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    //status jaunt
    lazy var patientImage: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = UIColor.black
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 25
        image.clipsToBounds = true
        return image
    }()
    
    lazy var patientName: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 16)
        label.textColor = UIColor.black
        label.numberOfLines = 0
        return label
    }()
    
    lazy var questionTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 25)
        label.text = "Health Concern"
        label.textColor = UIColor.black
        label.numberOfLines = 0
        return label
    }()
    
    lazy var questionContent: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue", size: 20)
        label.textColor = UIColor.black
        label.numberOfLines = 0
        return label
    }()
    
    //haven't watch video label
    lazy var watchVideoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 25)
        label.text = "View Question to Respond"
        label.textColor = UIColor.black
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        if reuseIdentifier == "patientReuse"{
            configurePatientSubview()

        } else if reuseIdentifier == "infoReuse"{
            self.addSubview(questionContent)
            self.addSubview(questionTitle)
            
            questionTitle.snp.makeConstraints { (make) -> Void in
                make.top.equalTo(self).offset(10)
                make.left.equalTo(self).offset(10)
                make.right.equalTo(self).offset(-10)
               // make.bottom.equalTo(self).offset(-5)
            }
            questionContent.snp.makeConstraints { (make) -> Void in
                make.top.equalTo(questionTitle.snp.bottom).offset(5)
                make.left.equalTo(self).offset(10)
                make.right.equalTo(self).offset(-10)
                make.bottom.equalTo(self).offset(-10)
            }
            
        } else if reuseIdentifier == "contentReuse"{


            
        } else if reuseIdentifier == "statusReuse"{
            self.addSubview(statusLabel)
            statusLabel.snp.makeConstraints { (make) -> Void in
                make.top.equalTo(self).offset(150)
                make.left.equalTo(self).offset(125)
                make.right.equalTo(self).offset(-125)
                make.bottom.equalTo(self).offset(-150)
            }
            
        } else if reuseIdentifier == "dashboardReuse"{
            configureDashboard()
            
        } else if reuseIdentifier == "noWatchVideoReuse"{
            self.addSubview(watchVideoLabel)
            watchVideoLabel.snp.makeConstraints { (make) -> Void in
                make.top.equalTo(self).offset(25)
                make.left.equalTo(self).offset(10)
                make.right.equalTo(self).offset(-10)
               // make.bottom.equalTo(self).offset(-150)
            }
        }
    }
    
    // We won’t use this but it’s required for the class to compile
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    //dashboard
    
    func configureDashboard(){
        
        //payments
        self.addSubview(paymentView)
        paymentView.addSubview(paymentsLabel)
        paymentView.addSubview(paymentAmount)
        paymentView.addSubview(getPaidLabel)
        
        paymentView.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(200)
            make.top.equalTo(self)
            make.left.equalTo(self)
            make.right.equalTo(self)
            // make.bottom.equalTo(self).offset(-50)
        }
        
        paymentsLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(paymentView.snp.top).offset(20)
            make.left.equalTo(paymentView.snp.left).offset(5)
            make.right.equalTo(paymentView.snp.right).offset(-5)
            // make.bottom.equalTo(self).offset(-50)
        }
        
        paymentAmount.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(paymentsLabel.snp.bottom).offset(5)
            make.left.equalTo(paymentView.snp.left).offset(5)
            make.right.equalTo(paymentView.snp.right).offset(-5)
           // make.bottom.equalTo(paymentView.snp.bottom).offset(-10)
        }
        
        getPaidLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(paymentAmount.snp.bottom).offset(15)
            make.left.equalTo(paymentView.snp.left).offset(10)
            make.right.equalTo(paymentView.snp.right).offset(-10)
            // make.bottom.equalTo(paymentView.snp.bottom).offset(-10)
        }
        
        //status
       self.addSubview(statusButton)
        self.addSubview(queueLabel)
        
        statusButton.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(50)
            make.top.equalTo(paymentView.snp.bottom).offset(15)
            make.left.equalTo(self).offset(10)
            make.right.equalTo(self).offset(-10)
           // make.bottom.equalTo(self).offset(-50)
        }
        
        queueLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(statusButton.snp.bottom).offset(5)
            make.left.equalTo(self).offset(5)
            make.right.equalTo(self).offset(-5)
            make.bottom.equalTo(self).offset(-10)
        }
    }
    
    //question
    
   func configurePatientSubview(){
        self.addSubview(patientImage)
        self.addSubview(patientName)

        patientImage.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(50)
            make.top.equalTo(self).offset(25)
            make.left.equalTo(self).offset(10)
            // make.right.equalTo(self).offset(-10)
            make.bottom.equalTo(self).offset(-25)
        }
        
        patientName.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(patientImage.snp.top).offset(10)
            make.left.equalTo(patientImage.snp.right).offset(5)
            make.right.equalTo(self).offset(-5)
            //make.bottom.equalTo(self).offset(-25)
        }
    }
}
