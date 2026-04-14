//
//  ArtistQuizViewModel.swift
//  ArtScope
//
//  Created by loxxy on 14.04.2026.
//

import Foundation

final class ArtistQuizViewModel {
    private let artistID: String
    private let quizService: QuizRemoteService
    
    var onQuizLoaded: ((Quiz) -> Void)?
    var onLoadingFailed: ((Error) -> Void)?
    
    init(artistID: String, quizService: QuizRemoteService) {
        self.artistID = artistID
        self.quizService = quizService
    }
    
    func load() {
        guard let entityID = entityID(from: artistID) else { return }
        
        quizService.fetchArtistQuiz(entityID: entityID) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case let .success(quiz):
                    self?.onQuizLoaded?(quiz)
                case let .failure(error):
                    self?.onLoadingFailed?(error)
                }
            }
        }
    }
    
    private func entityID(from artistIdentifier: String) -> String? {
        URL(string: artistIdentifier)?.lastPathComponent
    }
}
