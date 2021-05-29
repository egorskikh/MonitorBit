//
//  NetworkService.swift
//  MonitorBit
//
//  Created by Егор Горских on 25.03.2021.
// https://blockchain.info/ticker

import Foundation

final class NetworkService {
    
    public func request(completion: @escaping (Data?, Error?) -> Void) {
        let url = self.url()
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "get"
        let task = createDataTask(from: urlRequest, completion: completion)
        task.resume()
    }
    
    private func url() -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "blockchain.info"
        components.path = "/ticker"
        return components.url!
    }
    
    private func createDataTask(from request: URLRequest,
                                completion: @escaping (Data? , Error?) -> Void) -> URLSessionDataTask {
        return URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                completion(data, error)
            }
        }
    }
    
}
