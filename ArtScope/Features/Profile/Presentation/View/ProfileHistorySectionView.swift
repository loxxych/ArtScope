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
    }

    private let headerView: ProfileSectionHeaderView
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    private let emptyLabel = UILabel()
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
    }

    private func clearCards() {
        stackView.arrangedSubviews.forEach {
            stackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
    }
}
