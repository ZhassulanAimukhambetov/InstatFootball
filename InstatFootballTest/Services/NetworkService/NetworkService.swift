//
//  NetworkService.swift
//  InstatFootballTest
//
//  Created by Zhassulan Aimukhambetov on 04.08.2022.
//

import Foundation

protocol NetworkService {
    func execute<T: Decodable>(with router: NetworkRouter, completion: @escaping (Result<T, NetworkError>) -> Void)
}

final class Network: NetworkService {
    private let session = URLSession(configuration: .default)
    
    func execute<T: Decodable>(with router: NetworkRouter, completion: @escaping (Result<T, NetworkError>) -> Void) {
        call(with: router) { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }

    private func call<T>(with router: NetworkRouter, completion: @escaping (Result<T, NetworkError>) -> Void) where T : Decodable {
        guard let request = try? router.request() else {
            completion(.failure(.missingRequest))
            return
        }
        
        let task = session.dataTask(with: request) { data, response, error in
            if let _ = error {
                print(error as Any)
                completion(.failure(.taskError))
                return
            }
            
            guard let response = response as? HTTPURLResponse, case (200...299) = response.statusCode else {
                print(response as Any)
                completion(.failure(.responseError))
                return
            }

            guard let data = data else {
                completion(.failure(.dataError))
                return
            }

            guard let decodableResult = try? JSONDecoder().decode(T.self, from: data) else {
                completion(.failure(.decodeError))
                return
            }
            
            completion(.success(decodableResult))
        }
        
        task.resume()
    }
}
