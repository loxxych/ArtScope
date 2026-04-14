//
//  QuizBackendEndpoint.swift
//  ArtScope
//
//  Created by loxxy on 14.04.2026.
//

import Foundation

enum QuizBackendEndpoint {
    static let baseURL = URL(string: "http://127.0.0.1:8000")!
    private static let requestTimeout: TimeInterval = 15
    
    static func dailyQuiz() -> URLRequest {
        request(path: "/api/v1/quizzes/daily")
    }
    
    static func quizTopics() -> URLRequest {
        request(path: "/api/v1/quizzes/topics")
    }
    
    static func allQuizzes() -> URLRequest {
        request(path: "/api/v1/quizzes")
    }
    
    static func artistQuiz(entityID: String) -> URLRequest {
        request(path: "/api/v1/quizzes/artist/\(entityID)")
    }
    
    private static func request(path: String) -> URLRequest {
        var request = URLRequest(url: baseURL.appendingPathComponent(path.trimmingCharacters(in: CharacterSet(charactersIn: "/"))))
        request.timeoutInterval = requestTimeout
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
}
