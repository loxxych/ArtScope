//
//  ViewModel.swift
//  ArtScope
//
//  Created by loxxy on 22.01.2026.
//

import Foundation

final class MainPageViewModel {
    private let artistService: ArtistService
    private let artistOfTheDayService: ArtistOfTheDayService
    
    var onArtistsLoaded: (([ArtistPreview], ArtistPreview) -> Void)?
    var onStylesLoaded: (([StylePreview]) -> Void)?
    var onLoadingFailed: ((Error) -> Void)?
    
    init(artistService: ArtistService, artistOfTheDayService: ArtistOfTheDayService) {
        self.artistService = artistService
        self.artistOfTheDayService = artistOfTheDayService
    }
    
    func loadArtists() {
        artistService.fetchArtists { [weak self] result in
            guard let self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case let .success(artists):
                    let featured = self.artistOfTheDayService.getArtist(from: artists)
                    self.onArtistsLoaded?(artists, featured)
                case let .failure(error):
                    self.onLoadingFailed?(error)
                }
            }
        }
    }
    
    func loadStyles() {
        artistService.fetchStyles { [weak self] result in
            guard let self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case let .success(styles):
                    self.onStylesLoaded?(styles)
                case let .failure(error):
                    self.onLoadingFailed?(error)
                }
            }
        }
    }
}
