//
//  ViewModel.swift
//  ArtScope
//
//  Created by loxxy on 22.01.2026.
//

import Foundation

final class MainPageViewModel {
    private let artistService: ArtistService
    
    var onArtistsLoaded: (([ArtistPreview]) -> Void)?
    var onLoadingFailed: ((Error) -> Void)?
    
    init(artistService: ArtistService) {
        self.artistService = artistService
    }
    
    func loadArtists() {
        artistService.fetchArtists { [weak self] result in
            guard let self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case let .success(artists):
                    self.onArtistsLoaded?(artists)
                case let .failure(error):
                    self.onLoadingFailed?(error)
                }
            }
        }
    }
}
