//
//  QuizTheme.swift
//  ArtScope
//
//  Created by loxxy on 20.04.2026.
//

import SwiftUI

enum QuizTheme {
    static let screenBackground = Color.artScopePink
    static let headerBackground = Color.black
    static let primaryAction = Color.artScopeBlue
    static let cardBackground = Color.artScopePink
    static let lightText = Color.white
    static let darkText = Color.black
    static let progressFill = Color(red: 237 / 255, green: 244 / 255, blue: 88 / 255)
    static let progressTrack = Color(red: 236 / 255, green: 177 / 255, blue: 171 / 255)
    static let correctFill = Color(red: 142 / 255, green: 236 / 255, blue: 102 / 255)
    static let incorrectFill = Color(red: 192 / 255, green: 18 / 255, blue: 31 / 255)
    static let neutralOption = Color.black
    static let selectedOption = Color.white
    static let subduedOption = Color.black.opacity(0.82)
    static let resultTrack = Color.artScopeBlue.opacity(0.35)
    static let iconYellow = Color(red: 237 / 255, green: 244 / 255, blue: 88 / 255)
    static let warningOrange = Color(red: 255 / 255, green: 181 / 255, blue: 59 / 255)

    static func performanceColor(for percentage: Int) -> Color {
        if percentage < 50 {
            return warningOrange
        }

        if percentage > 90 {
            return progressFill
        }

        return primaryAction
    }
}
