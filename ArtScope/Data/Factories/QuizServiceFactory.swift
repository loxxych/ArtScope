//
//  QuizServiceFactory.swift
//  ArtScope
//
//  Created by loxxy on 15.04.2026.
//

import Foundation

enum QuizServiceFactory {
    static func makeQuizService() -> QuizService {
        GeminiQuizService(
            client: URLSessionNetworkClient(),
            cacheStore: UserDefaultsQuizCacheStore(),
            storedQuizStore: UserDefaultsStoredQuizStore(),
            studiedArtworkStore: UserDefaultsStudiedArtworkStore()
        )
    }

    static func makeStudiedArtworkStore() -> StudiedArtworkStore {
        UserDefaultsStudiedArtworkStore()
    }
}
