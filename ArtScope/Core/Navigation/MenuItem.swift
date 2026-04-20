//
//  MenuItem.swift
//  ArtScope
//
//  Created by loxxy on 22.01.2026.
//

import UIKit

enum MenuItem: Int, CaseIterable {
    case home
    case search
    case quiz
    case profile
    
    var icon: UIImage? {
        switch self {
        case .home: return .artScopeHomeIcon
        case .search: return .artScopeSearchIcon
        case .quiz: return .artScopeQuizzesIcon
        case .profile: return .artScopeUserIcon
        }
    }
}
