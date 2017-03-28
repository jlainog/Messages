//
//  LocationMonitor.swift
//  Messages
//
//  Created by Gustavo Mario Londoño Correa on 3/28/17.
//  Copyright © 2017 JLainoG. All rights reserved.
//

import Foundation
import CoreLocation

class LocationMonitorSingleton : NSObject {
    
    var currentPosition = CLLocation()
    var locationFixAchieved : Bool = false
    fileprivate static let sharedInstance = LocationMonitorSingleton()
    fileprivate let locationManager = CLLocationManager()
    fileprivate var handler: ((CLLocation) -> Void)?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    deinit {
        locationManager.stopUpdatingLocation()
    }
}

extension LocationMonitorSingleton : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            locationManager.stopUpdatingLocation()
            self.handler?(locations.last!)
    }
    
    func getLocation(handler: @escaping (CLLocation) -> Void) {
        self.handler = handler
    }
}