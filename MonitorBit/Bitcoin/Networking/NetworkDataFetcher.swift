//
//  NetworkDataFetcher.swift
//  MonitorBit
//
//  Created by Егор Горских on 25.03.2021.
//

import Foundation

final class NetworkDataFetcher {

    var networkService = NetworkService()
    
    func fetchСourse(completion: @escaping (BitcoinResponse?) -> ()) {

        networkService.request() { (data, error) in
            
            if let error = error {
                print("Error received requesting data: \(error.localizedDescription)")
                completion(nil)
            }
            
            let decode = self.decodeJSON(type: BitcoinResponse.self, from: data)
            completion(decode)
        }
    }
    
    func decodeJSON<T: Decodable>(type: T.Type, from: Data?) -> T? {
        let decoder = JSONDecoder()
        guard let data = from else { return nil }
        
        do {
            let objects = try decoder.decode(type.self, from: data)
            return objects
        } catch let jsonError {
            print("Failed to decode JSON: \(jsonError)", jsonError.localizedDescription)
            return nil
        }
    }

    
}
