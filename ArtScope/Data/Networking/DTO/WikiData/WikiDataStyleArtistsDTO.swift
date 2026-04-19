//
//  WikiDataStyleArtistsDTO.swift
//  ArtScope
//
//  Created by loxxy on 19.04.2026.
//

struct WikiDataStyleArtistsDTO: Decodable {
    let results: Results

    struct Results: Decodable {
        let bindings: [Binding]
    }

    struct Binding: Decodable {
        let artist: Value?
        let artistLabel: Value?
        let image: Value?

        struct Value: Decodable {
            let value: String
        }
    }
}
