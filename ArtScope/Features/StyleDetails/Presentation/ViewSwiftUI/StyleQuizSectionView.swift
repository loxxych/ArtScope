//
//  StyleQuizSectionView.swift
//  ArtScope
//
//  Created by loxxy on 28.04.2026.
//

import SwiftUI

struct StyleQuizSectionView: View {
    @ObservedObject var viewModel: StyleQuizViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Quiz")
                .font(.InstrumentSansBold31)
                .foregroundStyle(StyleTheme.darkText)

            Text("Complete a short quiz to test your knowledge!")
                .font(.InstrumentSansRegular15)
                .foregroundStyle(StyleTheme.darkText.opacity(0.85))

            content
        }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .loading:
            StyleQuizLoadingCardView()
        case .unavailable:
            StyleQuizStatusCardView(
                title: "Quiz unavailable",
                bodyStr: "We couldn't generate a quiz for this style right now.",
                actionTitle: "Try again",
                onAction: { viewModel.load(force: true) }
            )
        case .ready:
            StyleQuizStartCardView(onBegin: { viewModel.beginQuiz() })
        case let .question(question, selectedOptionID, revealed):
            QuizQuestionCardView(
                question: question,
                imageURL: nil,
                displayState: revealed
                    ? .revealed(
                        selectedOptionID: selectedOptionID,
                        correctOptionID: question.correctOptionID,
                        explanation: question.explanation
                    )
                    : .answering(selectedOptionID: selectedOptionID),
                actionTitle: revealed ? "Next" : "Answer",
                onSelectOption: { viewModel.selectOption($0) },
                onAction: { viewModel.advanceAction() }
            )
            .padding(.horizontal, 14)
            .padding(.top, 4)
            .padding(.bottom, 6)
            .background(StyleTheme.quizCardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .shadow(color: StyleTheme.quizCardBackground.opacity(0.35), radius: 10, x: 0, y: 5)
        case let .result(correctAnswers, totalQuestions):
            QuizResultCardView(
                elapsedTimeText: viewModel.resultElapsedTimeText,
                scorePercent: percentage(correctAnswers: correctAnswers, totalQuestions: totalQuestions),
                showsTime: false,
                onRetry: { viewModel.retry() }
            )
        }
    }

    private func percentage(correctAnswers: Int, totalQuestions: Int) -> Int {
        let total = max(totalQuestions, 1)
        return Int((Double(correctAnswers) / Double(total)) * 100)
    }

}

private struct StyleQuizLoadingCardView: View {
    var body: some View {
        VStack(spacing: 18) {
            ProgressView()
                .tint(StyleTheme.lightText.opacity(0.8))
                .scaleEffect(1.2)

            Text("Preparing quiz...")
                .font(.ByteBounce28)
                .foregroundStyle(StyleTheme.darkText)

            Text("Creating a short English quiz from the style description and artworks.")
                .font(.InstrumentSansRegular15)
                .foregroundStyle(StyleTheme.darkText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 12)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 28)
        .padding(.horizontal, 20)
        .background(StyleTheme.quizCardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .shadow(color: StyleTheme.quizCardBackground.opacity(0.35), radius: 10, x: 0, y: 5)
    }
}

private struct StyleQuizStatusCardView: View {
    let title: String
    let bodyStr: String
    let actionTitle: String
    let onAction: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Text(title)
                .font(.ByteBounce28)
                .foregroundStyle(StyleTheme.darkText)

            Text(bodyStr)
                .font(.InstrumentSansRegular15)
                .foregroundStyle(StyleTheme.darkText)
                .multilineTextAlignment(.center)

            Button(action: onAction) {
                Text(actionTitle)
                    .font(.InstrumentSansBold16)
                    .foregroundStyle(StyleTheme.lightText)
                    .frame(height: 40)
                    .padding(.horizontal, 24)
                    .background(StyleTheme.actionBlue)
                    .clipShape(Capsule())
            }
            .buttonStyle(.plain)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .padding(.horizontal, 20)
        .background(StyleTheme.quizCardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .shadow(color: StyleTheme.quizCardBackground.opacity(0.35), radius: 10, x: 0, y: 5)
    }
}

private struct StyleQuizStartCardView: View {
    let onBegin: () -> Void

    var body: some View {
        VStack(spacing: 18) {
            Text("Test yourself!")
                .font(.ByteBounce28)
                .foregroundStyle(StyleTheme.darkText)

            HStack {
                Image(uiImage: UIImage.artScopePaintbrush ?? UIImage())
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 56, height: 56)
                    .foregroundStyle(StyleTheme.lightText)

                Spacer()

                Button(action: onBegin) {
                    HStack(spacing: 10) {
                        Text("Begin")
                            .font(.InstrumentSansSemiBold15)

                        Image(systemName: "arrow.right")
                            .font(.system(size: 16, weight: .semibold))
                    }
                    .foregroundStyle(StyleTheme.lightText)
                    .padding(.horizontal, 22)
                    .frame(height: 40)
                    .background(StyleTheme.actionBlue)
                    .clipShape(Capsule())
                }
                .buttonStyle(.plain)

                Spacer()

                Image(uiImage: UIImage.artScopePalette ?? UIImage())
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 56, height: 56)
                    .foregroundStyle(StyleTheme.lightText)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 20)
        .padding(.vertical, 22)
        .background(StyleTheme.quizCardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .shadow(color: StyleTheme.quizCardBackground.opacity(0.35), radius: 10, x: 0, y: 5)
    }
}

#Preview {
    StyleQuizSectionView(viewModel: StyleQuizViewModel(
        styleID: "style-impressionism",
        styleName: "Impressionism",
        styleImageURL: nil,
        quizService: QuizServiceFactory.makeQuizService()
    ))
    .padding()
    .background(StyleTheme.screenBackground)
}
