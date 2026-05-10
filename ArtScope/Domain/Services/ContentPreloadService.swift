//
//  ContentPreloadService.swift
//  ArtScope
//
//  Created by loxxy on 10.05.2026.
//

protocol ContentPreloadService {
    func preloadArtistContent(_ artists: [ArtistPreview], limit: Int)
    func preloadStyleContent(_ styles: [StylePreview], limit: Int)
}
