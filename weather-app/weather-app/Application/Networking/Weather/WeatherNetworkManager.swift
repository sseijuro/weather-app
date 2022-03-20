//
//  WeatherNetworkManager.swift
//  weather-app
//
//  Created by Alexandr Kozorez on 20.03.2022.
//

import Foundation

struct WeatherNetworkManager: HttpNetworkManager {
    let router: HttpRouter<WeatherEndpoint> = HttpRouter()
    
    func getWeather(for cityNamy: String, completion: @escaping (WeatherNetworkManagerResult) -> ()) {
        router.resume(.weather(cityName: cityNamy)) { data, response, error in
            if error != nil {
                completion(.failure(.connectionError))
            }
            
            guard let response = response as? HTTPURLResponse else {
                return completion(.failure(.unknownError))
            }
            
            switch httpStatusMiddleware(response) {
                case .failure(let error):
                    return completion(.failure(error))
                case .success(_):
                    guard let data = data,
                        let weatherData = try? JSONDecoder().decode(WeatherDTO.self, from: data) else {
                            return completion(.failure(.emptyDataError))
                        }
                    return completion(.success(weatherData))
            }
        }
    }
}
