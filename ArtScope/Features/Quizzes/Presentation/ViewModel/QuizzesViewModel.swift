//
//  QuizzesViewModel.swift
//  ArtScope
//
//  Created by loxxy on 14.04.2026.
//

import Foundation

final class QuizzesViewModel {
    private let quizService: QuizService
    private let curatedTopics: [QuizGenerationTopic] = curatedTopicCatalog
    
    var onDailyQuizLoaded: ((Quiz) -> Void)?
    var onTopicsLoaded: (([QuizTopic]) -> Void)?
    var onQuizzesLoaded: (([QuizListItem]) -> Void)?
    var onLoadingFailed: ((Error) -> Void)?
    
    init(quizService: QuizService) {
        self.quizService = quizService
    }

    func curatedTopic(id: String) -> QuizGenerationTopic? {
        curatedTopics.first(where: { $0.id == id })
    }

    func fetchStoredQuiz(id: String) -> Quiz? {
        quizService.fetchStoredQuizzes().first(where: { $0.id == id })
    }
    
    func load() {
        onTopicsLoaded?(Self.defaultTopics)
        publishCuratedQuizzes()
        prefetchCuratedQuizzes()
        loadDailyQuiz()
    }

    func loadCuratedQuiz(
        id: String,
        completion: @escaping (Result<Quiz, Error>) -> Void
    ) {
        if let storedQuiz = fetchStoredQuiz(id: id) {
            completion(.success(storedQuiz))
            return
        }

        guard let topic = curatedTopic(id: id) else {
            completion(.failure(QuizGenerationError.invalidResponseFormat))
            return
        }

        quizService.fetchCuratedQuiz(topic: topic, completion: completion)
    }
    
    private func loadDailyQuiz() {
        quizService.fetchDailyQuiz { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case let .success(quiz):
                    self?.onDailyQuizLoaded?(quiz)
                    self?.publishCuratedQuizzes()
                case let .failure(error):
                    self?.onLoadingFailed?(error)
                }
            }
        }
    }

    private func publishCuratedQuizzes() {
        let quizzes = curatedTopics.map { topic in
            return QuizListItem(
                id: topic.id,
                topicID: topic.id,
                type: topic.type,
                title: topic.title,
                subtitle: topic.subtitle,
                description: topic.description ?? "Test your knowledge of \(topic.title.lowercased()).",
                difficulty: "medium",
                estimatedTimeSeconds: topic.questionCount * 20,
                questionCount: topic.questionCount,
                isDaily: false
            )
        }

        onQuizzesLoaded?(quizzes)
    }

    private func prefetchCuratedQuizzes(index: Int = 0) {
        guard curatedTopics.indices.contains(index) else { return }

        let topic = curatedTopics[index]
        if fetchStoredQuiz(id: topic.id) != nil {
            prefetchCuratedQuizzes(index: index + 1)
            return
        }

        quizService.fetchCuratedQuiz(topic: topic) { [weak self] result in
            DispatchQueue.main.async {
                if case let .failure(error) = result {
                    print("[Quizzes] curated prefetch failed for \(topic.id): \(error)")
                }
                self?.prefetchCuratedQuizzes(index: index + 1)
            }
        }
    }

    private static let curatedTopicCatalog: [QuizGenerationTopic] = [
        QuizGenerationTopic(
            id: "topic-impressionism",
            type: "style",
            title: "Impressionism",
            subtitle: "19th century light and color",
            description: "Test your knowledge of Impressionism, its atmosphere, brushwork, and major painters.",
            questionCount: 5
        ),
        QuizGenerationTopic(
            id: "topic-surrealism",
            type: "style",
            title: "Surrealism",
            subtitle: "Dreams and the unconscious",
            description: "Explore surreal imagery, automatic techniques, and major artists of the movement.",
            questionCount: 5
        ),
        QuizGenerationTopic(
            id: "topic-baroque",
            type: "style",
            title: "Baroque",
            subtitle: "Drama and grandeur",
            description: "Questions about Baroque painting, theatrical composition, and key masters.",
            questionCount: 5
        ),
        QuizGenerationTopic(
            id: "topic-realism",
            type: "style",
            title: "Realism",
            subtitle: "Everyday life on canvas",
            description: "Focus on Realism, truthful depiction, and the artists who shaped it.",
            questionCount: 5
        ),
        QuizGenerationTopic(
            id: "topic-cubism",
            type: "style",
            title: "Cubism",
            subtitle: "Fragments and geometry",
            description: "Questions about Cubism, its visual language, and its leading painters.",
            questionCount: 5
        ),
        QuizGenerationTopic(
            id: "topic-expressionism",
            type: "style",
            title: "Expressionism",
            subtitle: "Emotion over realism",
            description: "Test your knowledge of expressive color, distortion, and modernist tension.",
            questionCount: 5
        ),
        QuizGenerationTopic(
            id: "topic-19th-century",
            type: "era",
            title: "19th Century Art",
            subtitle: "A century of change",
            description: "A quiz about major artistic developments, movements, and figures of the 19th century.",
            questionCount: 5
        ),
        QuizGenerationTopic(
            id: "topic-salvador-dali",
            type: "artist",
            title: "Salvador Dalí",
            subtitle: "Surrealist icon",
            description: "Questions about Dalí's life, imagery, and the surrealist world he built.",
            questionCount: 5
        ),
        QuizGenerationTopic(
            id: "topic-vincent-van-gogh",
            type: "artist",
            title: "Vincent van Gogh",
            subtitle: "Color and emotion",
            description: "Explore van Gogh's life, technique, and lasting influence on modern art.",
            questionCount: 5
        ),
        QuizGenerationTopic(
            id: "topic-claude-monet",
            type: "artist",
            title: "Claude Monet",
            subtitle: "Founder of Impressionism",
            description: "A quiz about Monet's landscapes, light studies, and Impressionist legacy.",
            questionCount: 5
        ),
        QuizGenerationTopic(
            id: "topic-pablo-picasso",
            type: "artist",
            title: "Pablo Picasso",
            subtitle: "Cubism pioneer",
            description: "Test your knowledge of Picasso's periods, style changes, and major works.",
            questionCount: 5
        ),
        QuizGenerationTopic(
            id: "topic-frida-kahlo",
            type: "artist",
            title: "Frida Kahlo",
            subtitle: "Symbol and self-portrait",
            description: "Questions about Frida Kahlo's life, symbolism, and artistic identity.",
            questionCount: 5
        ),
        QuizGenerationTopic(
            id: "topic-gustav-klimt",
            type: "artist",
            title: "Gustav Klimt",
            subtitle: "Golden ornament",
            description: "Explore Klimt's decorative style, symbolism, and famous portraits.",
            questionCount: 5
        )
    ]

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

}
