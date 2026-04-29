//
//  StyleQuizViewModel.swift
//  ArtScope
//
//  Created by loxxy on 28.04.2026.
//

import Foundation
import Combine

final class StyleQuizViewModel: ObservableObject {
    enum State {
        case loading
        case unavailable
        case ready
        case question(question: QuizQuestion, selectedOptionID: String?, revealed: Bool)
        case result(correctAnswers: Int, totalQuestions: Int)
    }

    private let styleID: String
    private let styleName: String
    private let styleImageURL: URL?
    private let quizService: QuizService
    private let completedQuizHistoryStore: CompletedQuizHistoryStore

    private var description: String?
    private var artists: [StyleArtistItem] = []
    private var works: [StyleWorkItem] = []
    private var quiz: Quiz?
    private var currentQuestionIndex = 0
    private var selectedOptionID: String?
    private var isAnswerRevealed = false
    private var correctAnswersCount = 0
    private var didPersistCompletion = false
    private var isLoading = false

    @Published private(set) var state: State = .loading

    var resultElapsedTimeText: String {
        guard let quiz else { return "0:00" }
        return formatElapsedTime(seconds: quiz.estimatedTimeSeconds)
    }

    init(
        styleID: String,
        styleName: String,
        styleImageURL: URL?,
        quizService: QuizService
    ) {
        self.styleID = styleID
        self.styleName = styleName
        self.styleImageURL = styleImageURL
        self.quizService = quizService
        self.completedQuizHistoryStore = ProfileHistoryFactory.makeCompletedQuizHistoryStore()
    }

    func updateContext(description: String?, artists: [StyleArtistItem], works: [StyleWorkItem]) {
        self.description = description
        self.artists = artists
        self.works = works
    }

    func load(force _: Bool = false) {
        guard !isLoading else { return }

        isLoading = true
        state = .loading

        quizService.fetchStyleQuiz(
            styleID: styleID,
            styleName: styleName,
            description: description,
            artists: artists,
            works: works
        ) { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }
                self.isLoading = false

                switch result {
                case let .success(quiz):
                    self.quiz = quiz
                    self.didPersistCompletion = false
                    self.currentQuestionIndex = 0
                    self.selectedOptionID = nil
                    self.isAnswerRevealed = false
                    self.correctAnswersCount = 0
                    self.state = .ready
                case .failure:
                    self.quiz = nil
                    self.state = .unavailable
                }
            }
        }
    }

    func beginQuiz() {
        currentQuestionIndex = 0
        selectedOptionID = nil
        isAnswerRevealed = false
        correctAnswersCount = 0
        didPersistCompletion = false
        showCurrentQuestion()
    }

    func selectOption(_ optionID: String) {
        guard case let .question(question, _, revealed) = state, !revealed else { return }
        selectedOptionID = optionID
        state = .question(question: question, selectedOptionID: optionID, revealed: false)
    }

    func advanceAction() {
        guard let question = currentQuestion else {
            showResult()
            return
        }

        if isAnswerRevealed {
            if selectedOptionID == question.correctOptionID {
                correctAnswersCount += 1
            }

            currentQuestionIndex += 1
            selectedOptionID = nil
            isAnswerRevealed = false

            if currentQuestion != nil {
                showCurrentQuestion()
            } else {
                showResult()
            }
            return
        }

        guard selectedOptionID != nil else { return }

        isAnswerRevealed = true
        state = .question(
            question: question,
            selectedOptionID: selectedOptionID,
            revealed: true
        )
    }

    func retry() {
        currentQuestionIndex = 0
        selectedOptionID = nil
        isAnswerRevealed = false
        correctAnswersCount = 0
        didPersistCompletion = false
        state = .ready
    }

    private var currentQuestion: QuizQuestion? {
        guard let quiz, quiz.payload.questions.indices.contains(currentQuestionIndex) else {
            return nil
        }
        return quiz.payload.questions[currentQuestionIndex]
    }

    private func showResult() {
        let totalQuestions = quiz?.payload.questions.count ?? 0
        state = .result(correctAnswers: correctAnswersCount, totalQuestions: totalQuestions)
        persistCompletionIfNeeded(totalQuestions: totalQuestions)
    }

    private func showCurrentQuestion() {
        guard let question = currentQuestion else {
            showResult()
            return
        }

        state = .question(question: question, selectedOptionID: selectedOptionID, revealed: isAnswerRevealed)
    }

    private func persistCompletionIfNeeded(totalQuestions: Int) {
        guard !didPersistCompletion, let quiz else { return }
        didPersistCompletion = true

        let total = max(totalQuestions, 1)
        let scorePercent = Int((Double(correctAnswersCount) / Double(total)) * 100)

        completedQuizHistoryStore.save(
            CompletedQuizHistoryItem(
                id: "\(quiz.id)-\(styleID)-\(UUID().uuidString)",
                sourceQuizID: quiz.id,
                title: "\(styleName) quiz",
                scorePercent: scorePercent,
                imageURLString: styleImageURL?.absoluteString,
                elapsedTimeText: formatElapsedTime(seconds: quiz.estimatedTimeSeconds),
                completedAt: Date()
            )
        )
    }

    private func formatElapsedTime(seconds: Int) -> String {
        let safeSeconds = max(seconds, 0)
        let minutes = safeSeconds / 60
        let remainder = safeSeconds % 60
        return String(format: "%d:%02d", minutes, remainder)
    }
}
