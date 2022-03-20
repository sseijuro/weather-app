//
//  HttpParametersEncodingProtocol.swift
//  weather-app
//
//  Created by Alexandr Kozorez on 20.03.2022.
//

import Foundation

public protocol HttpParametersEncoder {
    func encode(_ request: inout URLRequest, with params: HttpParameters) throws
}
