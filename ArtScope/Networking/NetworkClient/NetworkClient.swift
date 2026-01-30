//
//  NetworkClient.swift
//  ArtScope
//
//  Created by loxxy on 28.01.2026.
//

import Foundation

protocol NetworkClient {
    func request<T: Decodable>(
        _ request: URLRequest,
        completion: @escaping (Result<T, Error>) -> Void
    )
}
