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
    
    private let client: NetworkClient

    init(client: NetworkClient) {
        self.client = client
    }

    func fetchArtists(
            completion: @escaping (Result<[ArtistPreview], Error>) -> Void
        ) {
            let request = WikidataEndpoint.artistsList(limit: 8)

            client.request(request) { (result: Result<WikidataArtistsDTO, Error>) in
                completion(result.map(ArtistPreviewMapper.map))
            }
        }
    
    func fetchStyles(
        completion: @escaping (Result<[StylePreview], Error>) -> Void
    ) {
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
                self.fetchWikipediaExtract(from: candidateTitles) { summary in
                    completion(.success(
                        ArtistDetailsMapper.map(
                            details: dto,
                            preview: preview,
                            wikipediaSummary: summary
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
}
