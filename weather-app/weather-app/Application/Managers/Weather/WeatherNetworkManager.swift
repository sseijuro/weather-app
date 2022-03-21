//
//  WeatherNetworkManager.swift
//  weather-app
//
//  Created by Alexandr Kozorez on 20.03.2022.
//

import Foundation

struct WeatherNetworkManager: HttpNetworkManager {
    private let router: HttpRouter<WeatherEndpoint> = HttpRouter()
    private let weatherQueue = DispatchQueue(
        label: "weather.manager.queue",
        qos: .background
    )
    
    private let weatherSemaphore = DispatchSemaphore(value: 0)
    
    func getWeather(
        for cityNamy: String,
        completion: @escaping (Result<WeatherDTO?, HttpNetworkManagerError>) -> ()
    ) {
        fetchEndpoint(.cityWeather(cityName: cityNamy), completion: completion, type: WeatherDTO.self)
    }
    
    func getWeather(
        lat: Double,
        lon: Double,
        completion: @escaping (Result<WeatherDTO?, HttpNetworkManagerError>) -> ()
    ) {
        fetchEndpoint(.latLonWeather(lat: lat, lon: lon), completion: completion, type: WeatherDTO.self)
    }
    
    func getForecast(
        lat: Double,
        lon: Double,
        completion: @escaping (Result<ForecastDTO?, HttpNetworkManagerError>) -> ()
    ) {
        fetchEndpoint(.forecast(lat: lat, lon: lon), completion: completion, type: ForecastDTO.self)
    }
    
    private func fetchEndpoint<T: Decodable>(
        _ endpoint: WeatherEndpoint,
        completion: @escaping (Result<T?, HttpNetworkManagerError>) -> (),
        type: T.Type = T.self
    ) {
        weatherQueue.sync {
            Thread.sleep(forTimeInterval: 1)
            router.resume(endpoint) { data, response, error in
                defer { weatherSemaphore.signal() }
                if error != nil {
                    return completion(.failure(.connectionError))
                }
                
                guard let response = response as? HTTPURLResponse else {
                    return completion(.failure(.unknownError))
                }
                
                switch httpStatusMiddleware(response) {
                    case .failure(let error):
                        return completion(.failure(error))
                    case .success(_):
                        guard let data = data,
                              let decodedData = try? JSONDecoder().decode(type, from: data) else {
                                  return completion(.failure(.emptyDataError))
                              }
                        return completion(.success(decodedData))
                }
            }
        }
        weatherSemaphore.wait()
    }
}
