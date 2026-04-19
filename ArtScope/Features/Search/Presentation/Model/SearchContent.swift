//
//  SearchContent.swift
//  ArtScope
//
//  Created by loxxy on 19.04.2026.
//

import Foundation

struct SearchContent {
    let searchPlaceholder: String
    let featuredCategory: SearchFeaturedCategory
    let styleSectionTitle: String
    let styles: [SearchStyleItem]
}

struct SearchFeaturedCategory: Identifiable {
    let id: String
    let title: String
    let imageURL: URL?
}

struct SearchStyleItem: Identifiable {
    let id: String
    let title: String
    let imageURL: URL?
}

enum SearchSampleData {
    static let content = SearchContent(
        searchPlaceholder: "Search for artists, works, styles etc.",
        featuredCategory: SearchFeaturedCategory(
            id: "artists",
            title: "Artists",
            imageURL: URL(string: "https://upload.wikimedia.org/wikipedia/en/8/8b/MetamorphosisOfNarcissus.jpg")
        ),
        styleSectionTitle: "Art styles and\nmovements",
        styles: [
            SearchStyleItem(
                id: "impressionism-1",
                title: "Impressionism",
                imageURL: URL(string: "https://upload.wikimedia.org/wikipedia/commons/0/0d/Claude_Monet%2C_Impression%2C_soleil_levant.jpg")
            ),
            SearchStyleItem(
                id: "cubism-1",
                title: "Cubism",
                imageURL: URL(string: "https://upload.wikimedia.org/wikipedia/en/1/1c/Picasso%2C_1910%2C_Girl_with_a_Mandolin_%28Fanny_Tellier%29%2C_oil_on_canvas%2C_100.3_x_73.6_cm%2C_Museum_of_Modern_Art%2C_New_York.jpg")
            ),
            SearchStyleItem(
                id: "surrealism-1",
                title: "Surrealism",
                imageURL: URL(string: "https://upload.wikimedia.org/wikipedia/en/1/17/TheSonOfMan.jpg")
            ),
            SearchStyleItem(
                id: "realism-1",
                title: "Realism",
                imageURL: URL(string: "https://upload.wikimedia.org/wikipedia/commons/4/40/Jean-Fran%C3%A7ois_Millet_-_Gleaners_-_Google_Art_Project_2.jpg")
            ),
            SearchStyleItem(
                id: "impressionism-2",
                title: "Impressionism",
                imageURL: URL(string: "https://upload.wikimedia.org/wikipedia/commons/0/0d/Claude_Monet%2C_Impression%2C_soleil_levant.jpg")
            ),
            SearchStyleItem(
                id: "cubism-2",
                title: "Cubism",
                imageURL: URL(string: "https://upload.wikimedia.org/wikipedia/en/1/1c/Picasso%2C_1910%2C_Girl_with_a_Mandolin_%28Fanny_Tellier%29%2C_oil_on_canvas%2C_100.3_x_73.6_cm%2C_Museum_of_Modern_Art%2C_New_York.jpg")
            )
        ]
    )
}
