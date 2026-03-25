//
//  ArtistOfTheDayView.swift
//  ArtScope
//
//  Created by loxxy on 31.01.2026.
//

import UIKit

final class ArtistOfTheDayView : UIView {
    // MARK: - Constants
    private enum Constants {
        // UI Constraint properties
        static let textLeft: CGFloat = 25
        static let textTop: CGFloat = 20
        
        static let buttonLeft: CGFloat = 25
        static let buttonTop: CGFloat = 60
        static let buttonHeight: CGFloat = 31
        static let buttonWidth: CGFloat = 133
        static let cornerRadius: CGFloat = buttonHeight / 2
        static let buttonRight: CGFloat = stackRight

        static let wrapCornerRadius: CGFloat = 10
        static let wrapCutoutInset: CGFloat = 6
        
        static let imageSize: CGFloat = 55
        static let paletteImageRight: CGFloat = 10
        static let imageBottom: CGFloat = 10
        
        static let stackSpacing: CGFloat = 6
        static let stackRight: CGFloat = 20
        static let stackTop: CGFloat = 5
        
        static let titleBorderWidth: CGFloat = 2
        
        static let artistImageSize: CGFloat = 183
        static let artistImageCornerRadius: CGFloat = artistImageSize / 2
        
        // Strings
        static let titleText: String = "Artist of the day"
        static let learnMoreButtonText: String = "Learn more"
        
        // Fonts
        static let titleFont: UIFont? = UIFont(name: "ByteBounce", size: 41)
        static let artistNameFont: UIFont? = UIFont(name: "InstrumentSans-Bold", size: 26)
        static let descriptionFont: UIFont? = UIFont(name: "InstrumentSans-Regular", size: 12)
        static let buttonFont: UIFont? = UIFont(name: "InstrumentSans-SemiBold", size: 15)
        
        // Colors
        static let wrapColor: UIColor = .artScopePink
        static let learnMoreButtonColor: UIColor = .artScopeBlue
        static let learnMoreButtonTintColor: UIColor = .white
        static let textColor: UIColor = .white
        static let imageColor: UIColor = .white
        static let titleBorderColor: CGColor = CGColor(red: 55/255, green: 113/255, blue: 255/255, alpha: 1)
        
        // Images
        static let paletteImage: UIImage = .palette
    }
    
    // MARK: - Fields
    private let wrap: UIView = .init()
    private let titleLabel: UILabel = .init()
    private let artistNameLabel: UILabel = .init()
    private let descirptionLabel: UILabel = .init()
    private let paletteImageView: UIImageView = .init()
    private let learnMoreButton: UIButton = .init(type: .system)
    private let textStack: UIStackView = .init()
    private let artistImageView: UIImageView = .init()
    private var currentImageURL: URL?
    
    var onLearnMoreButtonTapped: (() -> Void)?
    
    // MARK: - Lifecycle
    init() {
        super.init(frame: .zero)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        applyWrapMask()
        artistImageView.layer.cornerRadius = artistImageView.bounds.width / 2
    }

    // MARK: - UI Configuration
    private func configureUI() {
        self.setWidth(362)
        self.setHeight(275)

        configureWrap()
        configureTitle()
        configureArtistName()
        configureDescription()
        configureTextStack()
        configureLearnMoreButton()
        configurePaletteImageView()
        configureArtistImageView()
    }
    
    // MARK: - Wrap configuration
    private func configureWrap() {
        addSubview(wrap)
        
        wrap.backgroundColor = Constants.wrapColor
        wrap.layer.cornerRadius = Constants.wrapCornerRadius
        wrap.layer.masksToBounds = true
        
        wrap.setWidth(353)
        wrap.setHeight(254)
        wrap.pinLeft(to: self.leadingAnchor, 10)
        wrap.pinTop(to: self.topAnchor, 10)
    }
    
    // MARK: - Title configuration
    private func configureTitle() {
        wrap.addSubview(titleLabel)
        
        titleLabel.text = Constants.titleText
        titleLabel.font = Constants.titleFont
        titleLabel.textColor = Constants.textColor
        
        titleLabel.pinLeft(to: wrap.leadingAnchor, Constants.textLeft)
        titleLabel.pinTop(to: wrap.topAnchor, Constants.textTop)
    }
    
    // MARK: - Artist name configuration
    private func configureArtistName() {
        artistNameLabel.text = "Artist"
        artistNameLabel.font = Constants.artistNameFont
        artistNameLabel.textColor = Constants.textColor
        artistNameLabel.numberOfLines = 2
    }
    
    // MARK: - Description configuration
    private func configureDescription() {
        descirptionLabel.text = "A featured artist from the encyclopedia."
        descirptionLabel.font = Constants.descriptionFont
        descirptionLabel.textColor = Constants.textColor
        descirptionLabel.numberOfLines = 4
    }
    
    // MARK: - Text stack configuration
    private func configureTextStack() {
        wrap.addSubview(textStack)
        
        textStack.axis = .vertical
        textStack.alignment = .leading
        textStack.spacing = Constants.stackSpacing
        textStack.addArrangedSubview(artistNameLabel)
        textStack.addArrangedSubview(descirptionLabel)
        
        textStack.pinRight(to: wrap.trailingAnchor, Constants.stackRight)
        textStack.pinTop(to: titleLabel.bottomAnchor, Constants.stackTop)
    }
    
    // MARK: - Learn more button configuration
    private func configureLearnMoreButton() {
        wrap.addSubview(learnMoreButton)
        
        learnMoreButton.setTitle(Constants.learnMoreButtonText, for: .normal)
        learnMoreButton.titleLabel?.font = Constants.buttonFont
        learnMoreButton.backgroundColor = Constants.learnMoreButtonColor
        learnMoreButton.tintColor = Constants.learnMoreButtonTintColor
        learnMoreButton.layer.cornerRadius = Constants.cornerRadius
        learnMoreButton.addTarget(self, action: #selector(learnMoreButtonPressed), for: .touchUpInside)
        
        learnMoreButton.pinTop(to: textStack.bottomAnchor, Constants.buttonTop)
        learnMoreButton.pinRight(to: wrap.trailingAnchor, Constants.buttonRight)
        learnMoreButton.setWidth(Constants.buttonWidth)
        learnMoreButton.setHeight(Constants.buttonHeight)
    }
    
    // MARK: - Palette image view configuration
    private func configurePaletteImageView() {
        addSubview(paletteImageView)
        
        paletteImageView.image = Constants.paletteImage
        paletteImageView.tintColor = Constants.imageColor
        
        paletteImageView.setWidth(Constants.imageSize)
        paletteImageView.setHeight(Constants.imageSize)
        paletteImageView.pinRight(to: self.trailingAnchor)
        paletteImageView.pinTop(to: self.topAnchor)
    }
    
    // MARK: - Artist image view configuration
    private func configureArtistImageView() {
        addSubview(artistImageView)
        
        artistImageView.image = AppImages.defaultArtistPreview
        artistImageView.clipsToBounds = true
        artistImageView.contentMode = .scaleAspectFill
        
        artistImageView.setWidth(Constants.artistImageSize)
        artistImageView.setHeight(Constants.artistImageSize)
        artistImageView.pinLeft(to: self.leadingAnchor)
        artistImageView.pinBottom(to: self.bottomAnchor)
    }
    
    func configure(with artist: ArtistPreview) {
        currentImageURL = artist.imageURL
        artistNameLabel.text = artist.name
        descirptionLabel.text = artist.summary
        artistImageView.image = AppImages.defaultArtistPreview
        
        RemoteImageLoader.shared.loadImage(from: artist.imageURL) { [weak self] image in
            guard let self, self.currentImageURL == artist.imageURL else { return }
            
            DispatchQueue.main.async {
                self.artistImageView.image = image ?? AppImages.defaultArtistPreview
            }
        }
    }

    // MARK: - UI utilities
    @objc private func learnMoreButtonPressed() {
        onLearnMoreButtonTapped?()
    }
    
    private func applyWrapMask() {
        let maskPath = UIBezierPath(
            roundedRect: wrap.bounds,
            byRoundingCorners: [.topLeft, .topRight, .bottomRight],
            cornerRadii: CGSize(width: Constants.wrapCornerRadius, height: Constants.wrapCornerRadius)
        )
        
        let cutoutFrame = wrap.convert(
            artistImageView.bounds,
            from: artistImageView
        ).insetBy(dx: -Constants.wrapCutoutInset, dy: -Constants.wrapCutoutInset)
        let cutoutPath = UIBezierPath(ovalIn: cutoutFrame)
        maskPath.append(cutoutPath)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = maskPath.cgPath
        shapeLayer.fillRule = .evenOdd
        wrap.layer.mask = shapeLayer
    }

}
