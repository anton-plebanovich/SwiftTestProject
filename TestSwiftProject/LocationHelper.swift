//
//  LocationHelper.swift
//  TestSwiftProject
//
//  Created by mac-246 on 21.01.16.
//  Copyright © 2016 mac-246. All rights reserved.
//

import UIKit
import CoreLocation
import SDCAlertView

let LocationHelperStatusChangedNotification = "LocationHelperStatusChangedNotification"
let LocationHelperNewLocationNotification = "LocationHelperNewLocationNotification"
let LocationHelperNewLocationNotificationUserInfoKey = "LocationHelperNewLocationNotificationUserInfoKey"

enum LocationState: UInt {
    case Start
    case Stop
}

class LocationHelper: NSObject {
    static let sharedInstance = LocationHelper()
    private var locationManager: CLLocationManager
    var state: LocationState = .Stop
    
    override init() {
        locationManager = CLLocationManager()
        
        super.init()
        
        setupLocationManager()
    }
    
    func setupLocationManager() -> Void {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    }
    
    func start() -> Void {
        let authorizationStatus = CLLocationManager.authorizationStatus()
        switch authorizationStatus {
        case .NotDetermined:
            locationManager.requestWhenInUseAuthorization()
            state = .Start
            postStateChangeNotification()
        case .AuthorizedAlways, .AuthorizedWhenInUse:
            state = .Start
            postStateChangeNotification()
            locationManager.startUpdatingLocation()
        case .Denied:
            AlertController.showWithTitle("Location error", message: "No location available", actionTitle: "OK")
        case .Restricted:
            AlertController.showWithTitle("Location error", message: "No location available", actionTitle: "OK")
        }
    }
    
    func stop() -> Void {
        state = .Stop
        postStateChangeNotification()
        
        locationManager.stopUpdatingLocation()
    }
    
    func postStateChangeNotification() {
        NSNotificationCenter.defaultCenter().postNotificationName(LocationHelperStatusChangedNotification, object: self)
    }
}

// MARK: CLLocationManagerDelegate
extension LocationHelper: CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        AlertController.showWithTitle("Location error", message: error.localizedDescription, actionTitle: "OK")
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch (status) {
        case .AuthorizedAlways, .AuthorizedWhenInUse:
            if (state == .Start) {
                locationManager.startUpdatingLocation()
            }
        case .Denied, .Restricted:
            if (state == .Start) {
                state = .Stop
                postStateChangeNotification()
                AlertController.showWithTitle("Location error", message: "No location available", actionTitle: "OK")
            }
        default:
            break
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        NSNotificationCenter.defaultCenter().postNotificationName(LocationHelperNewLocationNotification, object: self, userInfo: [LocationHelperNewLocationNotificationUserInfoKey : newLocation])
    }
}

