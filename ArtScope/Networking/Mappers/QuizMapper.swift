//
//  QuizMapper.swift
//  ArtScope
//
//  Created by loxxy on 14.04.2026.
//

enum QuizMapper {
    static func map(_ dto: QuizResponseDTO) -> Quiz {
        Quiz(
            id: dto.id,
            topicID: dto.topicID,
            type: dto.type,
            title: dto.title,
            subtitle: dto.subtitle,
            description: dto.description,
            language: dto.language,
            difficulty: dto.difficulty,
            estimatedTimeSeconds: dto.estimatedTimeSeconds,
            questionCount: dto.questionCount,
            isDaily: dto.isDaily,
            payload: map(dto.payload)
        )
    }
    
    static func map(_ dto: QuizPayloadDTO) -> QuizPayload {
        QuizPayload(
            id: dto.id,
            title: dto.title,
            subtitle: dto.subtitle,
            description: dto.description,
            questions: dto.questions.map(map)
        )
    }
    
    static func map(_ dto: QuizQuestionDTO) -> QuizQuestion {
        QuizQuestion(
            id: dto.id,
            prompt: dto.prompt,
            kind: dto.kind,
            options: dto.options.map(map),
            correctOptionID: dto.correctOptionID,
            explanation: dto.explanation
        )
    }
    
    static func map(_ dto: QuizOptionDTO) -> QuizOption {
        QuizOption(id: dto.id, text: dto.text)
    }
    
    static func map(_ dto: QuizTopicDTO) -> QuizTopic {
        QuizTopic(
            id: dto.id,
            type: dto.type,
            title: dto.title,
            subtitle: dto.subtitle,
            description: dto.description,
            language: dto.language,
            isFeatured: dto.isFeatured
        )
    }
    
    static func map(_ dto: QuizListItemDTO) -> QuizListItem {
        QuizListItem(
            id: dto.id,
            topicID: dto.topicID,
            type: dto.type,
            title: dto.title,
            subtitle: dto.subtitle,
            description: dto.description,
            difficulty: dto.difficulty,
            estimatedTimeSeconds: dto.estimatedTimeSeconds,
            questionCount: dto.questionCount,
            isDaily: dto.isDaily
        )
    }
}
