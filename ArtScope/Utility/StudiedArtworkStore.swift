//
//  StudiedArtworkStore.swift
//  ArtScope
//
//  Created by Codex on 15.04.2026.
//

import Foundation

protocol StudiedArtworkStore {
    func fetchStudiedArtworks() -> [StudiedArtwork]
    func markArtworkStudied(_ artwork: StudiedArtwork)
}

final class UserDefaultsStudiedArtworkStore: StudiedArtworkStore {
    private enum Constants {
        static let storageKey = "studied_artworks"
        static let maxStoredArtworks = 50
    }

    private let defaults: UserDefaults
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func fetchStudiedArtworks() -> [StudiedArtwork] {
        guard
            let data = defaults.data(forKey: Constants.storageKey),
            let artworks = try? decoder.decode([StudiedArtwork].self, from: data)
        else {
            return []
        }

        return artworks.sorted { $0.lastViewedAt > $1.lastViewedAt }
    }

    func markArtworkStudied(_ artwork: StudiedArtwork) {
        var artworks = fetchStudiedArtworks()
        artworks.removeAll { $0.workID == artwork.workID }
        artworks.insert(artwork, at: 0)
        artworks = Array(artworks.prefix(Constants.maxStoredArtworks))

        guard let data = try? encoder.encode(artworks) else {
            return
        }

        defaults.set(data, forKey: Constants.storageKey)
    }
}
