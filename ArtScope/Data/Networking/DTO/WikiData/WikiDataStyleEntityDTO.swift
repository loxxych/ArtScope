//
//  WikiDataStyleEntityDTO.swift
//  ArtScope
//
//  Created by loxxy on 19.04.2026.
//

struct WikiDataStyleEntityDTO: Decodable {
    let results: Results

    struct Results: Decodable {
        let bindings: [Binding]
    }

    struct Binding: Decodable {
        let style: Value?

        struct Value: Decodable {
            let value: String
        }
    }
}
