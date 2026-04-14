//
//  ArtScopeQuizService.swift
//  ArtScope
//
//  Created by loxxy on 14.04.2026.
//

import Foundation

final class ArtScopeQuizService: QuizRemoteService {
    private let client: NetworkClient
    
    init(client: NetworkClient) {
        self.client = client
    }
    
    func fetchDailyQuiz(completion: @escaping (Result<Quiz, Error>) -> Void) {
        let request = QuizBackendEndpoint.dailyQuiz()
        client.request(request) { (result: Result<QuizResponseDTO, Error>) in
            completion(result.map(QuizMapper.map))
        }
    }
    
    func fetchQuizTopics(completion: @escaping (Result<[QuizTopic], Error>) -> Void) {
        let request = QuizBackendEndpoint.quizTopics()
        client.request(request) { (result: Result<[QuizTopicDTO], Error>) in
            completion(result.map { $0.map(QuizMapper.map) })
        }
    }
    
    func fetchAllQuizzes(completion: @escaping (Result<[QuizListItem], Error>) -> Void) {
        let request = QuizBackendEndpoint.allQuizzes()
        client.request(request) { (result: Result<[QuizListItemDTO], Error>) in
            completion(result.map { $0.map(QuizMapper.map) })
        }
    }
    
    func fetchArtistQuiz(entityID: String, completion: @escaping (Result<Quiz, Error>) -> Void) {
        let request = QuizBackendEndpoint.artistQuiz(entityID: entityID)
        client.request(request) { (result: Result<QuizResponseDTO, Error>) in
            completion(result.map(QuizMapper.map))
        }
    }
}
