//
//  HttpEndpoint.swift
//  weather-app
//
//  Created by Alexandr Kozorez on 20.03.2022.
//

import Foundation

public protocol HttpEndpoint {
    var url: URL { get }
    var path: String { get }
    var method: HttpMethod { get }
    var task: HttpTask { get }
    var headers: HttpHeaders? { get }
}
