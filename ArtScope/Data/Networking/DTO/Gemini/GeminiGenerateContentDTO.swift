//
//  GeminiGenerateContentDTO.swift
//  ArtScope
//
//  Created by loxxy on 15.04.2026.
//

import Foundation

struct GeminiGenerateContentRequestDTO: Encodable {
    let contents: [GeminiContentRequestDTO]
    let generationConfig: GeminiGenerationConfigDTO

    enum CodingKeys: String, CodingKey {
        case contents
        case generationConfig = "generationConfig"
    }
}

struct GeminiContentRequestDTO: Encodable {
    let role: String
    let parts: [GeminiPartRequestDTO]
}

struct GeminiPartRequestDTO: Encodable {
    let text: String
}

struct GeminiGenerationConfigDTO: Encodable {
    let temperature: Double
    let responseMimeType: String

    enum CodingKeys: String, CodingKey {
        case temperature
        case responseMimeType = "responseMimeType"
    }
}

struct GeminiGenerateContentResponseDTO: Decodable {
    let candidates: [GeminiCandidateDTO]?
}

struct GeminiCandidateDTO: Decodable {
    let content: GeminiContentResponseDTO?
}

struct GeminiContentResponseDTO: Decodable {
    let parts: [GeminiPartResponseDTO]?
}

struct GeminiPartResponseDTO: Decodable {
    let text: String?
}
