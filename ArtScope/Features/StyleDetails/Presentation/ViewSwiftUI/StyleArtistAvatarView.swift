//
//  StyleArtistAvatarView.swift
//  ArtScope
//
//  Created by loxxy on 15.04.2026.
//

import SwiftUI

struct StyleArtistAvatarView: View {
    let artist: StyleArtistItem
    var onTap: (() -> Void)?

    var body: some View {
        Button(action: { onTap?() }) {
            VStack(spacing: 8) {
                AsyncImage(url: artist.imageURL) { phase in
                    switch phase {
                    case let .success(image):
                        image
                            .resizable()
                            .scaledToFill()
                    default:
                        Circle()
                            .fill(Color.white.opacity(0.75))
                            .overlay(
                                Image(uiImage: .artScopeArtistPlaceholder)
                                    .resizable()
                                    .scaledToFit()
                                    .padding(18)
                                    .opacity(0.95)
                            )
                    }
                }
                .frame(width: 82, height: 82)
                .clipShape(Circle())

                Text(artist.name)
                    .font(.InstrumentSansRegular15)
                    .foregroundStyle(StyleTheme.darkText)
                    .multilineTextAlignment(.center)
                    .frame(width: 110)
                    .lineLimit(3)
            }
        }
        .buttonStyle(.plain)
    }
}
