//
//  StyleDetailsService.swift
//  ArtScope
//
//  Created by loxxy on 19.04.2026.
//

protocol StyleDetailsService {
    func fetchStyleDetails(
        style: StylePreview,
        completion: @escaping (Result<StyleDetailContent, Error>) -> Void
    )
}
