//
//  ViewController.swift
//  weather-app
//
//  Created by Alexandr Kozorez on 20.03.2022.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    private lazy var weatherManager: WeatherNetworkManager = {
        WeatherNetworkManager()
    }()
    
    private lazy var locationManager: LocationManagerProtocol = {
        let locationManager: LocationManagerProtocol = LocationManager()
        locationManager.delegate = self
        return locationManager
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.bootstrap()
    }

}

extension ViewController: LocationManagerDelegate {
    func onReceiveLocations(locations: [CLLocation]) {
        guard let lat = locations.first?.coordinate.latitude,
              let lon = locations.first?.coordinate.longitude else { return }
    
        weatherManager.getWeather(lat: lat, lon: lon) { weather in
            print(weather)
        }
    }
    
    func onDisabledLocationService() {
        print("disabled")
    }
    
    func onEnabledAllowedLocationService() {
        print(locationManager.location ?? "no")
    }
    
    func onEnabledDisallowedLocationService() {
        print("enabled disallowed")
    }
}
