//
//  QuizMapper.swift
//  ArtScope
//
//  Created by loxxy on 14.04.2026.
//

enum QuizMapper {
    static func map(_ dto: GeneratedQuizDTO) -> Quiz {
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
    
    static func map(_ dto: GeneratedQuizPayloadDTO) -> QuizPayload {
        QuizPayload(
            id: dto.id,
            title: dto.title,
            subtitle: dto.subtitle,
            description: dto.description,
            questions: dto.questions.map(map)
        )
    }
    
    static func map(_ dto: GeneratedQuizQuestionDTO) -> QuizQuestion {
        QuizQuestion(
            id: dto.id,
            prompt: dto.prompt,
            kind: dto.kind,
            options: dto.options.map(map),
            correctOptionID: dto.correctOptionID,
            explanation: dto.explanation
        )
    }
    
    static func map(_ dto: GeneratedQuizOptionDTO) -> QuizOption {
        QuizOption(id: dto.id, text: dto.text)
    }
}
