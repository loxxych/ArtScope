//
//  StyleDetailContent.swift
//  ArtScope
//
//  Created by loxxy on 15.04.2026.
//

import Foundation

struct StyleDetailContent: Identifiable {
    let id: String
    let title: String
    let description: String
    let heroImageURL: URL?
    let artists: [StyleArtistItem]
    let works: [StyleWorkItem]
}

struct StyleArtistItem: Identifiable {
    let id: String
    let name: String
    let imageURL: URL?
}

struct StyleWorkItem: Identifiable {
    let id: String
    let title: String
    let imageURL: URL?
}

enum StyleDetailSampleData {
    static let impressionism = StyleDetailContent(
        id: "style-impressionism",
        title: "Impressionism",
        description: "Impressionism was a 19th-century art movement characterized by visible brush strokes, open composition, emphasis on accurate depiction of light in its changing qualities, and scenes of everyday life.",
        heroImageURL: URL(string: "https://upload.wikimedia.org/wikipedia/commons/0/0d/Claude_Monet%2C_Impression%2C_soleil_levant.jpg"),
        artists: [
            StyleArtistItem(
                id: "salvador-dali",
                name: "Salvador Dali",
                imageURL: URL(string: "https://upload.wikimedia.org/wikipedia/commons/2/24/Salvador_Dal%C3%AD_1939.jpg")
            ),
            StyleArtistItem(
                id: "pablo-picasso",
                name: "Pablo Picasso",
                imageURL: URL(string: "https://upload.wikimedia.org/wikipedia/commons/9/98/Pablo_picasso_1.jpg")
            ),
            StyleArtistItem(
                id: "vincent-van-gogh",
                name: "Vincent Van Gogh",
                imageURL: URL(string: "https://upload.wikimedia.org/wikipedia/commons/b/bd/Vincent_van_Gogh_-_Self-Portrait_-_Google_Art_Project_%28454545%29.jpg")
            ),
            StyleArtistItem(
                id: "claude-monet",
                name: "Claude Monet",
                imageURL: URL(string: "https://upload.wikimedia.org/wikipedia/commons/4/4d/Claude_Monet_1899_Nadar_crop.jpg")
            )
        ],
        works: [
            StyleWorkItem(
                id: "great-masturbator",
                title: "The great masturbator",
                imageURL: URL(string: "https://upload.wikimedia.org/wikipedia/en/b/b5/The_Great_Masturbator.jpg")
            ),
            StyleWorkItem(
                id: "persistence-of-memory",
                title: "The Persistence of Memory",
                imageURL: URL(string: "https://upload.wikimedia.org/wikipedia/en/d/dd/The_Persistence_of_Memory.jpg")
            ),
            StyleWorkItem(
                id: "metamorphosis-of-narcissus",
                title: "Metamorphosis of Narcissus",
                imageURL: URL(string: "https://upload.wikimedia.org/wikipedia/en/8/8b/MetamorphosisOfNarcissus.jpg")
            )
        ]
    )
}
