//
//  ArtistService.swift
//  ArtScope
//
//  Created by loxxy on 28.01.2026.
//

protocol ArtistService {
//    func fetchArtist(
//        name: String,
//        completion: @escaping (Result<Artist, Error>) -> Void
//    )
    
    func fetchArtists(completion: @escaping (Result<[ArtistPreview], Error>) -> Void)
}
