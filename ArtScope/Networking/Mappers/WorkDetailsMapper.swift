//
//  WorkDetailsMapper.swift
//  ArtScope
//
//  Created by loxxy on 25.03.2026.
//

import Foundation

enum WorkDetailsMapper {
    static func map(
        dto: WikiDataWorkDetailsDTO,
        work: ArtistWork,
        artistName: String,
        wikipediaSummary: String?
    ) -> WorkDetailsContent {
        let firstBinding = dto.results.bindings.first
        let title = firstBinding?.workLabel?.value ?? work.title
        let metadataLine = buildMetadataLine(binding: firstBinding)
        let infoText = buildInfoText(
            binding: firstBinding,
            title: title,
            artistName: artistName,
            wikipediaSummary: wikipediaSummary
        )
        let relatedItems = buildRelatedItems(from: dto)
        
        return WorkDetailsContent(
            title: title,
            metadataLine: metadataLine,
            artistName: artistName,
            infoText: infoText,
            imageURL: work.imageURL,
            relatedItems: relatedItems
        )
    }
    
    private static func buildMetadataLine(binding: WikiDataWorkDetailsDTO.Binding?) -> String {
        let year = formatYear(from: binding?.inception?.value)
        let dimensions = formatDimensions(height: binding?.height?.value, width: binding?.width?.value)
        
        switch (year, dimensions) {
        case let (year?, dimensions?) where !dimensions.isEmpty:
            return "\(year) • \(dimensions)"
        case let (year?, _):
            return year
        case let (_, dimensions?) where !dimensions.isEmpty:
            return dimensions
        default:
            return "Artwork details unavailable"
        }
    }
    
    private static func buildInfoText(
        binding: WikiDataWorkDetailsDTO.Binding?,
        title: String,
        artistName: String,
        wikipediaSummary: String?
    ) -> String {
        let material = binding?.materialLabel?.value
        let description = normalizedSentence(from: wikipediaSummary ?? binding?.workDescription?.value)
        let year = formatYear(from: binding?.inception?.value)
        
        var parts: [String] = []
        
        if let material, let year {
            parts.append("\"\(title)\" is a \(material.lowercased()) work by \(artistName) created in \(year).")
        } else if let year {
            parts.append("\"\(title)\" is a work by \(artistName) created in \(year).")
        } else {
            parts.append("\"\(title)\" is a work by \(artistName).")
        }
        
        if let description {
            parts.append(description)
        }
        
        return parts.joined(separator: " ")
    }
    
    private static func buildRelatedItems(from dto: WikiDataWorkDetailsDTO) -> [WorkRelatedItem] {
        let titles = Array(Set(dto.results.bindings.compactMap { $0.movementLabel?.value })).sorted()
        
        return titles.map {
            WorkRelatedItem(
                title: $0,
                subtitle: "Art movement related to this work."
            )
        }
    }
    
    private static func formatYear(from dateString: String?) -> String? {
        guard let dateString, !dateString.isEmpty else { return nil }
        return String(dateString.dropFirst().prefix(4))
    }
    
    private static func formatDimensions(height: String?, width: String?) -> String? {
        guard
            let height = height?.components(separatedBy: ".").first,
            let width = width?.components(separatedBy: ".").first,
            !height.isEmpty,
            !width.isEmpty
        else {
            return nil
        }
        
        return "\(height)×\(width) cm"
    }
    
    private static func normalizedSentence(from text: String?) -> String? {
        guard let text else { return nil }
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }
        
        let sentence = trimmed.prefix(1).uppercased() + trimmed.dropFirst()
        return sentence.hasSuffix(".") ? sentence : sentence + "."
    }
}
