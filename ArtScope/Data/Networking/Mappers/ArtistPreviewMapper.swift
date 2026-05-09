//
//  ArtistPreviewMapper.swift
//  ArtScope
//
//  Created by loxxy on 28.01.2026.
//

import Foundation

final class ArtistPreviewMapper {
    static func map(_ dto: WikidataArtistsDTO) -> [ArtistPreview] {
        dto.results.bindings.compactMap { binding in
            guard let name = WikidataDisplaySanitizer.sanitizedTitle(binding.artistLabel.value) else {
                return nil
            }

            return ArtistPreview(
                id: binding.artist.value,
                name: name,
                summary: binding.artistDescription?.value ?? "Artist and encyclopedic figure in world art.",
                imageURL: URL(string: binding.image?.value ?? "")
            )
        }
    }
}
