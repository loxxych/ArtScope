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
        static let cardSize = CGSize(width: 170, height: 150)
        static let accentColor: UIColor = UIColor(named: "ArtScopePink") ?? .systemPink
        static let titleText: String = "Related"
        static let subtitleText: String = "Styles and eras the artist was related to."
        static let subtitleTopSpacing: CGFloat = 6
        static let scrollTopSpacing: CGFloat = 12
        static let stackSpacing: CGFloat = 12
        static let cardCornerRadius: CGFloat = 16
        static let cardInnerInset: CGFloat = 12
        static let imageInset: CGFloat = 10
        static let imageHeight: CGFloat = 68
        static let imageCornerRadius: CGFloat = 14
        static let titleTopSpacing: CGFloat = 10
        static let subtitleCardTopSpacing: CGFloat = 6
        static let cardBottomInset: CGFloat = 12
        static let titleFont: UIFont = UIFont(name: "InstrumentSans-Bold", size: 17) ?? .boldSystemFont(ofSize: 17)
        static let subtitleFont: UIFont = UIFont(name: "InstrumentSans-Regular", size: 14) ?? .systemFont(ofSize: 14)
        static let cardTitleFont: UIFont = UIFont(name: "InstrumentSans-Bold", size: 16) ?? .boldSystemFont(ofSize: 16)
        static let cardSubtitleFont: UIFont = UIFont(name: "InstrumentSans-Regular", size: 12) ?? .systemFont(ofSize: 12)
        static let descriptionLines: Int = 0
        static let cardTitleLines: Int = 2
        static let cardSubtitleLines: Int = 3
    }
    
    // MARK: - Properties
    private let items: [Item]
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
    
    private func makeCard(item: Item) -> UIView {
        let card = UIView()
        let imageBlock = UIView()
        let titleLabel = UILabel()
        let subtitleLabel = UILabel()
        
        card.backgroundColor = .white.withAlphaComponent(0.28)
        card.layer.cornerRadius = Constants.cardCornerRadius
        card.setWidth(Constants.cardSize.width)
        
        card.addSubview(imageBlock)
        card.addSubview(titleLabel)
        card.addSubview(subtitleLabel)
        
        imageBlock.backgroundColor = Constants.accentColor.withAlphaComponent(0.45)
        imageBlock.layer.cornerRadius = Constants.imageCornerRadius
        imageBlock.pinTop(to: card.topAnchor, Constants.imageInset)
        imageBlock.pinHorizontal(to: card, Constants.imageInset)
        imageBlock.setHeight(Constants.imageHeight)
        
        titleLabel.text = item.title
        titleLabel.font = Constants.cardTitleFont
        titleLabel.numberOfLines = Constants.cardTitleLines
        titleLabel.pinTop(to: imageBlock.bottomAnchor, Constants.titleTopSpacing)
        titleLabel.pinHorizontal(to: card, Constants.cardInnerInset)
        
        subtitleLabel.text = item.subtitle
        subtitleLabel.font = Constants.cardSubtitleFont
        subtitleLabel.numberOfLines = Constants.cardSubtitleLines
        subtitleLabel.pinTop(to: titleLabel.bottomAnchor, Constants.subtitleCardTopSpacing)
        subtitleLabel.pinHorizontal(to: card, Constants.cardInnerInset)
        subtitleLabel.pinBottom(to: card.bottomAnchor, Constants.cardBottomInset)
        
        return card
    }
}
