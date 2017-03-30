//
//  MyLocationViewController.swift
//  Messages
//
//  Created by Stephany Lara Jimenez on 3/21/17.
//  Copyright © 2017 JLainoG. All rights reserved.
//

import Foundation
import CoreLocation

typealias handler = (CLLocation?, Error?) -> Void

protocol LocationMonitorProtocol {
    func getPosAsync(handler: @escaping (handler))
}

class LocationMonitorSingleton : NSObject, LocationMonitorProtocol {

    fileprivate var handlers = [handler]()
    fileprivate let manager = CLLocationManager()
    static var sharedInstance = LocationMonitorSingleton()
    
    func getPosAsync(handler: @escaping (handler)) {
        manager.requestLocation()
        self.handlers.append(handler)
    }
    
    override private init() {
        super.init()
        manager.delegate = self
    }
}

extension LocationMonitorSingleton : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for handler in handlers { handler(locations.last, nil) }
        handlers.removeAll()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        for handler in handlers { handler(nil, error) }
        handlers.removeAll()
    }
}
