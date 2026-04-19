//
//  WikipediaPageExtractDTO.swift
//  ArtScope
//
//  Created by loxxy on 13.04.2026.
//

struct WikipediaPageExtractDTO: Decodable {
    let query: Query
    
    struct Query: Decodable {
        let pages: [Page]
    }
    
    struct Page: Decodable {
        let title: String?
        let extract: String?
        let missing: Bool?
    }
}
