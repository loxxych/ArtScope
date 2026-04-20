//
//  ArtistQuizExplanationView.swift
//  ArtScope
//
//  Created by loxxy on 14.04.2026.
//

import UIKit

final class ArtistQuizExplanationView: UIView {
    private enum Constants {
        static let cornerRadius: CGFloat = 8
        static let inset: CGFloat = 14
        static let backgroundColor: UIColor = .white
        static let font: UIFont = .InstrumentSansRegular13
        static let textColor: UIColor = .black
    }
    
    private let textLabel = UILabel()
    private let iconView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(text: String?) {
        let trimmed = text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        isHidden = trimmed.isEmpty
        textLabel.text = trimmed
    }
    
    private func configureUI() {
        backgroundColor = Constants.backgroundColor
        layer.cornerRadius = Constants.cornerRadius
        
        addSubview(textLabel)
        addSubview(iconView)
        
        textLabel.font = Constants.font
        textLabel.textColor = Constants.textColor
        textLabel.numberOfLines = 0
        textLabel.pinTop(to: topAnchor, Constants.inset)
        textLabel.pinBottom(to: bottomAnchor, Constants.inset)
        textLabel.pinLeft(to: leadingAnchor, Constants.inset)
        textLabel.pinRight(to: trailingAnchor, 44, .lsOE)
        
        iconView.image = UIImage.artScopeInfo
        iconView.tintColor = .black
        iconView.contentMode = .scaleAspectFit
        iconView.setWidth(22)
        iconView.setHeight(22)
        iconView.pinRight(to: trailingAnchor, Constants.inset)
        iconView.pinCenterY(to: self)
    }
}
