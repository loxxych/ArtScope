//
//  ArtistQuizPlaceholderView.swift
//  ArtScope
//
//  Created by loxxy on 25.03.2026.
//

import UIKit

final class ArtistQuizPlaceholderView: UIView {
    // MARK: - Constants
    private enum Constants {
        static let accentColor: UIColor = UIColor(named: "ArtScopePink") ?? .systemPink
        static let titleText: String = "Quiz"
        static let subtitleText: String = "Quiz content for this artist will be added next."
        static let cardTitleText: String = "Test yourself!"
        static let cardSubtitleText: String = "We will add questions, answers and scoring here later."
        static let titleBottomSpacing: CGFloat = 6
        static let cardTopSpacing: CGFloat = 12
        static let cardCornerRadius: CGFloat = 18
        static let cardInset: CGFloat = 18
        static let cardTitleBottomSpacing: CGFloat = 10
        static let titleFont: UIFont = UIFont(name: "InstrumentSans-Bold", size: 27) ?? .boldSystemFont(ofSize: 27)
        static let subtitleFont: UIFont = UIFont(name: "InstrumentSans-Regular", size: 15) ?? .systemFont(ofSize: 15)
        static let cardTitleFont: UIFont = UIFont(name: "ByteBounce", size: 40) ?? .boldSystemFont(ofSize: 40)
        static let cardSubtitleFont: UIFont = UIFont(name: "InstrumentSans-Regular", size: 15) ?? .systemFont(ofSize: 15)
        static let bodyLinesCount: Int = 0
    }
    
    // MARK: - Properties
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let card = UIView()
    private let cardTitle = UILabel()
    private let cardSubtitle = UILabel()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    private func configureUI() {
        configureTitle()
        configureSubtitle()
        configureCard()
    }
    
    private func configureTitle() {
        addSubview(titleLabel)
        titleLabel.text = Constants.titleText
        titleLabel.font = Constants.titleFont
        titleLabel.pinTop(to: topAnchor)
        titleLabel.pinHorizontal(to: self)
    }
    
    private func configureSubtitle() {
        addSubview(subtitleLabel)
        subtitleLabel.text = Constants.subtitleText
        subtitleLabel.font = Constants.subtitleFont
        subtitleLabel.numberOfLines = Constants.bodyLinesCount
        subtitleLabel.pinTop(to: titleLabel.bottomAnchor, Constants.titleBottomSpacing)
        subtitleLabel.pinHorizontal(to: self)
    }
    
    private func configureCard() {
        addSubview(card)
        card.backgroundColor = Constants.accentColor
        card.layer.cornerRadius = Constants.cardCornerRadius
        card.pinTop(to: subtitleLabel.bottomAnchor, Constants.cardTopSpacing)
        card.pinHorizontal(to: self)
        card.pinBottom(to: bottomAnchor)
        
        card.addSubview(cardTitle)
        card.addSubview(cardSubtitle)
        
        cardTitle.text = Constants.cardTitleText
        cardTitle.font = Constants.cardTitleFont
        cardTitle.pinTop(to: card.topAnchor, Constants.cardInset)
        cardTitle.pinHorizontal(to: card, Constants.cardInset)
        
        cardSubtitle.text = Constants.cardSubtitleText
        cardSubtitle.font = Constants.cardSubtitleFont
        cardSubtitle.numberOfLines = Constants.bodyLinesCount
        cardSubtitle.pinTop(to: cardTitle.bottomAnchor, Constants.cardTitleBottomSpacing)
        cardSubtitle.pinHorizontal(to: card, Constants.cardInset)
        cardSubtitle.pinBottom(to: card.bottomAnchor, Constants.cardInset)
    }
}
