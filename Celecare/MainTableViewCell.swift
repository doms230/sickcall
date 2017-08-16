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
    
    ///view answer v2 ////
    
    

    
    ///////////Patient Info for new question/////////////////
    
    lazy var basicInfoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 16)
        label.text = "Basic Information"
        label.textColor = UIColor.black
        label.numberOfLines = 0
        return label
    }()
    
    ////////overview/////
    
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
    
    
    ////////////detail////////////////
    
    lazy var pendingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 25)
        label.text = "Your answer is Pending"
        label.textColor = UIColor.black
        label.numberOfLines = 0
        return label
    }()
    
    //profile 
   /* lazy var userImage: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = UIColor.black
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 50
        image.clipsToBounds = true
        return image
    }()
    
    lazy var userName: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue", size: 20)
        label.textColor = UIColor.black
        label.numberOfLines = 0
        return label
    }()*/
    
    lazy var editProfileButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 20)
        button.titleLabel?.textAlignment = .left
        button.setTitle("Edit Profile", for: .normal)
        button.setTitleColor(.black, for: .normal)
        //label.numberOfLines = 0
        return button
    }()
    
    lazy var advisorButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 20)
        button.titleLabel?.textAlignment = .left
        button.setTitle("Become Advisor", for: .normal)
        button.setTitleColor(.black, for: .normal)
        //label.numberOfLines = 0
        return button
    }()
    

    
    //status
    
    /*lazy var advisorImage: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = UIColor.black
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 25
        image.clipsToBounds = true
        return image
    }()
    
    lazy var advisorName: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
        label.textColor = UIColor.black
        label.numberOfLines = 0
        return label
    }()
    
    
    lazy var recommendationTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue", size: 20)
        label.text = "Recommendation"
        label.textColor = UIColor.black
        label.numberOfLines = 0
        return label
    }()
    
    lazy var recommendation: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
        label.textColor = UIColor.black
        label.numberOfLines = 0
        return label
    }()
    
    lazy var commentsTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue", size: 20)
        label.text = "Comments"
        label.textColor = UIColor.black
        label.numberOfLines = 0
        return label
    }()
    
    lazy var comments: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
        label.textColor = UIColor.black
        label.numberOfLines = 0
        return label
    }()*/
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        if reuseIdentifier == "profileReuse"{
           // self.addSubview(userImage)
           // self.addSubview(userName)
            self.addSubview(editProfileButton)
            self.addSubview(advisorButton)
            
           /* userImage.snp.makeConstraints { (make) -> Void in
                make.height.width.equalTo(50)
                make.top.equalTo(self).offset(25)
                make.center.equalTo(self)
               // make.left.equalTo(self).offset(100)
               //// make.right.equalTo(self).offset(-100)
                //make.bottom.equalTo(self).offset(-25)
            }
            
            userName.snp.makeConstraints { (make) -> Void in
                make.top.equalTo(userImage.snp.bottom)
                make.left.equalTo(self).offset(10)
                make.right.equalTo(self).offset(-10)
                //make.bottom.equalTo(self).offset(-25)
            }*/
            
            
            editProfileButton.snp.makeConstraints { (make) -> Void in
                make.top.equalTo(self).offset(25)
                make.left.equalTo(self).offset(10)
                make.right.equalTo(self).offset(-10)
                //make.bottom.equalTo(self).offset(-25)
            }
            
            advisorButton.snp.makeConstraints { (make) -> Void in
                make.top.equalTo(editProfileButton.snp.bottom).offset(10)
                make.left.equalTo(self).offset(10)
                make.right.equalTo(self).offset(-10)
                make.bottom.equalTo(self).offset(-25)
            }
            
        } else if reuseIdentifier == "pendingReuse"{
            self.addSubview(pendingLabel)
            pendingLabel.snp.makeConstraints { (make) -> Void in
                make.top.equalTo(self).offset(25)
                make.left.equalTo(self).offset(10)
                make.right.equalTo(self).offset(-5)
                make.bottom.equalTo(self).offset(-25)
            }
            
        }else if reuseIdentifier == "myQuestionsReuse"{
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
    
    /*func configureAnswerSubview(){
        
        self.addSubview(advisorImage)
        self.addSubview(advisorName)
        self.addSubview(recommendationTitle)
        self.addSubview(recommendation)
        self.addSubview(commentsTitle)
        self.addSubview(comments)
        
        advisorImage.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(50)
            make.top.equalTo(self).offset(25)
            make.left.equalTo(self).offset(10)
            // make.right.equalTo(self).offset(-10)
            //make.bottom.equalTo(self).offset(-5)
        }
        
        advisorName.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(advisorImage.snp.top).offset(10)
            make.left.equalTo(advisorImage.snp.right).offset(5)
            make.right.equalTo(self).offset(-5)
            //make.bottom.equalTo(self).offset(-25)
        }
        
        recommendationTitle.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(advisorImage.snp.bottom).offset(10)
            make.left.equalTo(self).offset(10)
            make.right.equalTo(self).offset(-5)
        }
        
        recommendation.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(recommendationTitle.snp.bottom).offset(5)
            make.left.equalTo(self).offset(10)
            make.right.equalTo(self).offset(-5)
        }
        
        commentsTitle.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(recommendation.snp.bottom).offset(10)
            make.left.equalTo(self).offset(10)
            make.right.equalTo(self).offset(-5)
        }
        
        comments.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(commentsTitle.snp.bottom).offset(5)
            make.left.equalTo(self).offset(10)
            make.right.equalTo(self).offset(-5)
            make.bottom.equalTo(self).offset(-25)
        }
    }*/
}
