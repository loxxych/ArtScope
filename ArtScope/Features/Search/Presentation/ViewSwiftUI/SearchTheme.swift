//
//  SearchTheme.swift
//  ArtScope
//
//  Created by loxxy on 19.04.2026.
//

import SwiftUI

enum SearchTheme {
    static let background = Color(uiColor: UIColor(named: "ArtScopeGreen") ?? .systemYellow)
    static let text = Color.black
    static let searchBorder = Color.black.opacity(0.28)
    static let placeholder = Color.black.opacity(0.28)
    static let cardOverlay = LinearGradient(
        colors: [.clear, Color.black.opacity(0.15), Color.black.opacity(0.62)],
        startPoint: .top,
        endPoint: .bottom
    )

    static func pixelFont(size: CGFloat) -> Font {
        if UIFont(name: "ByteBounce", size: size) != nil {
            return .custom("ByteBounce", size: size)
        }
        return .system(size: size, weight: .bold)
    }

    static func regularFont(size: CGFloat) -> Font {
        if UIFont(name: "InstrumentSans-Regular", size: size) != nil {
            return .custom("InstrumentSans-Regular", size: size)
        }
        return .system(size: size)
    }

    static func semiBoldFont(size: CGFloat) -> Font {
        if UIFont(name: "InstrumentSans-SemiBold", size: size) != nil {
            return .custom("InstrumentSans-SemiBold", size: size)
        }
        return .system(size: size, weight: .semibold)
    }
}
