//
//  ViewController.swift
//  ArtScope
//
//  Created by loxxy on 22.01.2026.
//

import SwiftUI
import UIKit

final class SearchViewController: UIViewController {
    private let viewModel = SearchViewModel(
        artistService: WikiDataArtistService(client: URLSessionNetworkClient())
    )
    private lazy var hostingController = UIHostingController(
        rootView: SearchScreen(
            content: SearchSampleData.content,
            viewModel: viewModel,
            onArtistSelected: { [weak self] artist in
                self?.showArtistDetails(for: artist)
            },
            onStyleSelected: { [weak self] style in
                self?.showStyleDetails(for: style)
            }
        )
    )
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        embedHostingController()
        viewModel.load()
    }

    private func embedHostingController() {
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

    private func showArtistDetails(for artist: ArtistPreview) {
        let vc = ArtistDetailsViewController(artist: artist)
        navigationController?.pushViewController(vc, animated: true)
    }

    private func showStyleDetails(for style: StylePreview) {
        let vc = StyleDetailViewController(style: style)
        navigationController?.pushViewController(vc, animated: true)
    }
}
