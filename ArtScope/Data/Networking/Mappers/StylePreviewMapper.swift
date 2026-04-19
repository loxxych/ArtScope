//
//  StylePreviewMapper.swift
//  ArtScope
//
//  Created by loxxy on 25.03.2026.
//

import Foundation

enum StylePreviewMapper {
    static func map(_ dto: WikiDataStylesDTO) -> [StylePreview] {
        dto.results.bindings.compactMap { binding in
            guard
                let id = binding.style?.value,
                let name = binding.styleLabel?.value,
                !name.isEmpty
            else {
                return nil
            }
            
            return StylePreview(
                id: id,
                name: name,
                imageURL: URL(string: binding.image?.value ?? "")
            )
        }
    }
}
