//
//  QuizResponseDTO.swift
//  ArtScope
//
//  Created by Codex on 14.04.2026.
//

struct QuizResponseDTO: Decodable {
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
    let payload: QuizPayloadDTO
    
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

struct QuizPayloadDTO: Decodable {
    let id: String
    let title: String
    let subtitle: String?
    let description: String?
    let questions: [QuizQuestionDTO]
}

struct QuizQuestionDTO: Decodable {
    let id: String
    let prompt: String
    let kind: String
    let options: [QuizOptionDTO]
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

struct QuizOptionDTO: Decodable {
    let id: String
    let text: String
}

struct QuizTopicDTO: Decodable {
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

struct QuizListItemDTO: Decodable {
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
