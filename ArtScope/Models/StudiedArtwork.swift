//
//  StudiedArtwork.swift
//  ArtScope
//
//  Created by loxxy on 15.04.2026.
//

import Foundation

struct StudiedArtwork: Codable, Equatable {
    let workID: String
    let title: String
    let artistName: String
    let imageURL: URL?
    let lastViewedAt: Date
}
