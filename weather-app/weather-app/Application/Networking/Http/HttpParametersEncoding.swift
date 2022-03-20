//
//  HttpParametersEncoding.swift
//  weather-app
//
//  Created by Alexandr Kozorez on 20.03.2022.
//

import Foundation

public enum HttpParametersEncoding {
    case url
    case json
    case both
    
    public func encode(request: inout URLRequest, bodyParams: HttpParameters?, urlParams: HttpParameters?) throws {
        do {
            switch self {
                case .url:
                    guard let params = urlParams else { return }
                    try HttpParametersURLEncoder().encode(&request, with: params)
                    sanitize(request: &request, contentType: "x-www-form-urlencoded")
                
                case .json:
                    guard let params = bodyParams else { return }
                    try HttpParametersJSONEncoder().encode(&request, with: params)
                    sanitize(request: &request, contentType: "application/json")
                
                case .both:
                    if let bodyParams = bodyParams {
                        try HttpParametersJSONEncoder().encode(&request, with: bodyParams)
                    }
                    if let urlParams = urlParams {
                        try HttpParametersURLEncoder().encode(&request, with: urlParams)
                    }
            }
        } catch {
            throw error
        }
    }
    
    private func sanitize(request: inout URLRequest, contentType: String) {
        if request.value(forHTTPHeaderField: "Content-Type") == nil {
            request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        }
    }
}
