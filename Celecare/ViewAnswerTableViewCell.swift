//
//  ViewAnswerTableViewCell.swift
//  Celecare
//
//  Created by Dom Smith on 8/14/17.
//  Copyright © 2017 Celecare LLC. All rights reserved.
//

import UIKit
import SnapKit

class ViewAnswerTableViewCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        if reuseIdentifier == "patientReuse"{
            self.addSubview(patientImage)
            self.addSubview(patientName)
            
            patientImage.snp.makeConstraints { (make) -> Void in
                make.height.width.equalTo(50)
                make.top.equalTo(self).offset(20)
                make.left.equalTo(self).offset(10)
                // make.right.equalTo(self).offset(-20)
            }
            
            patientName.snp.makeConstraints { (make) -> Void in
                make.top.equalTo(patientImage).offset(6)
                make.left.equalTo(patientImage.snp.right).offset(5)
                make.right.equalTo(self).offset(-20)
            }
            
            configureQuestionSubviews()
            
        } else if reuseIdentifier == "advisorReuse"{
            
            configureAdvisorSubviews()
        }
    }
    
    // We won’t use this but it’s required for the class to compile
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    //advisor 
    lazy var advisorImage: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = UIColor.black
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 25
        image.clipsToBounds = true
        image.image = UIImage(named: "appy")
        return image
    }()
    
    lazy var advisorName: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 25)
        label.text = "Name"
        label.textColor = UIColor.black
        label.numberOfLines = 0
        return label
    }()
    
    lazy var levelLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
        label.text = "Level"
        label.textColor = UIColor.black
        label.layer.cornerRadius = 3
        label.clipsToBounds = true 
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    lazy var optionsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
        label.text = "Potential Options"
        label.textColor = UIColor.black
        label.numberOfLines = 0
        return label
    }()
    
    lazy var optionsBody: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue", size: 18)
        label.text = "Options"
        label.textColor = UIColor.black
        label.numberOfLines = 0
        return label
    }()
    
    lazy var commentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
        label.text = "Additional Comments"
        label.textColor = UIColor.black
        label.numberOfLines = 0
        return label
    }()
    
    lazy var commentBody: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue", size: 18)
        label.text = "Additional Comments"
        label.textColor = UIColor.black
        label.numberOfLines = 0
        return label
    }()
    
    func configureAdvisorSubviews(){
        self.addSubview(advisorImage)
        self.addSubview(advisorName)
        self.addSubview(levelLabel)
        self.addSubview(optionsLabel)
        self.addSubview(optionsBody)
        self.addSubview(commentLabel)
        self.addSubview(commentBody)
        
        advisorImage.snp.makeConstraints { (make) -> Void in
            make.height.width.equalTo(50)
            make.top.equalTo(self).offset(20)
            make.left.equalTo(self).offset(10)
            // make.right.equalTo(self).offset(-20)
        }
        
        advisorName.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(advisorImage).offset(6)
            make.left.equalTo(advisorImage.snp.right).offset(5)
            make.right.equalTo(self).offset(-20)
        }
        
        levelLabel.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(100)
            make.top.equalTo(advisorName.snp.bottom).offset(5)
            make.left.equalTo(advisorName)
           // make.right.equalTo(self).offset(-20)
            //make.bottom.equalTo(self).offset(-20)
        }
        
        optionsLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(levelLabel.snp.bottom).offset(10)
            make.left.equalTo(levelLabel)
            make.right.equalTo(self).offset(-20)
        }
        
        optionsBody.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(optionsLabel.snp.bottom)
            make.left.equalTo(levelLabel)
            make.right.equalTo(self).offset(-20)
        }
        
        commentLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(optionsBody.snp.bottom).offset(10)
            make.left.equalTo(levelLabel)
            make.right.equalTo(self).offset(-20)
        }
        
        commentBody.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(commentLabel.snp.bottom)
            make.left.equalTo(levelLabel)
            make.right.equalTo(self).offset(-20)
            make.bottom.equalTo(self).offset(-20)
        }
    }
    
    //patient
    lazy var patientImage: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = UIColor.black
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 25
        image.clipsToBounds = true
        image.image = UIImage(named: "appy")
        return image
    }()
    
    lazy var patientName: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 25)
        label.text = "Basic Information"
        label.textColor = UIColor.black
        label.numberOfLines = 0
        return label
    }()
    
    lazy var summaryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
        label.text = "Summary"
        label.textColor = UIColor.black
        label.numberOfLines = 0
        return label
    }()
    
    lazy var summaryBody: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue", size: 18)
        label.text = "Summary"
        label.textColor = UIColor.black
        label.numberOfLines = 0
        return label
    }()
    
    lazy var durationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
        label.text = "Duration"
        label.textColor = UIColor.black
        label.numberOfLines = 0
        return label
    }()
    
    lazy var durationBody: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue", size: 18)
        label.text = "duration"
        label.textColor = UIColor.black
        label.numberOfLines = 0
        return label
    }()
    
    lazy var videoButton: UIButton = {
        let button = UIButton()
        //button.setImage(UIImage(named: "people"), for: .normal)
        button.contentHorizontalAlignment = .left
        button.layer.cornerRadius = 3
        button.clipsToBounds = true
        button.backgroundColor = UIColor.white
        return button
    }()
    
    lazy var videoPreview: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 3
        view.clipsToBounds = true
        return view
    }()
    
    
    func configureQuestionSubviews(){
       /* self.addSubview(videoButton)
        self.videoButton.addSubview(summaryLabel)
        self.videoButton.addSubview(summaryBody)
        self.videoButton.addSubview(durationLabel)
        self.videoButton.addSubview(durationBody)
        self.videoButton.addSubview(videoPreview)*/
        
        self.addSubview(videoButton)
        self.addSubview(summaryLabel)
        self.addSubview(summaryBody)
        self.addSubview(durationLabel)
        self.addSubview(durationBody)
        //self.addSubview(videoPreview)
        
        /*videoPreview.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(50)
            make.top.equalTo(videoButton).offset(5)
            make.left.equalTo(videoButton).offset(5)
            //make.right.equalTo(self).offset(-20)
            //make.bottom.equalTo(self).offset(-20)
        }*/
        
        durationLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(videoPreview)
            make.left.equalTo(videoPreview.snp.right).offset(5)
            make.right.equalTo(self).offset(-5)
        }
        
        durationBody.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(durationLabel.snp.bottom).offset(1)
            make.left.equalTo(videoPreview.snp.right).offset(5)
            make.right.equalTo(self).offset(-5)
        }
        
        summaryLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(durationBody.snp.bottom).offset(1)
            make.left.equalTo(videoPreview.snp.right).offset(5)
            make.right.equalTo(self).offset(-5)
        }
        
        summaryBody.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(summaryLabel.snp.bottom)
            make.left.equalTo(videoPreview.snp.right).offset(5)
            make.right.equalTo(self).offset(-5)
            make.bottom.equalTo(self).offset(-20)
        }
        
        videoButton.snp.makeConstraints { (make) -> Void in
            //make.height.equalTo(150)
            make.top.equalTo(patientImage.snp.bottom).offset(5)
            make.left.equalTo(patientName)
            make.right.equalTo(self).offset(-10)
            make.bottom.equalTo(summaryBody).offset(-20)
        }
    }
    
    
    
    
    
    
    
    ////
    
    lazy var basicInfo: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
        label.text = "Basic Information"
        label.textColor = UIColor.black
        label.numberOfLines = 0
        return label
    }()
    
    lazy var genderLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue", size: 18)
        label.text = "Summary"
        label.textColor = UIColor.black
        label.numberOfLines = 0
        return label
    }()
    
    lazy var birthdayLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue", size: 18)
        label.text = "Birthday"
        label.textColor = UIColor.black
        label.numberOfLines = 0
        return label
    }()
    
    lazy var heightLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue", size: 18)
        label.text = "Height"
        label.textColor = UIColor.black
        label.numberOfLines = 0
        return label
    }()
    
    lazy var weightLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue", size: 18)
        label.text = "Weight"
        label.textColor = UIColor.black
        label.numberOfLines = 0
        return label
    }()
    
    lazy var basicInfoView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 3
        view.clipsToBounds = true
        return view
    }()
    
    func configureInfo(){
        self.addSubview(basicInfoView)
        basicInfoView.addSubview(basicInfo)
        basicInfoView.addSubview(genderLabel)
        basicInfoView.addSubview(birthdayLabel)
        basicInfoView.addSubview(heightLabel)
        basicInfoView.addSubview(weightLabel)
        
        basicInfoView.snp.makeConstraints { (make) -> Void in
            //make.height.equalTo(150)
            make.top.equalTo(summaryBody.snp.bottom).offset(10)
            make.left.equalTo(videoButton)
            make.right.equalTo(self).offset(-10)
            make.bottom.equalTo(self).offset(-20)
        }
        
        basicInfo.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(basicInfoView)
            make.left.equalTo(basicInfoView.snp.left).offset(5)
            make.right.equalTo(self).offset(-5)
        }
        
        genderLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(basicInfo.snp.bottom)
            make.left.equalTo(basicInfoView.snp.left).offset(5)
            make.right.equalTo(self).offset(-5)
        }
        
        birthdayLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(genderLabel.snp.bottom)
            make.left.equalTo(basicInfoView.snp.left).offset(5)
            make.right.equalTo(self).offset(-5)
        }
        
        heightLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(birthdayLabel.snp.bottom)
            make.left.equalTo(basicInfoView.snp.left).offset(5)
            make.right.equalTo(self).offset(-5)
        }
        
        weightLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(heightLabel.snp.bottom)
            make.left.equalTo(basicInfoView.snp.left).offset(5)
            make.right.equalTo(self).offset(-10)
            make.bottom.equalTo(self).offset(-20)
        }
    }
    
    
}
