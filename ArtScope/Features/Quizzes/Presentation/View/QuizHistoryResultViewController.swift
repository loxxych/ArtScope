//
//  QuizHistoryResultViewController.swift
//  ArtScope
//
//  Created by loxxy on 20.04.2026.
//

import SwiftUI
import UIKit

final class QuizHistoryResultViewController: UIViewController {
    private let quiz: Quiz
    private let historyItem: CompletedQuizHistoryItem
    private lazy var hostingController = UIHostingController(
        rootView: QuizPlayScreen(
            title: quiz.title,
            subtitle: quiz.subtitle,
            quiz: quiz,
            mode: .result(
                elapsedTimeText: historyItem.elapsedTimeText ?? fallbackElapsedTimeText,
                scorePercent: historyItem.scorePercent
            ),
            onBack: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            },
            onRetry: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
        )
    )

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

    private var fallbackElapsedTimeText: String {
        let safeSeconds = max(quiz.estimatedTimeSeconds, 0)
        let minutes = safeSeconds / 60
        let remainder = safeSeconds % 60
        return String(format: "%d:%02d", minutes, remainder)
    }
}
