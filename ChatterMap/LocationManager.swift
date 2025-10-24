//
//  LocationManager.swift
//  ChatterMap
//
//  Created by Noah Burnham on 10/15/25.
//  Code authored by  Stewart Lynch
//  from https://www.youtube.com/watch?v=xIU0PtHiwtg

import Foundation
import SwiftUI
import CoreLocation

@Observable
class LocationManager: NSObject, CLLocationManagerDelegate {
    @ObservationIgnored let manager = CLLocationManager()
    var userLocation: CLLocation?
    var isAuthorized = false

    
    override init(){
        super.init()
        manager.delegate = self
        startLocationServices()
    }
    
    func startLocationServices(){
        if manager.authorizationStatus == .authorizedAlways || manager.authorizationStatus == .authorizedWhenInUse{
            manager.startUpdatingLocation()
            isAuthorized = true
        } else{
            isAuthorized = false
            manager.requestWhenInUseAuthorization()
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = locations.last
        if let userLocation = locations.last{
            let latitude = userLocation.coordinate.latitude
            let longitude = userLocation.coordinate.longitude
        }
        
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus{
        case .authorizedAlways, .authorizedWhenInUse:
            isAuthorized = true
            manager.requestLocation()
        case .notDetermined:
            isAuthorized = false
            manager.requestWhenInUseAuthorization()
        case .denied:
            isAuthorized = false
            print("access denied")
        default:
            isAuthorized = true
            startLocationServices()
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print(error.localizedDescription)
    }
}
