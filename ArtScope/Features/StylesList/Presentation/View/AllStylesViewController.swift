//
//  AllStylesViewController.swift
//  ArtScope
//
//  Created by loxxy on 04.05.2026.
//

import SwiftUI
import UIKit

final class AllStylesViewController: UIViewController {
    private let styles: [StylePreview]
    private lazy var hostingController = UIHostingController(
        rootView: AllStylesScreen(
            styles: styles,
            onBack: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            },
            onStyleSelected: { [weak self] style in
                let vc = StyleDetailViewController(style: style)
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        )
    )

    init(styles: [StylePreview]) {
        self.styles = styles
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
}
