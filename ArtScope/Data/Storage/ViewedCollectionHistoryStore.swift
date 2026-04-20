//
//  ViewedCollectionHistoryStore.swift
//  ArtScope
//
//  Created by loxxy on 20.04.2026.
//

import Foundation

protocol ViewedCollectionHistoryStore {
    func fetchItems() -> [ViewedCollectionHistoryItem]
    func save(_ item: ViewedCollectionHistoryItem)
}

final class UserDefaultsViewedCollectionHistoryStore: ViewedCollectionHistoryStore {
    private enum Constants {
        static let storageKey = "viewed_collection_history_items"
        static let maxItems = 12
    }

    private let defaults: UserDefaults
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func fetchItems() -> [ViewedCollectionHistoryItem] {
        guard
            let data = defaults.data(forKey: Constants.storageKey),
            let items = try? decoder.decode([ViewedCollectionHistoryItem].self, from: data)
        else {
            return []
        }

        return items.sorted { $0.viewedAt > $1.viewedAt }
    }

    func save(_ item: ViewedCollectionHistoryItem) {
        var items = fetchItems()
        items.removeAll { $0.id == item.id && $0.kind == item.kind }
        items.insert(item, at: 0)
        items = Array(items.prefix(Constants.maxItems))
        persist(items)
    }

    private func persist(_ items: [ViewedCollectionHistoryItem]) {
        guard let data = try? encoder.encode(items) else {
            return
        }

        defaults.set(data, forKey: Constants.storageKey)
    }
}
