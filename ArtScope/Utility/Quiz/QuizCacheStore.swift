//
//  QuizCacheStore.swift
//  ArtScope
//
//  Created by Codex on 15.04.2026.
//

import Foundation

protocol QuizCacheStore {
    func quiz(forKey key: String) -> Quiz?
    func save(_ quiz: Quiz, forKey key: String, expirationDate: Date)
}

final class UserDefaultsQuizCacheStore: QuizCacheStore {
    private struct CacheEntry: Codable {
        let quiz: Quiz
        let expirationDate: Date
    }

    private enum Constants {
        static let storageKey = "quiz_cache_entries"
    }

    private let defaults: UserDefaults
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func quiz(forKey key: String) -> Quiz? {
        var entries = fetchEntries()

        guard let entry = entries[key] else {
            return nil
        }

        guard entry.expirationDate > Date() else {
            entries.removeValue(forKey: key)
            persist(entries)
            return nil
        }

        return entry.quiz
    }

    func save(_ quiz: Quiz, forKey key: String, expirationDate: Date) {
        var entries = fetchEntries()
        entries[key] = CacheEntry(quiz: quiz, expirationDate: expirationDate)
        persist(entries)
    }

    private func fetchEntries() -> [String: CacheEntry] {
        guard
            let data = defaults.data(forKey: Constants.storageKey),
            let entries = try? decoder.decode([String: CacheEntry].self, from: data)
        else {
            return [:]
        }

        return entries
    }

    private func persist(_ entries: [String: CacheEntry]) {
        guard let data = try? encoder.encode(entries) else {
            return
        }

        defaults.set(data, forKey: Constants.storageKey)
    }
}
