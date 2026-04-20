//
//  StyleQuizTeaserCardView.swift
//  ArtScope
//
//  Created by loxxy on 15.04.2026.
//

import SwiftUI

struct StyleQuizTeaserCardView: View {
    var onBegin: (() -> Void)?

    var body: some View {
        VStack(spacing: 18) {
            Text("Test yourself!")
                .font(.ByteBounce28)
                .foregroundStyle(StyleTheme.darkText)

            HStack {
                Image(uiImage: UIImage.artScopePaintbrush ?? UIImage())
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 52, height: 52)
                    .foregroundStyle(StyleTheme.lightText)

                Spacer()

                Button(action: { onBegin?() }) {
                    Text("Begin")
                        .font(.InstrumentSansBold16)
                        .foregroundStyle(StyleTheme.lightText)
                        .frame(width: 118, height: 54)
                        .background(Color.black)
                        .clipShape(Capsule())
                }

                Spacer()

                Image(uiImage: UIImage.artScopePalette ?? UIImage())
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 52, height: 52)
                    .foregroundStyle(StyleTheme.lightText)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 22)
        .frame(maxWidth: .infinity)
        .background(StyleTheme.quizCardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .shadow(color: StyleTheme.quizCardBackground.opacity(0.45), radius: 12, x: 0, y: 6)
    }
}
