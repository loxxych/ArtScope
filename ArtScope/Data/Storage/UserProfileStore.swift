//
//  UserProfileStore.swift
//  ArtScope
//
//  Created by loxxy on 25.04.2026.
//

import Foundation
import UIKit

protocol UserProfileStore {
    func loadProfile() -> UserProfile
    func saveProfile(name: String, profilePicture: UIImage?) -> UserProfile
}

final class DefaultUserProfileStore: UserProfileStore {
    private enum Constants {
        static let usernameKey = "userName"
        static let defaultUserName = "Guest"
        static let profilePictureName = "profilePicture.png"
    }

    private let defaults: UserDefaults
    private let fileManager: FileManager

    init(
        defaults: UserDefaults = .standard,
        fileManager: FileManager = .default
    ) {
        self.defaults = defaults
        self.fileManager = fileManager
    }

    func loadProfile() -> UserProfile {
        let savedName = defaults.string(forKey: Constants.usernameKey) ?? Constants.defaultUserName
        let normalizedName = Self.normalizeName(savedName)

        let pictureURL = profilePictureURL()
        let picture = fileManager.fileExists(atPath: pictureURL.path)
            ? UIImage(contentsOfFile: pictureURL.path)
            : UIImage.artScopeDefaultProfilePicture

        return UserProfile(name: normalizedName, profilePicture: picture)
    }

    func saveProfile(name: String, profilePicture: UIImage?) -> UserProfile {
        let normalizedName = Self.normalizeName(name)
        defaults.set(normalizedName, forKey: Constants.usernameKey)

        let pictureURL = profilePictureURL()
        if let profilePicture, let data = profilePicture.jpegData(compressionQuality: 0.9) {
            try? data.write(to: pictureURL, options: .atomic)
        } else if fileManager.fileExists(atPath: pictureURL.path) {
            try? fileManager.removeItem(at: pictureURL)
        }

        return loadProfile()
    }

    private func profilePictureURL() -> URL {
        fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(Constants.profilePictureName)
    }

    private static func normalizeName(_ value: String) -> String {
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? Constants.defaultUserName : trimmed
    }
}
