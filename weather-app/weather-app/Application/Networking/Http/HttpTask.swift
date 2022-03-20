//
//  HttpTask.swift
//  weather-app
//
//  Created by Alexandr Kozorez on 20.03.2022.
//

import Foundation

public enum HttpTask {
    case request
    case requestWithParams(
        bodyParams: HttpParameters?,
        encoding: HttpParametersEncoding,
        urlParams: HttpParameters?
    )
    case requestWithParamsAndHeaders(
        bodyParams: HttpParameters?,
        encoding: HttpParametersEncoding,
        urlParams: HttpParameters?,
        headers: HttpHeaders?
    )
}
