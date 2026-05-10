//
//  WikiDataArtistService.swift
//  ArtScope
//
//  Created by loxxy on 28.01.2026.
//

import Foundation

final class WikiDataArtistService: ArtistService, ArtistDetailsService, WorkDetailsService, StyleDetailsService, ContentPreloadService {
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
        static let detailsLifetime: TimeInterval = 60 * 60 * 24
    }
    
    private let client: NetworkClient
    private let catalogCacheStore: CatalogCacheStore
    private let detailsCacheStore: DetailsCacheStore
    private let cacheLock = NSLock()
    private var inMemoryArtistDetails: [String: ArtistDetailsContent] = [:]
    private var inMemoryArtistWorks: [String: [ArtistWork]] = [:]
    private var inMemoryStyleDetails: [String: StyleDetailContent] = [:]
    private var inMemoryWorkDetails: [String: WorkDetailsContent] = [:]
    private var inflightArtistDetails: [String: [(Result<ArtistDetailsContent, Error>) -> Void]] = [:]
    private var inflightArtistWorks: [String: [(Result<[ArtistWork], Error>) -> Void]] = [:]
    private var inflightStyleDetails: [String: [(Result<StyleDetailContent, Error>) -> Void]] = [:]
    private var inflightWorkDetails: [String: [(Result<WorkDetailsContent, Error>) -> Void]] = [:]

    init(
        client: NetworkClient,
        catalogCacheStore: CatalogCacheStore = UserDefaultsCatalogCacheStore(),
        detailsCacheStore: DetailsCacheStore = UserDefaultsDetailsCacheStore()
    ) {
        self.client = client
        self.catalogCacheStore = catalogCacheStore
        self.detailsCacheStore = detailsCacheStore
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
        if let cached = cachedStyleDetails(for: style.id) {
            completion(.success(cached))
            return
        }

        if appendInflightStyleDetailsCompletion(completion, for: style.id) {
            return
        }

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
                    let content = StyleDetailMapper.map(
                            style: style,
                            description: summary.extract,
                            fallbackImageURL: URL(string: summary.thumbnail?.source ?? "") ?? style.imageURL,
                            artistsDTO: nil,
                            worksDTO: nil
                        )
                    self.storeStyleDetails(content, for: style.id)
                    self.resolveInflightStyleDetails(.success(content), for: style.id)
                } else {
                    self.resolveInflightStyleDetails(.failure(entityError ?? summaryError ?? NetworkError.noData), for: style.id)
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
        if let cached = cachedArtistDetails(for: entityID) {
            completion(.success(cached))
            return
        }

        if appendInflightArtistDetailsCompletion(completion, for: entityID) {
            return
        }

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
                    let content = ArtistDetailsMapper.map(
                            details: dto,
                            preview: preview,
                            wikipediaSummary: summary,
                            relatedStyles: relatedStyles
                        )
                    self.storeArtistDetails(content, for: entityID)
                    self.resolveInflightArtistDetails(.success(content), for: entityID)
                }
            case let .failure(error):
                self.resolveInflightArtistDetails(.failure(error), for: entityID)
            }
        }
    }
    
    func fetchArtistWorks(
        entityID: String,
        completion: @escaping (Result<[ArtistWork], Error>) -> Void
    ) {
        if let cached = cachedArtistWorks(for: entityID) {
            completion(.success(cached))
            return
        }

        if appendInflightArtistWorksCompletion(completion, for: entityID) {
            return
        }

        let request = WikidataEndpoint.artistWorks(entityID: entityID, limit: 8)
        
        client.request(request) { (result: Result<WikiDataArtistWorksDTO, Error>) in
            switch result {
            case let .success(dto):
                let works = ArtistDetailsMapper.map(works: dto)
                self.storeArtistWorks(works, for: entityID)
                self.resolveInflightArtistWorks(.success(works), for: entityID)
            case let .failure(error):
                self.resolveInflightArtistWorks(.failure(error), for: entityID)
            }
        }
    }
    
    func fetchWorkDetails(
        workID: String,
        work: ArtistWork,
        artistName: String,
        completion: @escaping (Result<WorkDetailsContent, Error>) -> Void
    ) {
        if let cached = cachedWorkDetails(for: workID) {
            completion(.success(cached))
            return
        }

        if appendInflightWorkDetailsCompletion(completion, for: workID) {
            return
        }

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
                    let content = WorkDetailsMapper.map(
                            dto: dto,
                            work: work,
                            artistName: artistName,
                            wikipediaSummary: summary
                        )
                    self.storeWorkDetails(content, for: workID)
                    self.resolveInflightWorkDetails(.success(content), for: workID)
                }
            case let .failure(error):
                self.resolveInflightWorkDetails(.failure(error), for: workID)
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
                self.resolveInflightStyleDetails(.failure(summaryError ?? capturedError), for: style.id)
            } else {
                self.storeStyleDetails(content, for: style.id)
                self.resolveInflightStyleDetails(.success(content), for: style.id)
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
        fetchArtistRelatedStyles(
            request: WikidataEndpoint.artistDirectRelatedStyles(entityID: entityID, limit: 24)
        ) { [weak self] directStyles in
            guard let self else {
                completion([])
                return
            }

            if !directStyles.isEmpty {
                completion(Array(directStyles.prefix(5)))
                return
            }

            self.fetchArtistRelatedStyles(
                request: WikidataEndpoint.artistWorkRelatedStyles(entityID: entityID, limit: 24),
                completion: completion
            )
        }
    }

    private func fetchArtistRelatedStyles(
        request: URLRequest,
        completion: @escaping ([ArtistRelatedStyle]) -> Void
    ) {
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

    func preloadArtistContent(_ artists: [ArtistPreview], limit: Int) {
        var seenIDs = Set<String>()
        let preloadedArtists = artists.filter { seenIDs.insert($0.id).inserted }.prefix(limit)

        preloadedArtists.forEach { artist in
            guard let entityID = URL(string: artist.id)?.lastPathComponent else { return }
            fetchArtistDetails(entityID: entityID, preview: artist) { _ in }
            fetchArtistWorks(entityID: entityID) { _ in }
        }
    }

    func preloadStyleContent(_ styles: [StylePreview], limit: Int) {
        var seenIDs = Set<String>()
        styles.filter { seenIDs.insert($0.id).inserted }.prefix(limit).forEach { style in
            fetchStyleDetails(style: style) { _ in }
        }
    }

    private func cacheExpirationDate() -> Date {
        Date().addingTimeInterval(CacheConstants.detailsLifetime)
    }

    private func cachedArtistDetails(for entityID: String) -> ArtistDetailsContent? {
        cacheLock.lock()
        if let cached = inMemoryArtistDetails[entityID] {
            cacheLock.unlock()
            return cached
        }
        cacheLock.unlock()

        guard let cached = detailsCacheStore.artistDetails(for: entityID) else { return nil }
        cacheLock.lock()
        inMemoryArtistDetails[entityID] = cached
        cacheLock.unlock()
        return cached
    }

    private func storeArtistDetails(_ details: ArtistDetailsContent, for entityID: String) {
        cacheLock.lock()
        inMemoryArtistDetails[entityID] = details
        cacheLock.unlock()
        detailsCacheStore.saveArtistDetails(details, for: entityID, expirationDate: cacheExpirationDate())
    }

    private func cachedArtistWorks(for entityID: String) -> [ArtistWork]? {
        cacheLock.lock()
        if let cached = inMemoryArtistWorks[entityID] {
            cacheLock.unlock()
            return cached
        }
        cacheLock.unlock()

        guard let cached = detailsCacheStore.artistWorks(for: entityID) else { return nil }
        cacheLock.lock()
        inMemoryArtistWorks[entityID] = cached
        cacheLock.unlock()
        return cached
    }

    private func storeArtistWorks(_ works: [ArtistWork], for entityID: String) {
        cacheLock.lock()
        inMemoryArtistWorks[entityID] = works
        cacheLock.unlock()
        detailsCacheStore.saveArtistWorks(works, for: entityID, expirationDate: cacheExpirationDate())
    }

    private func cachedStyleDetails(for styleID: String) -> StyleDetailContent? {
        cacheLock.lock()
        if let cached = inMemoryStyleDetails[styleID] {
            cacheLock.unlock()
            return cached
        }
        cacheLock.unlock()

        guard let cached = detailsCacheStore.styleDetails(for: styleID) else { return nil }
        cacheLock.lock()
        inMemoryStyleDetails[styleID] = cached
        cacheLock.unlock()
        return cached
    }

    private func storeStyleDetails(_ details: StyleDetailContent, for styleID: String) {
        cacheLock.lock()
        inMemoryStyleDetails[styleID] = details
        cacheLock.unlock()
        detailsCacheStore.saveStyleDetails(details, for: styleID, expirationDate: cacheExpirationDate())
    }

    private func cachedWorkDetails(for workID: String) -> WorkDetailsContent? {
        cacheLock.lock()
        if let cached = inMemoryWorkDetails[workID] {
            cacheLock.unlock()
            return cached
        }
        cacheLock.unlock()

        guard let cached = detailsCacheStore.workDetails(for: workID) else { return nil }
        cacheLock.lock()
        inMemoryWorkDetails[workID] = cached
        cacheLock.unlock()
        return cached
    }

    private func storeWorkDetails(_ details: WorkDetailsContent, for workID: String) {
        cacheLock.lock()
        inMemoryWorkDetails[workID] = details
        cacheLock.unlock()
        detailsCacheStore.saveWorkDetails(details, for: workID, expirationDate: cacheExpirationDate())
    }

    private func appendInflightArtistDetailsCompletion(
        _ completion: @escaping (Result<ArtistDetailsContent, Error>) -> Void,
        for entityID: String
    ) -> Bool {
        cacheLock.lock()
        defer { cacheLock.unlock() }
        if inflightArtistDetails[entityID] != nil {
            inflightArtistDetails[entityID, default: []].append(completion)
            return true
        }
        inflightArtistDetails[entityID] = [completion]
        return false
    }

    private func resolveInflightArtistDetails(_ result: Result<ArtistDetailsContent, Error>, for entityID: String) {
        cacheLock.lock()
        let completions = inflightArtistDetails.removeValue(forKey: entityID) ?? []
        cacheLock.unlock()
        completions.forEach { $0(result) }
    }

    private func appendInflightArtistWorksCompletion(
        _ completion: @escaping (Result<[ArtistWork], Error>) -> Void,
        for entityID: String
    ) -> Bool {
        cacheLock.lock()
        defer { cacheLock.unlock() }
        if inflightArtistWorks[entityID] != nil {
            inflightArtistWorks[entityID, default: []].append(completion)
            return true
        }
        inflightArtistWorks[entityID] = [completion]
        return false
    }

    private func resolveInflightArtistWorks(_ result: Result<[ArtistWork], Error>, for entityID: String) {
        cacheLock.lock()
        let completions = inflightArtistWorks.removeValue(forKey: entityID) ?? []
        cacheLock.unlock()
        completions.forEach { $0(result) }
    }

    private func appendInflightStyleDetailsCompletion(
        _ completion: @escaping (Result<StyleDetailContent, Error>) -> Void,
        for styleID: String
    ) -> Bool {
        cacheLock.lock()
        defer { cacheLock.unlock() }
        if inflightStyleDetails[styleID] != nil {
            inflightStyleDetails[styleID, default: []].append(completion)
            return true
        }
        inflightStyleDetails[styleID] = [completion]
        return false
    }

    private func resolveInflightStyleDetails(_ result: Result<StyleDetailContent, Error>, for styleID: String) {
        cacheLock.lock()
        let completions = inflightStyleDetails.removeValue(forKey: styleID) ?? []
        cacheLock.unlock()
        completions.forEach { $0(result) }
    }

    private func appendInflightWorkDetailsCompletion(
        _ completion: @escaping (Result<WorkDetailsContent, Error>) -> Void,
        for workID: String
    ) -> Bool {
        cacheLock.lock()
        defer { cacheLock.unlock() }
        if inflightWorkDetails[workID] != nil {
            inflightWorkDetails[workID, default: []].append(completion)
            return true
        }
        inflightWorkDetails[workID] = [completion]
        return false
    }

    private func resolveInflightWorkDetails(_ result: Result<WorkDetailsContent, Error>, for workID: String) {
        cacheLock.lock()
        let completions = inflightWorkDetails.removeValue(forKey: workID) ?? []
        cacheLock.unlock()
        completions.forEach { $0(result) }
    }
}
