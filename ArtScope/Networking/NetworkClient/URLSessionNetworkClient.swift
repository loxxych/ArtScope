//
//  URLSessionNetworkClient.swift
//  ArtScope
//
//  Created by loxxy on 28.01.2026.
//

import Foundation

final class URLSessionNetworkClient: NetworkClient {
    func request<T: Decodable>(
        _ request: URLRequest,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NetworkError.invalidResponse))
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                let responseBody = data.flatMap { String(data: $0, encoding: .utf8) }
                completion(.failure(NetworkError.unsuccessfulStatusCode(httpResponse.statusCode, responseBody)))
                return
            }

            guard let data else {
                completion(.failure(NetworkError.noData))
                return
            }

            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decoded))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
