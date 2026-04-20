//
//  QuizService.swift
//  ArtScope
//
//  Created by loxxy on 15.04.2026.
//

protocol QuizService {
    func fetchStoredQuizzes() -> [Quiz]
    func fetchDailyQuiz(completion: @escaping (Result<Quiz, Error>) -> Void)
    func fetchArtistQuiz(
        artistID: String,
        artistName: String,
        biography: String?,
        works: [ArtistWork],
        completion: @escaping (Result<Quiz, Error>) -> Void
    )
}
