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

let LocationHelperStatusChangedNotification = "LocationHelperStatusChanged"
let LocationHelperNewLocationNotification = "LocationHelperNewLocation"
let LocationHelperNewLocationNotificationUserInfoKey = "LocationHelperNewLocationNotificationUserInfoKey"

enum LocationManagerState: UInt {
    case On
    case Off
}

class LocationHelper: NSObject {
    static let sharedInstance = LocationHelper()
    private var locationManager: CLLocationManager
    var state: LocationManagerState = .Off
    
    override init() {
        locationManager = CLLocationManager()
        
        super.init()
        
        setupLocationManager()
    }
    
    func setupLocationManager() -> Void {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
      start()
    }
    
    func start() -> Void {
        let authorizationStatus = CLLocationManager.authorizationStatus()
        switch authorizationStatus {
        case .NotDetermined:
            locationManager.requestWhenInUseAuthorization()
            state = .On
            postStateChangeNotification()
        case .AuthorizedAlways, .AuthorizedWhenInUse:
            state = .On
            postStateChangeNotification()
            locationManager.startUpdatingLocation()
        case .Denied:
            AlertController.showWithTitle("Location error", message: "No location available", actionTitle: "OK")
        case .Restricted:
            AlertController.showWithTitle("Location error", message: "No location available", actionTitle: "OK")
        }
    }
    
    func stop() -> Void {
        state = .Off
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
            if (state == .On) {
                locationManager.startUpdatingLocation()
            }
        case .Denied, .Restricted:
            if (state == .On) {
                state = .Off
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

