//
//  API.swift
//  R3PI Shopping List
//
//  Created by Vasil Nunev on 10/04/2018.
//  Copyright © 2018 Vasil Nunev. All rights reserved.
//

import Foundation

class API {
    
    private let manager = URLSession.shared
    private let endpointURL: URL? = URL(string: "http://www.apilayer.net/api/live?access_key=2ee46d570f82d6ee6bb4ea5e06ad7023&format=1")
    
    func requestCurrencies(handler: @escaping (Result<Currencies>) -> Void) {
        guard let url = endpointURL else { return }
        let urlRequest = URLRequest(url: url)
        manager.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                handler(.failure(error))
            } else if let data = data {
                let decoder = JSONDecoder()
                do {
                    let currencies = try decoder.decode(Currencies.self, from: data)
                    handler(.success(currencies))
                } catch let error {
                    handler(.failure(error))
                }
            }
        }.resume()
    }
}
