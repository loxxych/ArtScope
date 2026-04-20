//
//  ProfileCollectionHistoryCardView.swift
//  ArtScope
//
//  Created by loxxy on 20.04.2026.
//

import UIKit

final class ProfileCollectionHistoryCardView: UIControl {
    private enum Constants {
        static let cardWidth: CGFloat = 200
        static let imageHeight: CGFloat = 138
        static let cornerRadius: CGFloat = 16
        static let titleTop: CGFloat = 10
        static let titleFont: UIFont = .InstrumentSansBold20
    }

    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let chevronImageView = UIImageView()
    var onTap: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with item: ViewedCollectionHistoryItem) {
        titleLabel.text = item.title

        RemoteImageLoader.shared.loadImage(from: item.imageURL) { [weak self] image in
            DispatchQueue.main.async {
                let fallback = item.kind == .artist ? UIImage.artScopeDefaultArtistPreview : UIImage.artScopeArtist
                self?.imageView.image = image ?? fallback
            }
        }
    }

    private func configureUI() {
        setWidth(Constants.cardWidth)

        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(chevronImageView)

        imageView.backgroundColor = UIColor.white.withAlphaComponent(0.25)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = Constants.cornerRadius
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
        titleLabel.pinBottom(to: bottomAnchor)

        chevronImageView.image = UIImage(systemName: "chevron.right")
        chevronImageView.tintColor = .black
        chevronImageView.contentMode = .scaleAspectFit
        chevronImageView.setWidth(10)
        chevronImageView.setHeight(16)
        chevronImageView.pinRight(to: trailingAnchor, 2)
        chevronImageView.pinTop(to: imageView.bottomAnchor, Constants.titleTop + 6)
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
