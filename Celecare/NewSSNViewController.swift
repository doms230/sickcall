//
//  NewSSNViewController.swift
//  Celecare
//
//  Created by Dominic Smith on 10/17/17.
//  Copyright © 2017 Celecare LLC. All rights reserved.
//

import UIKit
import SnapKit

class NewSSNViewController: UIViewController {
    
    lazy var ssnLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 25)
        label.text = "Social Security Number"
        label.textColor = UIColor.black
        label.backgroundColor = .clear
        label.numberOfLines = 0
        return label
    }()
    
    lazy var ssnText: UITextField = {
        let label = UITextField()
        label.placeholder = "Social Security Number"
        label.backgroundColor = .white
        label.font = UIFont(name: "HelveticaNeue", size: 17)
        label.clearButtonMode = .whileEditing
        label.borderStyle = .roundedRect
        label.keyboardType = .numberPad
        return label
    }()
    
    lazy var ssnExplanation: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue", size: 12)
        label.text = "Your social security number is needed to verify your identity."
        label.textColor = UIColor.black
        label.backgroundColor = .clear
        label.numberOfLines = 0
        return label
    }()
    
    var line1: String!
    var line2: String!
    var city: String!
    var zipCode: String!
    var state: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSSN()

        // Do any additional setup after loading the view.
    }

    func configureSSN(){
        self.view.addSubview(ssnLabel)
        self.view.addSubview(ssnText)
        self.view.addSubview(ssnExplanation)
        
        ssnLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.view).offset(20)
            make.left.equalTo(self.view).offset(10)
            make.right.equalTo(self.view).offset(-10)
        }
        
        ssnText.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(ssnLabel.snp.bottom).offset(5)
            make.left.equalTo(self.view).offset(10)
            make.right.equalTo(self.view).offset(-10)
        }
        
        ssnExplanation.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(ssnText.snp.bottom).offset(5)
            make.left.equalTo(self.view).offset(10)
            make.right.equalTo(self.view).offset(-10)
            make.bottom.equalTo(self.view).offset(-20)
        }
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
