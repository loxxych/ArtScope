//
//  ProfileHistoryTopBar.swift
//  ArtScope
//
//  Created by loxxy on 04.05.2026.
//

import SwiftUI

struct ProfileHistoryTopBar: View {
    let title: String
    var onBack: (() -> Void)?

    private let headerHeight: CGFloat = 84

    var body: some View {
        ZStack(alignment: .bottom) {
            Color.black
                .ignoresSafeArea(edges: .top)

            ZStack {
                Text(title)
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
        .frame(height: headerHeight)
    }
}
