//
//  WikiDataArtistService.swift
//  ArtScope
//
//  Created by loxxy on 28.01.2026.
//

final class WikiDataArtistService: ArtistService, ArtistDetailsService, WorkDetailsService {
    private let client: NetworkClient

    init(client: NetworkClient) {
        self.client = client
    }

    func fetchArtists(
            completion: @escaping (Result<[ArtistPreview], Error>) -> Void
        ) {
            let request = WikidataEndpoint.artistsList(limit: 8)

            client.request(request) { (result: Result<WikidataArtistsDTO, Error>) in
                completion(result.map(ArtistPreviewMapper.map))
            }
        }
    
    func fetchArtistDetails(
        entityID: String,
        preview: ArtistPreview,
        completion: @escaping (Result<ArtistDetailsContent, Error>) -> Void
    ) {
        let request = WikidataEndpoint.artistDetails(entityID: entityID)
        
        client.request(request) { (result: Result<WikiDataArtistDetailsDTO, Error>) in
            completion(result.map { ArtistDetailsMapper.map(details: $0, preview: preview) })
        }
    }
    
    func fetchArtistWorks(
        entityID: String,
        completion: @escaping (Result<[ArtistWork], Error>) -> Void
    ) {
        let request = WikidataEndpoint.artistWorks(entityID: entityID, limit: 8)
        
        client.request(request) { (result: Result<WikiDataArtistWorksDTO, Error>) in
            completion(result.map { ArtistDetailsMapper.map(works: $0) })
        }
    }
    
    func fetchWorkDetails(
        workID: String,
        work: ArtistWork,
        artistName: String,
        completion: @escaping (Result<WorkDetailsContent, Error>) -> Void
    ) {
        let request = WikidataEndpoint.workDetails(workID: workID)
        
        client.request(request) { (result: Result<WikiDataWorkDetailsDTO, Error>) in
            completion(result.map { WorkDetailsMapper.map(dto: $0, work: work, artistName: artistName) })
        }
    }
}
