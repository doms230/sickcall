//
//  MainTableViewCell.swift
//  Sickcall
//
//  Created by Dominic Smith on 7/6/17.
//  Copyright © 2017 Sickcall All rights reserved.
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
        image.layer.cornerRadius = 25
        image.clipsToBounds = true
        return image
    }()
    
    //what the question is about
    lazy var questionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue", size: 20)
        label.textColor = UIColor.black
        label.numberOfLines = 1
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
    
    
    ////////////detail////////////////
    
    lazy var pendingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 25)
        label.text = "Your answer is Pending"
        label.textColor = UIColor.black
        label.numberOfLines = 0
        return label
    }()
    
    lazy var editProfileButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 20)
        button.titleLabel?.textAlignment = .left
        button.setTitle(" Edit Profile", for: .normal)
        button.setImage(UIImage(named: "user"), for: .normal)
        button.setTitleColor(.black, for: .normal)
        //label.numberOfLines = 0
        return button
    }()
    
    lazy var advisorButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 20)
        button.titleLabel?.textAlignment = .left
        button.setTitle("", for: .normal)
        button.setImage(UIImage(named: "medication"), for: .normal)
        button.setTitleColor(.black, for: .normal)
        //label.numberOfLines = 0
        return button
    }()
    
    //med History
    lazy var medHistoryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 25)
        label.text = ""
        label.textColor = UIColor.black
        label.numberOfLines = 0
        return label
    }()
    
    lazy var MedHistoryContent: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue", size: 20)
        label.text = ""
        label.textColor = UIColor.black
        label.numberOfLines = 0
        return label
    }()
    
    lazy var medHistoryButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 15)
        button.titleLabel?.textAlignment = .left
        button.setTitle("", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.textAlignment = .left
        //label.numberOfLines = 0
        return button
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        if reuseIdentifier == "profileReuse"{
           // self.addSubview(userImage)
           // self.addSubview(userName)
            self.addSubview(editProfileButton)
            self.addSubview(advisorButton)
            
            editProfileButton.snp.makeConstraints { (make) -> Void in
                make.top.equalTo(self).offset(25)
                make.left.equalTo(self).offset(10)
                //make.right.equalTo(self).offset(-10)
                //make.bottom.equalTo(self).offset(-25)
            }
            
            advisorButton.snp.makeConstraints { (make) -> Void in
                make.top.equalTo(editProfileButton.snp.bottom).offset(25)
                make.left.equalTo(self).offset(10)
                //make.right.equalTo(self).offset(-10)
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
        } else if reuseIdentifier == "medHistoryReuse"{
            self.addSubview(medHistoryLabel)
            self.addSubview(MedHistoryContent)
            self.addSubview(medHistoryButton)
            
            medHistoryLabel.snp.makeConstraints { (make) -> Void in
                make.top.equalTo(self).offset(20)
                make.left.equalTo(self).offset(10)
                make.right.equalTo(self).offset(-5)
            }
            
            MedHistoryContent.snp.makeConstraints { (make) -> Void in
                make.top.equalTo(medHistoryLabel.snp.bottom).offset(5)
                make.left.equalTo(self).offset(10)
                make.right.equalTo(self).offset(-5)
            }
            
            medHistoryButton.snp.makeConstraints { (make) -> Void in
                make.top.equalTo(MedHistoryContent.snp.bottom).offset(10)
                make.left.equalTo(self).offset(10)
                make.right.equalTo(self).offset(-5)
                make.bottom.equalTo(self)
            }
        }
    }
    
    //overview question view 
    
    func configureOverSubview(){
        self.addSubview(questionImage)
        self.addSubview(questionLabel)
       // self.addSubview(durationLabel)
        self.addSubview(statusLabel)
        //self.addSubview(dateUploadedLabel)
        
        questionImage.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(50)
            make.top.equalTo(self).offset(25)
            make.left.equalTo(self).offset(10)
            // make.right.equalTo(self).offset(-10)
            //make.bottom.equalTo(self).offset(-5)
        }
        
        questionLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(questionImage.snp.top).offset(5)
            make.left.equalTo(questionImage.snp.right).offset(10)
            make.right.equalTo(self).offset(-5)
            //make.bottom.equalTo(self)
        }
        
        statusLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(questionLabel.snp.bottom).offset(5)
            make.left.equalTo(questionImage.snp.right).offset(10)
            make.right.equalTo(self).offset(-5)
            make.bottom.equalTo(self).offset(-25)
        }
    }
    
    ///////////
    // We won’t use this but it’s required for the class to compile
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
