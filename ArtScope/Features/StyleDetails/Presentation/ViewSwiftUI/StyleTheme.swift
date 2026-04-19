//
//  StyleTheme.swift
//  ArtScope
//
//  Created by loxxy on 15.04.2026.
//

import SwiftUI

enum StyleTheme {
    static let screenBackground = Color(uiColor: UIColor(named: "ArtScopeGreen") ?? .systemYellow)
    static let quizCardBackground = Color(uiColor: UIColor(named: "ArtScopePink") ?? .systemPink)
    static let actionBlue = Color(uiColor: UIColor(named: "ArtScopeBlue") ?? .systemBlue)
    static let darkText = Color.black
    static let lightText = Color.white
    static let divider = Color.black.opacity(0.12)

    static func titleFont(size: CGFloat) -> Font {
        if UIFont(name: "ByteBounce", size: size) != nil {
            return .custom("ByteBounce", size: size)
        }
        return .system(size: size, weight: .bold)
    }

    static func bodyFont(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        let faceName: String
        switch weight {
        case .bold, .heavy, .black, .semibold:
            faceName = "InstrumentSans-Bold"
        default:
            faceName = "InstrumentSans-Regular"
        }

        if UIFont(name: faceName, size: size) != nil {
            return .custom(faceName, size: size)
        }
        return .system(size: size, weight: weight)
    }

    static func mediumFont(size: CGFloat) -> Font {
        if UIFont(name: "InstrumentSans-Medium", size: size) != nil {
            return .custom("InstrumentSans-Medium", size: size)
        }
        if UIFont(name: "InstrumentSans-SemiBold", size: size) != nil {
            return .custom("InstrumentSans-SemiBold", size: size)
        }
        return .system(size: size, weight: .medium)
    }

    static func semiBoldFont(size: CGFloat) -> Font {
        if UIFont(name: "InstrumentSans-SemiBold", size: size) != nil {
            return .custom("InstrumentSans-SemiBold", size: size)
        }
        if UIFont(name: "InstrumentSans-Medium", size: size) != nil {
            return .custom("InstrumentSans-Medium", size: size)
        }
        return .system(size: size, weight: .semibold)
    }
}
