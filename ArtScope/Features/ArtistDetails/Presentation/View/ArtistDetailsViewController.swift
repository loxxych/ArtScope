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
        static let headerBackgroundColor: UIColor = .black
        static let headerTextColor: UIColor = .white
        static let backButtonTintColor: UIColor = .white
        static let heroPlaceholderColor: UIColor = UIColor.white.withAlphaComponent(0.25)
        static let portraitBackgroundColor: UIColor = .white
        static let portraitBorderColor: CGColor = UIColor.white.cgColor
        static let sideInset: CGFloat = 20
        static let sectionSpacing: CGFloat = 24
        static let heroHeight: CGFloat = 220
        static let portraitSize: CGFloat = 200
        static let headerBarHeight: CGFloat = 100
        static let portraitOverlap: CGFloat = 75
        static let backButtonLeft: CGFloat = 16
        static let headerBottomInset: CGFloat = 18
        static let headerTitleLeftSpacing: CGFloat = 12
        static let headerTitleRight: CGFloat = 56
        static let contentTopSpacing: CGFloat = 16
        static let contentBottom: CGFloat = 300
        static let portraitBorderWidth: CGFloat = 5
        static let gradientLocations: [NSNumber] = [0.0, 0.55, 0.82, 1.0]
        static let headerTitleFont: UIFont = UIFont(name: "InstrumentSans-Bold", size: 18) ?? .boldSystemFont(ofSize: 18)
        static let headerTitleLinesCount: Int = 1
    }
    
    // MARK: - Properties
    private let artist: ArtistPreview
    private let viewModel: ArtistDetailsViewModel
    private let artistQuizViewModel: ArtistQuizViewModel
    
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
    private let relatedSectionView = ArtistRelatedSectionView(
        items: []
    )
    private let quizSectionView = ArtistQuizPlaceholderView()
    private var portraitImageURL: URL?
    private var works: [ArtistWork] = []
    private var currentBiography: String?
    private var didLoadArtistDetails = false
    private var didResolveArtistWorks = false
    private var didRequestArtistQuiz = false
    
    init(artist: ArtistPreview) {
        self.artist = artist
        self.viewModel = ArtistDetailsViewModel(
            preview: artist,
            service: WikiDataArtistService(client: URLSessionNetworkClient())
        )
        self.artistQuizViewModel = ArtistQuizViewModel(
            artistID: artist.id,
            artistName: artist.name,
            quizService: QuizServiceFactory.makeQuizService()
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
        bindQuizSectionActions()
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
        worksSectionView.onWorkSelected = { [weak self] work in
            self?.showWorkDetails(for: work)
        }
    }
    
    private func configureScrollView() {
        view.addSubview(scrollView)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delaysContentTouches = false
        scrollView.canCancelContentTouches = true
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
        heroImageView.backgroundColor = Constants.heroPlaceholderColor
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
        heroGradientLayer.locations = Constants.gradientLocations
        heroGradientView.layer.addSublayer(heroGradientLayer)
        
        contentView.addSubview(portraitImageView)
        portraitImageView.backgroundColor = Constants.portraitBackgroundColor
        portraitImageView.contentMode = .scaleAspectFill
        portraitImageView.clipsToBounds = true
        portraitImageView.layer.borderWidth = Constants.portraitBorderWidth
        portraitImageView.layer.borderColor = Constants.portraitBorderColor
        portraitImageView.image = AppImages.defaultArtistPreview
        portraitImageView.setWidth(Constants.portraitSize)
        portraitImageView.setHeight(Constants.portraitSize)
        portraitImageView.pinTop(to: heroImageView.bottomAnchor, -Constants.portraitOverlap)
        portraitImageView.pinCenterX(to: contentView)
    }
    
    private func configureHeaderBar() {
        view.addSubview(headerBar)
        headerBar.backgroundColor = Constants.headerBackgroundColor
        headerBar.pinTop(to: view.topAnchor)
        headerBar.pinHorizontal(to: view)
        headerBar.setHeight(Constants.headerBarHeight)
        
        headerBar.addSubview(backButton)
        backButton.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        backButton.tintColor = Constants.backButtonTintColor
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        backButton.pinLeft(to: headerBar.leadingAnchor, Constants.backButtonLeft)
        backButton.pinBottom(to: headerBar.bottomAnchor, Constants.headerBottomInset)
        backButton.setWidth(28)
        backButton.setHeight(28)
        
        headerBar.addSubview(titleLabel)
        titleLabel.text = artist.name
        titleLabel.textColor = Constants.headerTextColor
        titleLabel.font = Constants.headerTitleFont
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = Constants.headerTitleLinesCount
        titleLabel.pinLeft(to: backButton.trailingAnchor, Constants.headerTitleLeftSpacing, .grOE)
        titleLabel.pinRight(to: headerBar.trailingAnchor, Constants.headerTitleRight)
        titleLabel.pinCenterX(to: headerBar)
        titleLabel.pinBottom(to: headerBar.bottomAnchor, Constants.headerBottomInset)
    }
    
    private func configureContentStack() {
        contentView.addSubview(contentStack)
        contentStack.axis = .vertical
        contentStack.spacing = Constants.sectionSpacing
        
        contentStack.pinTop(to: portraitImageView.bottomAnchor, Constants.contentTopSpacing)
        contentStack.pinHorizontal(to: contentView, Constants.sideInset)
        contentStack.pinBottom(to: contentView.bottomAnchor, Constants.contentBottom)
    }
    
    // MARK: - Sections
    private func configureSections() {
        biographySectionView.setExpandable(true)
        contentStack.addArrangedSubview(identitySectionView)
        contentStack.addArrangedSubview(realNameSectionView)
        contentStack.addArrangedSubview(biographySectionView)
        contentStack.setCustomSpacing(12, after: realNameSectionView)
        contentStack.addArrangedSubview(relatedSectionView)
        contentStack.addArrangedSubview(worksSectionView)
        contentStack.addArrangedSubview(quizSectionView)
    }

    private func bindQuizSectionActions() {
        quizSectionView.onRetryTapped = { [weak self] in
            self?.requestArtistQuiz(force: true)
        }
    }
    
    // MARK: - Data
    private func bindViewModel() {
        viewModel.onDetailsLoaded = { [weak self] details in
            self?.apply(details: details)
            self?.didLoadArtistDetails = true
            self?.loadArtistQuizIfPossible()
        }
        
        viewModel.onWorksLoaded = { [weak self] works in
            self?.works = works
            self?.worksSectionView.update(with: works)
            self?.loadHeroImage(from: works.first?.imageURL)
            self?.didResolveArtistWorks = true
            self?.loadArtistQuizIfPossible()
        }
        
        viewModel.onDetailsLoadingFailed = { [weak self] error in
            self?.quizSectionView.configureUnavailableState()
            print("Failed to load artist details: \(error)")
        }

        viewModel.onWorksLoadingFailed = { [weak self] error in
            self?.didResolveArtistWorks = true
            self?.loadArtistQuizIfPossible()
            print("Failed to load artist works: \(error)")
        }

        artistQuizViewModel.onLoadingStateChanged = { [weak self] isLoading in
            guard isLoading else { return }
            self?.quizSectionView.configureLoadingState()
        }
        
        artistQuizViewModel.onQuizLoaded = { [weak self] quiz in
            self?.quizSectionView.configure(with: quiz)
        }
        
        artistQuizViewModel.onLoadingFailed = { [weak self] error in
            self?.quizSectionView.configureUnavailableState()
            print("Failed to load artist quiz: \(error)")
        }
    }
    
    private func applyInitialState() {
        let initial = ArtistDetailsContent(
            displayName: artist.name,
            realName: artist.name,
            biography: artist.summary,
            lifeSpan: "Life dates unavailable",
            imageURL: artist.imageURL,
            relatedStyles: []
        )
        
        apply(details: initial)
        quizSectionView.configureLoadingState()
        loadHeroImage(from: nil)
    }
    
    private func apply(details: ArtistDetailsContent) {
        portraitImageURL = details.imageURL
        currentBiography = details.biography
        titleLabel.text = details.displayName
        identitySectionView.configure(name: details.displayName, lifeSpan: details.lifeSpan)
        realNameSectionView.updateBody(details.realName)
        biographySectionView.updateBody(details.biography)
        relatedSectionView.update(
            with: details.relatedStyles.map {
                ArtistRelatedSectionView.Item(
                    title: $0,
                    subtitle: "An artistic movement associated with \(details.displayName)."
                )
            }
        )
        relatedSectionView.isHidden = details.relatedStyles.isEmpty
        loadPortraitImage(from: details.imageURL)
    }

    private func loadArtistQuizIfPossible() {
        guard didLoadArtistDetails, didResolveArtistWorks, !didRequestArtistQuiz else {
            return
        }

        requestArtistQuiz(force: false)
    }

    private func requestArtistQuiz(force: Bool) {
        if force {
            didRequestArtistQuiz = false
        }

        guard didLoadArtistDetails, didResolveArtistWorks, !didRequestArtistQuiz else {
            return
        }

        didRequestArtistQuiz = true
        artistQuizViewModel.updateContext(biography: currentBiography, works: works)
        artistQuizViewModel.load(force: force)
    }
    
    private func loadPortraitImage(from imageURL: URL?) {
        RemoteImageLoader.shared.loadImage(from: imageURL) { [weak self] image in
            DispatchQueue.main.async {
                self?.portraitImageView.image = image ?? AppImages.defaultArtistPreview
            }
        }
    }
    
    private func loadHeroImage(from imageURL: URL?) {
        let fallbackURL = imageURL ?? portraitImageURL
        
        RemoteImageLoader.shared.loadImage(from: fallbackURL) { [weak self] image in
            DispatchQueue.main.async {
                self?.heroImageView.image = image ?? AppImages.defaultArtistPreview
            }
        }
    }
    
    // MARK: - Actions
    private func showWorkDetails(for work: ArtistWork) {
        let vc = WorkDetailsViewController(
            work: work,
            artistName: artist.name,
            artistImageURL: portraitImageURL
        )
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }
}
