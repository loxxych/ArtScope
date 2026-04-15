//
//  QuizGenerationError.swift
//  ArtScope
//
//  Created by Codex on 15.04.2026.
//

import Foundation

enum QuizGenerationError: LocalizedError {
    case missingAPIKey
    case emptyResponse
    case invalidResponseFormat

    var errorDescription: String? {
        switch self {
        case .missingAPIKey:
            return "Gemini API key is missing in Info.plist."
        case .emptyResponse:
            return "Gemini returned an empty response."
        case .invalidResponseFormat:
            return "Gemini response format is invalid."
        }
    }
}
