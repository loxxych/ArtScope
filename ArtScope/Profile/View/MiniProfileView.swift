//
//  MiniProfileView.swift
//  ArtScope
//
//  Created by loxxy on 22.01.2026.
//

import UIKit

final class MiniProfileView : UIView {
    // MARK: - Constants
    private enum Constants {
        // Text
        static let font: UIFont? = UIFont(name: "InstrumentSans-Regular", size: 17)
        
        // UI Constraint properties
        static let viewHeight: CGFloat = 53
        
        // Colors
        static let tintColor: UIColor = .black
        static let textColor: UIColor = .black
        
    }
    
    // MARK: - Fields
    private let label: UILabel = .init()
    private var profileImage: UIImageView = .init()

    // MARK: - Lifecycle
    init(title: String, image: UIImage?) {
        label.text = title
        profileImage.image = image
        
        super.init(frame: .zero)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI configuration
    private func configureUI() {
        self.setHeight(Constants.viewHeight)
        
        configureProfileImage()
        configureLabel()
    }
    
    // MARK: - Label configuration
    private func configureLabel() {
        addSubview(label)
        
        label.font = Constants.font
        label.textColor = Constants.textColor
        
        label.pinCenterY(to: self)
        label.pinLeft(to: profileImage.trailingAnchor, 10)
    }
    
    // MARK: - Profile image configuration
    private func configureProfileImage() {
        addSubview(profileImage)
        
        profileImage.layer.cornerRadius = 24
        profileImage.clipsToBounds = true
        profileImage.setWidth(48)
        profileImage.setHeight(48)
        profileImage.pinCenterY(to: self)
        profileImage.pinLeft(to: self)
   
    }
    
    // MARK: - Update functions
    func updatePicture(with image: UIImage?) {
        if let image = image {
            profileImage.image = image
        }
    }
    
    func updateUsername(with username: String) {
        label.text = username
    }
}
