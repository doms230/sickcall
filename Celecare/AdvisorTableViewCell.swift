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
    
    
    //meds jaunt
    lazy var medName: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 16)
        label.textColor = UIColor.black
        label.numberOfLines = 0
        return label
    }()
    lazy var medDuration: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue", size: 14)
        label.textColor = UIColor.black
        label.numberOfLines = 0
        return label
    }()

    
    //status jaunt
    lazy var patientImage: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = UIColor.black
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 50
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
    
    lazy var segment: UISegmentedControl = {
        let items = ["Info", "Medications"]
        let segment = UISegmentedControl(items: items)
        segment.tintColor = UIColor.black
        segment.selectedSegmentIndex = 0
        return segment
    }()
    
    lazy var healthConcernTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue", size: 14)
        label.text = "Health Concern"
        label.textColor = UIColor.black
        label.numberOfLines = 0
        return label
    }()
    
    lazy var healthConcern: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 16)
        label.textColor = UIColor.black
        label.numberOfLines = 0
        return label
    }()
    
    lazy var healthDuration: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 16)
        label.textColor = UIColor.black
        label.numberOfLines = 0
        return label
    }()
    
    lazy var healthDurationTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue", size: 14)
        label.textColor = UIColor.black
        label.text = "Duration"
        label.numberOfLines = 0
        return label
    }()
    
    lazy var videoButton: UIButton = {
        let image = UIButton()
        image.layer.cornerRadius = 5
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    lazy var watchVideoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
        label.textColor = UIColor.black
        label.text = "View Question"
        label.numberOfLines = 0
        return label
    }()
    
    /*lazy var questionAmount: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 14)
        label.textColor = UIColor.black
        label.numberOfLines = 0
        return label
    }()*/    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        if reuseIdentifier == "patientReuse"{
            configurePatientSubview()

        } else if reuseIdentifier == "segmentReuse"{
            configureSegmentSubview()
            
        } else if reuseIdentifier == "infoReuse"{
            configureInfoSubview()
            
        } else if reuseIdentifier == "statusReuse"{
            self.addSubview(statusLabel)
            statusLabel.snp.makeConstraints { (make) -> Void in
                make.top.equalTo(self).offset(150)
                make.left.equalTo(self).offset(125)
                make.right.equalTo(self).offset(-125)
                make.bottom.equalTo(self).offset(-150)
            }
        } else if reuseIdentifier == "medReuse"{
            configureMedSubview()
        }
        
    }
    
    // We won’t use this but it’s required for the class to compile
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
        func configureMedSubview(){
            self.addSubview(medName)
            self.addSubview(medDuration)
            
            medName.snp.makeConstraints { (make) -> Void in
                make.top.equalTo(self).offset(5)
                make.left.equalTo(self).offset(5)
                make.right.equalTo(self).offset(-5)
                //make.bottom.equalTo(self).offset(-5)
            }
            
            medDuration.snp.makeConstraints { (make) -> Void in
                make.top.equalTo(medName.snp.bottom).offset(3)
                make.left.equalTo(self).offset(5)
                make.right.equalTo(self).offset(-5)
                make.bottom.equalTo(self).offset(-5)
            }
    }
    
    
    func configurePatientSubview(){
        self.addSubview(patientImage)
        self.addSubview(patientName)

        patientImage.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(100)
            make.top.equalTo(self).offset(25)
            make.left.equalTo(self).offset(125)
           // make.right.equalTo(self).offset(-10)
           //make.bottom.equalTo(self).offset(-5)
        }
        
        patientName.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(patientImage.snp.bottom).offset(10)
            make.left.equalTo(self).offset(125)
            make.right.equalTo(self).offset(-10)
            make.bottom.equalTo(self).offset(-25)
        }
    }
    
    func configureSegmentSubview(){
        self.addSubview(segment)
        
        segment.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self).offset(5)
            make.left.equalTo(self).offset(5)
            make.right.equalTo(self).offset(-5)
            make.bottom.equalTo(self).offset(-5)
        }
    }
    
    func configureInfoSubview(){
        self.addSubview(healthConcernTitle)
        self.addSubview(healthConcern)
        self.addSubview(healthDurationTitle)
        self.addSubview(healthDuration)
        self.addSubview(videoButton)
        self.addSubview(watchVideoLabel)
        
        healthConcernTitle.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self).offset(25)
            make.left.equalTo(self).offset(5)
            make.right.equalTo(self).offset(-5)
            
        }

        healthConcern.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(healthConcernTitle.snp.bottom).offset(5)
            make.left.equalTo(self).offset(5)
            make.right.equalTo(self).offset(-5)
        
        }
        
        healthDurationTitle.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(healthConcern.snp.bottom).offset(10)
            make.left.equalTo(self).offset(5)
            make.right.equalTo(self).offset(-5)
        }
        
        healthDuration.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(healthDurationTitle.snp.bottom).offset(5)
            make.left.equalTo(self).offset(5)
            make.right.equalTo(self).offset(-5)
        }
        
        videoButton.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(100)
            make.height.equalTo(150)
            make.top.equalTo(healthDuration.snp.bottom).offset(10)
            make.left.equalTo(self).offset(5)
            make.bottom.equalTo(self).offset(-5)
        }
        
        watchVideoLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(videoButton.snp.top).offset(75)
            make.left.equalTo(videoButton.snp.right).offset(5)
            make.right.equalTo(self).offset(-5)
        }
        

        
    }
}
