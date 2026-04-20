//
//  QuizTopBar.swift
//  ArtScope
//
//  Created by loxxy on 20.04.2026.
//

import SwiftUI

struct QuizTopBar: View {
    let title: String
    let subtitle: String?
    var onBack: (() -> Void)?

    var body: some View {
        ZStack(alignment: .bottom) {
            QuizTheme.headerBackground
                .ignoresSafeArea(edges: .top)

            ZStack {
                VStack(spacing: 2) {
                    Text(title)
                        .font(.InstrumentSansSemiBold26)
                        .foregroundStyle(QuizTheme.lightText)
                        .lineLimit(1)

                    if let subtitle, !subtitle.isEmpty {
                        Text(subtitle)
                            .font(.InstrumentSansRegular11)
                            .foregroundStyle(QuizTheme.lightText.opacity(0.8))
                            .lineLimit(1)
                    }
                }

                HStack {
                    Button(action: { onBack?() }) {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundStyle(QuizTheme.lightText)
                            .frame(width: 28, height: 28)
                    }

                    Spacer()
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 14)
        }
        .frame(height: 84)
    }
}
