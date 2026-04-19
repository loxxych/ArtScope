//
//  ArtistQuizViewModel.swift
//  ArtScope
//
//  Created by loxxy on 14.04.2026.
//

import Foundation

final class ArtistQuizViewModel {
    private let artistID: String
    private let artistName: String
    private let quizService: QuizService
    private var biography: String?
    private var works: [ArtistWork] = []
    private var isLoading = false
    
    var onQuizLoaded: ((Quiz) -> Void)?
    var onLoadingFailed: ((Error) -> Void)?
    var onLoadingStateChanged: ((Bool) -> Void)?
    
    init(artistID: String, artistName: String, quizService: QuizService) {
        self.artistID = artistID
        self.artistName = artistName
        self.quizService = quizService
    }

    func updateContext(biography: String?, works: [ArtistWork]) {
        self.biography = biography
        self.works = works
    }
    
    func load(force _: Bool = false) {
        guard !isLoading else { return }
        guard let entityID = entityID(from: artistID) else { return }

        isLoading = true
        onLoadingStateChanged?(true)

        quizService.fetchArtistQuiz(
            artistID: entityID,
            artistName: artistName,
            biography: biography,
            works: works
        ) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                self?.onLoadingStateChanged?(false)

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
