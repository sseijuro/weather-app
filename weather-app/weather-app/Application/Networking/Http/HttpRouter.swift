//
//  HttpRouter.swift
//  weather-app
//
//  Created by Alexandr Kozorez on 20.03.2022.
//

import Foundation

public typealias HttpRouterCompletion = (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> ()

public protocol HttpRouterProtocol: AnyObject {
    associatedtype ConcretteHttpEndpoint: HttpEndpoint
    func resume(
        _ route: ConcretteHttpEndpoint,
        completion: @escaping HttpRouterCompletion
    )
    func cancel()
}

public class HttpRouter<ConcretteHttpEndpoint: HttpEndpoint>: HttpRouterProtocol {
    private let session: URLSession
    
    private var task: URLSessionTask?
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    public func resume(_ route: ConcretteHttpEndpoint, completion: @escaping HttpRouterCompletion) {
        var request = URLRequest(url: route.url.appendingPathComponent(route.path))
        request.httpMethod = route.method.rawValue
        
        do {
            switch route.task {
                case .request: break
                
                case .requestWithParamsAndHeaders(let bodyParams, let encoding, let urlParams, let headers):
                    if let headers = headers {
                        headers.forEach { (key, value) in
                            request.setValue(value, forHTTPHeaderField: key)
                        }
                    }
                fallthrough
                
                case .requestWithParams(let bodyParams, let encoding, let urlParams):
                    try encoding.encode(request: &request, bodyParams: bodyParams, urlParams: urlParams)
            }
        } catch {
            completion(nil, nil, error)
        }
        
        task = session.dataTask(with: request, completionHandler: completion)
        task?.resume()
        
    }
    
    public func cancel() {
        task?.cancel()
    }
    
}
