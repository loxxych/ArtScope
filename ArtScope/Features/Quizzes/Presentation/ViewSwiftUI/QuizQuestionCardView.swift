//
//  QuizQuestionCardView.swift
//  ArtScope
//
//  Created by loxxy on 20.04.2026.
//

import SwiftUI

struct QuizQuestionCardView: View {
    enum DisplayState {
        case answering(selectedOptionID: String?)
        case revealed(selectedOptionID: String?, correctOptionID: String, explanation: String?)
    }

    let question: QuizQuestion
    let imageURL: URL?
    let displayState: DisplayState
    let actionTitle: String?
    var onSelectOption: ((String) -> Void)?
    var onAction: (() -> Void)?
    @State private var visibleOptionIDs: Set<String> = []

    private var selectedOptionID: String? {
        switch displayState {
        case let .answering(selectedOptionID):
            return selectedOptionID
        case let .revealed(selectedOptionID, _, _):
            return selectedOptionID
        }
    }

    private var correctOptionID: String? {
        switch displayState {
        case .answering:
            return nil
        case let .revealed(_, correctOptionID, _):
            return correctOptionID
        }
    }

    private var explanationText: String? {
        switch displayState {
        case .answering:
            return nil
        case let .revealed(_, _, explanation):
            return explanation
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            if let imageURL {
                AsyncImage(url: imageURL) { phase in
                    switch phase {
                    case let .success(image):
                        image
                            .resizable()
                            .scaledToFill()
                    default:
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Color.white.opacity(0.32))
                    }
                }
                .frame(width: 154, height: 192)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .shadow(color: Color.black.opacity(0.16), radius: 10, x: 0, y: 4)
                .frame(maxWidth: .infinity, alignment: .center)
            }

                Text(question.prompt)
                    .font(.InstrumentSansBold24)
                    .foregroundStyle(QuizTheme.darkText)
                    .multilineTextAlignment(.leading)

            if let explanationText, !explanationText.isEmpty {
                QuizExplanationBanner(text: explanationText)
                    .transition(.move(edge: .top).combined(with: .opacity))
            }

            VStack(spacing: 12) {
                ForEach(question.options, id: \.id) { option in
                    QuizAnswerOptionButton(
                        title: option.text,
                        state: optionState(for: option.id),
                        onTap: {
                            guard canSelectOption else { return }
                            onSelectOption?(option.id)
                        }
                    )
                    .opacity(visibleOptionIDs.contains(option.id) ? 1 : 0)
                    .offset(y: visibleOptionIDs.contains(option.id) ? 0 : -12)
                }
            }
            .animation(.spring(response: 0.28, dampingFraction: 0.82), value: selectedOptionID)
            .animation(.spring(response: 0.34, dampingFraction: 0.8), value: correctOptionID)

            if let actionTitle {
                Button(action: { onAction?() }) {
                    Text(actionTitle)
                        .font(.InstrumentSansSemiBold18)
                        .foregroundStyle(QuizTheme.lightText)
                        .frame(width: 138, height: 40)
                        .background(QuizTheme.primaryAction)
                        .clipShape(Capsule())
                }
                .buttonStyle(.plain)
                .frame(maxWidth: .infinity, alignment: .center)
                .disabled(isActionDisabled)
                .opacity(isActionDisabled ? 0.55 : 1)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .animation(.spring(response: 0.28, dampingFraction: 0.84), value: explanationText)
        .onAppear {
            animateOptionsEntrance()
        }
        .onChange(of: question.id) { _ in
            animateOptionsEntrance()
        }
    }

    private var canSelectOption: Bool {
        if case .answering = displayState {
            return true
        }
        return false
    }

    private var isActionDisabled: Bool {
        switch displayState {
        case let .answering(selectedOptionID):
            return selectedOptionID == nil
        case .revealed:
            return false
        }
    }

    private func optionState(for optionID: String) -> QuizAnswerOptionButton.State {
        switch displayState {
        case let .answering(selectedOptionID):
            return selectedOptionID == optionID ? .selected : .normal
        case let .revealed(selectedOptionID, correctOptionID, _):
            if optionID == correctOptionID {
                return .correct
            }

            if optionID == selectedOptionID, selectedOptionID != correctOptionID {
                return .incorrect
            }

            return .subdued
        }
    }

    private func animateOptionsEntrance() {
        visibleOptionIDs = []
        question.options.enumerated().forEach { index, option in
            DispatchQueue.main.asyncAfter(deadline: .now() + (Double(index) * 0.06)) {
                withAnimation(.easeOut(duration: 0.28)) {
                    visibleOptionIDs.formUnion([option.id])
                }
            }
        }
    }
}

private struct QuizExplanationBanner: View {
    let text: String

    var body: some View {
        HStack(spacing: 10) {
            Text(text)
                .font(.InstrumentSansRegular16)
                .foregroundStyle(QuizTheme.darkText)
                .frame(maxWidth: .infinity, alignment: .leading)

            Image(uiImage: UIImage.artScopeInfo ?? UIImage())
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: 22, height: 22)
                .foregroundStyle(QuizTheme.darkText)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 12)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 6))
    }
}

private struct QuizAnswerOptionButton: View {
    enum State {
        case normal
        case selected
        case correct
        case incorrect
        case subdued
    }

    let title: String
    let state: State
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 10) {
                Text(title)
                    .font(.InstrumentSansRegular16)
                    .foregroundStyle(textColor)
                    .frame(maxWidth: .infinity, alignment: .leading)

                if let icon = trailingIcon {
                    Image(uiImage: icon)
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(trailingIconColor)
                }
            }
            .padding(.horizontal, 18)
            .frame(maxWidth: .infinity)
            .frame(height: 54)
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 6))
            .scaleEffect(scale)
        }
        .buttonStyle(.plain)
    }

    private var backgroundColor: Color {
        switch state {
        case .normal:
            return QuizTheme.neutralOption
        case .selected:
            return QuizTheme.selectedOption
        case .correct:
            return QuizTheme.correctFill
        case .incorrect:
            return QuizTheme.incorrectFill
        case .subdued:
            return QuizTheme.subduedOption
        }
    }

    private var textColor: Color {
        switch state {
        case .selected:
            return QuizTheme.darkText
        case .correct:
            return QuizTheme.darkText
        default:
            return QuizTheme.lightText
        }
    }

    private var trailingIcon: UIImage? {
        switch state {
        case .correct:
            return UIImage.artScopeCheckmark
        case .incorrect:
            return UIImage.artScopeDislike
        default:
            return nil
        }
    }

    private var trailingIconColor: Color {
        switch state {
        case .correct:
            return Color(red: 148 / 255, green: 115 / 255, blue: 0)
        case .incorrect:
            return Color.white
        default:
            return QuizTheme.lightText
        }
    }

    private var scale: CGFloat {
        switch state {
        case .selected:
            return 0.985
        case .correct:
            return 1.01
        case .incorrect:
            return 1.01
        default:
            return 1
        }
    }
}
