//
//  ProfileViewModel.swift
//  ArtScope
//
//  Created by loxxy on 22.01.2026.
//

import Foundation
import UIKit

final class ProfileViewModel {
    // MARK: - Fields
    private let profileStore: UserProfileStore

    private(set) var userProfile: UserProfile? {
        didSet {
            onProfileUpdated?(userProfile)
        }
    }

    private let completedQuizHistoryStore: CompletedQuizHistoryStore
    private let viewedCollectionHistoryStore: ViewedCollectionHistoryStore
    
    var onProfileUpdated: ((UserProfile?) -> Void)?
    var onCompletedQuizHistoryUpdated: (([CompletedQuizHistoryItem]) -> Void)?
    var onViewedCollectionHistoryUpdated: (([ViewedCollectionHistoryItem]) -> Void)?

    init(
        profileStore: UserProfileStore = DefaultUserProfileStore(),
        completedQuizHistoryStore: CompletedQuizHistoryStore = ProfileHistoryFactory.makeCompletedQuizHistoryStore(),
        viewedCollectionHistoryStore: ViewedCollectionHistoryStore = ProfileHistoryFactory.makeViewedCollectionHistoryStore()
    ) {
        self.profileStore = profileStore
        self.completedQuizHistoryStore = completedQuizHistoryStore
        self.viewedCollectionHistoryStore = viewedCollectionHistoryStore
    }
    
    // MARK: - Functions
    func loadUserProfile() {
        self.userProfile = profileStore.loadProfile()
        onCompletedQuizHistoryUpdated?(completedQuizHistoryStore.fetchResults())
        onViewedCollectionHistoryUpdated?(viewedCollectionHistoryStore.fetchItems())
    }
    
    func saveUserProfile(name: String, profilePicture: UIImage?) {
        self.userProfile = profileStore.saveProfile(name: name, profilePicture: profilePicture)
        onCompletedQuizHistoryUpdated?(completedQuizHistoryStore.fetchResults())
        onViewedCollectionHistoryUpdated?(viewedCollectionHistoryStore.fetchItems())
    }
}
