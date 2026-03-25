//
//  ArtistDetailsViewController.swift
//  ArtScope
//
//  Created by loxxy on 25.03.2026.
//

import UIKit

final class ArtistDetailsViewController: UIViewController {
    // MARK: - Constants
    private enum Constants {
        static let backgroundColor: UIColor = UIColor(named: "ArtScopeGreen") ?? .systemYellow
        static let sideInset: CGFloat = 20
        static let sectionSpacing: CGFloat = 24
        static let heroHeight: CGFloat = 220
        static let portraitSize: CGFloat = 200
        static let headerBarHeight: CGFloat = 100
        static let portraitOverlap: CGFloat = 75
    }
    
    // MARK: - Properties
    private let artist: ArtistPreview
    private let viewModel: ArtistDetailsViewModel
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let heroImageView = UIImageView()
    private let heroGradientView = UIView()
    private let portraitImageView = UIImageView()
    private let headerBar = UIView()
    private let backButton = UIButton(type: .system)
    private let titleLabel = UILabel()
    private let contentStack = UIStackView()
    private let heroGradientLayer = CAGradientLayer()
    private let identitySectionView = ArtistIdentitySectionView()
    private let realNameSectionView = ArtistTextSectionView(title: "Real name")
    private let biographySectionView = ArtistTextSectionView(title: "Biography")
    private let worksSectionView = ArtistWorksSectionView()
    
    init(artist: ArtistPreview) {
        self.artist = artist
        self.viewModel = ArtistDetailsViewModel(
            preview: artist,
            service: WikiDataArtistService(client: URLSessionNetworkClient())
        )
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
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
        bindViewModel()
        configureUI()
        applyInitialState()
        viewModel.load()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        portraitImageView.layer.cornerRadius = portraitImageView.bounds.width / 2
        heroGradientLayer.frame = heroGradientView.bounds
    }
    
    // MARK: - UI Setup
    private func configureUI() {
        view.backgroundColor = Constants.backgroundColor
        configureHeaderBar()
        configureScrollView()
        configureHero()
        configureContentStack()
        configureSections()
    }
    
    private func configureScrollView() {
        view.addSubview(scrollView)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.pinTop(to: headerBar.bottomAnchor)
        scrollView.pinLeft(to: view.leadingAnchor)
        scrollView.pinRight(to: view.trailingAnchor)
        scrollView.pinBottom(to: view.bottomAnchor)
        
        scrollView.addSubview(contentView)
        contentView.pinTop(to: scrollView.contentLayoutGuide.topAnchor)
        contentView.pinLeft(to: scrollView.contentLayoutGuide.leadingAnchor)
        contentView.pinRight(to: scrollView.contentLayoutGuide.trailingAnchor)
        contentView.pinBottom(to: scrollView.contentLayoutGuide.bottomAnchor)
        contentView.pinWidth(to: scrollView.frameLayoutGuide.widthAnchor)
    }
    
    private func configureHero() {
        contentView.addSubview(heroImageView)
        heroImageView.backgroundColor = .white.withAlphaComponent(0.25)
        heroImageView.contentMode = .scaleAspectFill
        heroImageView.clipsToBounds = true
        heroImageView.image = AppImages.defaultArtistPreview
        heroImageView.pinTop(to: contentView.topAnchor)
        heroImageView.pinHorizontal(to: contentView)
        heroImageView.setHeight(Constants.heroHeight)
        
        contentView.addSubview(heroGradientView)
        heroGradientView.isUserInteractionEnabled = false
        heroGradientView.backgroundColor = .clear
        heroGradientView.pinTop(to: heroImageView.topAnchor)
        heroGradientView.pinHorizontal(to: heroImageView)
        heroGradientView.pinBottom(to: heroImageView.bottomAnchor)
        
        heroGradientLayer.colors = [
            UIColor.clear.cgColor,
            Constants.backgroundColor.withAlphaComponent(0.2).cgColor,
            Constants.backgroundColor.withAlphaComponent(0.72).cgColor,
            Constants.backgroundColor.cgColor
        ]
        heroGradientLayer.locations = [0.0, 0.55, 0.82, 1.0]
        heroGradientView.layer.addSublayer(heroGradientLayer)
        
        contentView.addSubview(portraitImageView)
        portraitImageView.backgroundColor = .white
        portraitImageView.contentMode = .scaleAspectFill
        portraitImageView.clipsToBounds = true
        portraitImageView.layer.borderWidth = 5
        portraitImageView.layer.borderColor = UIColor.white.cgColor
        portraitImageView.image = AppImages.defaultArtistPreview
        portraitImageView.setWidth(Constants.portraitSize)
        portraitImageView.setHeight(Constants.portraitSize)
        portraitImageView.pinTop(to: heroImageView.bottomAnchor, -Constants.portraitOverlap)
        portraitImageView.pinCenterX(to: contentView)
    }
    
    private func configureHeaderBar() {
        view.addSubview(headerBar)
        headerBar.backgroundColor = .black
        headerBar.pinTop(to: view.topAnchor)
        headerBar.pinHorizontal(to: view)
        headerBar.setHeight(Constants.headerBarHeight)
        
        headerBar.addSubview(backButton)
        backButton.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        backButton.tintColor = .white
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        backButton.pinLeft(to: headerBar.leadingAnchor, 16)
        backButton.pinBottom(to: headerBar.bottomAnchor, 18)
        backButton.setWidth(28)
        backButton.setHeight(28)
        
        headerBar.addSubview(titleLabel)
        titleLabel.text = artist.name
        titleLabel.textColor = .white
        titleLabel.font = UIFont(name: "InstrumentSans-Bold", size: 18) ?? .boldSystemFont(ofSize: 18)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 1
        titleLabel.pinLeft(to: backButton.trailingAnchor, 12, .grOE)
        titleLabel.pinRight(to: headerBar.trailingAnchor, 56)
        titleLabel.pinCenterX(to: headerBar)
        titleLabel.pinBottom(to: headerBar.bottomAnchor, 18)
    }
    
    private func configureContentStack() {
        contentView.addSubview(contentStack)
        contentStack.axis = .vertical
        contentStack.spacing = Constants.sectionSpacing
        
        contentStack.pinTop(to: portraitImageView.bottomAnchor, 16)
        contentStack.pinHorizontal(to: contentView, Constants.sideInset)
        contentStack.pinBottom(to: contentView.bottomAnchor, 32)
    }
    
    // MARK: - Sections
    private func configureSections() {
        contentStack.addArrangedSubview(identitySectionView)
        contentStack.addArrangedSubview(realNameSectionView)
        contentStack.addArrangedSubview(biographySectionView)
        contentStack.addArrangedSubview(makeRelatedSectionView())
        contentStack.addArrangedSubview(worksSectionView)
        contentStack.addArrangedSubview(makeQuizSectionView())
    }
    
    private func makeRelatedSectionView() -> UIView {
        ArtistRelatedSectionView(
            items: [
                .init(title: "Modern Art", subtitle: "A movement of experimentation and new visual language."),
                .init(title: "Portraiture", subtitle: "Artists and eras focused on character, likeness and identity.")
            ]
        )
    }
    
    // MARK: - Quiz
    private func makeQuizSectionView() -> UIView {
        ArtistQuizPlaceholderView()
    }
    
    // MARK: - Data
    private func bindViewModel() {
        viewModel.onDetailsLoaded = { [weak self] details in
            self?.apply(details: details)
        }
        
        viewModel.onWorksLoaded = { [weak self] works in
            self?.worksSectionView.update(with: works)
        }
        
        viewModel.onLoadingFailed = { error in
            print("Failed to load artist details: \(error)")
        }
    }
    
    private func applyInitialState() {
        let initial = ArtistDetailsContent(
            displayName: artist.name,
            realName: artist.name,
            biography: artist.summary,
            lifeSpan: "Life dates unavailable",
            imageURL: artist.imageURL
        )
        
        apply(details: initial)
    }
    
    private func apply(details: ArtistDetailsContent) {
        titleLabel.text = details.displayName
        identitySectionView.configure(name: details.displayName, lifeSpan: details.lifeSpan)
        realNameSectionView.updateBody(details.realName)
        biographySectionView.updateBody(details.biography)
        loadImages(from: details.imageURL)
    }
    
    private func loadImages(from imageURL: URL?) {
        RemoteImageLoader.shared.loadImage(from: imageURL) { [weak self] image in
            DispatchQueue.main.async {
                self?.heroImageView.image = image ?? AppImages.defaultArtistPreview
                self?.portraitImageView.image = image ?? AppImages.defaultArtistPreview
            }
        }
    }
    
    // MARK: - Actions
    @objc private func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }
}
