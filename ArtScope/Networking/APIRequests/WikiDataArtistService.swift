//
//  WikiDataArtistService.swift
//  ArtScope
//
//  Created by loxxy on 28.01.2026.
//

final class WikiDataArtistService: ArtistService {
    private let client: NetworkClient

    init(client: NetworkClient) {
        self.client = client
    }

//    func fetchArtist(
//        name: String,
//        completion: @escaping (Result<Artist, Error>) -> Void
//    ) {
//        let request = WikidataEndpoint.artist(by: name)
//
//        client.request(request) { (result: Result<WikidataResponseDTO, Error>) in
//            completion(result.map(ArtistMapper.map))
//        }
//    }
//    
    func fetchArtists(
            completion: @escaping (Result<[ArtistPreview], Error>) -> Void
        ) {
            let request = WikidataEndpoint.artistsList(limit: 20)

            client.request(request) { (result: Result<WikidataArtistsDTO, Error>) in
                completion(result.map(ArtistPreviewMapper.map))
            }
        }
}
