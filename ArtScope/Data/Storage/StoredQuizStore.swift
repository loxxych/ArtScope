//
//  StoredQuizStore.swift
//  ArtScope
//
//  Created by loxxy on 20.04.2026.
//

import Foundation

protocol StoredQuizStore {
    func fetchQuizzes() -> [Quiz]
    func save(_ quiz: Quiz)
}

final class UserDefaultsStoredQuizStore: StoredQuizStore {
    private struct Entry: Codable {
        let quiz: Quiz
        let savedAt: Date
    }

    private enum Constants {
        static let storageKey = "stored_generated_quizzes"
        static let maxStoredQuizzes = 10
    }

    private let defaults: UserDefaults
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func fetchQuizzes() -> [Quiz] {
        fetchEntries()
            .sorted { $0.savedAt > $1.savedAt }
            .map(\.quiz)
    }

    func save(_ quiz: Quiz) {
        var entries = fetchEntries()
        entries.removeAll { $0.quiz.id == quiz.id }
        entries.insert(Entry(quiz: quiz, savedAt: Date()), at: 0)
        entries = Array(entries.prefix(Constants.maxStoredQuizzes))
        persist(entries)
    }

    private func fetchEntries() -> [Entry] {
        guard
            let data = defaults.data(forKey: Constants.storageKey),
            let entries = try? decoder.decode([Entry].self, from: data)
        else {
            return []
        }

        return entries
    }

    private func persist(_ entries: [Entry]) {
        guard let data = try? encoder.encode(entries) else {
            return
        }

        defaults.set(data, forKey: Constants.storageKey)
    }
}
