//
//  ViewController.swift
//  TestSwiftProject
//
//  Created by mac-246 on 21.01.16.
//  Copyright © 2016 mac-246. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var mainLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        mainLabel.text = "Test"
    }
}

