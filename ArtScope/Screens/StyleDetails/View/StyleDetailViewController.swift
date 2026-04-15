//
//  StyleDetailViewController.swift
//  ArtScope
//
//  Created by loxxy on 15.04.2026.
//

import SwiftUI
import UIKit

final class StyleDetailViewController: UIViewController {
    private let style: StylePreview
    private let hostingController: UIHostingController<StyleDetailScreen>

    init(style: StylePreview) {
        self.style = style

        let content = StyleDetailViewController.makeContent(from: style)
        self.hostingController = UIHostingController(
            rootView: StyleDetailScreen(content: content)
        )

        super.init(nibName: nil, bundle: nil)

        hostingController.rootView = StyleDetailScreen(
            content: content,
            onBack: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            },
            onBeginQuiz: {
                print("[StyleDetail] quiz teaser tapped: style=\(style.name)")
            }
        )
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
        view.backgroundColor = UIColor(named: "ArtScopeGreen") ?? .systemYellow
        embedHostingController()
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

    private static func makeContent(from style: StylePreview) -> StyleDetailContent {
        let sample = StyleDetailSampleData.impressionism
        return StyleDetailContent(
            id: style.id,
            title: style.name,
            description: sample.description,
            heroImageURL: style.imageURL ?? sample.heroImageURL,
            artists: sample.artists,
            works: sample.works
        )
    }
}
