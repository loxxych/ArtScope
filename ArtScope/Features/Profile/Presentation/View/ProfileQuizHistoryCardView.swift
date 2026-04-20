//
//  ProfileQuizHistoryCardView.swift
//  ArtScope
//
//  Created by loxxy on 20.04.2026.
//

import UIKit

final class ProfileQuizHistoryCardView: UIControl {
    private enum Constants {
        static let cardWidth: CGFloat = 200
        static let imageHeight: CGFloat = 138
        static let cornerRadius: CGFloat = 16
        static let titleTop: CGFloat = 10
        static let titleFont: UIFont = .InstrumentSansBold20
        static let scoreFont: UIFont = .InstrumentSansBold24
    }

    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let chevronImageView = UIImageView()
    private let scoreLabel = UILabel()
    var onTap: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with item: CompletedQuizHistoryItem) {
        titleLabel.text = item.title
        scoreLabel.text = "\(item.scorePercent)%"

        RemoteImageLoader.shared.loadImage(from: item.imageURL) { [weak self] image in
            DispatchQueue.main.async {
                self?.imageView.image = image ?? UIImage.artScopeArtist
            }
        }
    }

    private func configureUI() {
        setWidth(Constants.cardWidth)

        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(chevronImageView)
        addSubview(scoreLabel)

        imageView.backgroundColor = UIColor.white.withAlphaComponent(0.25)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = Constants.cornerRadius
        imageView.image = UIImage.artScopeArtist
        imageView.pinTop(to: topAnchor)
        imageView.pinLeft(to: leadingAnchor)
        imageView.pinRight(to: trailingAnchor)
        imageView.setHeight(Constants.imageHeight)

        titleLabel.font = Constants.titleFont
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 2
        titleLabel.pinTop(to: imageView.bottomAnchor, Constants.titleTop)
        titleLabel.pinLeft(to: leadingAnchor)
        titleLabel.pinRight(to: chevronImageView.leadingAnchor, 8)

        chevronImageView.image = UIImage(systemName: "chevron.right")
        chevronImageView.tintColor = .black
        chevronImageView.contentMode = .scaleAspectFit
        chevronImageView.setWidth(10)
        chevronImageView.setHeight(16)
        chevronImageView.pinRight(to: trailingAnchor, 2)
        chevronImageView.pinTop(to: imageView.bottomAnchor, Constants.titleTop + 6)

        scoreLabel.font = Constants.scoreFont
        scoreLabel.textColor = .artScopeBlue
        scoreLabel.pinTop(to: titleLabel.bottomAnchor, 2)
        scoreLabel.pinLeft(to: leadingAnchor)
        scoreLabel.pinBottom(to: bottomAnchor)
    }

    override var isHighlighted: Bool {
        didSet {
            alpha = isHighlighted ? 0.7 : 1
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        if bounds.contains(touches.first?.location(in: self) ?? .zero) {
            onTap?()
        }
    }
}
