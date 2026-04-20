//
//  Colors.swift
//  ArtScope
//
//  Created by loxxy on 20.04.2026.
//

import SwiftUI
import UIKit

extension UIColor {
    static let artScopeGreenUIColor = UIColor(named: "ArtScopeGreen") ?? .systemYellow
    static let artScopePinkUIColor = UIColor(named: "ArtScopePink") ?? .systemPink
    static let artScopeBlueUIColor = UIColor(named: "ArtScopeBlue") ?? .systemBlue
}

extension Color {
    static let artScopeGreenColor = SwiftUI.Color(uiColor: UIColor.artScopeGreenUIColor)
    static let artScopePinkColor = SwiftUI.Color(uiColor: UIColor.artScopePinkUIColor)
    static let artScopeBlueColor = SwiftUI.Color(uiColor: UIColor.artScopeBlueUIColor)
}
