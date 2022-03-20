//
//  HttpParametersURLEncoder.swift
//  weather-app
//
//  Created by Alexandr Kozorez on 20.03.2022.
//

import Foundation

public struct HttpParametersURLEncoder: HttpParametersEncoder {
    public func encode(_ request: inout URLRequest, with params: HttpParameters) throws {
        guard let url = request.url else { throw HttpParametersEncoderError.badURL }
        guard !params.isEmpty,
              var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return }
                
        components.queryItems = [URLQueryItem]()
        params.forEach { (key, value) in
            components.queryItems?.append(URLQueryItem(name: key, value: "\(value)"))
        }
                
        request.url = components.url
    }
    
    
}
