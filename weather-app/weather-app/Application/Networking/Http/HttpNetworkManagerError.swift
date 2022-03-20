//
//  HttpNetworkManagerError.swift
//  weather-app
//
//  Created by Alexandr Kozorez on 20.03.2022.
//

import Foundation

public enum HttpNetworkManagerError: String, Error {
    case connectionError = "Internet connection not found"
    case authError = "Authentication failed"
    case requestError = "Corrupted request"
    case emptyDataError = "Data is empty"
    case unknownError = "Unknown error"
}
