//
//  Errors.swift
//  ArtScope
//
//  Created by loxxy on 28.01.2026.
//

enum NetworkError: Error {
    case noData
    case invalidResponse
    case unsuccessfulStatusCode(Int, String?)
}
    
