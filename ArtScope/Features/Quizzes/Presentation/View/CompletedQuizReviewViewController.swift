//
//  CompletedQuizReviewViewController.swift
//  ArtScope
//
//  Created by loxxy on 04.05.2026.
//

import SwiftUI
import UIKit

final class CompletedQuizReviewViewController: UIViewController {
    private let quiz: Quiz
    private let historyItem: CompletedQuizHistoryItem
    private var currentQuestionIndex = 0

    private lazy var hostingController = UIHostingController(rootView: makeRootView())

    init(quiz: Quiz, historyItem: CompletedQuizHistoryItem) {
        self.quiz = quiz
        self.historyItem = historyItem
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        menuController?.setMenuBarHidden(true, animated: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        menuController?.setMenuBarHidden(false, animated: true)
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
        QuizPlayScreen(
            title: quiz.title,
            subtitle: quiz.subtitle,
            quiz: quiz,
            mode: .review(
                questionIndex: currentQuestionIndex,
                selectedOptionID: selectedOptionIDForCurrentQuestion,
                elapsedTimeText: historyItem.elapsedTimeText ?? fallbackElapsedTimeText,
                scorePercent: historyItem.scorePercent,
                showsElapsedTime: showsElapsedTime
            ),
            onBack: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            },
            onSelectOption: nil,
            onAction: nil,
            onRetry: nil,
            onPreviousQuestion: { [weak self] in
                self?.showPreviousQuestion()
            },
            onNextQuestion: { [weak self] in
                self?.showNextQuestion()
            }
        )
    }

    private var selectedOptionIDForCurrentQuestion: String? {
        guard quiz.payload.questions.indices.contains(currentQuestionIndex) else { return nil }
        let questionID = quiz.payload.questions[currentQuestionIndex].id
        return historyItem.answerRecords?.first(where: {
            $0.questionIndex == currentQuestionIndex || $0.questionID == questionID
        })?.selectedOptionID
    }

    private func showPreviousQuestion() {
        guard currentQuestionIndex > 0 else { return }
        currentQuestionIndex -= 1
        refresh()
    }

    private func showNextQuestion() {
        guard currentQuestionIndex < quiz.payload.questions.count - 1 else { return }
        currentQuestionIndex += 1
        refresh()
    }

    private func refresh() {
        hostingController.rootView = makeRootView()
    }

    private var showsElapsedTime: Bool {
        if let showsElapsedTime = historyItem.showsElapsedTime {
            return showsElapsedTime
        }

        return quiz.type != "artist" && quiz.type != "style"
    }

    private var fallbackElapsedTimeText: String {
        let safeSeconds = max(quiz.estimatedTimeSeconds, 0)
        let minutes = safeSeconds / 60
        let remainder = safeSeconds % 60
        return String(format: "%d:%02d", minutes, remainder)
    }
}
