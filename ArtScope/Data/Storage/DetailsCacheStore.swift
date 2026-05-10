//
//  DetailsCacheStore.swift
//  ArtScope
//
//  Created by loxxy on 10.05.2026.
//

import Foundation

protocol DetailsCacheStore {
    func artistDetails(for entityID: String) -> ArtistDetailsContent?
    func saveArtistDetails(_ details: ArtistDetailsContent, for entityID: String, expirationDate: Date)

    func artistWorks(for entityID: String) -> [ArtistWork]?
    func saveArtistWorks(_ works: [ArtistWork], for entityID: String, expirationDate: Date)

    func styleDetails(for styleID: String) -> StyleDetailContent?
    func saveStyleDetails(_ details: StyleDetailContent, for styleID: String, expirationDate: Date)

    func workDetails(for workID: String) -> WorkDetailsContent?
    func saveWorkDetails(_ details: WorkDetailsContent, for workID: String, expirationDate: Date)
}

final class UserDefaultsDetailsCacheStore: DetailsCacheStore {
    private struct CacheEntry<Value: Codable>: Codable {
        let value: Value
        let expirationDate: Date
    }

    private enum Constants {
        static let artistDetailsPrefix = "details_cache_artist_details_"
        static let artistWorksPrefix = "details_cache_artist_works_"
        static let styleDetailsPrefix = "details_cache_style_details_"
        static let workDetailsPrefix = "details_cache_work_details_"
    }

    private let defaults: UserDefaults
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func artistDetails(for entityID: String) -> ArtistDetailsContent? {
        cachedValue(forKey: Constants.artistDetailsPrefix + entityID)
    }

    func saveArtistDetails(_ details: ArtistDetailsContent, for entityID: String, expirationDate: Date) {
        save(details, forKey: Constants.artistDetailsPrefix + entityID, expirationDate: expirationDate)
    }

    func artistWorks(for entityID: String) -> [ArtistWork]? {
        cachedValue(forKey: Constants.artistWorksPrefix + entityID)
    }

    func saveArtistWorks(_ works: [ArtistWork], for entityID: String, expirationDate: Date) {
        save(works, forKey: Constants.artistWorksPrefix + entityID, expirationDate: expirationDate)
    }

    func styleDetails(for styleID: String) -> StyleDetailContent? {
        cachedValue(forKey: Constants.styleDetailsPrefix + styleID)
    }

    func saveStyleDetails(_ details: StyleDetailContent, for styleID: String, expirationDate: Date) {
        save(details, forKey: Constants.styleDetailsPrefix + styleID, expirationDate: expirationDate)
    }

    func workDetails(for workID: String) -> WorkDetailsContent? {
        cachedValue(forKey: Constants.workDetailsPrefix + workID)
    }

    func saveWorkDetails(_ details: WorkDetailsContent, for workID: String, expirationDate: Date) {
        save(details, forKey: Constants.workDetailsPrefix + workID, expirationDate: expirationDate)
    }

    private func cachedValue<Value: Codable>(forKey key: String) -> Value? {
        guard
            let data = defaults.data(forKey: key),
            let entry = try? decoder.decode(CacheEntry<Value>.self, from: data)
        else {
            return nil
        }

        guard entry.expirationDate > Date() else {
            defaults.removeObject(forKey: key)
            return nil
        }

        return entry.value
    }

    private func save<Value: Codable>(_ value: Value, forKey key: String, expirationDate: Date) {
        let entry = CacheEntry(value: value, expirationDate: expirationDate)
        guard let data = try? encoder.encode(entry) else { return }
        defaults.set(data, forKey: key)
    }
}
