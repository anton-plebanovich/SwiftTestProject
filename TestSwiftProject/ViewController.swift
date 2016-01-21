//
//  ViewController.swift
//  TestSwiftProject
//
//  Created by mac-246 on 21.01.16.
//  Copyright © 2016 mac-246. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let locationsArray = NSMutableArray()
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "locationHelperNewLocationNotification:", name: LocationHelperNewLocationNotification, object: nil)
    }
    
    func scrollToBottom(animated animated: Bool) {
        let bottomSection = tableView.numberOfSections - 1
        if bottomSection < 0 {
            return
        }
        
        let bottomRow = tableView.numberOfRowsInSection(bottomSection) - 1
        if bottomRow < 0 {
            return
        }
        
        let bottomIndexPath = NSIndexPath(forRow: bottomRow, inSection: bottomSection)
        tableView.scrollToRowAtIndexPath(bottomIndexPath, atScrollPosition: .Bottom, animated: animated)
    }
}

// MARK: Notifications
extension ViewController {
    func locationHelperNewLocationNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let newLocation = userInfo[LocationHelperNewLocationNotificationUserInfoKey] {
                locationsArray.addObject(newLocation)
                
                tableView.reloadData()
                scrollToBottom(animated: true)
            }
        }
    }
}

// MARK: Actions
extension ViewController {
    @IBAction func didTapClearButton(sender: UIBarButtonItem) {
        locationsArray.removeAllObjects()
        
        tableView.reloadData()
    }
}

// MARK: UITableViewDelegate
extension ViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
}

// MARK: UITableViewDataSource
extension ViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationsArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as? LocationCell
        
        if let cell = cell {
            let row = indexPath.row
            let currentLocation = locationsArray[row] as! CLLocation
            cell.locationLabel.text = currentLocation.description
        }
        
        return cell ?? UITableViewCell()
    }
}

