//
//  StyleArtistAvatarView.swift
//  ArtScope
//
//  Created by loxxy on 15.04.2026.
//

import SwiftUI

struct StyleArtistAvatarView: View {
    let artist: StyleArtistItem

    var body: some View {
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
                            Image(systemName: "person.fill")
                                .foregroundStyle(Color.black.opacity(0.5))
                        )
                }
            }
            .frame(width: 62, height: 62)
            .clipShape(Circle())

            Text(artist.name)
                .font(StyleTheme.bodyFont(size: 11))
                .foregroundStyle(StyleTheme.darkText)
                .multilineTextAlignment(.center)
                .frame(width: 72)
                .lineLimit(2)
        }
    }
}
