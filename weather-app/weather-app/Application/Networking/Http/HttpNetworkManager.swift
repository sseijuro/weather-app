//
//  HttpNetworkManager.swift
//  weather-app
//
//  Created by Alexandr Kozorez on 20.03.2022.
//

import Foundation

public protocol HttpNetworkManager {}

public extension HttpNetworkManager {
    public func httpStatusMiddleware(_ response: HTTPURLResponse) -> Result<Any?, HttpNetworkManagerError> {
        switch response.statusCode {
            case 200...299:
                return .success(nil)
            case 401...500:
                return .failure(.authError)
            case 501...599:
                return .failure(.requestError)
            default:
                return .failure(.unknownError)
        }
    }
}
