//
//  ArtistDetailsContent.swift
//  ArtScope
//
//  Created by loxxy on 25.03.2026.
//

import Foundation

struct ArtistDetailsContent {
    let displayName: String
    let realName: String
    let biography: String
    let lifeSpan: String
    let imageURL: URL?
}

struct ArtistWork {
    let id: String
    let title: String
    let imageURL: URL?
}

struct WorkDetailsContent {
    let title: String
    let metadataLine: String
    let artistName: String
    let infoText: String
    let imageURL: URL?
    let relatedItems: [WorkRelatedItem]
}

struct WorkRelatedItem {
    let title: String
    let subtitle: String
}
