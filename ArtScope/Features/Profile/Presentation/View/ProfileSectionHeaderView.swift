//
//  ProfileSectionHeaderView.swift
//  ArtScope
//
//  Created by loxxy on 20.04.2026.
//

import UIKit

final class ProfileSectionHeaderView: UIView {
    private enum Constants {
        static let sideInset: CGFloat = 20
        static let descriptionTop: CGFloat = 2
        static let iconSize: CGFloat = 24
        static let titleFont: UIFont = .InstrumentSansBold27
        static let descriptionFont: UIFont = .InstrumentSansRegular15
    }

    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let iconView = UIImageView()

    init(title: String, description: String) {
        super.init(frame: .zero)
        titleLabel.text = title
        descriptionLabel.text = description
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(iconView)

        titleLabel.font = Constants.titleFont
        titleLabel.textColor = .black
        titleLabel.pinTop(to: topAnchor)
        titleLabel.pinLeft(to: leadingAnchor, Constants.sideInset)

        descriptionLabel.font = Constants.descriptionFont
        descriptionLabel.textColor = .black
        descriptionLabel.numberOfLines = 0
        descriptionLabel.pinTop(to: titleLabel.bottomAnchor, Constants.descriptionTop)
        descriptionLabel.pinLeft(to: leadingAnchor, Constants.sideInset)
        descriptionLabel.pinRight(to: iconView.leadingAnchor, 8)
        descriptionLabel.pinBottom(to: bottomAnchor)

        iconView.image = UIImage.artScopeHandPoint
        iconView.tintColor = .black
        iconView.contentMode = .scaleAspectFit
        iconView.setWidth(Constants.iconSize)
        iconView.setHeight(Constants.iconSize)
        iconView.pinCenterY(to: titleLabel)
        iconView.pinRight(to: trailingAnchor, Constants.sideInset)
    }
}
