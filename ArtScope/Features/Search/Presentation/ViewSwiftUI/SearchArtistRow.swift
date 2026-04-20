//
//  SearchArtistRow.swift
//  ArtScope
//
//  Created by loxxy on 20.04.2026.
//

import SwiftUI

struct SearchArtistRow: View {
    let artist: ArtistPreview
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 14) {
                AsyncImage(url: artist.imageURL) { phase in
                    switch phase {
                    case let .success(image):
                        image
                            .resizable()
                            .scaledToFill()
                    default:
                        Circle()
                            .fill(Color.white.opacity(0.5))
                            .overlay(
                                Image(systemName: "person.fill")
                                    .foregroundStyle(Color.black.opacity(0.45))
                            )
                    }
                }
                .frame(width: 58, height: 58)
                .clipShape(Circle())

                VStack(alignment: .leading, spacing: 4) {
                    Text(artist.name)
                        .font(.InstrumentSansSemiBold18)
                        .foregroundStyle(SearchTheme.text)
                        .lineLimit(1)

                    Text(artist.summary.isEmpty ? "Artist" : artist.summary)
                        .font(.InstrumentSansRegular15)
                        .foregroundStyle(SearchTheme.text.opacity(0.72))
                        .lineLimit(2)
                }

                Spacer()
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .background(Color.white.opacity(0.22))
            .clipShape(RoundedRectangle(cornerRadius: 18))
        }
        .buttonStyle(.plain)
    }
}
