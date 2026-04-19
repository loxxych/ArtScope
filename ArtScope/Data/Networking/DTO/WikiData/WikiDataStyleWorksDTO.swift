//
//  WikiDataStyleWorksDTO.swift
//  ArtScope
//
//  Created by loxxy on 19.04.2026.
//

struct WikiDataStyleWorksDTO: Decodable {
    let results: Results

    struct Results: Decodable {
        let bindings: [Binding]
    }

    struct Binding: Decodable {
        let work: Value?
        let workLabel: Value?
        let image: Value?
        let creatorLabel: Value?
        let creatorImage: Value?

        struct Value: Decodable {
            let value: String
        }
    }
}
