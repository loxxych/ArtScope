//
//  SearchStyleGridCard.swift
//  ArtScope
//
//  Created by loxxy on 19.04.2026.
//

import SwiftUI

struct SearchStyleGridCard: View {
    let item: SearchStyleItem

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            AsyncImage(url: item.imageURL) { phase in
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

            LinearGradient(
                colors: [.clear, Color.black.opacity(0.62)],
                startPoint: .center,
                endPoint: .bottom
            )

            Text(item.title)
                .font(SearchTheme.semiBoldFont(size: 16))
                .foregroundStyle(.white)
                .padding(.horizontal, 12)
                .padding(.bottom, 10)
        }
        .frame(height: 140)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}
