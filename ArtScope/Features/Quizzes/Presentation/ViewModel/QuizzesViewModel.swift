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
        publishStoredQuizzes()
        loadDailyQuiz()
    }
    
    private func loadDailyQuiz() {
        quizService.fetchDailyQuiz { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case let .success(quiz):
                    self?.onDailyQuizLoaded?(quiz)
                    self?.publishStoredQuizzes()
                case let .failure(error):
                    self?.onLoadingFailed?(error)
                }
            }
        }
    }

    private func publishStoredQuizzes() {
        let quizzes = quizService
            .fetchStoredQuizzes()
            .filter { !$0.isDaily }
            .map(Self.makeListItem(from:))

        onQuizzesLoaded?(quizzes)
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

    private static func makeListItem(from quiz: Quiz) -> QuizListItem {
        QuizListItem(
            id: quiz.id,
            topicID: quiz.topicID,
            type: quiz.type,
            title: listTitle(for: quiz),
            subtitle: quiz.subtitle,
            description: listDescription(for: quiz),
            difficulty: quiz.difficulty,
            estimatedTimeSeconds: quiz.estimatedTimeSeconds,
            questionCount: quiz.questionCount,
            isDaily: quiz.isDaily
        )
    }

    private static func listTitle(for quiz: Quiz) -> String {
        let candidates = [
            quiz.payload.title,
            quiz.title,
            quiz.subtitle,
            quiz.payload.subtitle
        ]

        return candidates
            .map { $0?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "" }
            .first(where: { !$0.isEmpty && $0.lowercased() != "quiz of the day" }) ?? quiz.title
    }

    private static func listDescription(for quiz: Quiz) -> String {
        let candidates = [
            quiz.description,
            quiz.payload.description,
            quiz.subtitle,
            quiz.payload.subtitle
        ]

        if let text = candidates
            .compactMap({ $0?.trimmingCharacters(in: .whitespacesAndNewlines) })
            .first(where: { !$0.isEmpty && $0.lowercased() != "quiz of the day" }) {
            return text
        }

        return "Test your \(listTitle(for: quiz).lowercased()) knowledge!"
    }
}
