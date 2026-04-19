//
//  WorkDetailsViewModel.swift
//  ArtScope
//
//  Created by loxxy on 25.03.2026.
//

import Foundation

final class WorkDetailsViewModel {
    // MARK: - Properties
    private let work: ArtistWork
    private let artistName: String
    private let service: WorkDetailsService
    
    var onDetailsLoaded: ((WorkDetailsContent) -> Void)?
    var onLoadingFailed: ((Error) -> Void)?
    
    // MARK: - Lifecycle
    init(work: ArtistWork, artistName: String, service: WorkDetailsService) {
        self.work = work
        self.artistName = artistName
        self.service = service
    }
    
    // MARK: - Data
    func load() {
        guard let workID = entityID(from: work.id) else { return }
        
        service.fetchWorkDetails(workID: workID, work: work, artistName: artistName) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case let .success(details):
                    self?.onDetailsLoaded?(details)
                case let .failure(error):
                    self?.onLoadingFailed?(error)
                }
            }
        }
    }
    
    private func entityID(from workIdentifier: String) -> String? {
        URL(string: workIdentifier)?.lastPathComponent
    }
}
