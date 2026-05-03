//
//  ViewedCollectionsListViewController.swift
//  ArtScope
//
//  Created by loxxy on 30.04.2026.
//

import UIKit

final class ViewedCollectionsListViewController: UIViewController {
    private enum Constants {
        static let backgroundColor: UIColor = .artScopeGreen
        static let headerHeight: CGFloat = 88
        static let topSpacing: CGFloat = 18
        static let horizontalInset: CGFloat = 20
        static let cardSpacing: CGFloat = 20
        static let bottomInset: CGFloat = 36
        static let emptyFont: UIFont = .InstrumentSansRegular15
        static let titleText: String = "Completed"
        static let subtitleText: String = "The artists, styles and eras you've discovered"
    }

    private let items: [ViewedCollectionHistoryItem]

    private let headerView = ProfileHistoryListHeaderView(
        title: Constants.titleText,
        subtitle: Constants.subtitleText
    )
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let stackView = UIStackView()
    private let emptyLabel = UILabel()

    init(items: [ViewedCollectionHistoryItem]) {
        self.items = items
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        populateCards()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    private func configureUI() {
        view.backgroundColor = Constants.backgroundColor

        headerView.onBack = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }

        view.addSubview(headerView)
        headerView.pinTop(to: view.topAnchor)
        headerView.pinLeft(to: view.leadingAnchor)
        headerView.pinRight(to: view.trailingAnchor)
        headerView.setHeight(Constants.headerHeight)

        view.addSubview(scrollView)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.pinTop(to: headerView.bottomAnchor)
        scrollView.pinLeft(to: view.leadingAnchor)
        scrollView.pinRight(to: view.trailingAnchor)
        scrollView.pinBottom(to: view.bottomAnchor)

        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
        ])

        contentView.addSubview(stackView)
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = Constants.cardSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.topSpacing),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalInset),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalInset),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.bottomInset)
        ])

        emptyLabel.font = Constants.emptyFont
        emptyLabel.textColor = .black
        emptyLabel.numberOfLines = 0
        emptyLabel.text = "No history yet."
        emptyLabel.isHidden = true
        contentView.addSubview(emptyLabel)
        emptyLabel.pinTop(to: contentView.topAnchor, Constants.topSpacing)
        emptyLabel.pinLeft(to: contentView.leadingAnchor, Constants.horizontalInset)
        emptyLabel.pinRight(to: contentView.trailingAnchor, Constants.horizontalInset)
        emptyLabel.pinBottom(to: contentView.bottomAnchor)
    }

    private func populateCards() {
        emptyLabel.isHidden = !items.isEmpty
        stackView.isHidden = items.isEmpty

        items.forEach { item in
            let card = ProfileCollectionHistoryCardView()
            card.configure(with: item)
            card.onTap = { [weak self] in
                self?.showCollection(for: item)
            }
            stackView.addArrangedSubview(card)
        }
    }

    private func showCollection(for item: ViewedCollectionHistoryItem) {
        switch item.kind {
        case .artist:
            let preview = ArtistPreview(
                id: item.id,
                name: item.title,
                summary: "",
                imageURL: item.imageURL
            )
            let vc = ArtistDetailsViewController(artist: preview)
            navigationController?.pushViewController(vc, animated: true)
        case .style:
            let preview = StylePreview(
                id: item.id,
                name: item.title,
                imageURL: item.imageURL
            )
            let vc = StyleDetailViewController(style: preview)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
