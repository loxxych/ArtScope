//
//  ViewModel.swift
//  ArtScope
//
//  Created by loxxy on 22.01.2026.
//

final class MainPageViewModel {
    private let artistService: ArtistService
    
    var onArtistsLoaded: (([ArtistPreview]) -> Void)?
    
    init(artistService: ArtistService) {
        self.artistService = artistService
    }
    
    func loadArtists() {
        artistService.fetchArtists { [weak self] result in
            guard let self else { return }
            
            if case let .success(artists) = result {
                self.onArtistsLoaded?(artists)
            }
        }
    }
}
