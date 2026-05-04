//
//  CompletedQuizzesListViewController.swift
//  ArtScope
//
//  Created by loxxy on 30.04.2026.
//

import SwiftUI
import UIKit

final class CompletedQuizzesListViewController: UIViewController {
    private let items: [CompletedQuizHistoryItem]
    private let quizService: QuizService = QuizServiceFactory.makeQuizService()

    private lazy var hostingController = UIHostingController(
        rootView: CompletedQuizHistoryScreen(
            items: items,
            onBack: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            },
            onItemSelected: { [weak self] item in
                self?.showResult(for: item)
            }
        )
    )

    init(items: [CompletedQuizHistoryItem]) {
        self.items = items
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

    private func showResult(for item: CompletedQuizHistoryItem) {
        if let quizSnapshot = item.quizSnapshot {
            let vc = CompletedQuizReviewViewController(quiz: quizSnapshot, historyItem: item)
            navigationController?.pushViewController(vc, animated: true)
            return
        }

        guard
            let sourceQuizID = item.sourceQuizID,
            let quiz = quizService.fetchStoredQuizzes().first(where: { $0.id == sourceQuizID || $0.topicID == sourceQuizID })
        else {
            print("[Profile] quiz history item is missing source quiz: \(item.id)")
            return
        }

        let vc = CompletedQuizReviewViewController(quiz: quiz, historyItem: item)
        navigationController?.pushViewController(vc, animated: true)
    }
}
