//
//  ArtistRelatedSectionView.swift
//  ArtScope
//
//  Created by loxxy on 25.03.2026.
//

import UIKit

final class ArtistRelatedSectionView: UIView {
    // MARK: - Models
    struct Item {
        let title: String
        let subtitle: String
    }
    
    // MARK: - Constants
    private enum Constants {
        static let cardSize = CGSize(width: 148, height: 180)
        static let titleText: String = "Related"
        static let subtitleText: String = "Styles and eras the artist was related to."
        static let subtitleTopSpacing: CGFloat = 8
        static let scrollTopSpacing: CGFloat = 12
        static let stackSpacing: CGFloat = 12
        static let imageHeight: CGFloat = 104
        static let imageCornerRadius: CGFloat = 16
        static let titleTopSpacing: CGFloat = 8
        static let titleFont: UIFont = UIFont(name: "InstrumentSans-Bold", size: 27) ?? .boldSystemFont(ofSize: 27)
        static let subtitleFont: UIFont = UIFont(name: "InstrumentSans-Regular", size: 15) ?? .systemFont(ofSize: 15)
        static let cardTitleFont: UIFont = UIFont(name: "InstrumentSans-SemiBold", size: 18) ?? .systemFont(ofSize: 18)
        static let descriptionLines: Int = 0
        static let cardTitleLines: Int = 3
    }
    
    // MARK: - Properties
    private var items: [Item]
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    
    // MARK: - Lifecycle
    init(items: [Item]) {
        self.items = items
        super.init(frame: .zero)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    private func configureUI() {
        configureTitle()
        configureSubtitle()
        configureScrollView()
        configureCards()
    }
    
    private func configureTitle() {
        addSubview(titleLabel)
        titleLabel.text = Constants.titleText
        titleLabel.font = Constants.titleFont
        titleLabel.pinTop(to: topAnchor)
        titleLabel.pinHorizontal(to: self)
    }
    
    private func configureSubtitle() {
        addSubview(subtitleLabel)
        subtitleLabel.text = Constants.subtitleText
        subtitleLabel.font = Constants.subtitleFont
        subtitleLabel.numberOfLines = Constants.descriptionLines
        subtitleLabel.pinTop(to: titleLabel.bottomAnchor, Constants.subtitleTopSpacing)
        subtitleLabel.pinHorizontal(to: self)
    }
    
    private func configureScrollView() {
        addSubview(scrollView)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.pinTop(to: subtitleLabel.bottomAnchor, Constants.scrollTopSpacing)
        scrollView.pinHorizontal(to: self)
        scrollView.setHeight(Constants.cardSize.height)
        scrollView.pinBottom(to: bottomAnchor)
        
        scrollView.addSubview(stackView)
        stackView.axis = .horizontal
        stackView.spacing = Constants.stackSpacing
        stackView.pinTop(to: scrollView.contentLayoutGuide.topAnchor)
        stackView.pinLeft(to: scrollView.contentLayoutGuide.leadingAnchor)
        stackView.pinRight(to: scrollView.contentLayoutGuide.trailingAnchor)
        stackView.pinBottom(to: scrollView.contentLayoutGuide.bottomAnchor)
        stackView.pinHeight(to: scrollView.frameLayoutGuide.heightAnchor)
    }
    
    private func configureCards() {
        items.forEach { item in
            stackView.addArrangedSubview(makeCard(item: item))
        }
    }

    func update(with items: [Item]) {
        self.items = items
        stackView.arrangedSubviews.forEach { view in
            stackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        configureCards()
    }
    
    private func makeCard(item: Item) -> UIView {
        ArtistRelatedCardView(item: item)
    }
}

private final class ArtistRelatedCardView: UIView {
    private enum Constants {
        static let cardSize = CGSize(width: 148, height: 180)
        static let imageHeight: CGFloat = 104
        static let imageCornerRadius: CGFloat = 16
        static let titleTopSpacing: CGFloat = 8
        static let titleFont: UIFont = UIFont(name: "InstrumentSans-SemiBold", size: 18) ?? .systemFont(ofSize: 18)
        static let titleLinesCount: Int = 3
        static let iconSize: CGFloat = 34
    }

    private let item: ArtistRelatedSectionView.Item
    private let imageView = UIView()
    private let iconView = UIImageView()
    private let titleLabel = UILabel()

    init(item: ArtistRelatedSectionView.Item) {
        self.item = item
        super.init(frame: .zero)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        setWidth(Constants.cardSize.width)

        addSubview(imageView)
        addSubview(titleLabel)

        imageView.backgroundColor = .white.withAlphaComponent(0.28)
        imageView.layer.cornerRadius = Constants.imageCornerRadius
        imageView.pinTop(to: topAnchor)
        imageView.pinHorizontal(to: self)
        imageView.setHeight(Constants.imageHeight)

        imageView.addSubview(iconView)
        iconView.image = UIImage(named: "palette")?.withRenderingMode(.alwaysTemplate)
        iconView.tintColor = .black.withAlphaComponent(0.7)
        iconView.contentMode = .scaleAspectFit
        iconView.pinCenterX(to: imageView)
        iconView.pinCenterY(to: imageView)
        iconView.setWidth(Constants.iconSize)
        iconView.setHeight(Constants.iconSize)

        titleLabel.text = item.title
        titleLabel.font = Constants.titleFont
        titleLabel.numberOfLines = Constants.titleLinesCount
        titleLabel.pinTop(to: imageView.bottomAnchor, Constants.titleTopSpacing)
        titleLabel.pinHorizontal(to: self)
        titleLabel.pinBottom(to: bottomAnchor)
    }
}
