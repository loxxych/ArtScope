//
//  ProfileHistorySectionView.swift
//  ArtScope
//
//  Created by loxxy on 20.04.2026.
//

import UIKit

final class ProfileHistorySectionView: UIView {
    private enum Constants {
        static let cardsTopInset: CGFloat = 8
        static let horizontalInset: CGFloat = 20
        static let cardSpacing: CGFloat = 12
        static let sectionBottomInset: CGFloat = 0
        static let emptyFont: UIFont = .InstrumentSansRegular15
        static let fadeWidth: CGFloat = 72
    }

    private let headerView: ProfileSectionHeaderView
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    private let emptyLabel = UILabel()
    private let rightFadeView = UIView()
    private let rightFadeLayer = CAGradientLayer()
    var onHeaderIconTapped: (() -> Void)?
    var onQuizSelected: ((CompletedQuizHistoryItem) -> Void)?
    var onCollectionSelected: ((ViewedCollectionHistoryItem) -> Void)?

    init(title: String, description: String) {
        self.headerView = ProfileSectionHeaderView(title: title, description: description)
        super.init(frame: .zero)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateQuizItems(_ items: [CompletedQuizHistoryItem]) {
        clearCards()
        emptyLabel.isHidden = !items.isEmpty

        items.forEach { item in
            let card = ProfileQuizHistoryCardView()
            card.configure(with: item)
            card.onTap = { [weak self] in
                self?.onQuizSelected?(item)
            }
            stackView.addArrangedSubview(card)
        }
    }

    func updateCollectionItems(_ items: [ViewedCollectionHistoryItem]) {
        clearCards()
        emptyLabel.isHidden = !items.isEmpty

        items.forEach { item in
            let card = ProfileCollectionHistoryCardView()
            card.configure(with: item)
            card.onTap = { [weak self] in
                self?.onCollectionSelected?(item)
            }
            stackView.addArrangedSubview(card)
        }
    }

    private func configureUI() {
        addSubview(headerView)
        addSubview(scrollView)
        addSubview(emptyLabel)
        addSubview(rightFadeView)

        headerView.onIconTap = { [weak self] in
            self?.onHeaderIconTapped?()
        }

        headerView.pinTop(to: topAnchor)
        headerView.pinLeft(to: leadingAnchor)
        headerView.pinRight(to: trailingAnchor)

        scrollView.showsHorizontalScrollIndicator = false
        scrollView.pinTop(to: headerView.bottomAnchor, Constants.cardsTopInset)
        scrollView.pinLeft(to: leadingAnchor)
        scrollView.pinRight(to: trailingAnchor)
        scrollView.pinBottom(to: bottomAnchor, Constants.sectionBottomInset)

        scrollView.addSubview(stackView)
        stackView.axis = .horizontal
        stackView.spacing = Constants.cardSpacing
        stackView.alignment = .top
        stackView.pinTop(to: scrollView.contentLayoutGuide.topAnchor)
        stackView.pinLeft(to: scrollView.contentLayoutGuide.leadingAnchor, Constants.horizontalInset)
        stackView.pinRight(to: scrollView.contentLayoutGuide.trailingAnchor, Constants.horizontalInset)
        stackView.pinBottom(to: scrollView.contentLayoutGuide.bottomAnchor)
        stackView.pinHeight(to: scrollView.frameLayoutGuide.heightAnchor)

        emptyLabel.font = Constants.emptyFont
        emptyLabel.textColor = .black
        emptyLabel.numberOfLines = 0
        emptyLabel.text = "No history yet."
        emptyLabel.isHidden = true
        emptyLabel.pinTop(to: headerView.bottomAnchor, Constants.cardsTopInset)
        emptyLabel.pinLeft(to: leadingAnchor, Constants.horizontalInset)
        emptyLabel.pinRight(to: trailingAnchor, Constants.horizontalInset)
        emptyLabel.pinBottom(to: bottomAnchor)

        rightFadeView.isUserInteractionEnabled = false
        rightFadeView.backgroundColor = .clear
        rightFadeView.pinTop(to: scrollView.topAnchor)
        rightFadeView.pinRight(to: trailingAnchor)
        rightFadeView.pinBottom(to: scrollView.bottomAnchor)
        rightFadeView.setWidth(Constants.fadeWidth)

        rightFadeLayer.colors = [
            UIColor.artScopeGreen.withAlphaComponent(0).cgColor,
            UIColor.artScopeGreen.withAlphaComponent(0.18).cgColor,
            UIColor.artScopeGreen.withAlphaComponent(0.72).cgColor,
            UIColor.artScopeGreen.cgColor
        ]
        rightFadeLayer.locations = [0.0, 0.42, 0.78, 1.0]
        rightFadeLayer.startPoint = CGPoint(x: 0, y: 0.5)
        rightFadeLayer.endPoint = CGPoint(x: 1, y: 0.5)
        rightFadeView.layer.addSublayer(rightFadeLayer)
    }

    private func clearCards() {
        stackView.arrangedSubviews.forEach {
            stackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        rightFadeLayer.frame = rightFadeView.bounds
    }
}
