//
//  QuizOfTheDayView.swift
//  ArtScope
//
//  Created by loxxy on 30.01.2026.
//

import UIKit

final class QuizOfTheDayView : UIView {
    // MARK: - Constants
    private enum Constants {
        // UI Constraint properties
        static let textLeft: CGFloat = 25
        static let textTop: CGFloat = 20
        static let buttonLeft: CGFloat = 25
        static let buttonBottom: CGFloat = 25
        static let buttonHeight: CGFloat = 38
        static let buttonWidth: CGFloat = 163
        static let cornerRadius: CGFloat = buttonHeight / 2
        static let wrapCornerRadius: CGFloat = 10
        static let imageSize: CGFloat = 88
        static let imageLeft: CGFloat = 10
        static let imageBottom: CGFloat = 10

        // Strings
        static let titleText: String = "Quiz of the day"
        static let themeText: String = "Theme: "
        static let startButtonText: String = "Start"
        
        // Fonts
        static let titleFont: UIFont? = UIFont(name: "ByteBounce", size: 41)
        static let themeFont: UIFont? = UIFont(name: "InstrumentSans-SemiBold", size: 17)
        
        // Colors
        static let wrapColor: UIColor = .artScopePink
        static let startButtonColor: UIColor = .artScopeBlue
        static let startButtonTintColor: UIColor = .white
        static let textColor: UIColor = .white
        static let imageColor: UIColor = .white
        
        // Images
        static let image: UIImage = .drawingBoard
    }
    
    // MARK: - Fields
    private let wrap: UIView = .init()
    private let titleLabel: UILabel = .init()
    private let themeLabel: UILabel = .init()
    private let imageView: UIImageView = .init()
    private let startButton: UIButton = .init(type: .system)
    
    var onStartButtonTapped: (() -> Void)?
    
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
        configureTheme()
        configureStartButton()
        configureImageView()
    }
    
    private func configureWrap() {
        addSubview(wrap)
        
        wrap.backgroundColor = Constants.wrapColor
        wrap.layer.cornerRadius = Constants.wrapCornerRadius
        wrap.layer.masksToBounds = true

        wrap.pin(to: self)
    }
    
    private func configureTitle() {
        wrap.addSubview(titleLabel)
        
        titleLabel.text = Constants.titleText
        titleLabel.font = Constants.titleFont
        titleLabel.textColor = Constants.textColor
        
        titleLabel.pinLeft(to: wrap.leadingAnchor, Constants.textLeft)
        titleLabel.pinTop(to: wrap.topAnchor, Constants.textTop)
    }
    
    private func configureTheme() {
        wrap.addSubview(themeLabel)
        
        themeLabel.text = Constants.themeText
        themeLabel.font = Constants.themeFont
        themeLabel.textColor = Constants.textColor

        themeLabel.pinLeft(to: wrap.leadingAnchor, Constants.textLeft)
        themeLabel.pinTop(to: titleLabel.bottomAnchor, Constants.textTop)
    }
    
    private func configureStartButton() {
        wrap.addSubview(startButton)
        
        startButton.setTitle(Constants.startButtonText, for: .normal)
        startButton.backgroundColor = Constants.startButtonColor
        startButton.tintColor = Constants.startButtonTintColor
        startButton.layer.cornerRadius = Constants.cornerRadius
        
        startButton.pinLeft(to: wrap.leadingAnchor, Constants.buttonLeft)
        startButton.pinBottom(to: wrap.bottomAnchor, Constants.buttonBottom)
        startButton.setWidth(Constants.buttonWidth)
        startButton.setHeight(Constants.buttonHeight)
    }
    
    private func configureImageView() {
        wrap.addSubview(imageView)
        
        imageView.image = Constants.image
        imageView.tintColor = Constants.imageColor
        
        imageView.setWidth(Constants.imageSize)
        imageView.setHeight(Constants.imageSize)
        imageView.pinRight(to: wrap.trailingAnchor, Constants.imageLeft)
        imageView.pinBottom(to: wrap.bottomAnchor, Constants.imageBottom)
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
