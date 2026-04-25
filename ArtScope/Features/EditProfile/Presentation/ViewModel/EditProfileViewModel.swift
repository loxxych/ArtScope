//
//  EditProfileViewModel.swift
//  ArtScope
//
//  Created by loxxy on 28.01.2026.
//

import Foundation
import UIKit

final class EditProfileViewModel {
    // MARK: - Fields
    private let profileStore: UserProfileStore

    private(set) var userProfile: UserProfile? {
        didSet {
            onProfileUpdated?(userProfile)
        }
    }
    
    var onProfileUpdated: ((UserProfile?) -> Void)?

    init(profileStore: UserProfileStore = DefaultUserProfileStore()) {
        self.profileStore = profileStore
    }
    
    // MARK: - Functions
    func loadUserProfile() {
        userProfile = profileStore.loadProfile()
    }
    
    func saveUserProfile(name: String, profilePicture: UIImage?) {
        userProfile = profileStore.saveProfile(name: name, profilePicture: profilePicture)
    }
}
