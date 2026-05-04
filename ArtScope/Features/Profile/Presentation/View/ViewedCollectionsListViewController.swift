//
//  ViewedCollectionsListViewController.swift
//  ArtScope
//
//  Created by loxxy on 30.04.2026.
//

import SwiftUI
import UIKit

final class ViewedCollectionsListViewController: UIViewController {
    private let items: [ViewedCollectionHistoryItem]

    private lazy var hostingController = UIHostingController(
        rootView: ViewedCollectionsGridScreen(
            items: items,
            onBack: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            },
            onItemSelected: { [weak self] item in
                self?.showCollection(for: item)
            }
        )
    )

    init(items: [ViewedCollectionHistoryItem]) {
        self.items = items
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        menuController?.setMenuBarHidden(true, animated: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        menuController?.setMenuBarHidden(false, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        hostingController.didMove(toParent: self)
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
