//
//  ViewController.swift
//  ArtScope
//
//  Created by loxxy on 22.01.2026.
//

import UIKit

final class MainPageViewController: UIViewController {
    // MARK: - Constants
    private enum Constants {
        // UI Constraint properties
        static let contentTop: CGFloat = 50
        static let sectionSpacing: CGFloat = 10
        static let contentSideInset: CGFloat = 10
        static let artistsSectionHeight: CGFloat = 200
        static let stylesSectionHeight: CGFloat = 260
        
        // Colors
        static let backgroundColor: UIColor = .artScopeGreen
    }
    
    // MARK: - Fields
    private let viewModel = MainPageViewModel(artistService: WikiDataArtistService(client: URLSessionNetworkClient() as NetworkClient))
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let artistOfTheDayView: ArtistOfTheDayView = .init()
    private let artistsSectionView: ArtistsSectionView = .init()
    private let stylesSectionView: StylesSectionView = .init()
    private var artists: [ArtistPreview] = []
    private var featuredArtist: ArtistPreview?

    // MARK: - Lifecycle
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        configureUI()
        viewModel.loadArtists()
        viewModel.loadStyles()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func bindViewModel() {
        artistOfTheDayView.onLearnMoreButtonTapped = { [weak self] in
            guard let self, let artist = self.featuredArtist else { return }
            self.showArtistDetails(for: artist)
        }
        
        artistsSectionView.onArtistSelected = { [weak self] artist in
            self?.showArtistDetails(for: artist)
        }

        stylesSectionView.onStyleSelected = { [weak self] style in
            self?.showStyleDetails(for: style)
        }
        
        viewModel.onArtistsLoaded = { [weak self] artists in
            guard let self, !artists.isEmpty else { return }
            
            let featuredArtist = self.makeFeaturedArtist(from: artists)
            self.artists = artists
            self.featuredArtist = featuredArtist
            self.artistOfTheDayView.configure(with: featuredArtist)
            self.artistsSectionView.update(with: artists)
        }
        
        viewModel.onStylesLoaded = { [weak self] styles in
            self?.stylesSectionView.update(with: styles)
        }
    }


    // MARK: - UI Configuration
    private func configureUI() {
        view.backgroundColor = Constants.backgroundColor
        configureScrollView()
        
        configureArtistOfTheDayView()
        configureArtistsSectionView()
        configureStylesSectionView()
    }
    
    private func configureScrollView() {
        view.addSubview(scrollView)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = .clear
        scrollView.pinTop(to: view.safeAreaLayoutGuide.topAnchor)
        scrollView.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor)
        scrollView.pinLeft(to: view.safeAreaLayoutGuide.leadingAnchor)
        scrollView.pinRight(to: view.safeAreaLayoutGuide.trailingAnchor)

        scrollView.addSubview(contentView)
        contentView.pinTop(to: scrollView.contentLayoutGuide.topAnchor)
        contentView.pinLeft(to: scrollView.contentLayoutGuide.leadingAnchor)
        contentView.pinRight(to: scrollView.contentLayoutGuide.trailingAnchor)
        contentView.pinBottom(to: scrollView.contentLayoutGuide.bottomAnchor)
        contentView.pinWidth(to: scrollView.frameLayoutGuide.widthAnchor)
    }

    private func configureArtistOfTheDayView() {
        contentView.addSubview(artistOfTheDayView)
        
        artistOfTheDayView.pinTop(to: contentView.topAnchor, Constants.contentTop)
        artistOfTheDayView.pinCenterX(to: contentView)
    }
    
    private func configureArtistsSectionView() {
        contentView.addSubview(artistsSectionView)
        
        artistsSectionView.pinTop(to: artistOfTheDayView.bottomAnchor, Constants.sectionSpacing)
        artistsSectionView.pinLeft(to: contentView.leadingAnchor, Constants.contentSideInset)
        artistsSectionView.pinRight(to: contentView.trailingAnchor, Constants.contentSideInset)
        artistsSectionView.setHeight(Constants.artistsSectionHeight)
    }
    
    private func configureStylesSectionView() {
        contentView.addSubview(stylesSectionView)
        
        stylesSectionView.pinTop(to: artistsSectionView.bottomAnchor, Constants.sectionSpacing)
        stylesSectionView.pinLeft(to: contentView.leadingAnchor, Constants.contentSideInset)
        stylesSectionView.pinRight(to: contentView.trailingAnchor, Constants.contentSideInset)
        stylesSectionView.setHeight(Constants.stylesSectionHeight)
        stylesSectionView.pinBottom(to: contentView.bottomAnchor, Constants.sectionSpacing)
    }
    
    private func makeFeaturedArtist(from artists: [ArtistPreview]) -> ArtistPreview {
        artists.first(where: { artist in
            guard let imageURL = artist.imageURL else { return false }
            let pathExtension = imageURL.pathExtension.lowercased()
            return ["jpg", "jpeg", "png", "webp"].contains(pathExtension)
        }) ?? artists[0]
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
