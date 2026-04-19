//
//  EditProfileViewModel.swift
//  ArtScope
//
//  Created by loxxy on 28.01.2026.
//

import Foundation
import UIKit

final class EditProfileViewModel {
    // MARK: - Constants
    private enum Constants {
        // Strings
        static let usernameKey: String = "userName"
        static let defaultUserName: String = "Guest"
        static let profilePictureName: String = "profilePicture.png"
    }
    
    // MARK: - Fields
    private(set) var userProfile: UserProfile? {
        didSet {
            onProfileUpdated?(userProfile)
        }
    }
    
    var onProfileUpdated: ((UserProfile?) -> Void)?
    
    // MARK: - Functions
    func loadUserProfile() {
        // Extract profile name from user defaults
        let name = UserDefaults.standard.string(forKey: Constants.usernameKey) ?? Constants.defaultUserName
        
        // Extract profile picture from file manager
        var profilePicture: UIImage? = AppImages.defaultProfile
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(Constants.profilePictureName)
        
        if (FileManager.default.fileExists(atPath: url.path)) {
            profilePicture = UIImage(contentsOfFile: url.path)
        }
        
        self.userProfile = UserProfile(name: name, profilePicture: profilePicture)
    }
    
    func saveUserProfile(name: String, profilePicture: UIImage?) {
        // Saving name
        UserDefaults.standard.set(name, forKey: Constants.usernameKey)
        
        // Saving picture
        if let profilePicture = profilePicture, let data = profilePicture.pngData() {
            let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(Constants.profilePictureName)
            try? data.write(to: url)
        }
        
        // Update info
        loadUserProfile()
    }
}
