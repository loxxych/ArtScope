//
//  StyleDetailScreen.swift
//  ArtScope
//
//  Created by loxxy on 15.04.2026.
//

import SwiftUI

struct StyleDetailScreen: View {
    let content: StyleDetailContent
    var onBack: (() -> Void)?
    var onBeginQuiz: (() -> Void)?

    private let headerHeight: CGFloat = 84
    private let workColumns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    var body: some View {
        ZStack(alignment: .top) {
            StyleTheme.screenBackground.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    StyleHeroView(imageURL: content.heroImageURL)
                        .padding(.top, headerHeight)

                    VStack(alignment: .leading, spacing: 28) {
                        titleBlock
                        descriptionBlock
                        artistsBlock
                        worksBlock
                        Divider()
                            .overlay(StyleTheme.divider)
                        quizBlock
                    }
                    .padding(.horizontal, 12)
                    .padding(.top, 18)
                    .padding(.bottom, 36)
                }
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
                Text(content.title)
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

    private var titleBlock: some View {
        Text(content.title)
            .font(StyleTheme.titleFont(size: 52))
            .foregroundStyle(StyleTheme.darkText)
            .frame(maxWidth: .infinity, alignment: .center)
    }

    private var descriptionBlock: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Description")
                .font(StyleTheme.bodyFont(size: 29, weight: .bold))
                .foregroundStyle(StyleTheme.darkText)

            Text(content.description)
                .font(StyleTheme.bodyFont(size: 15))
                .foregroundStyle(StyleTheme.darkText)
                .lineSpacing(2)

            Text("Read more")
                .font(StyleTheme.bodyFont(size: 15))
                .foregroundStyle(StyleTheme.actionBlue)
        }
    }

    private var artistsBlock: some View {
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
                        StyleArtistAvatarView(artist: artist)
                    }
                }
                .padding(.top, 4)
                .padding(.trailing, 12)
            }
        }
    }

    private var worksBlock: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Works")
                .font(StyleTheme.bodyFont(size: 31, weight: .bold))
                .foregroundStyle(StyleTheme.darkText)

            Text("Examples of artworks related to this style")
                .font(StyleTheme.bodyFont(size: 15))
                .foregroundStyle(StyleTheme.darkText.opacity(0.85))

            LazyVGrid(columns: workColumns, alignment: .leading, spacing: 16) {
                ForEach(content.works) { work in
                    StyleWorkCardView(work: work)
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
    StyleDetailScreen(content: StyleDetailSampleData.impressionism)
}
