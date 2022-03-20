//
//  WeatherDTO.swift
//  weather-app
//
//  Created by Alexandr Kozorez on 20.03.2022.
//

import Foundation

struct WeatherTextData: Decodable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct WeatherNumbersData: Decodable {
    let temp: Double
    let feels_like: Double
    let temp_min: Double
    let temp_max: Double
    let pressure: Double
    let humidity: Double
}

struct WeatherWind: Decodable {
    let speed: Double
    let deg: Double
}

struct WeatherDTO: Decodable {
    let weather: [WeatherTextData]
    let main: WeatherNumbersData
    let wind: WeatherWind
}
