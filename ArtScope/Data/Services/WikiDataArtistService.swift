//
//  WikiDataArtistService.swift
//  ArtScope
//
//  Created by loxxy on 28.01.2026.
//

import Foundation

final class WikiDataArtistService: ArtistService, ArtistDetailsService, WorkDetailsService, StyleDetailsService {
    private struct StyleSeed {
        let id: String
        let name: String
        let wikipediaTitle: String
    }
    
    private enum StyleConstants {
        static let seeds: [StyleSeed] = [
            .init(id: "style-impressionism", name: "Impressionism", wikipediaTitle: "Impressionism"),
            .init(id: "style-cubism", name: "Cubism", wikipediaTitle: "Cubism"),
            .init(id: "style-surrealism", name: "Surrealism", wikipediaTitle: "Surrealism"),
            .init(id: "style-baroque", name: "Baroque", wikipediaTitle: "Baroque"),
            .init(id: "style-expressionism", name: "Expressionism", wikipediaTitle: "Expressionism"),
            .init(id: "style-romanticism", name: "Romanticism", wikipediaTitle: "Romanticism"),
            .init(id: "style-realism", name: "Realism", wikipediaTitle: "Realism_(arts)"),
            .init(id: "style-symbolism", name: "Symbolism", wikipediaTitle: "Symbolism_(arts)")
        ]
    }

    private enum CacheConstants {
        static let featuredArtistsLifetime: TimeInterval = 60 * 60 * 12
        static let stylesLifetime: TimeInterval = 60 * 60 * 24
    }
    
    private let client: NetworkClient
    private let catalogCacheStore: CatalogCacheStore

    init(
        client: NetworkClient,
        catalogCacheStore: CatalogCacheStore = UserDefaultsCatalogCacheStore()
    ) {
        self.client = client
        self.catalogCacheStore = catalogCacheStore
    }

    func fetchArtists(
            completion: @escaping (Result<[ArtistPreview], Error>) -> Void
        ) {
            if let cachedArtists = catalogCacheStore.featuredArtists(), !cachedArtists.isEmpty {
                completion(.success(cachedArtists))
                return
            }

            let request = WikidataEndpoint.featuredArtists(names: PopularArtistCatalog.names)

            client.request(request) { (result: Result<WikidataArtistsDTO, Error>) in
                completion(result.map { dto in
                    let mapped = ArtistPreviewMapper.map(dto)
                    let sorted = self.sortArtists(mapped, byPreferredNames: PopularArtistCatalog.names)
                    let artists = self.deduplicatedFeaturedArtists(sorted, preferredNames: PopularArtistCatalog.names)
                    self.catalogCacheStore.saveFeaturedArtists(
                        artists,
                        expirationDate: Date().addingTimeInterval(CacheConstants.featuredArtistsLifetime)
                    )
                    return artists
                })
            }
        }

    func fetchAdditionalArtists(
        limit: Int,
        excludingArtistIDs: [String],
        completion: @escaping (Result<[ArtistPreview], Error>) -> Void
    ) {
        let request = WikidataEndpoint.artistsList(
            limit: limit,
            excludingArtistIDs: excludingArtistIDs
        )

        client.request(request) { (result: Result<WikidataArtistsDTO, Error>) in
            completion(result.map(ArtistPreviewMapper.map))
        }
    }
    
    func fetchStyles(
        completion: @escaping (Result<[StylePreview], Error>) -> Void
    ) {
        if let cachedStyles = catalogCacheStore.styles(), !cachedStyles.isEmpty {
            completion(.success(cachedStyles))
            return
        }

        let group = DispatchGroup()
        let lock = NSLock()
        var collected: [StylePreview] = []
        var capturedError: Error?
        
        StyleConstants.seeds.forEach { seed in
            group.enter()
            
            let request = WikidataEndpoint.wikipediaPageSummary(title: seed.wikipediaTitle)
            client.request(request) { (result: Result<WikipediaStyleSummaryDTO, Error>) in
                lock.lock()
                defer {
                    lock.unlock()
                    group.leave()
                }
                
                switch result {
                case let .success(summary):
                    collected.append(
                        StylePreview(
                            id: seed.id,
                            name: seed.name,
                            imageURL: URL(string: summary.thumbnail?.source ?? "")
                        )
                    )
                case let .failure(error):
                    if capturedError == nil {
                        capturedError = error
                    }
                }
            }
        }
        
        group.notify(queue: .global()) {
            if collected.isEmpty, let capturedError {
                completion(.failure(capturedError))
            } else {
                let ordered = StyleConstants.seeds.compactMap { seed in
                    collected.first(where: { $0.id == seed.id })
                }
                self.catalogCacheStore.saveStyles(
                    ordered,
                    expirationDate: Date().addingTimeInterval(CacheConstants.stylesLifetime)
                )
                completion(.success(ordered))
            }
        }
    }

    func fetchStyleDetails(
        style: StylePreview,
        completion: @escaping (Result<StyleDetailContent, Error>) -> Void
    ) {
        let seed = styleSeed(for: style)
        let wikipediaTitle = seed?.wikipediaTitle ?? style.name

        let lock = NSLock()
        let group = DispatchGroup()
        var summary: WikipediaStyleSummaryDTO?
        var summaryError: Error?
        var entityID: String?
        var entityError: Error?

        group.enter()
        client.request(WikidataEndpoint.wikipediaStyleSummary(title: wikipediaTitle)) { (result: Result<WikipediaStyleSummaryDTO, Error>) in
            lock.lock()
            defer {
                lock.unlock()
                group.leave()
            }

            switch result {
            case let .success(dto):
                summary = dto
            case let .failure(error):
                summaryError = error
            }
        }

        group.enter()
        client.request(WikidataEndpoint.styleEntity(wikipediaTitle: wikipediaTitle)) { (result: Result<WikiDataStyleEntityDTO, Error>) in
            lock.lock()
            defer {
                lock.unlock()
                group.leave()
            }

            switch result {
            case let .success(dto):
                entityID = Self.entityID(from: dto.results.bindings.first?.style?.value)
            case let .failure(error):
                entityError = error
            }
        }

        group.notify(queue: .global()) {
            guard let entityID else {
                if let summary {
                    completion(.success(
                        StyleDetailMapper.map(
                            style: style,
                            description: summary.extract,
                            fallbackImageURL: URL(string: summary.thumbnail?.source ?? "") ?? style.imageURL,
                            artistsDTO: nil,
                            worksDTO: nil
                        )
                    ))
                } else {
                    completion(.failure(entityError ?? summaryError ?? NetworkError.noData))
                }
                return
            }

            self.fetchStyleRelations(
                style: style,
                entityID: entityID,
                summary: summary,
                summaryError: summaryError,
                completion: completion
            )
        }
    }
    
    func fetchArtistDetails(
        entityID: String,
        preview: ArtistPreview,
        completion: @escaping (Result<ArtistDetailsContent, Error>) -> Void
    ) {
        let request = WikidataEndpoint.artistDetails(entityID: entityID)
        
        client.request(request) { (result: Result<WikiDataArtistDetailsDTO, Error>) in
            switch result {
            case let .success(dto):
                let binding = dto.results.bindings.first
                let candidateTitles = [
                    binding?.wikipediaTitle?.value,
                    binding?.artistLabel?.value,
                    binding?.birthName?.value,
                    preview.name
                ]
                let group = DispatchGroup()
                let lock = NSLock()
                var summary: String?
                var relatedStyles: [ArtistRelatedStyle] = []

                group.enter()
                self.fetchWikipediaExtract(from: candidateTitles) { extract in
                    lock.lock()
                    summary = extract
                    lock.unlock()
                    group.leave()
                }

                group.enter()
                self.fetchArtistRelatedStyles(entityID: entityID) { styles in
                    lock.lock()
                    relatedStyles = styles
                    lock.unlock()
                    group.leave()
                }

                group.notify(queue: .global()) {
                    completion(.success(
                        ArtistDetailsMapper.map(
                            details: dto,
                            preview: preview,
                            wikipediaSummary: summary,
                            relatedStyles: relatedStyles
                        )
                    ))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchArtistWorks(
        entityID: String,
        completion: @escaping (Result<[ArtistWork], Error>) -> Void
    ) {
        let request = WikidataEndpoint.artistWorks(entityID: entityID, limit: 8)
        
        client.request(request) { (result: Result<WikiDataArtistWorksDTO, Error>) in
            completion(result.map { ArtistDetailsMapper.map(works: $0) })
        }
    }
    
    func fetchWorkDetails(
        workID: String,
        work: ArtistWork,
        artistName: String,
        completion: @escaping (Result<WorkDetailsContent, Error>) -> Void
    ) {
        let request = WikidataEndpoint.workDetails(workID: workID)
        
        client.request(request) { (result: Result<WikiDataWorkDetailsDTO, Error>) in
            switch result {
            case let .success(dto):
                let binding = dto.results.bindings.first
                let candidateTitles = [
                    binding?.wikipediaTitle?.value,
                    binding?.workLabel?.value,
                    work.title
                ]
                self.fetchWikipediaExtract(from: candidateTitles) { summary in
                    completion(.success(
                        WorkDetailsMapper.map(
                            dto: dto,
                            work: work,
                            artistName: artistName,
                            wikipediaSummary: summary
                        )
                    ))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    private func fetchWikipediaSummary(title: String?, completion: @escaping (String?) -> Void) {
        guard let title, !title.isEmpty else {
            completion(nil)
            return
        }
        
        let request = WikidataEndpoint.wikipediaPageSummary(title: title)
        client.request(request) { (result: Result<WikipediaStyleSummaryDTO, Error>) in
            switch result {
            case let .success(summary):
                completion(summary.extract)
            case .failure:
                completion(nil)
            }
        }
    }
    
    private func fetchWikipediaExtract(
        from titles: [String?],
        completion: @escaping (String?) -> Void
    ) {
        let uniqueTitles = Array(
            NSOrderedSet(array: titles.compactMap { title in
                let trimmed = title?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
                return trimmed.isEmpty ? nil : trimmed
            })
        ) as? [String] ?? []
        
        fetchWikipediaExtract(
            titles: uniqueTitles,
            currentIndex: 0,
            completion: completion
        )
    }
    
    private func fetchWikipediaExtract(
        titles: [String],
        currentIndex: Int,
        completion: @escaping (String?) -> Void
    ) {
        guard titles.indices.contains(currentIndex) else {
            completion(nil)
            return
        }
        
        let title = titles[currentIndex]
        let request = WikidataEndpoint.wikipediaPageExtract(title: title)
        
        client.request(request) { (result: Result<WikipediaPageExtractDTO, Error>) in
            switch result {
            case let .success(dto):
                let extract = dto.query.pages.first?.extract?.trimmingCharacters(in: .whitespacesAndNewlines)
                
                if let extract, !extract.isEmpty {
                    completion(extract)
                } else {
                    self.fetchWikipediaExtract(
                        titles: titles,
                        currentIndex: currentIndex + 1,
                        completion: completion
                    )
                }
            case .failure:
                self.fetchWikipediaExtract(
                    titles: titles,
                    currentIndex: currentIndex + 1,
                    completion: completion
                )
            }
        }
    }

    private func fetchStyleRelations(
        style: StylePreview,
        entityID: String,
        summary: WikipediaStyleSummaryDTO?,
        summaryError: Error?,
        completion: @escaping (Result<StyleDetailContent, Error>) -> Void
    ) {
        let group = DispatchGroup()
        let lock = NSLock()
        var artistsDTO: WikiDataStyleArtistsDTO?
        var worksDTO: WikiDataStyleWorksDTO?
        var capturedError: Error?

        group.enter()
        client.request(WikidataEndpoint.styleArtists(entityID: entityID, limit: 8)) { (result: Result<WikiDataStyleArtistsDTO, Error>) in
            lock.lock()
            defer {
                lock.unlock()
                group.leave()
            }

            switch result {
            case let .success(dto):
                artistsDTO = dto
            case let .failure(error):
                if capturedError == nil {
                    capturedError = error
                }
            }
        }

        group.enter()
        client.request(WikidataEndpoint.styleWorks(entityID: entityID, limit: 8)) { (result: Result<WikiDataStyleWorksDTO, Error>) in
            lock.lock()
            defer {
                lock.unlock()
                group.leave()
            }

            switch result {
            case let .success(dto):
                worksDTO = dto
            case let .failure(error):
                if capturedError == nil {
                    capturedError = error
                }
            }
        }

        group.notify(queue: .global()) {
            let content = StyleDetailMapper.map(
                style: style,
                description: summary?.extract,
                fallbackImageURL: URL(string: summary?.thumbnail?.source ?? "") ?? style.imageURL,
                artistsDTO: artistsDTO,
                worksDTO: worksDTO
            )

            if summary == nil, artistsDTO == nil, worksDTO == nil, let capturedError {
                completion(.failure(summaryError ?? capturedError))
            } else {
                completion(.success(content))
            }
        }
    }

    private func styleSeed(for style: StylePreview) -> StyleSeed? {
        StyleConstants.seeds.first { seed in
            seed.id == style.id || seed.name.caseInsensitiveCompare(style.name) == .orderedSame
        }
    }

    private static func entityID(from entityValue: String?) -> String? {
        guard let entityValue else { return nil }
        return URL(string: entityValue)?.lastPathComponent ?? entityValue.components(separatedBy: "/").last
    }

    private func sortArtists(
        _ artists: [ArtistPreview],
        byPreferredNames preferredNames: [String]
    ) -> [ArtistPreview] {
        let order = Dictionary(
            uniqueKeysWithValues: preferredNames.enumerated().map { ($1.folding(options: [.diacriticInsensitive, .caseInsensitive], locale: .current), $0) }
        )

        return artists.sorted { lhs, rhs in
            let lhsOrder = order[lhs.name.folding(options: [.diacriticInsensitive, .caseInsensitive], locale: .current)] ?? .max
            let rhsOrder = order[rhs.name.folding(options: [.diacriticInsensitive, .caseInsensitive], locale: .current)] ?? .max
            return lhsOrder < rhsOrder
        }
    }

    private func deduplicatedFeaturedArtists(
        _ artists: [ArtistPreview],
        preferredNames: [String]
    ) -> [ArtistPreview] {
        var seenIDs = Set<String>()
        var seenNames = Set<String>()
        var seenPreferredKeys = Set<String>()

        return artists.compactMap { artist in
            guard seenIDs.insert(artist.id).inserted else {
                return nil
            }

            let normalizedName = normalizeArtistName(artist.name)
            guard seenNames.insert(normalizedName).inserted else {
                return nil
            }

            if let preferredKey = matchedPreferredNameKey(for: artist.name, preferredNames: preferredNames) {
                guard seenPreferredKeys.insert(preferredKey).inserted else {
                    return nil
                }
            }

            return artist
        }
    }

    private func matchedPreferredNameKey(
        for artistName: String,
        preferredNames: [String]
    ) -> String? {
        let normalizedArtistName = normalizeArtistName(artistName)
        let artistTokens = Set(normalizedArtistName.split(separator: " ").map(String.init))

        return preferredNames.first(where: { preferredName in
            let normalizedPreferredName = normalizeArtistName(preferredName)
            if normalizedArtistName == normalizedPreferredName {
                return true
            }

            let preferredTokens = normalizedPreferredName.split(separator: " ").map(String.init)
            return preferredTokens.allSatisfy { artistTokens.contains($0) }
        }).map(normalizeArtistName)
    }

    private func normalizeArtistName(_ name: String) -> String {
        name
            .folding(options: [.diacriticInsensitive, .caseInsensitive], locale: .current)
            .replacingOccurrences(of: "[^a-z0-9 ]", with: " ", options: .regularExpression)
            .replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private func fetchArtistRelatedStyles(
        entityID: String,
        completion: @escaping ([ArtistRelatedStyle]) -> Void
    ) {
        let request = WikidataEndpoint.artistRelatedStyles(entityID: entityID, limit: 24)

        client.request(request) { (result: Result<WikiDataArtistRelatedStylesDTO, Error>) in
            switch result {
            case let .success(dto):
                let preferredTitles = Set(
                    StyleConstants.seeds.map {
                        $0.name.folding(options: [.diacriticInsensitive, .caseInsensitive], locale: .current)
                    }
                )
                var seenTitles = Set<String>()

                let styles = dto.results.bindings.compactMap { binding -> ArtistRelatedStyle? in
                    guard
                        let id = binding.movement?.value,
                        let title = WikidataDisplaySanitizer.sanitizedTitle(binding.movementLabel?.value)
                    else {
                        return nil
                    }

                    let normalizedTitle = title.folding(options: [.diacriticInsensitive, .caseInsensitive], locale: .current)
                    guard seenTitles.insert(normalizedTitle).inserted else { return nil }

                    let imageURL: URL?
                    if let imageValue = binding.image?.value, !imageValue.isEmpty {
                        imageURL = URL(string: imageValue)
                    } else {
                        imageURL = nil
                    }

                    return ArtistRelatedStyle(
                        id: id,
                        title: title,
                        imageURL: imageURL
                    )
                }

                let sorted = styles.sorted { lhs, rhs in
                    let lhsIsPreferred = preferredTitles.contains(lhs.title.folding(options: [.diacriticInsensitive, .caseInsensitive], locale: .current))
                    let rhsIsPreferred = preferredTitles.contains(rhs.title.folding(options: [.diacriticInsensitive, .caseInsensitive], locale: .current))

                    if lhsIsPreferred != rhsIsPreferred {
                        return lhsIsPreferred
                    }

                    if (lhs.imageURL != nil) != (rhs.imageURL != nil) {
                        return lhs.imageURL != nil
                    }

                    if lhs.title.count != rhs.title.count {
                        return lhs.title.count < rhs.title.count
                    }

                    return lhs.title.localizedCaseInsensitiveCompare(rhs.title) == .orderedAscending
                }

                completion(Array(sorted.prefix(5)))
            case .failure:
                completion([])
            }
        }
    }
}
