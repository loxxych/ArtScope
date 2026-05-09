//
//  ProfileHistoryModels.swift
//  ArtScope
//
//  Created by loxxy on 20.04.2026.
//

import Foundation

struct CompletedQuizAnswerRecord: Codable {
    let questionIndex: Int
    let questionID: String
    let selectedOptionID: String?
}

struct CompletedQuizHistoryItem: Codable {
    let id: String
    let sourceQuizID: String?
    let title: String
    let subtitle: String?
    let scorePercent: Int
    let imageURLString: String?
    let elapsedTimeText: String?
    let showsElapsedTime: Bool?
    let completedAt: Date
    let answerRecords: [CompletedQuizAnswerRecord]?
    let quizSnapshot: Quiz?

    var imageURL: URL? {
        guard let imageURLString else { return nil }
        return URL(string: imageURLString)
    }
}

struct ViewedCollectionHistoryItem: Codable {
    enum Kind: String, Codable {
        case artist
        case style
    }

    let id: String
    let title: String
    let kind: Kind
    let imageURLString: String?
    let viewedAt: Date

    var imageURL: URL? {
        guard let imageURLString else { return nil }
        return URL(string: imageURLString)
    }
}
