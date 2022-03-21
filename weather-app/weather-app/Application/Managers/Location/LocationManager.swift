//
//  LocationManager.swift
//  weather-app
//
//  Created by U19809810 on 21.03.2022.
//

import Foundation
import CoreLocation

protocol LocationManagerDelegate: AnyObject {
    func onDisabledLocationService()
    func onEnabledAllowedLocationService()
    func onEnabledDisallowedLocationService()
    func onReceiveLocations(locations: [CLLocation])
}

protocol LocationManagerProtocol: AnyObject {
    var location: CLLocation? { get }
    var delegate: LocationManagerDelegate? { get set }
    
    func bootstrap()
}

final class LocationManager: NSObject, LocationManagerProtocol, CLLocationManagerDelegate {
    weak var delegate: LocationManagerDelegate?
    
    private lazy var manager: CLLocationManager = {
        CLLocationManager()
    }()
    
    var location: CLLocation? {
        manager.location
    }
    
    func bootstrap() {
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
                case .notDetermined, .restricted, .denied:
                    delegate?.onEnabledDisallowedLocationService()
                case .authorizedAlways, .authorizedWhenInUse:
                    delegate?.onEnabledAllowedLocationService()
                @unknown default:
                    break
            }
        } else {
            delegate?.onDisabledLocationService()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        delegate?.onReceiveLocations(locations: locations)
    }
    
}
