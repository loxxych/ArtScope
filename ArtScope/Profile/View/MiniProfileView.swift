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

    override func layoutSubviews() {
        super.layoutSubviews()

        print("---- MiniProfileView DEBUG ----")
        print("MiniProfileView frame:", self.frame)
        print("MiniProfileView bounds:", self.bounds)

        print("profileImage frame:", profileImage.frame)
        print("profileImage bounds:", profileImage.bounds)

        print("alpha:", profileImage.alpha)
        print("hidden:", profileImage.isHidden)
        print("clipsToBounds:", profileImage.clipsToBounds)
        print("translatesAutoresizingMaskIntoConstraints:",
              profileImage.translatesAutoresizingMaskIntoConstraints)

        print("superview:", profileImage.superview)

        print("constraints affecting image H:",
              profileImage.constraintsAffectingLayout(for: .horizontal))
        print("constraints affecting image V:",
              profileImage.constraintsAffectingLayout(for: .vertical))
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
        profileImage.clipsToBounds = true
        profileImage.contentMode = .scaleAspectFill
        profileImage.layer.cornerRadius = 24
        profileImage.layer.borderWidth = 0.5
        //profileImage.layer.borderColor = .clear

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
