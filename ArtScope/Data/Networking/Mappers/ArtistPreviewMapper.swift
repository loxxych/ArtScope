//
//  ArtistPreviewMapper.swift
//  ArtScope
//
//  Created by loxxy on 28.01.2026.
//

import Foundation

final class ArtistPreviewMapper {
    static func map(_ dto: WikidataArtistsDTO) -> [ArtistPreview] {
        dto.results.bindings.map { binding in
            ArtistPreview(
                id: binding.artist.value,
                name: binding.artistLabel.value,
                summary: binding.artistDescription?.value ?? "Artist and encyclopedic figure in world art.",
                imageURL: URL(string: binding.image?.value ?? "")
            )
        }
    }
}
