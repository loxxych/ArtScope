//
//  ProfileHistoryListHeaderView.swift
//  ArtScope
//
//  Created by loxxy on 30.04.2026.
//

import UIKit

final class ProfileHistoryListHeaderView: UIView {
    private enum Constants {
        static let titleFont: UIFont = .InstrumentSansSemiBold26
        static let subtitleFont: UIFont = .InstrumentSansRegular11
        static let leftInset: CGFloat = 16
        static let bottomInset: CGFloat = 14
        static let buttonSize: CGFloat = 28
    }

    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let backButton = UIButton(type: .system)

    var onBack: (() -> Void)?

    init(title: String, subtitle: String) {
        super.init(frame: .zero)
        titleLabel.text = title
        subtitleLabel.text = subtitle
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        backgroundColor = .black

        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(backButton)

        titleLabel.font = Constants.titleFont
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.pinTop(to: safeAreaLayoutGuide.topAnchor, 6)
        titleLabel.pinCenterX(to: centerXAnchor)

        subtitleLabel.font = Constants.subtitleFont
        subtitleLabel.textColor = .white
        subtitleLabel.textAlignment = .center
        subtitleLabel.pinTop(to: titleLabel.bottomAnchor, 2)
        subtitleLabel.pinCenterX(to: centerXAnchor)
        subtitleLabel.pinBottom(to: bottomAnchor, Constants.bottomInset)

        backButton.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        backButton.tintColor = .white
        backButton.contentHorizontalAlignment = .center
        backButton.contentVerticalAlignment = .center
        backButton.setWidth(Constants.buttonSize)
        backButton.setHeight(Constants.buttonSize)
        backButton.pinLeft(to: leadingAnchor, Constants.leftInset)
        backButton.pinCenterY(to: titleLabel)
        backButton.addTarget(self, action: #selector(handleBackTap), for: .touchUpInside)
    }

    @objc private func handleBackTap() {
        onBack?()
    }
}
