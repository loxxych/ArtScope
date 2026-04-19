//
//  SectionView.swift
//  ArtScope
//
//  Created by loxxy on 30.01.2026.
//

import UIKit

final class SectionView : UIView {
    // MARK: - Constants
    private enum Constants {
        // Layout
        static let horizontalInset: CGFloat = 20
        static let descriptionTop: CGFloat = 5
        static let descriptionRightInset: CGFloat = 20

        // Fonts
        static let titleFont: UIFont? = UIFont(name: "InstrumentSans-Bold", size: 27)
        static let descriptionFont: UIFont? = UIFont(name: "InstrumentSans-Regular", size: 13)
    }
    
    // MARK: - Fields
    private let titleLabel: UILabel = .init()
    private let descriptionLabel: UILabel = .init()
    
    var onEditProfileTapped: (() -> Void)?
    
    // MARK: - Lifecycle
    init(title: String, description: String) {
        titleLabel.text = title
        descriptionLabel.text = description
        
        super.init(frame: .zero)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Configuration
    private func configureUI() {
        configureTitle()
        configureDescription()
        
    }
    
    private func configureTitle() {
        addSubview(titleLabel)
        
        titleLabel.font = Constants.titleFont
        
        titleLabel.pinLeft(to: self, Constants.horizontalInset)
        titleLabel.pinTop(to: self)
    }
    
    private func configureDescription() {
        addSubview(descriptionLabel)
        
        descriptionLabel.font = Constants.descriptionFont
        descriptionLabel.numberOfLines = 0
        
        descriptionLabel.pinLeft(to: self, Constants.horizontalInset)
        descriptionLabel.pinRight(to: self.trailingAnchor, Constants.descriptionRightInset)
        descriptionLabel.pinTop(to: titleLabel.bottomAnchor, Constants.descriptionTop)
    }
}
