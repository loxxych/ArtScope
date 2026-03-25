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
        // Strings
        
        // UI Constraint properties
        
        // Colors
        static let backgroundColor: UIColor = UIColor(named: "ArtScopeGreen") ?? .green
    }
    
    // MARK: - Fields
    private let viewModel = MainPageViewModel(artistService: WikiDataArtistService(client: URLSessionNetworkClient() as NetworkClient))
    
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
    }
    
    private func bindViewModel() {
        artistOfTheDayView.onLearnMoreButtonTapped = { [weak self] in
            guard let self, let artist = self.featuredArtist else { return }
            self.showArtistDetails(for: artist)
        }
        
        artistsSectionView.onArtistSelected = { [weak self] artist in
            self?.showArtistDetails(for: artist)
        }
        
        viewModel.onArtistsLoaded = { [weak self] artists in
            guard let self, !artists.isEmpty else { return }
            
            let featuredArtist = self.makeFeaturedArtist(from: artists)
            print("Loaded artists count: \(artists.count)")
            self.artists = artists
            self.featuredArtist = featuredArtist
            self.artistOfTheDayView.configure(with: featuredArtist)
            self.artistsSectionView.update(with: artists)
        }
        
        viewModel.onLoadingFailed = { error in
            print("Failed to load artists: \(error)")
        }
    }


    // MARK: - UI Configuration
    private func configureUI() {
        view.backgroundColor = Constants.backgroundColor
        
        configureArtistOfTheDayView()
        configureArtistsSectionView()
        configureStylesSectionView()
    }

    private func configureArtistOfTheDayView() {
        view.addSubview(artistOfTheDayView)
        
        artistOfTheDayView.pinTop(to: view.topAnchor, 50)
        artistOfTheDayView.pinCenterX(to: view)
    }
    
    private func configureArtistsSectionView() {
        view.addSubview(artistsSectionView)
        
        artistsSectionView.pinTop(to: artistOfTheDayView.bottomAnchor, 20)
        artistsSectionView.pinLeft(to: view.leadingAnchor, 10)
        artistsSectionView.setHeight(260)
        artistsSectionView.setWidth(400)
    }
    
    private func configureStylesSectionView() {
        view.addSubview(stylesSectionView)
        
        stylesSectionView.pinTop(to: artistsSectionView.bottomAnchor, 20)
        stylesSectionView.pinLeft(to: view.leadingAnchor, 10)
        stylesSectionView.setHeight(260)
        stylesSectionView.setWidth(400)
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

}
