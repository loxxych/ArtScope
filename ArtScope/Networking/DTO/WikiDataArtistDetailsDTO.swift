//
//  WikiDataArtistDetailsDTO.swift
//  ArtScope
//
//  Created by loxxy on 25.03.2026.
//

struct WikiDataArtistDetailsDTO: Decodable {
    let results: Results
    
    struct Results: Decodable {
        let bindings: [Binding]
    }
    
    struct Binding: Decodable {
        let artistLabel: Value?
        let artistDescription: Value?
        let birthName: Value?
        let birthDate: Value?
        let deathDate: Value?
        let citizenshipLabel: Value?
        let birthPlaceLabel: Value?
        let deathPlaceLabel: Value?
        let occupations: Value?
        
        struct Value: Decodable {
            let value: String
        }
    }
}
