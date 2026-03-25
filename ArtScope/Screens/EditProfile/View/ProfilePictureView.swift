//
//  ProfilePictureView.swift
//  ArtScope
//
//  Created by loxxy on 28.01.2026.
//

import UIKit

final class ProfilePictureView: UIView {
    // MARK: - Constants
    private enum Constants {
        // Layout
        static let buttonSize: CGFloat = 42
        static let buttonBorderWidth: CGFloat = 2

        // Images
        static let cameraImage: UIImage? = UIImage(named: "camera")

        // Colors
        static let buttonColor: UIColor = .black
        static let buttonTintColor: UIColor = .white
        static let buttonBorderColor: UIColor = UIColor(named: "ArtScopeGreen") ?? .systemYellow
    }

    // MARK: - Fields
    private let imageView: UIImageView = .init()
    private let button: UIButton = .init(type: .system)

    var onButtonPressed: (() -> Void)?

    // MARK: - Lifecycle
    init() {
        super.init(frame: .zero)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.layer.cornerRadius = min(bounds.width, bounds.height) / 2
        button.layer.cornerRadius = Constants.buttonSize / 2
    }

    // MARK: - UI Configuration
    private func configureUI() {
        configureImageView()
        configureAddButton()
    }

    private func configureImageView() {
        addSubview(imageView)

        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.pin(to: self)
    }

    private func configureAddButton() {
        addSubview(button)

        button.setImage(Constants.cameraImage, for: .normal)
        button.backgroundColor = Constants.buttonColor
        button.tintColor = Constants.buttonTintColor
        button.layer.borderWidth = Constants.buttonBorderWidth
        button.layer.borderColor = Constants.buttonBorderColor.cgColor

        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: Constants.buttonSize),
            button.heightAnchor.constraint(equalToConstant: Constants.buttonSize),
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 6),
            button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 6)
        ])

        button.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
    }

    // MARK: - Button press functions
    @objc private func addButtonPressed() {
        onButtonPressed?()
    }

    // MARK: - Update functions
    func updatePicture(with image: UIImage?) {
        if let image {
            imageView.image = image
        }
    }

    func getPicture() -> UIImage? {
        imageView.image
    }
}
