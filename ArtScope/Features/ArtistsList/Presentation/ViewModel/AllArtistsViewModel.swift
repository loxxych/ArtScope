//
//  AllArtistsViewModel.swift
//  ArtScope
//
//  Created by loxxy on 05.05.2026.
//

import Combine
import Foundation

final class AllArtistsViewModel: ObservableObject {
    @Published private(set) var artists: [ArtistPreview] = []
    @Published private(set) var isLoadingMore = false

    private let artistService: ArtistService
    private let additionalArtistsLimit: Int

    init(artistService: ArtistService, additionalArtistsLimit: Int = 10) {
        self.artistService = artistService
        self.additionalArtistsLimit = additionalArtistsLimit
    }

    func configureInitialArtists(_ initialArtists: [ArtistPreview]) {
        artists = initialArtists
    }

    func loadAdditionalArtistsIfNeeded() {
        guard !isLoadingMore else { return }

        isLoadingMore = true
        let excludedIDs = artists.map(\.id)

        artistService.fetchAdditionalArtists(
            limit: additionalArtistsLimit,
            excludingArtistIDs: excludedIDs
        ) { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }
                self.isLoadingMore = false

                switch result {
                case let .success(additionalArtists):
                    let existingIDs = Set(self.artists.map(\.id))
                    let uniqueAdditionalArtists = additionalArtists.filter { !existingIDs.contains($0.id) }
                    self.artists.append(contentsOf: uniqueAdditionalArtists)
                case .failure:
                    break
                }
            }
        }
    }
}
