//
//  Quiz.swift
//  ArtScope
//
//  Created by loxxy on 14.04.2026.
//

import Foundation

struct Quiz {
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
}

struct QuizPayload {
    let id: String
    let title: String
    let subtitle: String?
    let description: String?
    let questions: [QuizQuestion]
}

struct QuizQuestion {
    let id: String
    let prompt: String
    let kind: String
    let options: [QuizOption]
    let correctOptionID: String
    let explanation: String
}

struct QuizOption {
    let id: String
    let text: String
}

struct QuizTopic {
    let id: String
    let type: String
    let title: String
    let subtitle: String?
    let description: String?
    let language: String
    let isFeatured: Bool
}

struct QuizListItem {
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
}
