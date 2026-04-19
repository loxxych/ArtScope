//
//  WikiDataArtistDTO.swift
//  ArtScope
//
//  Created by loxxy on 28.01.2026.
//

struct WikidataArtistsDTO: Decodable {
    let results: Results

    struct Results: Decodable {
        let bindings: [Binding]
    }

    struct Binding: Decodable {
        let artist: Value
        let artistLabel: Value
        let artistDescription: Value?
        let image: Value?

        struct Value: Decodable {
            let value: String
        }
    }
}
