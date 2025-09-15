//
//  LocationManager.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 13.06.25.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    static let shared = LocationManager()
    var currentLocation: CLLocation?
  @Published  var isPermissionsGranted: Bool = false
    @Published var speed: Double = 0.0
    
    override init() {
        super.init()
        locationManager.delegate = self
        print("locationManager started")
    }
    @MainActor
    func grantPermission() -> Bool {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        let authStatus = locationManager.authorizationStatus
        if authStatus == .authorizedWhenInUse || authStatus == .authorizedAlways  {
            isPermissionsGranted = true
        } else {
            isPermissionsGranted = false
        }
        return isPermissionsGranted
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        currentLocation = location
        if location.speed >= 0 {
            speed = location.speed * 3.6
            print(speed)
        } else {
            speed = 0.0
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            isPermissionsGranted = true
        default:
            isPermissionsGranted = false
        }
    }
    
    func startTracking() {
        locationManager.startUpdatingLocation()
    }
    
    func stopTracking() {
        locationManager.stopUpdatingLocation()
    }
    
}

