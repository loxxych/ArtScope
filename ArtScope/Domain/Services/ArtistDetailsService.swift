//
//  ArtistDetailsService.swift
//  ArtScope
//
//  Created by loxxy on 25.03.2026.
//

protocol ArtistDetailsService {
    func fetchArtistDetails(
        entityID: String,
        preview: ArtistPreview,
        completion: @escaping (Result<ArtistDetailsContent, Error>) -> Void
    )
    
    func fetchArtistWorks(
        entityID: String,
        completion: @escaping (Result<[ArtistWork], Error>) -> Void
    )
}
