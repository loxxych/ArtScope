//
//  WikiDataStylesDTO.swift
//  ArtScope
//
//  Created by loxxy on 25.03.2026.
//

struct WikiDataStylesDTO: Decodable {
    let results: Results
    
    struct Results: Decodable {
        let bindings: [Binding]
    }
    
    struct Binding: Decodable {
        let style: Value?
        let styleLabel: Value?
        let image: Value?
        
        struct Value: Decodable {
            let value: String
        }
    }
}
