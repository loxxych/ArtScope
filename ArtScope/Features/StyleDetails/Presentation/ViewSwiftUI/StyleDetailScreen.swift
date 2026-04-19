//
//  StyleDetailScreen.swift
//  ArtScope
//
//  Created by loxxy on 15.04.2026.
//

import SwiftUI

struct StyleDetailScreen: View {
    let screenTitle: String
    let content: StyleDetailContent?
    let isLoading: Bool
    let errorMessage: String?
    var onBack: (() -> Void)?
    var onRetry: (() -> Void)?
    var onBeginQuiz: (() -> Void)?
    var onArtistSelected: ((StyleArtistItem) -> Void)?
    var onWorkSelected: ((StyleWorkItem) -> Void)?
    @State private var isDescriptionExpanded = false

    private let headerHeight: CGFloat = 84
    private let workColumns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    var body: some View {
        ZStack(alignment: .top) {
            StyleTheme.screenBackground.ignoresSafeArea()

            if let content {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 0) {
                        StyleHeroView(imageURL: content.heroImageURL)
                            .padding(.top, headerHeight)

                        VStack(alignment: .leading, spacing: 28) {
                            titleBlock(content: content)
                            descriptionBlock(content: content)
                            artistsBlock(content: content)
                            worksBlock(content: content)
                            Divider()
                                .overlay(StyleTheme.divider)
                            quizBlock
                        }
                        .padding(.horizontal, 12)
                        .padding(.top, 18)
                        .padding(.bottom, 36)
                    }
                }
            } else {
                stateView
                    .padding(.top, headerHeight + 32)
                    .padding(.horizontal, 24)
            }

            headerBar
        }
        .navigationBarHidden(true)
    }

    private var headerBar: some View {
        ZStack(alignment: .bottom) {
            Color.black
                .ignoresSafeArea(edges: .top)

            ZStack {
                Text(screenTitle)
                    .font(StyleTheme.semiBoldFont(size: 26))
                    .foregroundStyle(StyleTheme.lightText)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .center)

                HStack {
                    Button(action: { onBack?() }) {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundStyle(StyleTheme.lightText)
                            .frame(width: 28, height: 28)
                    }

                    Spacer()
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 14)
        }
        .frame(height: headerHeight)
    }

    @ViewBuilder
    private var stateView: some View {
        if isLoading {
            VStack(spacing: 16) {
                ProgressView()
                    .tint(StyleTheme.darkText)
                    .scaleEffect(1.2)

                Text("Loading style details...")
                    .font(StyleTheme.bodyFont(size: 16, weight: .semibold))
                    .foregroundStyle(StyleTheme.darkText)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        } else {
            VStack(spacing: 16) {
                Text(errorMessage ?? "Failed to load style details.")
                    .font(StyleTheme.bodyFont(size: 15))
                    .foregroundStyle(StyleTheme.darkText)
                    .multilineTextAlignment(.center)

                Button(action: { onRetry?() }) {
                    Text("Retry")
                        .font(StyleTheme.semiBoldFont(size: 16))
                        .foregroundStyle(StyleTheme.lightText)
                        .padding(.horizontal, 22)
                        .padding(.vertical, 12)
                        .background(Color.black)
                        .clipShape(Capsule())
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
    }

    private func titleBlock(content: StyleDetailContent) -> some View {
        Text(content.title)
            .font(StyleTheme.titleFont(size: 52))
            .foregroundStyle(StyleTheme.darkText)
            .frame(maxWidth: .infinity, alignment: .center)
    }

    private func descriptionBlock(content: StyleDetailContent) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Description")
                .font(StyleTheme.bodyFont(size: 29, weight: .bold))
                .foregroundStyle(StyleTheme.darkText)

            Text(content.description)
                .font(StyleTheme.bodyFont(size: 15))
                .foregroundStyle(StyleTheme.darkText)
                .lineSpacing(2)
                .lineLimit(isDescriptionExpanded ? nil : 4)

            Button(action: {
                isDescriptionExpanded.toggle()
            }) {
                Text(isDescriptionExpanded ? "Show less" : "Read more")
                    .font(StyleTheme.bodyFont(size: 15))
                    .foregroundStyle(StyleTheme.actionBlue)
            }
        }
    }

    @ViewBuilder
    private func artistsBlock(content: StyleDetailContent) -> some View {
        if !content.artists.isEmpty {
            VStack(alignment: .leading, spacing: 10) {
                Text("Artists")
                    .font(StyleTheme.bodyFont(size: 31, weight: .bold))
                    .foregroundStyle(StyleTheme.darkText)

                Text("Artists related to this style")
                    .font(StyleTheme.bodyFont(size: 15))
                    .foregroundStyle(StyleTheme.darkText.opacity(0.85))

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .top, spacing: 12) {
                        ForEach(content.artists) { artist in
                            StyleArtistAvatarView(
                                artist: artist,
                                onTap: { onArtistSelected?(artist) }
                            )
                        }
                    }
                    .padding(.top, 4)
                    .padding(.trailing, 12)
                }
            }
        }
    }

    @ViewBuilder
    private func worksBlock(content: StyleDetailContent) -> some View {
        if !content.works.isEmpty {
            VStack(alignment: .leading, spacing: 10) {
                Text("Works")
                    .font(StyleTheme.bodyFont(size: 31, weight: .bold))
                    .foregroundStyle(StyleTheme.darkText)

                Text("Examples of artworks related to this style")
                    .font(StyleTheme.bodyFont(size: 15))
                    .foregroundStyle(StyleTheme.darkText.opacity(0.85))

                LazyVGrid(columns: workColumns, alignment: .leading, spacing: 16) {
                    ForEach(content.works) { work in
                        StyleWorkCardView(
                            work: work,
                            onTap: { onWorkSelected?(work) }
                        )
                    }
                }
            }
        }
    }

    private var quizBlock: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Quiz")
                .font(StyleTheme.bodyFont(size: 31, weight: .bold))
                .foregroundStyle(StyleTheme.darkText)

            Text("Complete a short quiz to test your knowledge!")
                .font(StyleTheme.bodyFont(size: 15))
                .foregroundStyle(StyleTheme.darkText.opacity(0.85))

            StyleQuizTeaserCardView(onBegin: onBeginQuiz)
        }
    }
}

#Preview {
    StyleDetailScreen(
        screenTitle: StyleDetailSampleData.impressionism.title,
        content: StyleDetailSampleData.impressionism,
        isLoading: false,
        errorMessage: nil
    )
}
