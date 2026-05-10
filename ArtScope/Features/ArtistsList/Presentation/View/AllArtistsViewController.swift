//
//  AllArtistsViewController.swift
//  ArtScope
//
//  Created by loxxy on 25.04.2026.
//

import SwiftUI
import UIKit

final class AllArtistsViewController: UIViewController {
    private let viewModel: AllArtistsViewModel
    private lazy var hostingController = UIHostingController(
        rootView: AllArtistsScreen(
            viewModel: viewModel,
            onBack: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            },
            onArtistSelected: { [weak self] artist in
                let vc = ArtistDetailsViewController(
                    artist: artist,
                    service: AppServicesFactory.makeArtistDetailsService()
                )
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        )
    )

    init(
        artists: [ArtistPreview],
        artistService: ArtistService = AppServicesFactory.makeArtistService()
    ) {
        self.viewModel = AllArtistsViewModel(artistService: artistService)
        self.viewModel.configureInitialArtists(artists)
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
        viewModel.loadAdditionalArtistsIfNeeded()
    }
}
