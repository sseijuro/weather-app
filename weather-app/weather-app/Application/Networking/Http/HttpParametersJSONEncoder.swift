//
//  HttpParametersJSONEncoder.swift
//  weather-app
//
//  Created by Alexandr Kozorez on 20.03.2022.
//

import Foundation

public struct HttpParametersJSONEncoder: HttpParametersEncoder {
    public func encode(_ request: inout URLRequest, with params: HttpParameters) throws {
        guard let serialized = try? JSONSerialization.data(withJSONObject: params) else {
            throw HttpParametersEncoderError.failedToEncode
        }
        
        request.httpBody = serialized
    }
}
