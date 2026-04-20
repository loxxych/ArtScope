//
//  SearchStyleGridCard.swift
//  ArtScope
//
//  Created by loxxy on 19.04.2026.
//

import SwiftUI

struct SearchStyleGridCard: View {
    let item: SearchStyleItem
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            ZStack(alignment: .bottom) {
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
                .frame(maxWidth: .infinity)
                .frame(height: 140)

                LinearGradient(
                    colors: [.clear, Color.black.opacity(0.14), Color.black.opacity(0.72)],
                    startPoint: .center,
                    endPoint: .bottom
                )
                .frame(maxWidth: .infinity)
                .frame(height: 140)

                HStack {
                    Text(item.title)
                        .font(.InstrumentSansSemiBold16)
                        .foregroundStyle(.white)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    LinearGradient(
                        colors: [Color.black.opacity(0.05), Color.black.opacity(0.42)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            }
            .frame(width: 165, height: 140)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .clipped()
        }
        .buttonStyle(.plain)
    }
}
