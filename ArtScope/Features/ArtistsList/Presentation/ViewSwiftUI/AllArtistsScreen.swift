//
//  AllArtistsScreen.swift
//  ArtScope
//
//  Created by loxxy on 25.04.2026.
//

import SwiftUI

struct AllArtistsScreen: View {
    let artists: [ArtistPreview]
    var onBack: (() -> Void)?
    var onArtistSelected: ((ArtistPreview) -> Void)?

    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    var body: some View {
        ZStack(alignment: .top) {
            Color.artScopeGreen.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    Color.clear
                        .frame(height: 96)

                    LazyVGrid(columns: columns, spacing: 24) {
                        ForEach(artists, id: \.id) { artist in
                            AllArtistsCardView(artist: artist) {
                                onArtistSelected?(artist)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
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
                Text("Artists")
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

private struct AllArtistsCardView: View {
    let artist: ArtistPreview
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 12) {
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
                                    .foregroundStyle(Color.black.opacity(0.45))
                            )
                    }
                }
                .frame(width: 110, height: 110)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(Color.white, lineWidth: 4)
                )

                VStack(spacing: 6) {
                    Text(artist.name)
                        .font(.InstrumentSansSemiBold18)
                        .foregroundStyle(.black)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)

                    if !artist.summary.isEmpty {
                        Text(artist.summary)
                            .font(.InstrumentSansRegular11)
                            .foregroundStyle(.black.opacity(0.68))
                            .multilineTextAlignment(.center)
                            .lineLimit(3)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .frame(minHeight: 220, alignment: .top)
            .padding(.horizontal, 12)
            .padding(.vertical, 18)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white.opacity(0.22))
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    AllArtistsScreen(
        artists: [
            ArtistPreview(
                id: "1",
                name: "Salvador Dali",
                summary: "Spanish surrealist artist",
                imageURL: URL(string: "https://upload.wikimedia.org/wikipedia/commons/2/24/Salvador_Dal%C3%AD_1939.jpg")
            ),
            ArtistPreview(
                id: "2",
                name: "Claude Monet",
                summary: "French impressionist painter",
                imageURL: URL(string: "https://upload.wikimedia.org/wikipedia/commons/4/4d/Claude_Monet_1899_Nadar_crop.jpg")
            ),
            ArtistPreview(
                id: "3",
                name: "Pablo Picasso",
                summary: "Spanish painter and sculptor",
                imageURL: URL(string: "https://upload.wikimedia.org/wikipedia/commons/9/98/Pablo_picasso_1.jpg")
            )
        ]
    )
}
