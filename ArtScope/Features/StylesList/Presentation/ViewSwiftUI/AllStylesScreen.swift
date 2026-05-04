//
//  AllStylesScreen.swift
//  ArtScope
//
//  Created by loxxy on 04.05.2026.
//

import SwiftUI

struct AllStylesScreen: View {
    let styles: [StylePreview]
    var onBack: (() -> Void)?
    var onStyleSelected: ((StylePreview) -> Void)?

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

                    LazyVGrid(columns: columns, spacing: 24) {
                        ForEach(styles, id: \.id) { style in
                            AllStylesGridCard(style: style) {
                                onStyleSelected?(style)
                            }
                        }
                    }
                    .padding(.horizontal, 18)
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
                Text("Styles")
                    .font(.InstrumentSansSemiBold26)
                    .foregroundStyle(.white)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .center)

                HStack {
                    Button(action: { onBack?() }) {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundStyle(.white)
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

private struct AllStylesGridCard: View {
    let style: StylePreview
    let onTap: () -> Void

    private let titleAreaHeight: CGFloat = 30

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 4) {
                AsyncImage(url: style.imageURL) { phase in
                    switch phase {
                    case let .success(image):
                        image
                            .resizable()
                            .scaledToFill()
                    default:
                        Rectangle()
                            .fill(Color.white.opacity(0.28))
                    }
                }
                .frame(height: 114)
                .frame(maxWidth: .infinity)
                .clipShape(RoundedRectangle(cornerRadius: 16))

                HStack(alignment: .top, spacing: 6) {
                    Text(style.name)
                        .font(.InstrumentSansBold16)
                        .foregroundStyle(.black)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .frame(height: titleAreaHeight, alignment: .topLeading)

                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(.black)
                        .padding(.top, 3)
                }
                .frame(height: titleAreaHeight, alignment: .top)

                Text(descriptionText)
                    .font(.InstrumentSansRegular11)
                    .foregroundStyle(.black)
                    .lineLimit(3)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .buttonStyle(.plain)
    }

    private var descriptionText: String {
        switch style.name.lowercased() {
        case "impressionism":
            return "Light, color, and fleeting everyday moments."
        case "cubism":
            return "Geometric forms and fragmented perspectives."
        case "surrealism":
            return "Dream imagery and the logic of the unconscious."
        case "baroque":
            return "Drama, movement, and theatrical grandeur."
        case "expressionism":
            return "Emotion-driven color and expressive distortion."
        case "romanticism":
            return "Nature, imagination, and heightened feeling."
        case "realism":
            return "Ordinary life shown with direct observation."
        case "symbolism":
            return "Myth, metaphor, and poetic inner meaning."
        default:
            return "Distinctive ideas and visual language in art."
        }
    }
}
