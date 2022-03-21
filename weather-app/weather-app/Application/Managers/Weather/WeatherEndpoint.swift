//
//  WeatherEndpoint.swift
//  weather-app
//
//  Created by Alexandr Kozorez on 20.03.2022.
//

import Foundation

enum WeatherEndpoint: HttpEndpoint {
    case cityWeather(cityName: String)
    case latLonWeather(lat: Double, lon: Double)
    
    private var apiKey: String {
        get {
            guard let filePath = Bundle.main.path(forResource: "Weather", ofType: "plist") else {
                fatalError("Couldn't find file Weather.plist.")
            }
            guard let value = NSDictionary(contentsOfFile: filePath)?.object(forKey: "API_KEY") as? String else {
                fatalError("Couldn't find 'API_KEY' in 'Weather.plist'.")
            }
            return value
        }
    }
    
    private var baseAPIAddress: String {
        "https://api.openweathermap.org/data/2.5/"
    }
    
    var url: URL {
        URL(string: baseAPIAddress)!
    }
    
    var path: String {
        switch self {
            case .cityWeather:
                return "weather"
            case .latLonWeather:
                return "weather"
        }
    }
    
    var method: HttpMethod {
        switch self {
            case .cityWeather:
                return .get
            case .latLonWeather:
                return .get
        }
    }
    
    var task: HttpTask {
        switch self {
            case .cityWeather(let cityName):
                return .requestWithParams(
                    bodyParams: nil,
                    encoding: .url,
                    urlParams: [
                        "q": cityName,
                        "appid": apiKey
                    ]
                )
        case .latLonWeather(let lat, let lon):
            return .requestWithParams(
                bodyParams: nil,
                encoding: .url,
                urlParams: [
                    "lat": lat,
                    "lon": lon,
                    "appid": apiKey
                ]
            )
        }
    }
    
    var headers: HttpHeaders? {
        nil
    }
}
