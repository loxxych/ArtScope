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
        titleLabel.text = "Related"
        titleLabel.font = UIFont(name: "InstrumentSans-Bold", size: 17) ?? .boldSystemFont(ofSize: 17)
        titleLabel.pinTop(to: topAnchor)
        titleLabel.pinHorizontal(to: self)
    }
    
    private func configureSubtitle() {
        addSubview(subtitleLabel)
        subtitleLabel.text = "Styles and eras the artist was related to."
        subtitleLabel.font = UIFont(name: "InstrumentSans-Regular", size: 14) ?? .systemFont(ofSize: 14)
        subtitleLabel.numberOfLines = 0
        subtitleLabel.pinTop(to: titleLabel.bottomAnchor, 6)
        subtitleLabel.pinHorizontal(to: self)
    }
    
    private func configureScrollView() {
        addSubview(scrollView)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.pinTop(to: subtitleLabel.bottomAnchor, 12)
        scrollView.pinHorizontal(to: self)
        scrollView.setHeight(Constants.cardSize.height)
        scrollView.pinBottom(to: bottomAnchor)
        
        scrollView.addSubview(stackView)
        stackView.axis = .horizontal
        stackView.spacing = 12
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
        card.layer.cornerRadius = 16
        card.setWidth(Constants.cardSize.width)
        
        card.addSubview(imageBlock)
        card.addSubview(titleLabel)
        card.addSubview(subtitleLabel)
        
        imageBlock.backgroundColor = Constants.accentColor.withAlphaComponent(0.45)
        imageBlock.layer.cornerRadius = 14
        imageBlock.pinTop(to: card.topAnchor, 10)
        imageBlock.pinHorizontal(to: card, 10)
        imageBlock.setHeight(68)
        
        titleLabel.text = item.title
        titleLabel.font = UIFont(name: "InstrumentSans-Bold", size: 16) ?? .boldSystemFont(ofSize: 16)
        titleLabel.numberOfLines = 2
        titleLabel.pinTop(to: imageBlock.bottomAnchor, 10)
        titleLabel.pinHorizontal(to: card, 12)
        
        subtitleLabel.text = item.subtitle
        subtitleLabel.font = UIFont(name: "InstrumentSans-Regular", size: 12) ?? .systemFont(ofSize: 12)
        subtitleLabel.numberOfLines = 3
        subtitleLabel.pinTop(to: titleLabel.bottomAnchor, 6)
        subtitleLabel.pinHorizontal(to: card, 12)
        subtitleLabel.pinBottom(to: card.bottomAnchor, 12)
        
        return card
    }
}
