//
//  WikipediaStyleSummaryDTO.swift
//  ArtScope
//
//  Created by loxxy on 25.03.2026.
//

struct WikipediaStyleSummaryDTO: Decodable {
    let title: String?
    let extract: String?
    let thumbnail: Thumbnail?
    
    struct Thumbnail: Decodable {
        let source: String
    }
}
