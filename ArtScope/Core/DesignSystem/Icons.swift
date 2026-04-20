//
//  Icons.swift
//  ArtScope
//
//  Created by loxxy on 20.04.2026.
//

import UIKit

extension UIImage {
    static let artScopeArtist = UIImage(named: "artist") ?? UIImage()
    static let artScopeDefaultProfilePicture = UIImage(named: "defaultProfilePicture")
    static let artScopeDefaultArtistPreview = UIImage(named: "defaultProfilePicture") ?? UIImage(systemName: "person.crop.circle.fill")
    static let artScopePalette = UIImage(named: "palette") ?? UIImage(systemName: "paintpalette.fill")
    static let artScopePaintbrush = UIImage(named: "paintbrush-icon") ?? UIImage(systemName: "paintbrush.pointed.fill")
    static let artScopeInfo = UIImage(named: "info-icon") ?? UIImage(systemName: "info.circle.fill")
    static let artScopeCheckmark = UIImage(named: "checkmark-icon") ?? UIImage(systemName: "checkmark.seal.fill")
    static let artScopeDislike = UIImage(named: "dislike-icon") ?? UIImage(systemName: "xmark.circle")
    static let artScopeLeaderboard = UIImage(named: "leaderboard-icon") ?? UIImage(systemName: "crown.fill")
    static let artScopeDrawingBoard = UIImage(named: "drawing-board-icon") ?? UIImage()
    static let artScopeHandPoint = UIImage(named: "hand-point-icon") ?? UIImage()
    static let artScopeCamera = UIImage(named: "camera-icon") ?? UIImage()
    static let artScopeUserIcon = UIImage(named: "user-icon") ?? UIImage()
    static let artScopeHomeIcon = UIImage(named: "home-icon") ?? UIImage()
    static let artScopeSearchIcon = UIImage(named: "search-icon") ?? UIImage()
    static let artScopeQuizzesIcon = UIImage(named: "quizzes-icon") ?? UIImage()
}
