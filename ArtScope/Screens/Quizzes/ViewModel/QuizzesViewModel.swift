//
//  QuizzesViewModel.swift
//  ArtScope
//
//  Created by Codex on 14.04.2026.
//

import Foundation

final class QuizzesViewModel {
    private let quizService: QuizRemoteService
    
    var onDailyQuizLoaded: ((Quiz) -> Void)?
    var onTopicsLoaded: (([QuizTopic]) -> Void)?
    var onQuizzesLoaded: (([QuizListItem]) -> Void)?
    var onLoadingFailed: ((Error) -> Void)?
    
    init(quizService: QuizRemoteService) {
        self.quizService = quizService
    }
    
    func load() {
        loadDailyQuiz()
        loadTopics()
        loadAllQuizzes()
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
    
    private func loadTopics() {
        quizService.fetchQuizTopics { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case let .success(topics):
                    self?.onTopicsLoaded?(topics)
                case let .failure(error):
                    self?.onLoadingFailed?(error)
                }
            }
        }
    }
    
    private func loadAllQuizzes() {
        quizService.fetchAllQuizzes { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case let .success(quizzes):
                    self?.onQuizzesLoaded?(quizzes)
                case let .failure(error):
                    self?.onLoadingFailed?(error)
                }
            }
        }
    }
}
