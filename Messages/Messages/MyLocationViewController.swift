//
//  MyLocationViewController.swift
//  Messages
//
//  Created by Stephany Lara Jimenez on 3/21/17.
//  Copyright © 2017 JLainoG. All rights reserved.
//

import UIKit
import CoreLocation

class LocationMonitor : NSObject {

    var currentPosition = CLLocation()
    var locationFixAchieved : Bool = false
    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.startUpdatingLocation()
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
    }
    
    deinit {
        locationManager.stopUpdatingLocation()
    }
}

extension LocationMonitor : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if (locationFixAchieved == false) {
            locationFixAchieved = true
        currentPosition = locations.last!
        }
    }
    
    func getPosition(handler: @escaping (CLLocation?, Error?) -> Void) {
        handler(currentPosition, nil)
    }
}
