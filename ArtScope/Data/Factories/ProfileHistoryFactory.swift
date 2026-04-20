//
//  ProfileHistoryFactory.swift
//  ArtScope
//
//  Created by loxxy on 20.04.2026.
//

import Foundation

enum ProfileHistoryFactory {
    static func makeCompletedQuizHistoryStore() -> CompletedQuizHistoryStore {
        UserDefaultsCompletedQuizHistoryStore()
    }

    static func makeViewedCollectionHistoryStore() -> ViewedCollectionHistoryStore {
        UserDefaultsViewedCollectionHistoryStore()
    }
}
