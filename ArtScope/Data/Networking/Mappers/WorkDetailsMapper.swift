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
        let movement = binding?.movementLabel?.value
        let dimensions = formatDimensions(height: binding?.height?.value, width: binding?.width?.value)
        let description = normalizedSentence(from: wikipediaSummary ?? binding?.workDescription?.value)
        let year = formatYear(from: binding?.inception?.value)
        
        var parts: [String] = []
        
        parts.append(buildLeadSentence(
            title: title,
            artistName: artistName,
            year: year,
            material: material,
            movement: movement
        ))
        
        if let description {
            parts.append(description)
        }
        
        if let dimensions, shouldAddDimensions(dimensions, to: description) {
            parts.append("Its documented dimensions are \(dimensions).")
        }
        
        if let movement, shouldAddMovement(movement, to: description) {
            parts.append("The work is associated with \(movement).")
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
        
        let normalized = dateString.hasPrefix("+") ? String(dateString.dropFirst()) : dateString
        return String(normalized.prefix(4))
    }
    
    private static func formatDimensions(height: String?, width: String?) -> String? {
        guard
            let formattedHeight = formatDimensionValue(height),
            let formattedWidth = formatDimensionValue(width)
        else {
            return nil
        }
        
        return "\(formattedHeight)×\(formattedWidth) cm"
    }
    
    private static func normalizedSentence(from text: String?) -> String? {
        guard let text else { return nil }
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }
        
        let sentence = trimmed.prefix(1).uppercased() + trimmed.dropFirst()
        return sentence.hasSuffix(".") ? sentence : sentence + "."
    }
    
    private static func buildLeadSentence(
        title: String,
        artistName: String,
        year: String?,
        material: String?,
        movement: String?
    ) -> String {
        var qualifiers: [String] = []
        
        if let material, !material.isEmpty {
            qualifiers.append(material.lowercased())
        }
        
        qualifiers.append("artwork")
        
        if let movement, !movement.isEmpty {
            qualifiers.append("associated with \(movement)")
        }
        
        let subject = "\"\(title)\" is a \(qualifiers.joined(separator: " ")) by \(artistName)"
        
        if let year, !year.isEmpty {
            return subject + ", created in \(year)."
        }
        
        return subject + "."
    }
    
    private static func shouldAddDimensions(_ dimensions: String, to description: String?) -> Bool {
        guard let description else { return true }
        return description.range(of: dimensions, options: .caseInsensitive) == nil
    }
    
    private static func shouldAddMovement(_ movement: String, to description: String?) -> Bool {
        guard let description else { return true }
        return description.range(of: movement, options: .caseInsensitive) == nil
    }
    
    private static func formatDimensionValue(_ value: String?) -> String? {
        guard
            let value,
            let numericValue = parseDecimal(from: value)
        else {
            return nil
        }
        
        let centimeterValue = numericValue <= 20 ? (numericValue * 100) : numericValue
        guard centimeterValue > 0 else { return nil }
        
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = centimeterValue.rounded() == centimeterValue ? 0 : 1
        
        return formatter.string(from: NSNumber(value: centimeterValue))
    }
    
    private static func parseDecimal(from value: String) -> Double? {
        let normalized = value
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "+", with: "")
        
        return Double(normalized)
    }
}
