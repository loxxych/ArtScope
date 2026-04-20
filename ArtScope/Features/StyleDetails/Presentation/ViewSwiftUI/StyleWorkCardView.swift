//
//  StyleWorkCardView.swift
//  ArtScope
//
//  Created by loxxy on 15.04.2026.
//

import SwiftUI

struct StyleWorkCardView: View {
    let work: StyleWorkItem
    var onTap: (() -> Void)?

    var body: some View {
        Button(action: { onTap?() }) {
            VStack(alignment: .leading, spacing: 8) {
                AsyncImage(url: work.imageURL) { phase in
                    switch phase {
                    case let .success(image):
                        image
                            .resizable()
                            .scaledToFill()
                    default:
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white.opacity(0.55))
                            .overlay(
                                Image(systemName: "photo")
                                    .foregroundStyle(Color.black.opacity(0.35))
                            )
                    }
                }
                .frame(height: 94)
                .frame(maxWidth: .infinity)
                .clipShape(RoundedRectangle(cornerRadius: 12))

                Text(work.title)
                    .font(.InstrumentSansSemiBold18)
                    .foregroundStyle(StyleTheme.darkText)
                    .lineLimit(2)
            }
        }
        .buttonStyle(.plain)
    }
}
