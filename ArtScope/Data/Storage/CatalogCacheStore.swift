//
//  CatalogCacheStore.swift
//  ArtScope
//
//  Created by loxxy on 09.05.2026.
//

import Foundation

protocol CatalogCacheStore {
    func featuredArtists() -> [ArtistPreview]?
    func saveFeaturedArtists(_ artists: [ArtistPreview], expirationDate: Date)

    func styles() -> [StylePreview]?
    func saveStyles(_ styles: [StylePreview], expirationDate: Date)
}

final class UserDefaultsCatalogCacheStore: CatalogCacheStore {
    private struct ArtistsEntry: Codable {
        let items: [ArtistPreview]
        let expirationDate: Date
    }

    private struct StylesEntry: Codable {
        let items: [StylePreview]
        let expirationDate: Date
    }

    private enum Constants {
        static let artistsStorageKey = "catalog_cache_featured_artists"
        static let stylesStorageKey = "catalog_cache_styles"
    }

    private let defaults: UserDefaults
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func featuredArtists() -> [ArtistPreview]? {
        guard
            let data = defaults.data(forKey: Constants.artistsStorageKey),
            let entry = try? decoder.decode(ArtistsEntry.self, from: data)
        else {
            return nil
        }

        guard entry.expirationDate > Date() else {
            defaults.removeObject(forKey: Constants.artistsStorageKey)
            return nil
        }

        return entry.items
    }

    func saveFeaturedArtists(_ artists: [ArtistPreview], expirationDate: Date) {
        let entry = ArtistsEntry(items: artists, expirationDate: expirationDate)
        guard let data = try? encoder.encode(entry) else { return }
        defaults.set(data, forKey: Constants.artistsStorageKey)
    }

    func styles() -> [StylePreview]? {
        guard
            let data = defaults.data(forKey: Constants.stylesStorageKey),
            let entry = try? decoder.decode(StylesEntry.self, from: data)
        else {
            return nil
        }

        guard entry.expirationDate > Date() else {
            defaults.removeObject(forKey: Constants.stylesStorageKey)
            return nil
        }

        return entry.items
    }

    func saveStyles(_ styles: [StylePreview], expirationDate: Date) {
        let entry = StylesEntry(items: styles, expirationDate: expirationDate)
        guard let data = try? encoder.encode(entry) else { return }
        defaults.set(data, forKey: Constants.stylesStorageKey)
    }
}
