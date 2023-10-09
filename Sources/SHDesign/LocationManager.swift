//
//  LocationManager.swift
//  SplootIOS
//
//  Created by Sahib Hussain on 03/10/22.
//

import Foundation
import CoreLocation


class LocationManager: NSObject, CLLocationManagerDelegate {
    
    private let manager = CLLocationManager()
    
    public var didUpdateLocation: ((CLLocationCoordinate2D) -> Void)? = nil
    
    static let shared = LocationManager()
    
    override private init() {
        super.init()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.delegate = self
    }
    
    
    public func start() {
        manager.startUpdatingLocation()
    }
    
    public func stop() {
        manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentCoordinate = manager.location?.coordinate else {return}
        didUpdateLocation?(currentCoordinate)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(#function, error)
    }
    
}
