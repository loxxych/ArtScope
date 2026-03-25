//
//  ArtistDetailsViewModel.swift
//  ArtScope
//
//  Created by loxxy on 25.03.2026.
//

import Foundation

final class ArtistDetailsViewModel {
    // MARK: - Properties
    private let preview: ArtistPreview
    private let service: ArtistDetailsService
    
    var onDetailsLoaded: ((ArtistDetailsContent) -> Void)?
    var onWorksLoaded: (([ArtistWork]) -> Void)?
    var onLoadingFailed: ((Error) -> Void)?
    
    // MARK: - Lifecycle
    init(preview: ArtistPreview, service: ArtistDetailsService) {
        self.preview = preview
        self.service = service
    }
    
    // MARK: - Data
    func load() {
        guard let entityID = entityID(from: preview.id) else { return }
        
        service.fetchArtistDetails(entityID: entityID, preview: preview) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case let .success(details):
                    self?.onDetailsLoaded?(details)
                case let .failure(error):
                    self?.onLoadingFailed?(error)
                }
            }
        }
        
        service.fetchArtistWorks(entityID: entityID) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case let .success(works):
                    self?.onWorksLoaded?(works)
                case let .failure(error):
                    self?.onLoadingFailed?(error)
                }
            }
        }
    }
    
    private func entityID(from artistIdentifier: String) -> String? {
        URL(string: artistIdentifier)?.lastPathComponent
    }
}
