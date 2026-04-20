//
//  QuizProgressHeaderView.swift
//  ArtScope
//
//  Created by loxxy on 20.04.2026.
//

import SwiftUI

struct QuizProgressHeaderView: View {
    let currentQuestion: Int
    let totalQuestions: Int
    let timeText: String

    private var progress: Double {
        guard totalQuestions > 0 else { return 0 }
        return min(max(Double(currentQuestion) / Double(totalQuestions), 0), 1)
    }

    var body: some View {
        VStack(spacing: 8) {
            Text(timeText)
                .font(.InstrumentSansBold27)
                .foregroundStyle(QuizTheme.darkText)

            HStack(spacing: 12) {
                Text("\(min(currentQuestion, totalQuestions))/\(totalQuestions)")
                    .font(.InstrumentSansSemiBold18)
                    .foregroundStyle(QuizTheme.progressFill)
                    .frame(width: 36, alignment: .leading)

                GeometryReader { proxy in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(QuizTheme.progressTrack)

                        Capsule()
                            .fill(QuizTheme.progressFill)
                            .frame(width: proxy.size.width * progress)
                    }
                }
                .frame(height: 10)
            }
        }
    }
}
