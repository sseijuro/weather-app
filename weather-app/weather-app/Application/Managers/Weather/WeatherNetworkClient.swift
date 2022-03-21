//
//  WeatherNetworkClient.swift
//  weather-app
//
//  Created by U19809810 on 21.03.2022.
//

import Foundation

public protocol WeatherNetworkClientProtocol {
	associatedtype ConcretteEndpoint: HttpEndpoint
	
	func fetch<T: Decodable>(
		_ endpoint: ConcretteEndpoint,
		completion: @escaping (Result<T?, HttpNetworkManagerError>) -> (),
		type: T.Type
	)
}

public final class WeatherNetworkClient<ConcretteEndpoint: HttpEndpoint>:
	WeatherNetworkClientProtocol,
	HttpNetworkClientProtocol
{
	private let weatherQueue = DispatchQueue(
		label: "weather.network.client.queue",
		qos: .background
	)
	
	private let weatherSemaphore = DispatchSemaphore(value: 0)
	
	private let router: HttpRouter<ConcretteEndpoint> = HttpRouter()
	
	public func fetch<T: Decodable>(
		_ endpoint: ConcretteEndpoint,
		completion: @escaping (Result<T?, HttpNetworkManagerError>) -> (),
		type: T.Type = T.self
	) {
		weatherQueue.sync {
			Thread.sleep(forTimeInterval: 1)
			router.resume(endpoint) { [weak self] (data, response, error) in
				guard let self = self else { return }
				defer { self.weatherSemaphore.signal() }
				if error != nil {
					return completion(.failure(.connectionError))
				}
				
				guard let response = response as? HTTPURLResponse else {
					return completion(.failure(.unknownError))
				}
				
				switch self.httpStatusMiddleware(response) {
					case .failure(let error):
						return completion(.failure(error))
					case .success(_):
						guard let data = data,
							  let decodedData = try? JSONDecoder().decode(type, from: data) else {
								  return completion(.failure(.emptyDataError))
							  }
						return completion(.success(decodedData))
				}
			}
		}
		weatherSemaphore.wait()
	}
}

