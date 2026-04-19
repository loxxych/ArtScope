//
//  WorkDetailsViewController.swift
//  ArtScope
//
//  Created by loxxy on 25.03.2026.
//

import UIKit

final class WorkDetailsViewController: UIViewController {
    // MARK: - Constants
    private enum Constants {
        static let backgroundColor: UIColor = UIColor(named: "ArtScopeGreen") ?? .systemYellow
        static let headerBackgroundColor: UIColor = .black
        static let headerTextColor: UIColor = .white
        static let backButtonTintColor: UIColor = .white
        static let heroPlaceholderColor: UIColor = UIColor.white.withAlphaComponent(0.25)
        static let sideInset: CGFloat = 20
        static let sectionSpacing: CGFloat = 24
        static let heroHeight: CGFloat = 360
        static let headerBarHeight: CGFloat = 100
        static let headerBottomInset: CGFloat = 18
        static let backButtonLeft: CGFloat = 16
        static let contentBottom: CGFloat = 32
        static let contentTop: CGFloat = 16
        static let metadataTopSpacing: CGFloat = 12
        static let authorSectionTopSpacing: CGFloat = 18
        static let authorImageSize: CGFloat = 48
        static let authorNameLeft: CGFloat = 12
        static let infoTopSpacing: CGFloat = 12
        static let infoButtonTopSpacing: CGFloat = 10
        static let dividerTopSpacing: CGFloat = 16
        static let dividerHeight: CGFloat = 1
        static let dividerAlpha: CGFloat = 0.15
        static let expandButtonSize: CGFloat = 28
        static let expandButtonTop: CGFloat = 12
        static let expandButtonRight: CGFloat = 12
        static let expandButtonTintColor: UIColor = .white
        static let headerTitleFont: UIFont = UIFont(name: "InstrumentSans-Bold", size: 18) ?? .boldSystemFont(ofSize: 18)
        static let titleFont: UIFont = UIFont(name: "ByteBounce", size: 36) ?? .boldSystemFont(ofSize: 36)
        static let metadataFont: UIFont = UIFont(name: "InstrumentSans-Regular", size: 16) ?? .systemFont(ofSize: 16)
        static let authorFont: UIFont = UIFont(name: "InstrumentSans-SemiBold", size: 18) ?? .systemFont(ofSize: 18)
        static let infoFont: UIFont = UIFont(name: "InstrumentSans-Regular", size: 16) ?? .systemFont(ofSize: 16)
        static let linesCount: Int = 0
        static let collapsedInfoLinesCount: Int = 4
        static let gradientLocations: [NSNumber] = [0.0, 0.65, 0.86, 1.0]
        static let infoActionTitleExpanded: String = "Hide >"
        static let infoActionTitleCollapsed: String = "Learn more >"
        static let infoActionTintColor: UIColor = .artScopeBlue
    }
    
    // MARK: - Properties
    private let work: ArtistWork
    private let artistName: String
    private let artistImageURL: URL?
    private let viewModel: WorkDetailsViewModel
    private let studiedArtworkStore: StudiedArtworkStore
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let headerBar = UIView()
    private let backButton = UIButton(type: .system)
    private let titleLabel = UILabel()
    private let heroImageView = UIImageView()
    private let heroGradientView = UIView()
    private let heroGradientLayer = CAGradientLayer()
    private let expandButton = UIButton(type: .system)
    private let contentStack = UIStackView()
    private let workTitleLabel = UILabel()
    private let metadataLabel = UILabel()
    private let authorRow = UIView()
    private let authorImageView = UIImageView()
    private let authorNameLabel = UILabel()
    private let dividerView = UIView()
    private let infoLabel = UILabel()
    private let infoActionButton = UIButton(type: .system)
    private var isInfoExpanded = false
    private var currentInfoText: String?
    
    // MARK: - Lifecycle
    init(work: ArtistWork, artistName: String, artistImageURL: URL?) {
        self.work = work
        self.artistName = artistName
        self.artistImageURL = artistImageURL
        self.studiedArtworkStore = QuizServiceFactory.makeStudiedArtworkStore()
        self.viewModel = WorkDetailsViewModel(
            work: work,
            artistName: artistName,
            service: WikiDataArtistService(client: URLSessionNetworkClient())
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
        bindViewModel()
        configureUI()
        applyInitialState()
        recordStudiedArtwork(title: work.title)
        viewModel.load()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        heroGradientLayer.frame = heroGradientView.bounds
        authorImageView.layer.cornerRadius = authorImageView.bounds.width / 2
        refreshInfoExpansionAvailability()
    }
    
    // MARK: - UI Setup
    private func configureUI() {
        view.backgroundColor = Constants.backgroundColor
        configureHeaderBar()
        configureScrollView()
        configureHero()
        configureContentStack()
        configureInfoSection()
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
        titleLabel.text = work.title
        titleLabel.textColor = Constants.headerTextColor
        titleLabel.font = Constants.headerTitleFont
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 1
        titleLabel.pinLeft(to: backButton.trailingAnchor, 12, .grOE)
        titleLabel.pinRight(to: headerBar.trailingAnchor, 56)
        titleLabel.pinCenterX(to: headerBar)
        titleLabel.pinBottom(to: headerBar.bottomAnchor, Constants.headerBottomInset)
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
            Constants.backgroundColor.withAlphaComponent(0.25).cgColor,
            Constants.backgroundColor.withAlphaComponent(0.74).cgColor,
            Constants.backgroundColor.cgColor
        ]
        heroGradientLayer.locations = Constants.gradientLocations
        heroGradientView.layer.addSublayer(heroGradientLayer)
        
        contentView.addSubview(expandButton)
        expandButton.setImage(UIImage(systemName: "arrow.up.left.and.arrow.down.right"), for: .normal)
        expandButton.tintColor = Constants.expandButtonTintColor
        expandButton.addTarget(self, action: #selector(expandButtonPressed), for: .touchUpInside)
        expandButton.pinTop(to: heroImageView.topAnchor, Constants.expandButtonTop)
        expandButton.pinRight(to: heroImageView.trailingAnchor, Constants.expandButtonRight)
        expandButton.setWidth(Constants.expandButtonSize)
        expandButton.setHeight(Constants.expandButtonSize)
    }
    
    private func configureContentStack() {
        contentView.addSubview(contentStack)
        contentStack.axis = .vertical
        contentStack.spacing = Constants.sectionSpacing
        contentStack.pinTop(to: heroImageView.bottomAnchor, -44)
        contentStack.pinHorizontal(to: contentView, Constants.sideInset)
        contentStack.pinBottom(to: contentView.bottomAnchor, Constants.contentBottom)
    }
    
    private func configureInfoSection() {
        let infoContainer = UIView()
        contentStack.addArrangedSubview(infoContainer)
        
        infoContainer.addSubview(workTitleLabel)
        infoContainer.addSubview(metadataLabel)
        infoContainer.addSubview(authorRow)
        infoContainer.addSubview(dividerView)
        infoContainer.addSubview(infoLabel)
        infoContainer.addSubview(infoActionButton)
        
        workTitleLabel.font = Constants.titleFont
        workTitleLabel.numberOfLines = Constants.linesCount
        workTitleLabel.textAlignment = .center
        workTitleLabel.pinTop(to: infoContainer.topAnchor)
        workTitleLabel.pinHorizontal(to: infoContainer)
        
        metadataLabel.font = Constants.metadataFont
        metadataLabel.textAlignment = .center
        metadataLabel.numberOfLines = Constants.linesCount
        metadataLabel.pinTop(to: workTitleLabel.bottomAnchor, Constants.metadataTopSpacing)
        metadataLabel.pinHorizontal(to: infoContainer)
        
        authorRow.pinTop(to: metadataLabel.bottomAnchor, Constants.authorSectionTopSpacing)
        authorRow.pinHorizontal(to: infoContainer)
        
        authorRow.addSubview(authorImageView)
        authorImageView.clipsToBounds = true
        authorImageView.contentMode = .scaleAspectFill
        authorImageView.image = AppImages.defaultArtistPreview
        authorImageView.pinLeft(to: authorRow.leadingAnchor)
        authorImageView.pinTop(to: authorRow.topAnchor)
        authorImageView.pinBottom(to: authorRow.bottomAnchor)
        authorImageView.setWidth(Constants.authorImageSize)
        authorImageView.setHeight(Constants.authorImageSize)
        
        authorRow.addSubview(authorNameLabel)
        authorNameLabel.font = Constants.authorFont
        authorNameLabel.numberOfLines = Constants.linesCount
        authorNameLabel.pinLeft(to: authorImageView.trailingAnchor, Constants.authorNameLeft)
        authorNameLabel.pinCenterY(to: authorImageView)
        authorNameLabel.pinRight(to: authorRow.trailingAnchor)
        
        dividerView.backgroundColor = .black
        dividerView.alpha = Constants.dividerAlpha
        dividerView.pinTop(to: authorRow.bottomAnchor, Constants.dividerTopSpacing)
        dividerView.pinHorizontal(to: infoContainer)
        dividerView.setHeight(Constants.dividerHeight)
        
        infoLabel.font = Constants.infoFont
        infoLabel.numberOfLines = Constants.linesCount
        infoLabel.pinTop(to: dividerView.bottomAnchor, Constants.infoTopSpacing)
        infoLabel.pinHorizontal(to: infoContainer)
        
        infoActionButton.titleLabel?.font = Constants.infoFont
        infoActionButton.tintColor = Constants.infoActionTintColor
        infoActionButton.contentHorizontalAlignment = .left
        infoActionButton.addTarget(self, action: #selector(toggleInfoExpandedState), for: .touchUpInside)
        infoActionButton.pinTop(to: infoLabel.bottomAnchor, Constants.infoButtonTopSpacing)
        infoActionButton.pinLeft(to: infoContainer.leadingAnchor)
        infoActionButton.pinRight(to: infoContainer.trailingAnchor)
        infoActionButton.pinBottom(to: infoContainer.bottomAnchor)
        infoActionButton.isHidden = true
        
    }
    
    // MARK: - Data
    private func bindViewModel() {
        viewModel.onDetailsLoaded = { [weak self] details in
            self?.apply(details: details)
        }
        
        viewModel.onLoadingFailed = { error in
            print("Failed to load work details: \(error)")
        }
    }
    
    private func applyInitialState() {
        workTitleLabel.text = work.title
        metadataLabel.text = "Artwork details unavailable"
        authorNameLabel.text = artistName
        updateInfoText("Information about this artwork is loading.")
        loadHeroImage(from: work.imageURL)
        loadArtistImage(from: artistImageURL)
    }
    
    private func apply(details: WorkDetailsContent) {
        recordStudiedArtwork(title: details.title)
        titleLabel.text = details.title
        workTitleLabel.text = details.title
        metadataLabel.text = details.metadataLine
        authorNameLabel.text = details.artistName
        updateInfoText(details.infoText)
        loadHeroImage(from: details.imageURL)
        loadArtistImage(from: artistImageURL)
    }

    private func recordStudiedArtwork(title: String) {
        studiedArtworkStore.markArtworkStudied(
            StudiedArtwork(
                workID: work.id,
                title: title,
                artistName: artistName,
                imageURL: work.imageURL,
                lastViewedAt: Date()
            )
        )
    }
    
    private func loadHeroImage(from imageURL: URL?) {
        RemoteImageLoader.shared.loadImage(from: imageURL) { [weak self] image in
            DispatchQueue.main.async {
                self?.heroImageView.image = image ?? AppImages.defaultArtistPreview
            }
        }
    }
    
    private func loadArtistImage(from imageURL: URL?) {
        RemoteImageLoader.shared.loadImage(from: imageURL) { [weak self] image in
            DispatchQueue.main.async {
                self?.authorImageView.image = image ?? AppImages.defaultArtistPreview
            }
        }
    }
    
    // MARK: - Actions
    @objc private func expandButtonPressed() {
        let vc = FullscreenImageViewController(image: heroImageView.image)
        present(vc, animated: true)
    }
    
    @objc private func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func toggleInfoExpandedState() {
        isInfoExpanded.toggle()
        refreshInfoExpansionAvailability()
        view.layoutIfNeeded()
    }
    
    private func updateInfoText(_ text: String) {
        currentInfoText = text
        infoLabel.text = text
        isInfoExpanded = false
        refreshInfoExpansionAvailability()
    }
    
    private func refreshInfoExpansionAvailability() {
        guard let text = currentInfoText, !text.isEmpty else {
            infoActionButton.isHidden = true
            infoLabel.numberOfLines = Constants.linesCount
            return
        }
        
        let hasOverflow = infoTextExceedsCollapsedLimit(text)
        infoActionButton.isHidden = !hasOverflow
        infoLabel.numberOfLines = isInfoExpanded || !hasOverflow
            ? Constants.linesCount
            : Constants.collapsedInfoLinesCount
        infoActionButton.setTitle(
            isInfoExpanded ? Constants.infoActionTitleExpanded : Constants.infoActionTitleCollapsed,
            for: .normal
        )
    }
    
    private func infoTextExceedsCollapsedLimit(_ text: String) -> Bool {
        let labelWidth = infoLabel.bounds.width > 0 ? infoLabel.bounds.width : view.bounds.width - (Constants.sideInset * 2)
        guard labelWidth > 0 else { return false }
        
        let maxCollapsedHeight = Constants.infoFont.lineHeight * CGFloat(Constants.collapsedInfoLinesCount)
        let constrainedSize = CGSize(width: labelWidth, height: .greatestFiniteMagnitude)
        let textBounds = (text as NSString).boundingRect(
            with: constrainedSize,
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: [.font: Constants.infoFont],
            context: nil
        )
        
        return ceil(textBounds.height) > ceil(maxCollapsedHeight)
    }
}
