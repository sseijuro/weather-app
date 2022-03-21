//
//  WeatherNetworkManager.swift
//  weather-app
//
//  Created by Alexandr Kozorez on 20.03.2022.
//

import Foundation

struct WeatherNetworkManager {
	let weatherClient: WeatherNetworkClient<WeatherEndpoint>
	
	init(client: WeatherNetworkClient<WeatherEndpoint> = WeatherNetworkClient()) {
		weatherClient = client
	}
	
    func getWeather(
        for cityNamy: String,
        completion: @escaping (Result<WeatherDTO?, HttpNetworkManagerError>) -> ()
    ) {
		weatherClient.fetch(.cityWeather(cityName: cityNamy), completion: completion, type: WeatherDTO.self)
    }
    
    func getWeather(
        lat: Double,
        lon: Double,
        completion: @escaping (Result<WeatherDTO?, HttpNetworkManagerError>) -> ()
    ) {
		weatherClient.fetch(.latLonWeather(lat: lat, lon: lon), completion: completion, type: WeatherDTO.self)
    }
    
    func getForecast(
        lat: Double,
        lon: Double,
        completion: @escaping (Result<ForecastDTO?, HttpNetworkManagerError>) -> ()
    ) {
		weatherClient.fetch(.forecast(lat: lat, lon: lon), completion: completion, type: ForecastDTO.self)
    }
    
	
}
