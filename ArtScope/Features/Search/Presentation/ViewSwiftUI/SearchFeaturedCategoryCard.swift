//
//  SearchFeaturedCategoryCard.swift
//  ArtScope
//
//  Created by loxxy on 19.04.2026.
//

import SwiftUI

struct SearchFeaturedCategoryCard: View {
    let category: SearchFeaturedCategory

    var body: some View {
        ZStack(alignment: .center) {
            AsyncImage(url: category.imageURL) { phase in
                switch phase {
                case let .success(image):
                    image
                        .resizable()
                        .scaledToFill()
                default:
                    Rectangle()
                        .fill(Color.white.opacity(0.35))
                }
            }

            SearchTheme.cardOverlay

            Text(category.title)
                .font(SearchTheme.pixelFont(size: 34))
                .foregroundStyle(.white)
                .shadow(color: .black.opacity(0.65), radius: 0, x: 2, y: 2)
        }
        .frame(height: 176)
        .clipShape(RoundedRectangle(cornerRadius: 22))
    }
}
