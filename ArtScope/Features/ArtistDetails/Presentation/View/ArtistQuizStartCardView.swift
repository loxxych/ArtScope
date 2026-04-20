//
//  ArtistQuizStartCardView.swift
//  ArtScope
//
//  Created by loxxy on 14.04.2026.
//

import UIKit

final class ArtistQuizStartCardView: UIView {
    private enum Constants {
        static let backgroundColor: UIColor = .artScopePink
        static let cornerRadius: CGFloat = 18
        static let contentInset: CGFloat = 22
        static let iconSize: CGFloat = 56
        static let buttonTopSpacing: CGFloat = 22
        static let titleFont: UIFont = .ByteBounce30
        static let titleText: String = "Test yourself!"
        static let buttonTitle: String = "Begin"
    }
    
    private let titleLabel = UILabel()
    private let leftIcon = UIImageView()
    private let rightIcon = UIImageView()
    private let actionButton = ArtistQuizActionButton()
    private lazy var tapGesture = UITapGestureRecognizer(target: self, action: #selector(beginTapped))
    
    var onBeginTapped: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        backgroundColor = Constants.backgroundColor
        layer.cornerRadius = Constants.cornerRadius
        isUserInteractionEnabled = true
        addGestureRecognizer(tapGesture)
        
        addSubview(titleLabel)
        addSubview(leftIcon)
        addSubview(rightIcon)
        addSubview(actionButton)
        
        titleLabel.text = Constants.titleText
        titleLabel.font = Constants.titleFont
        titleLabel.textAlignment = .center
        titleLabel.pinTop(to: topAnchor, Constants.contentInset)
        titleLabel.pinHorizontal(to: self, Constants.contentInset)
        
        leftIcon.image = UIImage.artScopePaintbrush?.withRenderingMode(.alwaysTemplate)
        leftIcon.tintColor = .white
        leftIcon.contentMode = .scaleAspectFit
        leftIcon.setWidth(Constants.iconSize)
        leftIcon.setHeight(Constants.iconSize)
        leftIcon.pinLeft(to: leadingAnchor, Constants.contentInset)
        leftIcon.pinBottom(to: bottomAnchor, Constants.contentInset)
        
        rightIcon.image = UIImage.artScopePalette?.withRenderingMode(.alwaysTemplate)
        rightIcon.tintColor = .white
        rightIcon.contentMode = .scaleAspectFit
        rightIcon.setWidth(Constants.iconSize)
        rightIcon.setHeight(Constants.iconSize)
        rightIcon.pinRight(to: trailingAnchor, Constants.contentInset)
        rightIcon.pinBottom(to: bottomAnchor, Constants.contentInset)
        
        actionButton.setTitleText(Constants.buttonTitle)
        actionButton.addTarget(self, action: #selector(beginTapped), for: .touchUpInside)
        actionButton.pinTop(to: titleLabel.bottomAnchor, Constants.buttonTopSpacing)
        actionButton.pinCenterX(to: self)
        actionButton.pinBottom(to: bottomAnchor, Constants.contentInset)
        bringSubviewToFront(actionButton)
    }
    
    @objc private func beginTapped() {
        onBeginTapped?()
    }
}
