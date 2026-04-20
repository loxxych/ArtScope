//
//  SearchTheme.swift
//  ArtScope
//
//  Created by loxxy on 19.04.2026.
//

import SwiftUI

enum SearchTheme {
    static let background = Color.artScopeGreen
    static let text = Color.black
    static let searchBorder = Color.black.opacity(0.28)
    static let placeholder = Color.black.opacity(0.28)
    static let cardOverlay = LinearGradient(
        colors: [.clear, Color.black.opacity(0.15), Color.black.opacity(0.62)],
        startPoint: .top,
        endPoint: .bottom
    )
}
