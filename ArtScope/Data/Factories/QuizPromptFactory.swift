//
//  QuizPromptFactory.swift
//  ArtScope
//
//  Created by loxxy on 15.04.2026.
//

import Foundation

enum QuizPromptFactory {
    private static let quizSchema = """
    Return only valid JSON with this exact structure and snake_case keys:
    {
      "id": "string",
      "topic_id": "string",
      "type": "artist" | "style" | "daily" | "topic",
      "title": "string",
      "subtitle": "string",
      "description": "string",
      "language": "en",
      "difficulty": "easy" | "medium" | "hard",
      "estimated_time_seconds": 90,
      "question_count": 5,
      "is_daily": true | false,
      "payload": {
        "id": "string",
        "title": "string",
        "subtitle": "string",
        "description": "string",
        "questions": [
          {
            "id": "string",
            "prompt": "string",
            "kind": "single_choice",
            "options": [
              { "id": "a", "text": "string" },
              { "id": "b", "text": "string" },
              { "id": "c", "text": "string" },
              { "id": "d", "text": "string" }
            ],
            "correct_option_id": "a",
            "explanation": "string"
          }
        ]
      }
    }
    """

    static func artistQuizCacheKey(artistID: String) -> String {
        "artist-quiz::\(artistID)"
    }

    static func styleQuizCacheKey(styleID: String) -> String {
        "style-quiz::\(styleID)"
    }

    static func dailyQuizCacheKey(for studiedArtworks: [StudiedArtwork], calendar: Calendar) -> String {
        let dayStamp = Self.dayStamp(from: Date(), calendar: calendar)
        let artworkSignature = studiedArtworks
            .prefix(6)
            .map(\.workID)
            .joined(separator: "|")
        return "daily-quiz::\(dayStamp)::\(artworkSignature)"
    }

    static func artistQuizPrompt(
        artistID: String,
        artistName: String,
        biography: String?,
        works: [ArtistWork],
        questionCount: Int
    ) -> String {
        let biographyText = {
            guard let biography else {
                return "Biography is unavailable. Use widely accepted art-history facts only."
            }

            let trimmed = biography.trimmingCharacters(in: .whitespacesAndNewlines)
            return trimmed.isEmpty
                ? "Biography is unavailable. Use widely accepted art-history facts only."
                : trimmed
        }()

        let worksText: String
        if works.isEmpty {
            worksText = "No artwork list is available. Use general knowledge about the artist's life, style and most famous works."
        } else {
            worksText = works
                .prefix(8)
                .enumerated()
                .map { "\($0.offset + 1). \($0.element.title)" }
                .joined(separator: "\n")
        }

        return """
        You are generating a museum-style English quiz for an iOS art encyclopedia.
        Create exactly \(questionCount) multiple-choice questions about the artist below.

        Artist id: \(artistID)
        Artist name: \(artistName)
        Biography/context:
        \(biographyText)

        Known artworks:
        \(worksText)

        Requirements:
        - Questions must be factually grounded in mainstream art-history knowledge.
        - Focus on artistic style, life path, major works, techniques, influences and historical context.
        - Avoid trick questions.
        - Each question must have exactly 4 options and exactly 1 correct answer.
        - Explanations must be short, clear and educational.
        - Use English only.
        - Set "type" to "artist".
        - Set "is_daily" to false.
        - Set "question_count" to \(questionCount).
        - Make the JSON self-consistent: question_count must equal the real number of questions.
        - Do not wrap the JSON in markdown fences.

        \(quizSchema)
        """
    }

    static func styleQuizPrompt(
        styleID: String,
        styleName: String,
        description: String?,
        artists: [StyleArtistItem],
        works: [StyleWorkItem],
        questionCount: Int
    ) -> String {
        let descriptionText = {
            guard let description else {
                return "Style description is unavailable. Use widely accepted art-history facts only."
            }

            let trimmed = description.trimmingCharacters(in: .whitespacesAndNewlines)
            return trimmed.isEmpty
                ? "Style description is unavailable. Use widely accepted art-history facts only."
                : trimmed
        }()

        let artistsText: String
        if artists.isEmpty {
            artistsText = "No artist list is available. Use general knowledge about the movement, key figures and historical context."
        } else {
            artistsText = artists
                .prefix(8)
                .enumerated()
                .map { "\($0.offset + 1). \($0.element.name)" }
                .joined(separator: "\n")
        }

        let worksText: String
        if works.isEmpty {
            worksText = "No work list is available. Use general knowledge about this movement's major artworks."
        } else {
            worksText = works
                .prefix(8)
                .enumerated()
                .map { "\($0.offset + 1). \($0.element.title) by \($0.element.artistName)" }
                .joined(separator: "\n")
        }

        return """
        You are generating a museum-style English quiz for an iOS art encyclopedia.
        Create exactly \(questionCount) multiple-choice questions about the art style below.

        Style id: \(styleID)
        Style name: \(styleName)
        Description/context:
        \(descriptionText)

        Known related artists:
        \(artistsText)

        Known related works:
        \(worksText)

        Requirements:
        - Questions must be factually grounded in mainstream art-history knowledge.
        - Focus on movement traits, key figures, historical context, techniques and major works.
        - Avoid trick questions.
        - Each question must have exactly 4 options and exactly 1 correct answer.
        - Explanations must be short, clear and educational.
        - Use English only.
        - Set "type" to "style".
        - Set "is_daily" to false.
        - Set "question_count" to \(questionCount).
        - Make the JSON self-consistent: question_count must equal the real number of questions.
        - Do not wrap the JSON in markdown fences.

        \(quizSchema)
        """
    }

    static func dailyQuizPrompt(studiedArtworks: [StudiedArtwork], questionCount: Int) -> String {
        let studiedWorksText: String
        if studiedArtworks.isEmpty {
            studiedWorksText = "The user has not studied any artworks yet. Create an accessible daily quiz about famous painters, artworks and art movements."
        } else {
            studiedWorksText = studiedArtworks
                .prefix(10)
                .enumerated()
                .map { index, artwork in
                    "\(index + 1). Artwork: \(artwork.title). Artist: \(artwork.artistName)."
                }
                .joined(separator: "\n")
        }

        return """
        You are generating the English "quiz of the day" for an iOS art encyclopedia.
        Build exactly \(questionCount) single-choice questions inspired by the artworks the user recently viewed.

        Recently studied artworks:
        \(studiedWorksText)

        Requirements:
        - Questions should mainly reference the viewed artworks, their artists, styles, periods or closely related context.
        - If the studied list is short, mix direct questions with broader art-history questions that still fit the same theme.
        - Keep difficulty beginner to medium.
        - Each question must have exactly 4 options and exactly 1 correct answer.
        - Explanations must be concise and helpful.
        - Use English only.
        - Set "type" to "daily".
        - Set "is_daily" to true.
        - Set "question_count" to \(questionCount).
        - Use a short theme-like subtitle, for example "Surrealism" or "Recently viewed artworks".
        - Do not wrap the JSON in markdown fences.

        \(quizSchema)
        """
    }

    static func curatedQuizPrompt(topic: QuizGenerationTopic) -> String {
        let subtitleText = {
            guard let subtitle = topic.subtitle?.trimmingCharacters(in: .whitespacesAndNewlines), !subtitle.isEmpty else {
                return "Curated quiz topic"
            }
            return subtitle
        }()

        let descriptionText = {
            guard let description = topic.description?.trimmingCharacters(in: .whitespacesAndNewlines), !description.isEmpty else {
                return "Use concise art-history knowledge related to the topic."
            }
            return description
        }()

        return """
        You are generating a museum-style English quiz for an iOS art encyclopedia.
        Create exactly \(topic.questionCount) multiple-choice questions about the topic below.

        Topic id: \(topic.id)
        Topic type: \(topic.type)
        Topic title: \(topic.title)
        Topic subtitle: \(subtitleText)
        Topic description:
        \(descriptionText)

        Requirements:
        - Questions must be factually grounded in mainstream art-history knowledge.
        - Focus on the topic's core characteristics, important figures, historical context, notable works and techniques.
        - Avoid trick questions.
        - Each question must have exactly 4 options and exactly 1 correct answer.
        - Explanations must be short, clear and educational.
        - Use English only.
        - Set "id" and "topic_id" to exactly "\(topic.id)".
        - Set "type" to "topic".
        - Set "is_daily" to false.
        - Set "question_count" to \(topic.questionCount).
        - Set "estimated_time_seconds" to \(topic.questionCount * 20).
        - Make the JSON self-consistent: question_count must equal the real number of questions.
        - Do not wrap the JSON in markdown fences.

        \(quizSchema)
        """
    }

    static func invalidFormatRetryPrompt(for originalPrompt: String) -> String {
        """
        \(originalPrompt)

        Your previous response could not be parsed as valid JSON.
        Return the answer again as valid JSON only.
        Do not add markdown fences, comments or extra text before or after the JSON.
        """
    }

    private static func dayStamp(from date: Date, calendar: Calendar) -> String {
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        let year = components.year ?? 0
        let month = components.month ?? 0
        let day = components.day ?? 0
        return String(format: "%04d-%02d-%02d", year, month, day)
    }
}
