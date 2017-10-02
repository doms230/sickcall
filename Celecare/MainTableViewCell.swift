//
//  MainTableViewCell.swift
//  Sickcall
//
//  Created by Dominic Smith on 7/6/17.
//  Copyright © 2017 Socialgroupe Incorporated All rights reserved.
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
    lazy var questionView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        view.backgroundColor = .black 
        return view
    }()
    
    //what the question is about
    lazy var questionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 25)
        label.textColor = UIColor.white
        label.numberOfLines = 1
        return label
    }()
    
    //status of the question.. either answer or pending answer
    lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue", size: 15)
        label.textColor = UIColor.white
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
    
    lazy var addLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue", size: 15)
        label.text = ""
        label.textColor = UIColor.black
        label.numberOfLines = 0
        return label
    }()
    
    //new question checkout
    lazy var summaryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 25)
        label.text = "Summary"
        label.textColor = UIColor.black
        label.numberOfLines = 0
        return label
    }()
    
    lazy var summaryTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue", size: 20)
        label.text = ""
        label.textColor = UIColor.black
        label.numberOfLines = 0
        return label
    }()
    
    lazy var durationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue", size: 20)
        label.text = ""
        label.textColor = UIColor.black
        label.numberOfLines = 0
        return label
    }()
    
    lazy var videoButton: UIButton = {
        let button = UIButton()
        button.setTitle("", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 3
        button.clipsToBounds = true 
        //label.numberOfLines = 0
        return button
    }()
    
    lazy var checkoutLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 25)
        label.text = "Checkout"
        label.textColor = UIColor.black
        label.numberOfLines = 0
        return label
    }()
    
    lazy var totalLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue", size: 20)
        label.text = ""
        label.textColor = UIColor.black
        label.numberOfLines = 0
        return label
    }()
    
    
    lazy var creditCardButton: UIButton = {
        let button = UIButton()
        button.setTitle("Credit Card", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        //button.setImage(UIImage(named: "new"), for: .normal)
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
            self.addSubview(addLabel)
            
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
            
            addLabel.snp.makeConstraints { (make) -> Void in
                make.top.equalTo(MedHistoryContent.snp.bottom).offset(10)
                make.left.equalTo(self).offset(10)
                make.right.equalTo(self).offset(-5)
                make.bottom.equalTo(self).offset(-10)
            }
        } else if reuseIdentifier == "checkoutReuse"{
            configureCheckoutSubview()
        }
    }
    
    ///////////
    // We won’t use this but it’s required for the class to compile
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //overview question view 
    
    func configureOverSubview(){
        self.addSubview(questionView)
        self.questionView.addSubview(questionLabel)
        self.questionView.addSubview(statusLabel)
        //self.addSubview(dateUploadedLabel)
        
        questionView.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(100)
            make.top.equalTo(self).offset(20)
            make.left.equalTo(self).offset(10)
            make.right.equalTo(self).offset(-10)
            make.bottom.equalTo(self).offset(-20)
        }
        
        statusLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.questionView.snp.top).offset(20)
            make.left.equalTo(self.questionView.snp.left).offset(10)
            make.right.equalTo(self.questionView.snp.right).offset(-10)
        }
        
        questionLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(statusLabel.snp.bottom).offset(5)
            make.left.equalTo(self.questionView.snp.left).offset(10)
            make.right.equalTo(self.questionView.snp.right).offset(-10)
            //make.bottom.equalTo(self).offset(-20)
        }
    }
    
    func configureCheckoutSubview(){
        self.addSubview(summaryLabel)
        self.addSubview(summaryTitle)
        self.addSubview(durationLabel)
        self.addSubview(videoButton)
        self.addSubview(checkoutLabel)
        self.addSubview(totalLabel)
        self.addSubview(creditCardButton)
        
        summaryLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self).offset(20)
            make.left.equalTo(self).offset(10)
            make.right.equalTo(self).offset(-10)
        }
        
        summaryTitle.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(summaryLabel.snp.bottom).offset(5)
            make.left.equalTo(self).offset(10)
            make.right.equalTo(self).offset(-10)
        }
        
        durationLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(summaryTitle.snp.bottom).offset(5)
            make.left.equalTo(self).offset(10)
            make.right.equalTo(self).offset(-10)
        }
        
        videoButton.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(75)
            make.top.equalTo(durationLabel.snp.bottom).offset(5)
            make.left.equalTo(self).offset(10)
        }
        
        checkoutLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(videoButton.snp.bottom).offset(20)
            make.left.equalTo(self).offset(10)
            make.right.equalTo(self).offset(-10)
        }
        
        totalLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(checkoutLabel.snp.bottom).offset(5)
            make.left.equalTo(self).offset(10)
            make.right.equalTo(self).offset(-10)
        }
        
        creditCardButton.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(totalLabel.snp.bottom).offset(10)
            make.left.equalTo(self).offset(10)
            make.bottom.equalTo(self).offset(-20)
        }
    }
}
