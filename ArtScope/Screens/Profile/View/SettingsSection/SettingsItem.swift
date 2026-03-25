//
//  SettingsItem.swift
//  ArtScope
//
//  Created by loxxy on 25.01.2026.
//

import UIKit

final class SettingsItem : UIView {
    // MARK: - Constants
    private enum Constants {
        // Strings
        static let titleText: String = "Edit profile"
        static let descriptionText: String = "Change your name and profile picture"
        
        // Images
        static let userIcon: UIImage? = UIImage(named: "user-icon")
        static let buttonImage: UIImage? = UIImage(named: "hand-point")
        
        // Fonts
        static let titleFont: UIFont? = UIFont(name: "InstrumentSans-SemiBold", size: 17)
        static let descriptionFont: UIFont? = UIFont(name: "InstrumentSans-Regular", size: 13)
        
        // UI Constraint properties
        static let titleDescriptionLeft: CGFloat = 18
        static let buttonSize: CGFloat = 24
        static let spacing: CGFloat = 4
        static let imageSize: CGFloat = 24
        
        // Colors
        static let tintColor: UIColor = .black
    }
    
    // MARK: - Fields
    private let titleLabel: UILabel = .init()
    private let descriptionLabel: UILabel = .init()
    private let textStack = UIStackView()
    private let imageView: UIImageView = .init()
    private let button: UIButton = .init(type: .system)
    
    var onButtonPressed: (() -> Void)?
    
    // MARK: - Lifecycle
    init() {
        super.init(frame: .zero)
        
        configureUI()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Configuration
    private func configureUI() {
        configureImageView()
        configureTextStack()
        configureDescription()
        configureButton()
    }
    
    private func configureImageView() {
        addSubview(imageView)
        
        imageView.image = Constants.userIcon
        imageView.tintColor = Constants.tintColor
        
        imageView.setHeight(Constants.imageSize)
        imageView.setWidth(Constants.imageSize)
        imageView.pinLeft(to: self.leadingAnchor)
        imageView.pinCenterY(to: self)
    }
    
    private func configureTextStack() {
        textStack.axis = .vertical
        textStack.spacing = Constants.spacing
        textStack.alignment = .leading
        
        configureTitle()
        configureDescription()
        
        textStack.addArrangedSubview(titleLabel)
        textStack.addArrangedSubview(descriptionLabel)
        
        addSubview(textStack)
        
        textStack.pinLeft(to: imageView.trailingAnchor, Constants.titleDescriptionLeft)
        textStack.pinCenterY(to: self)
    }
    
    private func configureTitle() {
        titleLabel.text = Constants.titleText
        titleLabel.font = Constants.titleFont
    }
    
    private func configureDescription() {
        descriptionLabel.text = Constants.descriptionText
        descriptionLabel.font = Constants.descriptionFont
        descriptionLabel.numberOfLines = 2
    }
    
    private func configureButton() {
        addSubview(button)
        
        button.setImage(Constants.buttonImage?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = Constants.tintColor
        
        button.pinRight(to: self.trailingAnchor)
        button.pinCenterY(to: self)
        button.setWidth(Constants.buttonSize)
        button.setHeight(Constants.buttonSize)
        
        button.addTarget(self, action: #selector(itemTapped), for: .touchUpInside)
    }
    
    // MARK: - Button press functions
    @objc private func itemTapped() {
        onButtonPressed?()
    }
}
