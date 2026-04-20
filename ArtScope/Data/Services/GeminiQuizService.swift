//
//  GeminiQuizService.swift
//  ArtScope
//
//  Created by loxxy on 15.04.2026.
//

import Foundation

final class GeminiQuizService: QuizService {
    private enum Constants {
        static let artistQuestionCount = 5
        static let dailyQuestionCount = 5
        static let artistCacheLifetime: TimeInterval = 60 * 60 * 12
    }

    private let client: NetworkClient
    private let configuration: GeminiConfiguration?
    private let cacheStore: QuizCacheStore
    private let storedQuizStore: StoredQuizStore
    private let studiedArtworkStore: StudiedArtworkStore
    private let calendar: Calendar

    init(
        client: NetworkClient,
        configuration: GeminiConfiguration? = GeminiConfiguration.fromBundle(),
        cacheStore: QuizCacheStore,
        storedQuizStore: StoredQuizStore,
        studiedArtworkStore: StudiedArtworkStore,
        calendar: Calendar = .current
    ) {
        self.client = client
        self.configuration = configuration
        self.cacheStore = cacheStore
        self.storedQuizStore = storedQuizStore
        self.studiedArtworkStore = studiedArtworkStore
        self.calendar = calendar
    }

    func fetchStoredQuizzes() -> [Quiz] {
        storedQuizStore.fetchQuizzes()
    }

    func fetchDailyQuiz(completion: @escaping (Result<Quiz, Error>) -> Void) {
        let studiedArtworks = studiedArtworkStore.fetchStudiedArtworks()
        let cacheKey = QuizPromptFactory.dailyQuizCacheKey(for: studiedArtworks, calendar: calendar)

        if let cachedQuiz = cacheStore.quiz(forKey: cacheKey) {
            storedQuizStore.save(cachedQuiz)
            completion(.success(cachedQuiz))
            return
        }

        generateQuiz(
            cacheKey: cacheKey,
            expirationDate: nextDayStart(),
            prompt: QuizPromptFactory.dailyQuizPrompt(
                studiedArtworks: studiedArtworks,
                questionCount: Constants.dailyQuestionCount
            ),
            completion: completion
        )
    }

    func fetchArtistQuiz(
        artistID: String,
        artistName: String,
        biography: String?,
        works: [ArtistWork],
        completion: @escaping (Result<Quiz, Error>) -> Void
    ) {
        let cacheKey = QuizPromptFactory.artistQuizCacheKey(artistID: artistID)

        if let cachedQuiz = cacheStore.quiz(forKey: cacheKey) {
            storedQuizStore.save(cachedQuiz)
            completion(.success(cachedQuiz))
            return
        }

        generateQuiz(
            cacheKey: cacheKey,
            expirationDate: Date().addingTimeInterval(Constants.artistCacheLifetime),
            prompt: QuizPromptFactory.artistQuizPrompt(
                artistID: artistID,
                artistName: artistName,
                biography: biography,
                works: works,
                questionCount: Constants.artistQuestionCount
            ),
            completion: completion
        )
    }

    private func generateQuiz(
        cacheKey: String,
        expirationDate: Date,
        prompt: String,
        completion: @escaping (Result<Quiz, Error>) -> Void
    ) {
        guard let configuration else {
            completion(.failure(QuizGenerationError.missingAPIKey))
            return
        }

        requestQuiz(configuration: configuration, prompt: prompt, didRetryAfterInvalidJSON: false) { [weak self] result in
            switch result {
            case let .success(quiz):
                self?.cacheStore.save(quiz, forKey: cacheKey, expirationDate: expirationDate)
                self?.storedQuizStore.save(quiz)
                completion(.success(quiz))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    private func requestQuiz(
        configuration: GeminiConfiguration,
        prompt: String,
        didRetryAfterInvalidJSON: Bool,
        completion: @escaping (Result<Quiz, Error>) -> Void
    ) {
        do {
            let payload = GeminiGenerateContentRequestDTO(
                contents: [
                    GeminiContentRequestDTO(
                        role: "user",
                        parts: [GeminiPartRequestDTO(text: prompt)]
                    )
                ],
                generationConfig: GeminiGenerationConfigDTO(
                    temperature: 0.4,
                    responseMimeType: "application/json"
                )
            )

            let request = try GeminiEndpoint.generateContent(
                configuration: configuration,
                payload: payload
            )

            client.request(request) { [weak self] (result: Result<GeminiGenerateContentResponseDTO, Error>) in
                switch result {
                case let .success(response):
                    do {
                        guard let self else {
                            completion(.failure(QuizGenerationError.invalidResponseFormat))
                            return
                        }

                        let generatedText = try self.extractGeneratedText(from: response)
                        let quiz = try self.decodeQuiz(from: generatedText)
                        completion(.success(quiz))
                    } catch {
                        guard let self, !didRetryAfterInvalidJSON else {
                            completion(.failure(error))
                            return
                        }

                        let retryPrompt = QuizPromptFactory.invalidFormatRetryPrompt(for: prompt)
                        self.requestQuiz(
                            configuration: configuration,
                            prompt: retryPrompt,
                            didRetryAfterInvalidJSON: true,
                            completion: completion
                        )
                    }
                case let .failure(error):
                    completion(.failure(error))
                }
            }
        } catch {
            completion(.failure(error))
        }
    }

    private func extractGeneratedText(from response: GeminiGenerateContentResponseDTO) throws -> String {
        guard
            let candidates = response.candidates,
            let firstCandidate = candidates.first,
            let parts = firstCandidate.content?.parts
        else {
            throw QuizGenerationError.emptyResponse
        }

        let combinedText = parts.compactMap(\.text).joined(separator: "\n").trimmingCharacters(in: .whitespacesAndNewlines)
        guard !combinedText.isEmpty else {
            throw QuizGenerationError.emptyResponse
        }

        return combinedText
    }

    private func decodeQuiz(from generatedText: String) throws -> Quiz {
        let normalizedText = generatedText
            .replacingOccurrences(of: "```json", with: "")
            .replacingOccurrences(of: "```", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)

        guard let data = normalizedText.data(using: .utf8) else {
            throw QuizGenerationError.invalidResponseFormat
        }

        let dto = try JSONDecoder().decode(GeneratedQuizDTO.self, from: data)
        return QuizMapper.map(dto)
    }

    private func nextDayStart() -> Date {
        let today = calendar.startOfDay(for: Date())
        return calendar.date(byAdding: .day, value: 1, to: today) ?? Date().addingTimeInterval(60 * 60 * 24)
    }
}
