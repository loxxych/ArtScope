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
    private let viewModel: StyleDetailViewModel
    private let hostingController: UIHostingController<StyleDetailScreen>
    private let viewedCollectionHistoryStore: ViewedCollectionHistoryStore
    private let styleQuizViewModel: StyleQuizViewModel
    private var currentState: StyleDetailViewModel.State = .loading
    private var preparedQuizContentID: String?

    init(
        style: StylePreview,
        service: StyleDetailsService = WikiDataArtistService(client: URLSessionNetworkClient())
    ) {
        self.style = style
        self.viewModel = StyleDetailViewModel(service: service)
        self.viewedCollectionHistoryStore = ProfileHistoryFactory.makeViewedCollectionHistoryStore()
        self.styleQuizViewModel = StyleQuizViewModel(
            styleID: style.id,
            styleName: style.name,
            styleImageURL: style.imageURL,
            quizService: QuizServiceFactory.makeQuizService()
        )
        self.hostingController = UIHostingController(
            rootView: StyleDetailScreen(
                screenTitle: style.name,
                content: nil,
                isLoading: true,
                errorMessage: nil,
                quizViewModel: styleQuizViewModel
            )
        )

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
        view.backgroundColor = .artScopeGreen
        bindViewModel()
        embedHostingController()
        recordStyleView()
        loadStyleDetails()
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

    private func bindViewModel() {
        viewModel.onStateChanged = { [weak self] state in
            self?.currentState = state
            self?.render()
        }
    }

    private func loadStyleDetails() {
        preparedQuizContentID = nil
        viewModel.load(style: style)
    }

    private func recordStyleView() {
        viewedCollectionHistoryStore.save(
            ViewedCollectionHistoryItem(
                id: style.id,
                title: style.name,
                kind: .style,
                imageURLString: style.imageURL?.absoluteString,
                viewedAt: Date()
            )
        )
    }

    private func render() {
        let content: StyleDetailContent?
        let isLoading: Bool
        let errorMessage: String?

        switch currentState {
        case .loading:
            content = nil
            isLoading = true
            errorMessage = nil
        case let .loaded(loadedContent):
            content = loadedContent
            isLoading = false
            errorMessage = nil
        case let .failed(message):
            content = nil
            isLoading = false
            errorMessage = message
        }

        hostingController.rootView = StyleDetailScreen(
            screenTitle: style.name,
            content: content,
            isLoading: isLoading,
            errorMessage: errorMessage,
            quizViewModel: styleQuizViewModel,
            onBack: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            },
            onRetry: { [weak self] in
                self?.loadStyleDetails()
            },
            onArtistSelected: { [weak self] artist in
                self?.showArtistDetails(for: artist)
            },
            onWorkSelected: { [weak self] work in
                self?.showWorkDetails(for: work)
            }
        )

        if let content {
            prepareStyleQuizIfNeeded(content: content)
        }
    }

    private func showArtistDetails(for artist: StyleArtistItem) {
        let preview = ArtistPreview(
            id: artist.id,
            name: artist.name,
            summary: "",
            imageURL: artist.imageURL
        )
        let vc = ArtistDetailsViewController(artist: preview)
        navigationController?.pushViewController(vc, animated: true)
    }

    private func showWorkDetails(for work: StyleWorkItem) {
        let artistWork = ArtistWork(
            id: work.id,
            title: work.title,
            imageURL: work.imageURL
        )
        let vc = WorkDetailsViewController(
            work: artistWork,
            artistName: work.artistName,
            artistImageURL: work.artistImageURL
        )
        navigationController?.pushViewController(vc, animated: true)
    }

    private func prepareStyleQuizIfNeeded(content: StyleDetailContent) {
        guard preparedQuizContentID != content.id else { return }
        preparedQuizContentID = content.id
        styleQuizViewModel.updateContext(
            description: content.description,
            artists: content.artists,
            works: content.works
        )
        styleQuizViewModel.load()
    }
}
