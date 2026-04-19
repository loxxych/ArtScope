//
//  StyleDetailMapper.swift
//  ArtScope
//
//  Created by loxxy on 19.04.2026.
//

import Foundation

enum StyleDetailMapper {
    static func map(
        style: StylePreview,
        description: String?,
        fallbackImageURL: URL?,
        artistsDTO: WikiDataStyleArtistsDTO?,
        worksDTO: WikiDataStyleWorksDTO?
    ) -> StyleDetailContent {
        let artists: [StyleArtistItem] = artistsDTO?.results.bindings.compactMap { binding -> StyleArtistItem? in
            guard
                let id = binding.artist?.value,
                let name = binding.artistLabel?.value,
                !name.isEmpty
            else {
                return nil
            }

            return StyleArtistItem(
                id: id,
                name: name,
                imageURL: URL(string: binding.image?.value ?? "")
            )
        } ?? []

        let works: [StyleWorkItem] = worksDTO?.results.bindings.compactMap { binding -> StyleWorkItem? in
            guard
                let id = binding.work?.value,
                let title = binding.workLabel?.value,
                let artistName = binding.creatorLabel?.value,
                !title.isEmpty
            else {
                return nil
            }

            return StyleWorkItem(
                id: id,
                title: title,
                imageURL: URL(string: binding.image?.value ?? ""),
                artistName: artistName,
                artistImageURL: URL(string: binding.creatorImage?.value ?? "")
            )
        } ?? []

        let trimmedDescription = description?.trimmingCharacters(in: .whitespacesAndNewlines)

        return StyleDetailContent(
            id: style.id,
            title: style.name,
            description: (trimmedDescription?.isEmpty == false ? trimmedDescription : nil) ?? "\(style.name) is an important art movement in the history of painting.",
            heroImageURL: fallbackImageURL ?? style.imageURL,
            artists: artists,
            works: works
        )
    }
}
