//
//  MiniProfileView.swift
//  ArtScope
//
//  Created by loxxy on 22.01.2026.
//

import UIKit

final class MiniProfileView: UIView {
    // MARK: - Constants
    private enum Constants {
        // Layout
        static let viewHeight: CGFloat = 60
        static let horizontalInset: CGFloat = 24
        static let imageSize: CGFloat = 48
        static let labelLeftInset: CGFloat = 14

        // Fonts
        static let font: UIFont = UIFont(name: "InstrumentSans-SemiBold", size: 17) ?? .systemFont(ofSize: 17, weight: .semibold)

        // Colors
        static let textColor: UIColor = .black
    }

    // MARK: - Fields
    private let label: UILabel = .init()
    private let profileImage: UIImageView = .init()

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
        profileImage.layer.cornerRadius = Constants.imageSize / 2
    }

    // MARK: - UI configuration
    private func configureUI() {
        setHeight(Constants.viewHeight)
        configureProfileImage()
        configureLabel()
    }

    private func configureLabel() {
        addSubview(label)

        label.font = Constants.font
        label.textColor = Constants.textColor

        label.pinCenterY(to: self)
        label.pinLeft(to: profileImage.trailingAnchor, Constants.labelLeftInset)
        label.pinRight(to: trailingAnchor, Constants.horizontalInset)
    }

    private func configureProfileImage() {
        addSubview(profileImage)

        profileImage.clipsToBounds = true
        profileImage.contentMode = .scaleAspectFill

        profileImage.setWidth(Constants.imageSize)
        profileImage.setHeight(Constants.imageSize)
        profileImage.pinCenterY(to: self)
        profileImage.pinLeft(to: self, Constants.horizontalInset)
    }

    // MARK: - Update functions
    func updatePicture(with image: UIImage?) {
        if let image {
            profileImage.image = image
        }
    }

    func updateUsername(with username: String) {
        label.text = username
    }
}
