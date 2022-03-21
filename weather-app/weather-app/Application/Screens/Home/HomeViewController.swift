//
//  HomeViewController.swift
//  weather-app
//
//  Created by U19809810 on 21.03.2022.
//

import Foundation
import CoreLocation
import UIKit

final class HomeViewController: UIViewController {
    private var currentForecast: ForecastDTO?
    private var currentWeather: WeatherDTO?
    
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
        locationManager.run()
        navigationItem.rightBarButtonItem = setupReloadButton()
    }
    
    func setupReloadButton() -> UIBarButtonItem {
        let reloadButton = UIBarButtonItem(
            image: UIImage(systemName: "cursorarrow.click"),
            style: .plain,
            target: self,
            action: #selector(reload)
        )
        reloadButton.tintColor = .systemOrange
        return reloadButton
    }
    
    @objc func reload() {
        locationManager.run()
    }
}

extension HomeViewController: LocationManagerDelegate {
    func onEnabledAllowedLocationService() {
        guard let lat = locationManager.location?.coordinate.latitude,
              let lon = locationManager.location?.coordinate.longitude else { return }
        
        weatherManager.getForecast(lat: lat, lon: lon) { [weak self] forecast in
            switch forecast {
                case .failure(let error):
                    print(error)
                case .success(let forecast):
                    self?.currentForecast = forecast
            }
        }
    }
    
    func onEnabledDisallowedLocationService() {
        print("onEnabledDisallowedLocationService")
    }
    
    func onDisabledLocationService() {
        print("onDisabledLocationService")
    }
    
    func onReceiveLocations(locations: [CLLocation]) {
        print(locations)
    }
}
