//
//  MainContainerViewController.swift
//  Celecare
//
//  Created by Mac Owner on 7/10/17.
//  Copyright © 2017 Celecare LLC. All rights reserved.
//

import UIKit

import SidebarOverlay

class MainContainerViewController: SOContainerViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.menuSide = .left
        self.topViewController = self.storyboard?.instantiateViewController(withIdentifier: "main")
        self.sideViewController = self.storyboard?.instantiateViewController(withIdentifier: "sidebar")
        

        // Do any additional setup after loading the view.
    }
}
