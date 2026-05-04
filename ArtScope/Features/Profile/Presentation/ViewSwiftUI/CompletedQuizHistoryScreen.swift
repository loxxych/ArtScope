//
//  CompletedQuizHistoryScreen.swift
//  ArtScope
//
//  Created by loxxy on 04.05.2026.
//

import SwiftUI

struct CompletedQuizHistoryScreen: View {
    let items: [CompletedQuizHistoryItem]
    var onBack: (() -> Void)?
    var onItemSelected: ((CompletedQuizHistoryItem) -> Void)?

    private let columns = [
        GridItem(.flexible(), spacing: 14),
        GridItem(.flexible(), spacing: 14)
    ]

    var body: some View {
        ZStack(alignment: .top) {
            Color.artScopeGreenColor.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    Color.clear
                        .frame(height: 96)

                    if items.isEmpty {
                        emptyState
                    } else {
                        LazyVGrid(columns: columns, spacing: 24) {
                            ForEach(items, id: \.id) { item in
                                CompletedQuizGridCard(item: item) {
                                    onItemSelected?(item)
                                }
                            }
                        }
                        .padding(.horizontal, 18)
                        .padding(.bottom, 36)
                    }
                }
            }

            ProfileHistoryTopBar(title: "Quizzes", onBack: onBack)
        }
        .navigationBarHidden(true)
    }

    private var emptyState: some View {
        Text("No history yet.")
            .font(.InstrumentSansRegular15)
            .foregroundStyle(.black)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 18)
            .padding(.top, 18)
    }
}

private struct CompletedQuizGridCard: View {
    let item: CompletedQuizHistoryItem
    let onTap: () -> Void

    private var scoreColor: Color {
        switch item.scorePercent {
        case ..<50:
            return Color.orange
        case 50..<90:
            return Color.artScopeBlueColor
        default:
            return Color.green
        }
    }

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 8) {
                AsyncImage(url: item.imageURL) { phase in
                    switch phase {
                    case let .success(image):
                        image
                            .resizable()
                            .scaledToFill()
                    default:
                        Rectangle()
                            .fill(Color.white.opacity(0.35))
                            .overlay(
                                Image(uiImage: .artScopeArtist)
                                    .resizable()
                                    .scaledToFill()
                                    .opacity(0.8)
                            )
                    }
                }
                .frame(height: 114)
                .frame(maxWidth: .infinity)
                .clipShape(RoundedRectangle(cornerRadius: 14))

                HStack(alignment: .top, spacing: 6) {
                    Text(item.title)
                        .font(.InstrumentSansBold16)
                        .foregroundStyle(.black)
                        .multilineTextAlignment(.leading)
                        .lineLimit(3)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(.black)
                        .padding(.top, 3)
                }

                Text("\(item.scorePercent)%")
                    .font(.InstrumentSansBold16)
                    .foregroundStyle(scoreColor)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .buttonStyle(.plain)
    }
}
