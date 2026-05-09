//
//  WikidataDisplaySanitizer.swift
//  ArtScope
//
//  Created by loxxy on 09.05.2026.
//

import Foundation

enum WikidataDisplaySanitizer {
    static func sanitizedTitle(_ value: String?) -> String? {
        guard let cleaned = cleaned(value), !looksLikeEntityID(cleaned) else {
            return nil
        }

        return cleaned
    }

    static func sanitizedTitle(_ value: String?, fallback: String?) -> String? {
        sanitizedTitle(value) ?? sanitizedTitle(fallback)
    }

    private static func cleaned(_ value: String?) -> String? {
        guard let value else { return nil }
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? nil : trimmed
    }

    private static func looksLikeEntityID(_ value: String) -> Bool {
        value.range(of: #"^Q\d+$"#, options: .regularExpression) != nil
    }
}
