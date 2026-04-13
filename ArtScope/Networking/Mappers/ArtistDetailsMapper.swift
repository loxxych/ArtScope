//
//  ArtistDetailsMapper.swift
//  ArtScope
//
//  Created by loxxy on 25.03.2026.
//

import Foundation

enum ArtistDetailsMapper {
    static func map(
        details dto: WikiDataArtistDetailsDTO,
        preview: ArtistPreview,
        wikipediaSummary: String?
    ) -> ArtistDetailsContent {
        let binding = dto.results.bindings.first
        let realName = binding?.birthName?.value ?? preview.name
        let biography = buildBiography(
            binding: binding,
            fallback: wikipediaSummary ?? preview.summary
        )
        let lifeSpan = buildLifeSpan(
            birthDateString: binding?.birthDate?.value,
            deathDateString: binding?.deathDate?.value
        )
        
        return ArtistDetailsContent(
            displayName: binding?.artistLabel?.value ?? preview.name,
            realName: realName,
            biography: biography,
            lifeSpan: lifeSpan,
            imageURL: preview.imageURL
        )
    }
    
    static func map(works dto: WikiDataArtistWorksDTO) -> [ArtistWork] {
        dto.results.bindings.compactMap { binding in
            guard
                let id = binding.work?.value,
                let title = binding.workLabel?.value,
                !title.isEmpty
            else { return nil }
            
            return ArtistWork(
                id: id,
                title: title,
                imageURL: URL(string: binding.image?.value ?? "")
            )
        }
    }
    
    private static func buildBiography(
        binding: WikiDataArtistDetailsDTO.Binding?,
        fallback: String
    ) -> String {
        guard let binding else { return fallback }
        
        let citizenship = binding.citizenshipLabel?.value
        let occupations = binding.occupations?.value
        let birthPlace = binding.birthPlaceLabel?.value
        let deathPlace = binding.deathPlaceLabel?.value
        let description = fallback.isEmpty ? (binding.artistDescription?.value ?? fallback) : fallback
        let normalizedDescription = normalizedSentence(from: description)
        
        var parts: [String] = []
        
        if shouldAddMetadataLead(to: normalizedDescription) {
            if let citizenship, let occupations, !occupations.isEmpty {
                parts.append("A \(citizenship.lowercased()) \(occupations.lowercased()).")
            } else if let occupations, !occupations.isEmpty {
                parts.append("An artist known as \(occupations.lowercased()).")
            }
        }
        
        parts.append(normalizedDescription)
        
        if let birthPlace, shouldAddBirthPlace(to: normalizedDescription, birthPlace: birthPlace) {
            parts.append("Born in \(birthPlace).")
        }
        
        if let deathPlace, shouldAddDeathPlace(to: normalizedDescription, deathPlace: deathPlace) {
            parts.append("Died in \(deathPlace).")
        }
        
        return parts.joined(separator: " ")
    }
    
    private static func buildLifeSpan(
        birthDateString: String?,
        deathDateString: String?
    ) -> String {
        let birthDate = format(dateString: birthDateString)
        let deathDate = format(dateString: deathDateString)
        
        switch (birthDate, deathDate) {
        case let (birth?, death?):
            return "\(birth) - \(death)"
        case let (birth?, nil):
            return "\(birth) - Present"
        case let (nil, death?):
            return death
        case (nil, nil):
            return "Life dates unavailable"
        }
    }
    
    private static func format(dateString: String?) -> String? {
        guard let dateString else { return nil }
        
        let cleaned = String(dateString.dropFirst().prefix(10))
        let inputFormatter = DateFormatter()
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        inputFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let date = inputFormatter.date(from: cleaned) else { return nil }
        
        let outputFormatter = DateFormatter()
        outputFormatter.locale = Locale(identifier: "en_US_POSIX")
        outputFormatter.dateFormat = "MMMM d, yyyy"
        return outputFormatter.string(from: date)
    }
    
    private static func normalizedSentence(from text: String) -> String {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return "Biography unavailable." }
        
        let sentence = trimmed.prefix(1).uppercased() + trimmed.dropFirst()
        return sentence.hasSuffix(".") ? sentence : sentence + "."
    }
    
    private static func shouldAddMetadataLead(to biography: String) -> Bool {
        biography.count < 220
    }
    
    private static func shouldAddBirthPlace(to biography: String, birthPlace: String) -> Bool {
        !containsCaseInsensitive(birthPlace, in: biography)
    }
    
    private static func shouldAddDeathPlace(to biography: String, deathPlace: String) -> Bool {
        !containsCaseInsensitive(deathPlace, in: biography)
    }
    
    private static func containsCaseInsensitive(_ text: String, in target: String) -> Bool {
        target.range(of: text, options: .caseInsensitive) != nil
    }
}
