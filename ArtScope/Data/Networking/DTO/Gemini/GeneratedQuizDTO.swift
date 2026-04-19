//
//  GeneratedQuizDTO.swift
//  ArtScope
//
//  Created by loxxy on 15.04.2026.
//

import Foundation

struct GeneratedQuizDTO: Decodable {
    let id: String
    let topicID: String
    let type: String
    let title: String
    let subtitle: String?
    let description: String?
    let language: String
    let difficulty: String
    let estimatedTimeSeconds: Int
    let questionCount: Int
    let isDaily: Bool
    let payload: GeneratedQuizPayloadDTO

    enum CodingKeys: String, CodingKey {
        case id
        case topicID = "topic_id"
        case type
        case title
        case subtitle
        case description
        case language
        case difficulty
        case estimatedTimeSeconds = "estimated_time_seconds"
        case questionCount = "question_count"
        case isDaily = "is_daily"
        case payload
    }
}

struct GeneratedQuizPayloadDTO: Decodable {
    let id: String
    let title: String
    let subtitle: String?
    let description: String?
    let questions: [GeneratedQuizQuestionDTO]
}

struct GeneratedQuizQuestionDTO: Decodable {
    let id: String
    let prompt: String
    let kind: String
    let options: [GeneratedQuizOptionDTO]
    let correctOptionID: String
    let explanation: String

    enum CodingKeys: String, CodingKey {
        case id
        case prompt
        case kind
        case options
        case correctOptionID = "correct_option_id"
        case explanation
    }
}

struct GeneratedQuizOptionDTO: Decodable {
    let id: String
    let text: String
}
