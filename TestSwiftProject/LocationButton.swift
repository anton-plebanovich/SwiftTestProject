//
//  LocationButton.swift
//  TestSwiftProject
//
//  Created by mac-246 on 21.01.16.
//  Copyright © 2016 mac-246. All rights reserved.
//

import UIKit

class LocationButton: UIBarButtonItem {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        updateState()
        target = self
        action = "didTapLocationButton:"
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "locationHelperStatusChangedNotification:", name: LocationHelperStatusChangedNotification, object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func toggleState() {
        let state = LocationHelper.sharedInstance.state
        switch state {
        case .Start:
            LocationHelper.sharedInstance.stop()
        case .Stop:
            LocationHelper.sharedInstance.start()
        }
    }
    
    func updateState() {
        let state = LocationHelper.sharedInstance.state
        switch state {
        case .Stop:
            title = "Start"
        case .Start:
            title = "Stop"
        }
    }
    
    // MARK: Actions
    func didTapLocationButton(sender: LocationButton) {
        toggleState()
    }
    
    // MARK: Notifications
    func locationHelperStatusChangedNotification(notification: NSNotification) {
        updateState()
    }
}
