//
//  QuizResultCardView.swift
//  ArtScope
//
//  Created by loxxy on 20.04.2026.
//

import SwiftUI

struct QuizResultCardView: View {
    let elapsedTimeText: String
    let scorePercent: Int
    var onRetry: (() -> Void)?

    var body: some View {
        VStack(spacing: 0) {
            Image(uiImage: UIImage.artScopeLeaderboard ?? UIImage())
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: 86, height: 86)
                .foregroundStyle(QuizTheme.iconYellow)
                .padding(.top, 8)

            Text("Congratulations!")
                .font(.InstrumentSansBold27)
                .foregroundStyle(QuizTheme.lightText)
                .padding(.top, 10)

            Text("You did great! Keep going at it.")
                .font(.InstrumentSansRegular15)
                .foregroundStyle(QuizTheme.lightText)
                .padding(.top, 6)

            Text("Time: \(elapsedTimeText)")
                .font(.InstrumentSansSemiBold18)
                .foregroundStyle(QuizTheme.lightText)
                .padding(.top, 24)

            Text("\(scorePercent) %")
                .font(.ByteBounce48)
                .foregroundStyle(QuizTheme.primaryAction)
                .padding(.top, 20)

            ZStack(alignment: .leading) {
                Capsule()
                    .fill(QuizTheme.resultTrack)

                GeometryReader { proxy in
                    Capsule()
                        .fill(QuizTheme.primaryAction)
                        .frame(width: proxy.size.width * CGFloat(min(max(Double(scorePercent) / 100, 0), 1)))
                }
            }
            .frame(height: 10)
            .padding(.top, 16)
            .padding(.horizontal, 42)

            Button(action: { onRetry?() }) {
                HStack(spacing: 8) {
                    Text("Retry")
                        .font(.InstrumentSansSemiBold18)

                    Image(systemName: "arrow.clockwise")
                        .font(.system(size: 16, weight: .medium))
                }
                .foregroundStyle(QuizTheme.lightText)
                .frame(width: 138, height: 40)
                .background(Color.black)
                .clipShape(Capsule())
            }
            .buttonStyle(.plain)
            .padding(.top, 30)
            .padding(.bottom, 18)
        }
        .frame(maxWidth: .infinity)
        .background(QuizTheme.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }
}
