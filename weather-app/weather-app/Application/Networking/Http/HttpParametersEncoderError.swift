//
//  HttpParametersEncoderError.swift
//  weather-app
//
//  Created by Alexandr Kozorez on 20.03.2022.
//

import Foundation

public enum HttpParametersEncoderError: String, Error {
    case badURL = "Received url is empty or corrupted"
    case failedToEncode = "Failed to encode the parameters"
}
