//
//  QuizzesViewModel.swift
//  ArtScope
//
//  Created by loxxy on 14.04.2026.
//

import Foundation

final class QuizzesViewModel {
    private let quizService: QuizService
    
    var onDailyQuizLoaded: ((Quiz) -> Void)?
    var onTopicsLoaded: (([QuizTopic]) -> Void)?
    var onQuizzesLoaded: (([QuizListItem]) -> Void)?
    var onLoadingFailed: ((Error) -> Void)?
    
    init(quizService: QuizService) {
        self.quizService = quizService
    }
    
    func load() {
        onTopicsLoaded?(Self.defaultTopics)
        onQuizzesLoaded?(Self.defaultQuizzes)
        loadDailyQuiz()
    }
    
    private func loadDailyQuiz() {
        quizService.fetchDailyQuiz { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case let .success(quiz):
                    self?.onDailyQuizLoaded?(quiz)
                case let .failure(error):
                    self?.onLoadingFailed?(error)
                }
            }
        }
    }

    private static let defaultTopics: [QuizTopic] = [
        QuizTopic(
            id: "topic-daily",
            type: "daily",
            title: "Quiz of the Day",
            subtitle: "Daily selection",
            description: "Generated from artworks the user explored recently.",
            language: "en",
            isFeatured: true
        ),
        QuizTopic(
            id: "topic-surrealism",
            type: "movement",
            title: "Surrealism",
            subtitle: "Art movement",
            description: "Dream logic, symbolism and striking visual experiments.",
            language: "en",
            isFeatured: true
        ),
        QuizTopic(
            id: "topic-artist",
            type: "artist",
            title: "Artist Quiz",
            subtitle: "Single artist focus",
            description: "Quiz cards generated from an artist biography and artworks.",
            language: "en",
            isFeatured: false
        )
    ]

    private static let defaultQuizzes: [QuizListItem] = [
        QuizListItem(
            id: "quiz-daily",
            topicID: "topic-daily",
            type: "daily",
            title: "Quiz of the Day",
            subtitle: "Recently viewed artworks",
            description: "A fresh quiz generated from the works the user studied most recently.",
            difficulty: "easy",
            estimatedTimeSeconds: 120,
            questionCount: 5,
            isDaily: true
        ),
        QuizListItem(
            id: "quiz-artist-template",
            topicID: "topic-artist",
            type: "artist",
            title: "Artist Card Quiz",
            subtitle: "Per-artist section",
            description: "Each artist screen can request a dedicated Gemini-generated quiz.",
            difficulty: "easy",
            estimatedTimeSeconds: 90,
            questionCount: 5,
            isDaily: false
        )
    ]
}
