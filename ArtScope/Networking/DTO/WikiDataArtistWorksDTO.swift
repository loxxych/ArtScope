//
//  WikiDataArtistWorksDTO.swift
//  ArtScope
//
//  Created by loxxy on 25.03.2026.
//

struct WikiDataArtistWorksDTO: Decodable {
    let results: Results
    
    struct Results: Decodable {
        let bindings: [Binding]
    }
    
    struct Binding: Decodable {
        let workLabel: Value?
        let image: Value?
        
        struct Value: Decodable {
            let value: String
        }
    }
}
