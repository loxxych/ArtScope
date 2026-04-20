//
//  SearchViewModel.swift
//  ArtScope
//
//  Created by loxxy on 20.04.2026.
//

import Combine
import Foundation

final class SearchViewModel: ObservableObject {
    @Published var query = ""
    @Published private(set) var artists: [ArtistPreview] = []
    @Published private(set) var styles: [StylePreview] = []
    @Published private(set) var isLoading = false

    private let artistService: ArtistService

    init(artistService: ArtistService) {
        self.artistService = artistService
    }

    var filteredArtists: [ArtistPreview] {
        let normalizedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !normalizedQuery.isEmpty else { return [] }

        return artists.filter { artist in
            artist.name.localizedCaseInsensitiveContains(normalizedQuery) ||
            artist.summary.localizedCaseInsensitiveContains(normalizedQuery)
        }
    }

    var filteredStyles: [StylePreview] {
        let normalizedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !normalizedQuery.isEmpty else { return styles }

        return styles.filter { style in
            style.name.localizedCaseInsensitiveContains(normalizedQuery)
        }
    }

    var shouldShowArtistsSection: Bool {
        !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var hasNoResults: Bool {
        shouldShowArtistsSection && filteredArtists.isEmpty && filteredStyles.isEmpty
    }

    func load() {
        isLoading = true
        let group = DispatchGroup()

        group.enter()
        artistService.fetchArtists { [weak self] result in
            DispatchQueue.main.async {
                if case let .success(artists) = result {
                    self?.artists = artists
                }
                group.leave()
            }
        }

        group.enter()
        artistService.fetchStyles { [weak self] result in
            DispatchQueue.main.async {
                if case let .success(styles) = result {
                    self?.styles = styles
                }
                group.leave()
            }
        }

        group.notify(queue: .main) { [weak self] in
            self?.isLoading = false
        }
    }
}
