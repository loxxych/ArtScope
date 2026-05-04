//
//  QuizPlayScreen.swift
//  ArtScope
//
//  Created by loxxy on 20.04.2026.
//

import SwiftUI

struct QuizPlayScreen: View {
    enum Mode {
        case question(
            questionIndex: Int,
            timeText: String,
            selectedOptionID: String?,
            revealed: Bool,
            imageURL: URL?,
            explanationText: String?
        )
        case result(
            elapsedTimeText: String,
            scorePercent: Int
        )
        case review(
            questionIndex: Int,
            selectedOptionID: String?,
            elapsedTimeText: String,
            scorePercent: Int,
            showsElapsedTime: Bool
        )
    }

    let title: String
    let subtitle: String?
    let quiz: Quiz
    let mode: Mode
    var onBack: (() -> Void)? = nil
    var onSelectOption: ((String) -> Void)? = nil
    var onAction: (() -> Void)? = nil
    var onRetry: (() -> Void)? = nil
    var onPreviousQuestion: (() -> Void)? = nil
    var onNextQuestion: (() -> Void)? = nil

    var body: some View {
        ZStack(alignment: .top) {
            QuizTheme.screenBackground.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 22) {
                    Color.clear
                        .frame(height: 84)

                    content

                    Color.clear
                        .frame(height: 32)
                }
                .padding(.horizontal, 20)
            }

            QuizTopBar(
                title: title,
                subtitle: subtitle,
                onBack: onBack
            )
        }
        .navigationBarHidden(true)
    }

    @ViewBuilder
    private var content: some View {
        switch mode {
        case let .question(questionIndex, timeText, selectedOptionID, revealed, imageURL, explanationText):
            questionContent(
                questionIndex: questionIndex,
                timeText: timeText,
                selectedOptionID: selectedOptionID,
                revealed: revealed,
                imageURL: imageURL,
                explanationText: explanationText
            )
        case let .result(elapsedTimeText, scorePercent):
            resultContent(
                elapsedTimeText: elapsedTimeText,
                scorePercent: scorePercent
            )
        case let .review(questionIndex, selectedOptionID, elapsedTimeText, scorePercent, showsElapsedTime):
            reviewContent(
                questionIndex: questionIndex,
                selectedOptionID: selectedOptionID,
                elapsedTimeText: elapsedTimeText,
                scorePercent: scorePercent,
                showsElapsedTime: showsElapsedTime
            )
        }
    }

    private func questionContent(
        questionIndex: Int,
        timeText: String,
        selectedOptionID: String?,
        revealed: Bool,
        imageURL: URL?,
        explanationText: String?
    ) -> some View {
        let safeIndex = min(max(questionIndex, 0), max(quiz.payload.questions.count - 1, 0))
        let question = quiz.payload.questions[safeIndex]
        let displayState: QuizQuestionCardView.DisplayState = revealed
            ? .revealed(
                selectedOptionID: selectedOptionID,
                correctOptionID: question.correctOptionID,
                explanation: explanationText ?? question.explanation
            )
            : .answering(selectedOptionID: selectedOptionID)

        return VStack(alignment: .leading, spacing: 18) {
            QuizProgressHeaderView(
                currentQuestion: safeIndex + 1,
                totalQuestions: max(quiz.payload.questions.count, 1),
                timeText: timeText
            )

            QuizQuestionCardView(
                question: question,
                imageURL: imageURL,
                displayState: displayState,
                actionTitle: revealed ? "Next" : "Answer",
                onSelectOption: onSelectOption,
                onAction: onAction
            )
        }
    }

    private func resultContent(
        elapsedTimeText: String,
        scorePercent: Int
    ) -> some View {
        QuizResultCardView(
            elapsedTimeText: elapsedTimeText,
            scorePercent: scorePercent,
            onRetry: onRetry
        )
        .padding(.top, 24)
    }

    private func reviewContent(
        questionIndex: Int,
        selectedOptionID: String?,
        elapsedTimeText: String,
        scorePercent: Int,
        showsElapsedTime: Bool
    ) -> some View {
        let safeIndex = min(max(questionIndex, 0), max(quiz.payload.questions.count - 1, 0))
        let question = quiz.payload.questions[safeIndex]

        return VStack(alignment: .leading, spacing: 18) {
            QuizProgressHeaderView(
                currentQuestion: safeIndex + 1,
                totalQuestions: max(quiz.payload.questions.count, 1),
                timeText: nil
            )

            QuizQuestionCardView(
                question: question,
                imageURL: nil,
                displayState: .revealed(
                    selectedOptionID: selectedOptionID,
                    correctOptionID: question.correctOptionID,
                    explanation: question.explanation
                ),
                actionTitle: nil,
                onSelectOption: nil,
                onAction: nil
            )

            QuizReviewNavigationView(
                canGoPrevious: safeIndex > 0,
                canGoNext: safeIndex < quiz.payload.questions.count - 1,
                onPrevious: onPreviousQuestion,
                onNext: onNextQuestion
            )

            QuizResultCardView(
                elapsedTimeText: elapsedTimeText,
                scorePercent: scorePercent,
                showsTime: showsElapsedTime,
                showsRetryButton: false,
                onRetry: nil
            )
        }
    }
}

private struct QuizReviewNavigationView: View {
    let canGoPrevious: Bool
    let canGoNext: Bool
    var onPrevious: (() -> Void)?
    var onNext: (() -> Void)?

    var body: some View {
        HStack(spacing: 12) {
            Button(action: { onPrevious?() }) {
                Text("Previous")
                    .font(.InstrumentSansSemiBold18)
                    .foregroundStyle(QuizTheme.lightText)
                    .frame(maxWidth: .infinity)
                    .frame(height: 40)
                    .background(Color.black.opacity(canGoPrevious ? 1 : 0.45))
                    .clipShape(Capsule())
            }
            .buttonStyle(.plain)
            .disabled(!canGoPrevious)

            Button(action: { onNext?() }) {
                Text("Next")
                    .font(.InstrumentSansSemiBold18)
                    .foregroundStyle(QuizTheme.lightText)
                    .frame(maxWidth: .infinity)
                    .frame(height: 40)
                    .background(QuizTheme.primaryAction.opacity(canGoNext ? 1 : 0.45))
                    .clipShape(Capsule())
            }
            .buttonStyle(.plain)
            .disabled(!canGoNext)
        }
    }
}

#Preview("Question With Image") {
    QuizPlayScreen(
        title: "Quiz of the day",
        subtitle: "Surrealism",
        quiz: QuizPlayScreenPreviewData.sampleQuiz,
        mode: .question(
            questionIndex: 0,
            timeText: "0:15",
            selectedOptionID: "salvador",
            revealed: false,
            imageURL: URL(string: "https://upload.wikimedia.org/wikipedia/en/9/90/Portrait_de_Picasso%2C_1909-10%2C_Juan_Gris.jpg"),
            explanationText: nil
        )
    )
}

#Preview("Question Revealed") {
    QuizPlayScreen(
        title: "Quiz of the day",
        subtitle: "Surrealism",
        quiz: QuizPlayScreenPreviewData.sampleQuiz,
        mode: .question(
            questionIndex: 1,
            timeText: "0:15",
            selectedOptionID: "impressionism",
            revealed: true,
            imageURL: nil,
            explanationText: "This is an explanation sheet!"
        )
    )
}

#Preview("Result") {
    QuizPlayScreen(
        title: "Quiz of the day",
        subtitle: "Surrealism",
        quiz: QuizPlayScreenPreviewData.sampleQuiz,
        mode: .result(
            elapsedTimeText: "2:32",
            scorePercent: 70
        )
    )
}

private enum QuizPlayScreenPreviewData {
    static let sampleQuiz = Quiz(
        id: "daily-1",
        topicID: "surrealism",
        type: "daily",
        title: "Quiz of the day",
        subtitle: "Surrealism",
        description: "A short surrealism quiz",
        language: "en",
        difficulty: "easy",
        estimatedTimeSeconds: 15,
        questionCount: 6,
        isDaily: true,
        payload: QuizPayload(
            id: "payload-1",
            title: "Surrealism",
            subtitle: "Quiz",
            description: nil,
            questions: [
                QuizQuestion(
                    id: "q1",
                    prompt: "Who is the artist?",
                    kind: "multiple_choice",
                    options: [
                        QuizOption(id: "salvador", text: "Salvador Dali"),
                        QuizOption(id: "gogh", text: "van Gogh"),
                        QuizOption(id: "korovin", text: "Korovin")
                    ],
                    correctOptionID: "salvador",
                    explanation: "The portrait shown in the example belongs to the correct artist."
                ),
                QuizQuestion(
                    id: "q2",
                    prompt: "Which art style did Dali relate to?",
                    kind: "multiple_choice",
                    options: [
                        QuizOption(id: "surrealism", text: "Surrealism"),
                        QuizOption(id: "impressionism", text: "Impressionism"),
                        QuizOption(id: "realism", text: "Realism")
                    ],
                    correctOptionID: "surrealism",
                    explanation: "Dali is one of the central figures of surrealism."
                )
            ]
        )
    )
}
