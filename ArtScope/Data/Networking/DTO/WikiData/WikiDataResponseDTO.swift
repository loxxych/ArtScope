//
//  WikiDataResponseDTO.swift
//  ArtScope
//
//  Created by loxxy on 28.01.2026.
//

struct WikidataResponseDTO: Decodable {
    let results: ResultsDTO

    struct ResultsDTO: Decodable {
        let bindings: [BindingDTO]
    }
}
