//
//  MenuItem.swift
//  ArtScope
//
//  Created by loxxy on 22.01.2026.
//

enum MenuItem: Int, CaseIterable {
    case home
    case search
    case quiz
    case profile
    
    var iconName: String {
        switch self {
        case .home: return "home-icon"
        case .search: return "search-icon"
        case .quiz: return "quizzes-icon"
        case .profile: return "user-icon"
        }
    }
}
