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
        static let buttonTop: CGFloat = 40
        static let buttonHeight: CGFloat = 31
        static let buttonWidth: CGFloat = 133
        static let cornerRadius: CGFloat = buttonHeight / 2
        static let wrapCornerRadius: CGFloat = 10
        static let imageSize: CGFloat = 55
        static let paletteImageRight: CGFloat = 10
        static let imageBottom: CGFloat = 10
        static let stackSpacing: CGFloat = 6
        static let stackLeft: CGFloat = 10
        static let stackTop: CGFloat = 15
        
        // Strings
        static let titleText: String = "Quiz of the day"
        static let learnMoreButtonText: String = "Learn more"
        
        // Fonts
        static let titleFont: UIFont? = UIFont(name: "ByteBounce", size: 41)
        static let artistNameFont: UIFont? = UIFont(name: "InstrumentSans-SemiBold", size: 26)
        static let descriptionFont: UIFont? = UIFont(name: "InstrumentSans-Regular", size: 12)
        static let buttonFont: UIFont? = UIFont(name: "InstrumentSans-SemiBold", size: 17)
        
        // Colors
        static let wrapColor: UIColor = .artScopePink
        static let learnMoreButtonColor: UIColor = .artScopeBlue
        static let learnMoreButtonTintColor: UIColor = .white
        static let textColor: UIColor = .white
        static let imageColor: UIColor = .white
        
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
        applyPerimeterFade(to: wrap)
    }

    // MARK: - UI Configuration
    private func configureUI() {
        configureWrap()
        configureTitle()
        configureArtistName()
        configureDescription()
        configureTextStack()
        configureLearnMoreButton()
        configurePaletteImageView()
    }
    
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
    
    private func configureTitle() {
        wrap.addSubview(titleLabel)
        
        titleLabel.text = Constants.titleText
        titleLabel.font = Constants.titleFont
        titleLabel.textColor = Constants.textColor
        
        titleLabel.pinLeft(to: wrap.leadingAnchor, Constants.textLeft)
        titleLabel.pinTop(to: wrap.topAnchor, Constants.textTop)
    }
    
    private func configureArtistName() {
        artistNameLabel.text = "Van Gogh"
        artistNameLabel.font = Constants.artistNameFont
        artistNameLabel.textColor = Constants.textColor
    }
    
    private func configureDescription() {
        descirptionLabel.text = "Impressionist painter who is among\n the most famous and influential\n figures in the history of Western art."
        descirptionLabel.font = Constants.descriptionFont
        descirptionLabel.textColor = Constants.textColor
    }
    
    private func configureTextStack() {
        wrap.addSubview(textStack)
        
        textStack.axis = .vertical
        textStack.alignment = .leading
        textStack.spacing = Constants.stackSpacing
        textStack.addArrangedSubview(artistNameLabel)
        textStack.addArrangedSubview(descirptionLabel)
        
        textStack.pinRight(to: wrap.trailingAnchor, Constants.stackLeft)
        textStack.pinTop(to: titleLabel.bottomAnchor, Constants.stackTop)

    }
    
    private func configureLearnMoreButton() {
        wrap.addSubview(learnMoreButton)
        
        learnMoreButton.setTitle(Constants.learnMoreButtonText, for: .normal)
        learnMoreButton.backgroundColor = Constants.learnMoreButtonColor
        learnMoreButton.tintColor = Constants.learnMoreButtonTintColor
        learnMoreButton.layer.cornerRadius = Constants.cornerRadius
        
        learnMoreButton.pinTop(to: textStack.bottomAnchor, Constants.buttonTop)
        learnMoreButton.setWidth(Constants.buttonWidth)
        learnMoreButton.setHeight(Constants.buttonHeight)
    }
    
    private func configurePaletteImageView() {
        wrap.addSubview(paletteImageView)
        
        paletteImageView.image = Constants.paletteImage
        paletteImageView.tintColor = Constants.imageColor
        
        paletteImageView.setWidth(Constants.imageSize)
        paletteImageView.setHeight(Constants.imageSize)
        paletteImageView.pinRight(to: self.trailingAnchor)
        paletteImageView.pinTop(to: self.topAnchor)
    }
    
    // MARK: - UI utilities
    private func applyPerimeterFade(to view: UIView, fade: CGFloat = 20) {
        let maskLayer = CAGradientLayer()
        maskLayer.frame = view.bounds
        maskLayer.shadowRadius = 5
        maskLayer.shadowPath = CGPath(roundedRect: view.bounds.insetBy(dx: 5, dy: 5), cornerWidth: 10, cornerHeight: 10, transform: nil)
        maskLayer.shadowOpacity = 1;
        maskLayer.shadowOffset = CGSize.zero;
        maskLayer.shadowColor = UIColor.white.cgColor
        view.layer.mask = maskLayer;
    }

}
