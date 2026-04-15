//
//  GeminiConfiguration.swift
//  ArtScope
//
//  Created by Codex on 15.04.2026.
//

import Foundation

struct GeminiConfiguration {
    let apiKey: String
    let model: String

    static func fromBundle(_ bundle: Bundle = .main) -> GeminiConfiguration? {
        guard
            let rawAPIKey = bundle.object(forInfoDictionaryKey: "GEMINI_API_KEY") as? String,
            !rawAPIKey.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        else {
            return nil
        }

        let apiKey = rawAPIKey.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !apiKey.hasPrefix("$(") else {
            return nil
        }

        let model = (bundle.object(forInfoDictionaryKey: "GEMINI_MODEL") as? String)?
            .trimmingCharacters(in: .whitespacesAndNewlines)

        return GeminiConfiguration(
            apiKey: apiKey,
            model: (model?.isEmpty == false ? model : "gemini-2.5-flash") ?? "gemini-2.5-flash"
        )
    }
}
