//
//  WikiDataArtistRelatedStylesDTO.swift
//  ArtScope
//
//  Created by loxxy on 19.04.2026.
//

struct WikiDataArtistRelatedStylesDTO: Decodable {
    let results: Results

    struct Results: Decodable {
        let bindings: [Binding]
    }

    struct Binding: Decodable {
        let movement: Value?
        let movementLabel: Value?

        struct Value: Decodable {
            let value: String
        }
    }
}
