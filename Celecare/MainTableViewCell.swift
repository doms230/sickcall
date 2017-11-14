//
//  MainTableViewCell.swift
//  Sickcall
//
//  Created by Dominic Smith on 7/6/17.
//  Copyright © 2017 Sickcall LLC All rights reserved.
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
        label.font = UIFont(name: "HelveticaNeue", size: 15)
        label.text = ""
        label.textColor = UIColor.black
        label.numberOfLines = 0
        return label
    }()
    
    lazy var videoButton: UIButton = {
        let button = UIButton()
        button.setTitle("", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 50
        button.clipsToBounds = true 
        return button
    }()
    
    lazy var playImage: UIImageView = {
       let image = UIImageView()
        
        image.image = UIImage(named: "play")
        return image
    }()
    //
    lazy var nurseFeeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue", size: 17)
        label.text = "Registered nurse advsior fee"
        label.textColor = UIColor.black
        label.numberOfLines = 0
        return label
    }()
    
    lazy var nursePrice: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue", size: 17)
        label.text = "$0.00"
        label.textColor = UIColor.black
        label.numberOfLines = 0
        return label
    }()
    
    lazy var bookingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue", size: 17)
        label.text = "Booking fee"
        label.textColor = UIColor.black
        label.numberOfLines = 0
        return label
    }()
    
    lazy var bookingPrice: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue", size: 17)
        label.text = "$1.99"
        label.textColor = UIColor.black
        label.numberOfLines = 0
        return label
    }()
    
    lazy var discountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue", size: 17)
        label.text = "Discounts"
        label.textColor = UIColor.black
        label.numberOfLines = 0
        return label
    }()
    
    lazy var discountPrice: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue", size: 17)
        label.text = "$0.00"
        label.textColor = UIColor.black
        label.numberOfLines = 0
        return label
    }()
    
    
    lazy var totalLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
       // label.textAlignment = .center
        label.text = "Total"
        label.textColor = UIColor.black
        label.numberOfLines = 0
        return label
    }()
    
    lazy var totalPrice: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
        // label.textAlignment = .center
        label.text = "$0.00"
        label.textColor = UIColor.black
        label.numberOfLines = 0
        return label
    }()
    
    /*lazy var creditCardButton: UIButton = {
        let button = UIButton()
        button.setTitle("Credit Card", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.isEnabled = false
        //button.setImage(UIImage(named: "new"), for: .normal)
        return button
    }()*/
    
    lazy var ccImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "add")
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    lazy var ccLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue", size: 15)
        // label.textAlignment = .center
        label.text = "Card"
        label.textColor = UIColor.black
        label.numberOfLines = 0
        return label
    }()
    
    lazy var addCCLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue", size: 15)
        // label.textAlignment = .center
        label.text = "Add"
        label.textColor = UIColor.black
        label.numberOfLines = 0
        return label
    }()
    
    lazy var chargeDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 12)
        label.textAlignment = .center
        label.text = "You're card will be charged after your Sickcall is answered."
        label.textColor = UIColor.darkGray
        label.numberOfLines = 0
        return label
    }()
    lazy var chargeDescriptionLabel2: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue", size: 12)
        label.textAlignment = .center
        label.text = "Sickcall never stores your card information without your permission."
        label.textColor = UIColor.darkGray
        label.numberOfLines = 0
        return label
    }()
    
    lazy var chargeDescriptionLabel1: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue", size: 12)
        label.textAlignment = .center
        label.text = "This transaction is performed over a 128-Bit SSL Encryption."
        label.textColor = UIColor.darkGray
        label.numberOfLines = 0
        return label
    }()
    

    
    /*lazy var checkoutView: UIButton = {
        let button = UIButton()
        /*button.layer.cornerRadius = 5
        button.clipsToBounds = true*/
        return button
    }()
    
    lazy var summaryView: UIButton = {
        let button = UIButton()
       /* button.layer.cornerRadius = 5
        button.clipsToBounds = true*/
        return button
    }()*/
    
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
        } else if reuseIdentifier == "summaryReuse"{
            self.addSubview(summaryTitle)
            self.addSubview(durationLabel)
            self.addSubview(videoButton)
            self.addSubview(playImage)
            
            videoButton.snp.makeConstraints { (make) -> Void in
                make.width.height.equalTo(100)
                make.top.equalTo(self).offset(20)
                make.left.equalTo(self).offset(10)
                make.bottom.equalTo(self).offset(-20)
            }
            
            playImage.snp.makeConstraints { (make) -> Void in
                make.width.height.equalTo(35)
                make.top.equalTo(videoButton.snp.top).offset(35)
                make.left.equalTo(videoButton.snp.left).offset(35)
            }
            
            summaryTitle.snp.makeConstraints { (make) -> Void in
                make.top.equalTo(videoButton.snp.top).offset(20)
                make.left.equalTo(videoButton.snp.right).offset(5)
                make.right.equalTo(self).offset(-5)
            }
            
            durationLabel.snp.makeConstraints { (make) -> Void in
                make.top.equalTo(summaryTitle.snp.bottom).offset(5)
                make.left.equalTo(videoButton.snp.right).offset(5)
                make.right.equalTo(self).offset(-5)
            }
            
        } else if reuseIdentifier == "subtotalReuse"{
            self.addSubview(nurseFeeLabel)
            self.addSubview(nursePrice)
            self.addSubview(bookingLabel)
            self.addSubview(bookingPrice)
            //self.addSubview(discountLabel)
            //self.addSubview(discountPrice)
            
            nurseFeeLabel.snp.makeConstraints { (make) -> Void in
                make.top.equalTo(self).offset(10)
                make.left.equalTo(self).offset(10)
            }
            
            nursePrice.snp.makeConstraints { (make) -> Void in
                make.top.equalTo(self).offset(10)
                make.right.equalTo(self).offset(-10)
            }
            
            bookingLabel.snp.makeConstraints { (make) -> Void in
                make.top.equalTo(self.nurseFeeLabel.snp.bottom).offset(10)
                make.left.equalTo(self).offset(10)
            }
            
            bookingPrice.snp.makeConstraints { (make) -> Void in
                make.top.equalTo(self.nurseFeeLabel.snp.bottom).offset(10)
                make.right.equalTo(self).offset(-10)
                make.bottom.equalTo(self).offset(-10)
            }
            
            /*discountLabel.snp.makeConstraints { (make) -> Void in
                make.top.equalTo(self.bookingLabel.snp.bottom).offset(10)
                make.left.equalTo(self).offset(10)
            }
            
            discountPrice.snp.makeConstraints { (make) -> Void in
                make.top.equalTo(self.bookingLabel.snp.bottom).offset(10)
                make.right.equalTo(self).offset(-10)
                make.bottom.equalTo(self).offset(-10)
            }*/
            
        } else if reuseIdentifier == "totalReuse"{
            self.addSubview(totalLabel)
            self.addSubview(totalPrice)
            
            totalLabel.snp.makeConstraints { (make) -> Void in
                make.top.equalTo(self).offset(10)
                make.left.equalTo(self).offset(10)
            }
            
            totalPrice.snp.makeConstraints { (make) -> Void in
                make.top.equalTo(self).offset(10)
                make.right.equalTo(self).offset(-10)
                make.bottom.equalTo(self).offset(-10)
            }
            
            
        } else if reuseIdentifier == "ccReuse"{
            self.addSubview(ccImage)
            self.addSubview(ccLabel)
            self.addSubview(addCCLabel)
            self.addSubview(chargeDescriptionLabel)

            ccImage.snp.makeConstraints { (make) -> Void in
                make.width.equalTo(30)
                make.height.equalTo(20)
                make.top.equalTo(self).offset(10)
                make.left.equalTo(self).offset(10)
                make.bottom.equalTo(self).offset(-10)
            }
            
            ccLabel.snp.makeConstraints { (make) -> Void in
                make.top.equalTo(self).offset(10)
                make.left.equalTo(self.ccImage.snp.right).offset(3)
                make.bottom.equalTo(self).offset(-10)
            }
            
            addCCLabel.snp.makeConstraints { (make) -> Void in
                make.top.equalTo(self).offset(10)
                make.right.equalTo(self).offset(-10)
                make.bottom.equalTo(self).offset(-10)
            }
            
        } else if reuseIdentifier == "ccDescriptionReuse"{
            self.addSubview(chargeDescriptionLabel)
            self.addSubview(chargeDescriptionLabel1)
            self.addSubview(chargeDescriptionLabel2)

            chargeDescriptionLabel.snp.makeConstraints { (make) -> Void in
                make.top.equalTo(self).offset(10)
                make.left.equalTo(self).offset(10)
                make.right.equalTo(self).offset(-10)
            }
            
            chargeDescriptionLabel1.snp.makeConstraints { (make) -> Void in
                make.top.equalTo(self.chargeDescriptionLabel.snp.bottom).offset(10)
                make.left.equalTo(self).offset(10)
                make.right.equalTo(self).offset(-10)
            }
            
            chargeDescriptionLabel2.snp.makeConstraints { (make) -> Void in
                make.top.equalTo(self.chargeDescriptionLabel1.snp.bottom).offset(10)
                make.left.equalTo(self).offset(10)
                make.right.equalTo(self).offset(-10)
                make.bottom.equalTo(self)
            }
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
            make.top.equalTo(self).offset(10)
            make.left.equalTo(self).offset(10)
            make.right.equalTo(self).offset(-10)
            make.bottom.equalTo(self).offset(-10)
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
}
