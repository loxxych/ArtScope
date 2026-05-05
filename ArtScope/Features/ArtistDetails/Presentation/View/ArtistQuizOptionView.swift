//
//  ArtistQuizOptionView.swift
//  ArtScope
//
//  Created by loxxy on 14.04.2026.
//

import UIKit

final class ArtistQuizOptionView: UIControl {
    enum Style {
        case normal
        case selected
        case correct
        case incorrect
        case subdued
    }
    
    private enum Constants {
        static let minHeight: CGFloat = 72
        static let cornerRadius: CGFloat = 8
        static let horizontalInset: CGFloat = 18
        static let iconRightInset: CGFloat = 14
        static let borderWidth: CGFloat = 2
        static let font: UIFont = .InstrumentSansRegular14
        static let textColorLight: UIColor = .black
        static let textColorDark: UIColor = .white
        static let normalColor: UIColor = .black
        static let selectedColor: UIColor = .white
        static let correctColor: UIColor = UIColor(red: 145/255, green: 240/255, blue: 104/255, alpha: 1)
        static let incorrectColor: UIColor = UIColor(red: 192/255, green: 18/255, blue: 31/255, alpha: 1)
        static let subduedAlpha: CGFloat = 0.72
    }
    
    private let titleLabel = UILabel()
    private let iconView = UIImageView()
    private var currentStyle: Style = .normal
    
    let optionID: String
    
    init(optionID: String, title: String) {
        self.optionID = optionID
        super.init(frame: .zero)
        titleLabel.text = title
        configureUI()
        apply(style: .normal, animated: false)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func apply(style: Style, animated: Bool = true) {
        currentStyle = style

        let updates = {
            self.alpha = 1
            self.layer.borderWidth = 0
            self.iconView.isHidden = true
            self.iconView.alpha = 1
            self.transform = .identity
            
            switch style {
            case .normal:
                self.backgroundColor = Constants.normalColor
                self.titleLabel.textColor = Constants.textColorDark
            case .selected:
                self.backgroundColor = Constants.selectedColor
                self.titleLabel.textColor = Constants.textColorLight
                self.transform = CGAffineTransform(scaleX: 0.985, y: 0.985)
            case .correct:
                self.backgroundColor = Constants.correctColor
                self.titleLabel.textColor = Constants.textColorLight
                self.iconView.image = UIImage.artScopeCheckmark?.withRenderingMode(.alwaysTemplate)
                self.iconView.tintColor = UIColor(red: 160/255, green: 125/255, blue: 25/255, alpha: 1)
                self.iconView.isHidden = false
            case .incorrect:
                self.backgroundColor = Constants.incorrectColor
                self.titleLabel.textColor = Constants.textColorDark
                self.iconView.image = UIImage.artScopeDislike?.withRenderingMode(.alwaysTemplate)
                self.iconView.tintColor = .white
                self.iconView.isHidden = false
            case .subdued:
                self.backgroundColor = Constants.normalColor
                self.titleLabel.textColor = Constants.textColorDark
                self.alpha = Constants.subduedAlpha
            }
        }

        guard animated else {
            updates()
            return
        }

        if style == .correct || style == .incorrect {
            iconView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            UIView.animate(
                withDuration: 0.24,
                delay: 0,
                usingSpringWithDamping: 0.72,
                initialSpringVelocity: 0.3,
                options: [.curveEaseOut]
            ) {
                updates()
                self.iconView.transform = .identity
            }
            return
        }

        UIView.animate(
            withDuration: 0.18,
            delay: 0,
            usingSpringWithDamping: 0.82,
            initialSpringVelocity: 0.25,
            options: [.curveEaseOut]
        ) {
            updates()
        }
    }
    
    private func configureUI() {
        layer.cornerRadius = Constants.cornerRadius
        clipsToBounds = true
        setHeight(mode: .grOE, Constants.minHeight)
        
        addSubview(titleLabel)
        addSubview(iconView)
        
        titleLabel.font = Constants.font
        titleLabel.numberOfLines = 0
        titleLabel.pinTop(to: topAnchor, 14)
        titleLabel.pinBottom(to: bottomAnchor, 14)
        titleLabel.pinLeft(to: leadingAnchor, Constants.horizontalInset)
        titleLabel.pinRight(to: trailingAnchor, 52, .lsOE)
        
        iconView.contentMode = .scaleAspectFit
        iconView.setWidth(24)
        iconView.setHeight(24)
        iconView.pinRight(to: trailingAnchor, Constants.iconRightInset)
        iconView.pinCenterY(to: self)
    }
}
