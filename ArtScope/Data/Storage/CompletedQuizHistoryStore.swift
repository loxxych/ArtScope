//
//  CompletedQuizHistoryStore.swift
//  ArtScope
//
//  Created by loxxy on 20.04.2026.
//

import Foundation

protocol CompletedQuizHistoryStore {
    func fetchResults() -> [CompletedQuizHistoryItem]
    func save(_ item: CompletedQuizHistoryItem)
}

final class UserDefaultsCompletedQuizHistoryStore: CompletedQuizHistoryStore {
    private enum Constants {
        static let storageKey = "completed_quiz_history_items"
        static let maxItems = 10
    }

    private let defaults: UserDefaults
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func fetchResults() -> [CompletedQuizHistoryItem] {
        guard
            let data = defaults.data(forKey: Constants.storageKey),
            let items = try? decoder.decode([CompletedQuizHistoryItem].self, from: data)
        else {
            return []
        }

        return items.sorted { $0.completedAt > $1.completedAt }
    }

    func save(_ item: CompletedQuizHistoryItem) {
        var items = fetchResults()
        items.removeAll { $0.id == item.id }
        items.insert(item, at: 0)
        items = Array(items.prefix(Constants.maxItems))
        persist(items)
    }

    private func persist(_ items: [CompletedQuizHistoryItem]) {
        guard let data = try? encoder.encode(items) else {
            return
        }

        defaults.set(data, forKey: Constants.storageKey)
    }
}
