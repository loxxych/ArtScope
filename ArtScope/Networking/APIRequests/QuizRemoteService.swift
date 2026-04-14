//
//  QuizRemoteService.swift
//  ArtScope
//
//  Created by loxxy on 14.04.2026.
//

protocol QuizRemoteService {
    func fetchDailyQuiz(completion: @escaping (Result<Quiz, Error>) -> Void)
    func fetchQuizTopics(completion: @escaping (Result<[QuizTopic], Error>) -> Void)
    func fetchAllQuizzes(completion: @escaping (Result<[QuizListItem], Error>) -> Void)
    func fetchArtistQuiz(entityID: String, completion: @escaping (Result<Quiz, Error>) -> Void)
}
