//
//  QuizPlayViewController.swift
//  ArtScope
//
//  Created by loxxy on 25.04.2026.
//

import SwiftUI
import UIKit

final class QuizPlayViewController: UIViewController {
    private let quiz: Quiz
    private let completedQuizHistoryStore: CompletedQuizHistoryStore

    private var currentQuestionIndex = 0
    private var selectedOptionID: String?
    private var isAnswerRevealed = false
    private var correctAnswersCount = 0
    private var didCountCurrentQuestion = false
    private var didPersistCompletion = false
    private var selectedAnswersByQuestionID: [String: String] = [:]
    private var startedAt = Date()
    private var questionStartedAt = Date()
    private var timer: Timer?
    private let questionTimeLimitSeconds = 90
    
    var onQuizCompleted: (() -> Void)?
    
    private lazy var hostingController = UIHostingController(rootView: makeRootView())

    init(quiz: Quiz) {
        self.quiz = quiz
        self.completedQuizHistoryStore = ProfileHistoryFactory.makeCompletedQuizHistoryStore()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        stopTimer()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        menuController?.setMenuBarHidden(true, animated: true)
        startTimerIfNeeded()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        menuController?.setMenuBarHidden(false, animated: true)
        stopTimer()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        hostingController.didMove(toParent: self)
    }

    private func makeRootView() -> QuizPlayScreen {
        if isFinished {
            return QuizPlayScreen(
                title: quiz.title,
                subtitle: quiz.subtitle,
                quiz: quiz,
                mode: .result(
                    elapsedTimeText: elapsedTimeText,
                    scorePercent: scorePercent
                ),
                onBack: { [weak self] in
                    self?.navigationController?.popViewController(animated: true)
                },
                onRetry: { [weak self] in
                    self?.restartQuiz()
                }
            )
        }

        return QuizPlayScreen(
            title: quiz.title,
            subtitle: quiz.subtitle,
            quiz: quiz,
            mode: .question(
                questionIndex: currentQuestionIndex,
                timeText: remainingTimeText,
                selectedOptionID: selectedOptionID,
                revealed: isAnswerRevealed,
                imageURL: nil,
                explanationText: currentQuestion?.explanation
            ),
            onBack: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            },
            onSelectOption: { [weak self] optionID in
                self?.selectedOptionID = optionID
                self?.refresh()
            },
            onAction: { [weak self] in
                self?.handleAction()
            },
            onRetry: nil
        )
    }

    private func handleAction() {
        guard let currentQuestion else { return }

        if isAnswerRevealed {
            if !didCountCurrentQuestion {
                if selectedOptionID == currentQuestion.correctOptionID {
                    correctAnswersCount += 1
                }
                didCountCurrentQuestion = true
            }

            if let selectedOptionID {
                selectedAnswersByQuestionID[currentQuestion.id] = selectedOptionID
            }

            currentQuestionIndex += 1
            selectedOptionID = nil
            isAnswerRevealed = false
            didCountCurrentQuestion = false
            questionStartedAt = Date()
            if isFinished {
                persistCompletionIfNeeded()
                stopTimer()
            }
            refresh()
            return
        }

        guard selectedOptionID != nil else { return }
        isAnswerRevealed = true
        refresh()
    }

    private func restartQuiz() {
        currentQuestionIndex = 0
        selectedOptionID = nil
        isAnswerRevealed = false
        correctAnswersCount = 0
        didCountCurrentQuestion = false
        didPersistCompletion = false
        selectedAnswersByQuestionID.removeAll()
        startedAt = Date()
        questionStartedAt = Date()
        startTimerIfNeeded()
        refresh()
    }

    private func refresh() {
        hostingController.rootView = makeRootView()
    }

    private var currentQuestion: QuizQuestion? {
        guard quiz.payload.questions.indices.contains(currentQuestionIndex) else {
            return nil
        }
        return quiz.payload.questions[currentQuestionIndex]
    }

    private var isFinished: Bool {
        currentQuestionIndex >= quiz.payload.questions.count
    }

    private var scorePercent: Int {
        let total = max(quiz.payload.questions.count, 1)
        return Int((Double(correctAnswersCount) / Double(total)) * 100)
    }

    private var remainingTimeText: String {
        let elapsedSeconds = Int(Date().timeIntervalSince(questionStartedAt))
        let remainingSeconds = max(questionTimeLimitSeconds - elapsedSeconds, 0)
        let minutes = remainingSeconds / 60
        let remainder = remainingSeconds % 60
        return String(format: "%d:%02d", minutes, remainder)
    }

    private var elapsedTimeText: String {
        let elapsedSeconds = Int(Date().timeIntervalSince(startedAt))
        let minutes = max(elapsedSeconds, 0) / 60
        let remainder = max(elapsedSeconds, 0) % 60
        return String(format: "%d:%02d", minutes, remainder)
    }

    private func startTimerIfNeeded() {
        stopTimer()
        guard !isFinished else { return }
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self else { return }
            if self.isFinished {
                self.stopTimer()
                return
            }
            if !self.isAnswerRevealed, Int(Date().timeIntervalSince(self.questionStartedAt)) >= self.questionTimeLimitSeconds {
                self.isAnswerRevealed = true
                self.selectedOptionID = nil
            }
            self.refresh()
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    private func persistCompletionIfNeeded() {
        guard !didPersistCompletion else { return }
        didPersistCompletion = true

        let total = max(quiz.payload.questions.count, 1)
        let percentage = Int((Double(correctAnswersCount) / Double(total)) * 100)
        let completedAt = Date()

        completedQuizHistoryStore.save(
            CompletedQuizHistoryItem(
                id: "\(quiz.id)-\(UUID().uuidString)",
                sourceQuizID: quiz.id,
                title: historyTitle(for: quiz, completedAt: completedAt),
                scorePercent: percentage,
                imageURLString: nil,
                elapsedTimeText: elapsedTimeText,
                showsElapsedTime: true,
                completedAt: completedAt,
                answerRecords: quiz.payload.questions.map { question in
                    let index = quiz.payload.questions.firstIndex(where: { $0.id == question.id }) ?? 0
                    return CompletedQuizAnswerRecord(
                        questionIndex: index,
                        questionID: question.id,
                        selectedOptionID: selectedAnswersByQuestionID[question.id]
                    )
                },
                quizSnapshot: quiz
            )
        )
        
        onQuizCompleted?()
    }

    private func historyTitle(for quiz: Quiz, completedAt: Date) -> String {
        if quiz.isDaily {
            return "\(quizDateString(from: completedAt)) Quiz of the day"
        }

        return quiz.title
    }

    private func quizDateString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yy"
        return formatter.string(from: date)
    }
}
