//
//  ArtistDetailsContent.swift
//  ArtScope
//
//  Created by loxxy on 25.03.2026.
//

import Foundation

struct ArtistDetailsContent: Codable {
    let displayName: String
    let realName: String
    let biography: String
    let lifeSpan: String
    let imageURL: URL?
    let relatedStyles: [ArtistRelatedStyle]
}

struct ArtistRelatedStyle: Codable {
    let id: String
    let title: String
    let imageURL: URL?
}

struct ArtistWork: Codable {
    let id: String
    let title: String
    let imageURL: URL?
}

struct WorkDetailsContent: Codable {
    let title: String
    let metadataLine: String
    let artistName: String
    let artistImageURL: URL?
    let infoText: String
    let imageURL: URL?
    let relatedItems: [WorkRelatedItem]
}

struct WorkRelatedItem: Codable {
    let title: String
    let subtitle: String
}
