//
//  StyleHeroView.swift
//  ArtScope
//
//  Created by loxxy on 15.04.2026.
//

import SwiftUI

struct StyleHeroView: View {
    let imageURL: URL?

    var body: some View {
        ZStack {
            AsyncImage(url: imageURL) { phase in
                switch phase {
                case let .success(image):
                    image
                        .resizable()
                        .scaledToFill()
                default:
                    LinearGradient(
                        colors: [.black, .black.opacity(0.65), StyleTheme.screenBackground.opacity(0.8)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                }
            }
            .frame(height: 255)
            .frame(maxWidth: .infinity)
            .clipped()
            .overlay(
                LinearGradient(
                    colors: [.clear, StyleTheme.screenBackground.opacity(0.55), StyleTheme.screenBackground],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
        }
    }
}
