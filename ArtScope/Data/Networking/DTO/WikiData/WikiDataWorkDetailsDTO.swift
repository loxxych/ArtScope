//
//  WikiDataWorkDetailsDTO.swift
//  ArtScope
//
//  Created by loxxy on 25.03.2026.
//

struct WikiDataWorkDetailsDTO: Decodable {
    let results: Results
    
    struct Results: Decodable {
        let bindings: [Binding]
    }
    
    struct Binding: Decodable {
        let workLabel: Value?
        let wikipediaTitle: Value?
        let inception: Value?
        let height: Value?
        let width: Value?
        let materialLabel: Value?
        let workDescription: Value?
        let movementLabel: Value?
        
        struct Value: Decodable {
            let value: String
        }
    }
}
