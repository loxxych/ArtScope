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
      "type": "artist" | "daily",
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
