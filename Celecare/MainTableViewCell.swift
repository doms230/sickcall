//
//  MainTableViewCell.swift
//  Celecare
//
//  Created by Mac Owner on 7/6/17.
//  Copyright © 2017 Celecare LLC. All rights reserved.
//

import UIKit
import SnapKit

class MainTableViewCell: UITableViewCell {

    
    ///////////Patient Info for new question/////////////////
    
    lazy var basicInfoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 16)
        label.text = "Basic Information"
        label.textColor = UIColor.black
        label.numberOfLines = 0
        return label
    }()
    
    /////////////
    
    lazy var noQuestionsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 25)
        label.text = "You haven't asked any questions yet"
        label.textColor = UIColor.black
        label.numberOfLines = 0
        return label
    }()
    
    //question views
    lazy var questionImage: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = UIColor.black
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 5
        image.clipsToBounds = true
        return image
    }()
    
    //what the question is about
    lazy var questionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue", size: 20)
        label.textColor = UIColor.black
        label.numberOfLines = 0
        return label
    }()
    
    //how long problem has gone one
    lazy var durationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue", size: 18)
        label.textColor = UIColor.black
        label.numberOfLines = 0
        return label
    }()
        
    //status of the question.. either answer or pending answer
    lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 16)
        label.textColor = UIColor.black
        label.numberOfLines = 0
        return label
    }()
    
    //date question was asked
    lazy var dateUploadedLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue", size: 14)
        label.textColor = UIColor.black
        label.numberOfLines = 0
        return label
    }()
    
    
    ////////////////////////////
    
    //status
    lazy var loadingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 16)
        label.text = "Loading ..."
        label.textColor = UIColor.black
        label.numberOfLines = 0
        return label
    }()
    
    //segment
    lazy var segment: UISegmentedControl = {
        let items = ["Question", "Answer"]
        let segment = UISegmentedControl(items: items)
        segment.tintColor = UIColor.black
        segment.selectedSegmentIndex = 0
        return segment
    }()
    
    
    //advisorTab
    lazy var advisorImage: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = UIColor.black
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 50
        image.clipsToBounds = true
        return image
    }()
    
    lazy var advisorName: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 16)
        label.textColor = UIColor.black
        label.numberOfLines = 0
        return label
    }()
        
    //question tab
    lazy var patientImage: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = UIColor.black
        image.contentMode = .scaleAspectFill
        image.image = UIImage(named:"appy")
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
    
    lazy var videoButton: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 5
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.image = UIImage(named:"appy")
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
        
    //answer tab
    
    lazy var recommendationTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue", size: 14)
        label.text = "Recommendation"
        label.textColor = UIColor.black
        label.numberOfLines = 0
        return label
    }()
    
    lazy var recommendation: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 16)
        label.textColor = UIColor.black
        label.numberOfLines = 0
        return label
    }()
    
    lazy var answerVideoButton: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 5
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    lazy var answerWatchVideoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
        label.textColor = UIColor.black
        label.text = "View Answer"
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        if reuseIdentifier == "advisorReuse"{
            configureAdvisorSubview()
            
        } else if reuseIdentifier == "segmentReuse"{
            configureSegmentSubview()
            
        } else if reuseIdentifier == "questionReuse"{
            configureQuestionSubview()
            
        } else if reuseIdentifier == "answerReuse"{
            configureAnswerSubview()
            
        } else if reuseIdentifier == "loadingReuse"{
            self.addSubview(loadingLabel)
            
            loadingLabel.snp.makeConstraints { (make) -> Void in
                make.top.equalTo(self).offset(25)
                make.left.equalTo(self).offset(5)
                 make.right.equalTo(self).offset(-5)
                make.bottom.equalTo(self).offset(-25)
            }
         
            //Main - patients
        } else if reuseIdentifier == "myQuestionsReuse"{
            configureOverSubview()
            
        } else if reuseIdentifier == "noQuestionsReuse"{
            self.addSubview(noQuestionsLabel)
            noQuestionsLabel.snp.makeConstraints { (make) -> Void in
                make.top.equalTo(self).offset(25)
                make.left.equalTo(self).offset(10)
                make.right.equalTo(self).offset(-5)
                make.bottom.equalTo(self).offset(-25)
            }
        }
    }
    
    // We won’t use this but it’s required for the class to compile
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //overview question view 
    
    func configureOverSubview(){
        self.addSubview(questionImage)
        self.addSubview(questionLabel)
        self.addSubview(durationLabel)
        self.addSubview(statusLabel)
        self.addSubview(dateUploadedLabel)
        
        questionImage.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(100)
            make.top.equalTo(self).offset(25)
            make.left.equalTo(self).offset(10)
            // make.right.equalTo(self).offset(-10)
            //make.bottom.equalTo(self).offset(-5)
        }
        
        questionLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(questionImage.snp.top).offset(5)
            make.left.equalTo(questionImage.snp.right).offset(10)
            make.right.equalTo(self).offset(-5)
            //make.bottom.equalTo(self).offset(-25)
        }
        
        durationLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(questionLabel.snp.bottom).offset(5)
            make.left.equalTo(questionImage.snp.right).offset(10)
            make.right.equalTo(self).offset(-5)
            //make.bottom.equalTo(self).offset(-25)
        }
        
        statusLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(questionImage.snp.bottom).offset(5)
            make.left.equalTo(self).offset(10)
            make.right.equalTo(self).offset(-5)
            //make.bottom.equalTo(self).offset(-25)
        }
        
        dateUploadedLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(statusLabel.snp.bottom).offset(5)
            make.left.equalTo(self).offset(10)
            make.right.equalTo(self).offset(-5)
            make.bottom.equalTo(self).offset(-15)
        }
    }
    
    //detail question view
    
    func configureAdvisorSubview(){
        self.addSubview(advisorImage)
        self.addSubview(advisorName)
        
        advisorImage.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(100)
            make.top.equalTo(self).offset(25)
            make.left.equalTo(self).offset(125)
            // make.right.equalTo(self).offset(-10)
            //make.bottom.equalTo(self).offset(-5)
        }
        
        advisorName.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(advisorImage.snp.bottom).offset(10)
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
    
    func configureQuestionSubview(){
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
    
    func configureAnswerSubview(){
        self.addSubview(recommendationTitle)
        self.addSubview(recommendation)
        self.addSubview(answerVideoButton)
        self.addSubview(answerWatchVideoLabel)
        
        recommendationTitle.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self).offset(25)
            make.left.equalTo(self).offset(5)
            make.right.equalTo(self).offset(-5)
        }
        
        recommendation.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(recommendationTitle.snp.bottom).offset(5)
            make.left.equalTo(self).offset(5)
            make.right.equalTo(self).offset(-5)
        }
        
        answerVideoButton.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(100)
            make.height.equalTo(150)
            make.top.equalTo(recommendation.snp.bottom).offset(10)
            make.left.equalTo(self).offset(5)
            make.bottom.equalTo(self).offset(-5)
        }
        
        answerWatchVideoLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(answerVideoButton.snp.top).offset(75)
            make.left.equalTo(answerVideoButton.snp.right).offset(5)
            make.right.equalTo(self).offset(-5)
        }
    }
}
