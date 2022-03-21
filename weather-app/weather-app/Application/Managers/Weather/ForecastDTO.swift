//
//  ForecastDTO.swift
//  weather-app
//
//  Created by U19809810 on 21.03.2022.
//

import Foundation

struct ForecastDTO: Decodable {
    let cnt: Int
    let list: [ForecastWrapper]
    
    struct ForecastWrapper: Decodable {
        let dt: Int
        let dt_txt: String
        
        let main: WeatherDTO.WeatherNumbersData
        let weather: [WeatherDTO.WeatherTextData]
        let wind: WeatherDTO.WeatherWind
    }
}
