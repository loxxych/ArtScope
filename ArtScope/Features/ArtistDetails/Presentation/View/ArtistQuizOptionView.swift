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
    
    let optionID: String
    
    init(optionID: String, title: String) {
        self.optionID = optionID
        super.init(frame: .zero)
        titleLabel.text = title
        configureUI()
        apply(style: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func apply(style: Style) {
        alpha = 1
        layer.borderWidth = 0
        iconView.isHidden = true
        
        switch style {
        case .normal:
            backgroundColor = Constants.normalColor
            titleLabel.textColor = Constants.textColorDark
        case .selected:
            backgroundColor = Constants.selectedColor
            titleLabel.textColor = Constants.textColorLight
        case .correct:
            backgroundColor = Constants.correctColor
            titleLabel.textColor = Constants.textColorLight
            iconView.image = UIImage.artScopeCheckmark
            iconView.tintColor = UIColor(red: 160/255, green: 125/255, blue: 25/255, alpha: 1)
            iconView.isHidden = false
        case .incorrect:
            backgroundColor = Constants.incorrectColor
            titleLabel.textColor = Constants.textColorDark
            iconView.image = UIImage.artScopeDislike
            iconView.tintColor = .white
            iconView.isHidden = false
        case .subdued:
            backgroundColor = Constants.normalColor
            titleLabel.textColor = Constants.textColorDark
            alpha = Constants.subduedAlpha
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
