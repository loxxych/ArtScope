//
//  GeminiEndpoint.swift
//  ArtScope
//
//  Created by loxxy on 15.04.2026.
//

import Foundation

enum GeminiEndpoint {
    private static let baseURL = URL(string: "https://generativelanguage.googleapis.com/v1beta/models")!
    private static let requestTimeout: TimeInterval = 45

    static func generateContent(
        configuration: GeminiConfiguration,
        payload: GeminiGenerateContentRequestDTO
    ) throws -> URLRequest {
        var components = URLComponents(
            url: baseURL.appendingPathComponent("\(configuration.model):generateContent"),
            resolvingAgainstBaseURL: false
        )!
        components.queryItems = [
            URLQueryItem(name: "key", value: configuration.apiKey)
        ]

        var request = URLRequest(url: components.url!)
        request.httpMethod = "POST"
        request.timeoutInterval = requestTimeout
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = try JSONEncoder().encode(payload)
        return request
    }
}
