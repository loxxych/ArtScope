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
        static let artistsSectionTitle: String = "Artists"
        
        // UI Constraint properties
        static let artistsTitleLeft: CGFloat = 20
        
        // Colors
        static let backgroundColor: UIColor = UIColor(named: "ArtScopeGreen") ?? .green
    }
    
    // MARK: - Fields
    private let viewModel = MainPageViewModel(artistService: WikiDataArtistService(client: URLSessionNetworkClient() as NetworkClient))
    
    private var artistsSectionTitle: SectionTitleView = .init(title: "Artists")
    private let artistOfTheDayView: ArtistOfTheDayView = .init()
    
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
    }
    
    private func bindViewModel() {
        viewModel.onArtistsLoaded = { [weak self] artists in
            guard let self else { return }

            let artist = artists.first!

//            URLSession.shared.dataTask(with: artist.imageURL) { data, _, _ in
//                guard let data, let image = UIImage(data: data) else { return }
//
//                DispatchQueue.main.async {
//                    let view = ArtistPreviewView(
//                        name: artist.name,
//                        image: image
//                    )
//
//                    self.view.addSubview(view)
//                    // constraints
//                }
//            }.resume()
        }
    }


    // MARK: - UI Configuration
    private func configureUI() {
        view.backgroundColor = Constants.backgroundColor
        
        configureArtistOfTheDayView()
        configureArtistsSection()
    }

    private func configureArtistOfTheDayView() {
        view.addSubview(artistOfTheDayView)
        
        artistOfTheDayView.pinTop(to: view.topAnchor, 50)
        artistOfTheDayView.pinLeft(to: view.leadingAnchor, 20)
    }
    
    // MARK: - Artist section configuration
    private func configureArtistsSection() {
        artistsSectionTitle = SectionTitleView(title: Constants.artistsSectionTitle)
        
        view.addSubview(artistsSectionTitle)
        
        artistsSectionTitle.pinLeft(to: view.leadingAnchor, Constants.artistsTitleLeft)
        artistsSectionTitle.pinCenterY(to: view)
    }
}

