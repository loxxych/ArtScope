//
//  AppServicesFactory.swift
//  ArtScope
//
//  Created by loxxy on 10.05.2026.
//

import Foundation

enum AppServicesFactory {
    private static let networkClient: NetworkClient = URLSessionNetworkClient()
    private static let wikiDataService = WikiDataArtistService(
        client: networkClient,
        catalogCacheStore: UserDefaultsCatalogCacheStore(),
        detailsCacheStore: UserDefaultsDetailsCacheStore()
    )

    static func makeArtistService() -> ArtistService {
        wikiDataService
    }

    static func makeArtistDetailsService() -> ArtistDetailsService {
        wikiDataService
    }

    static func makeStyleDetailsService() -> StyleDetailsService {
        wikiDataService
    }

    static func makeWorkDetailsService() -> WorkDetailsService {
        wikiDataService
    }

    static func makeContentPreloadService() -> ContentPreloadService {
        wikiDataService
    }
}
