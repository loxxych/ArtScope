//
//  Quiz.swift
//  ArtScope
//
//  Created by loxxy on 14.04.2026.
//

import Foundation

struct Quiz: Codable {
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
    let payload: QuizPayload

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

struct QuizPayload: Codable {
    let id: String
    let title: String
    let subtitle: String?
    let description: String?
    let questions: [QuizQuestion]
}

struct QuizQuestion: Codable {
    let id: String
    let prompt: String
    let kind: String
    let options: [QuizOption]
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

struct QuizOption: Codable {
    let id: String
    let text: String
}

struct QuizTopic: Codable {
    let id: String
    let type: String
    let title: String
    let subtitle: String?
    let description: String?
    let language: String
    let isFeatured: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case type
        case title
        case subtitle
        case description
        case language
        case isFeatured = "is_featured"
    }
}

struct QuizListItem: Codable {
    let id: String
    let topicID: String
    let type: String
    let title: String
    let subtitle: String?
    let description: String?
    let difficulty: String
    let estimatedTimeSeconds: Int
    let questionCount: Int
    let isDaily: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case topicID = "topic_id"
        case type
        case title
        case subtitle
        case description
        case difficulty
        case estimatedTimeSeconds = "estimated_time_seconds"
        case questionCount = "question_count"
        case isDaily = "is_daily"
    }
}
