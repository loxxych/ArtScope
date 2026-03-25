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
        titleLabel.text = "Quiz"
        titleLabel.font = UIFont(name: "InstrumentSans-Bold", size: 27) ?? .boldSystemFont(ofSize: 27)
        titleLabel.pinTop(to: topAnchor)
        titleLabel.pinHorizontal(to: self)
    }
    
    private func configureSubtitle() {
        addSubview(subtitleLabel)
        subtitleLabel.text = "Quiz content for this artist will be added next."
        subtitleLabel.font = UIFont(name: "InstrumentSans-Regular", size: 15) ?? .systemFont(ofSize: 15)
        subtitleLabel.numberOfLines = 0
        subtitleLabel.pinTop(to: titleLabel.bottomAnchor, 6)
        subtitleLabel.pinHorizontal(to: self)
    }
    
    private func configureCard() {
        addSubview(card)
        card.backgroundColor = Constants.accentColor
        card.layer.cornerRadius = 18
        card.pinTop(to: subtitleLabel.bottomAnchor, 12)
        card.pinHorizontal(to: self)
        card.pinBottom(to: bottomAnchor)
        
        card.addSubview(cardTitle)
        card.addSubview(cardSubtitle)
        
        cardTitle.text = "Test yourself!"
        cardTitle.font = UIFont(name: "ByteBounce", size: 40) ?? .boldSystemFont(ofSize: 40)
        cardTitle.pinTop(to: card.topAnchor, 18)
        cardTitle.pinHorizontal(to: card, 18)
        
        cardSubtitle.text = "We will add questions, answers and scoring here later."
        cardSubtitle.font = UIFont(name: "InstrumentSans-Regular", size: 15) ?? .systemFont(ofSize: 15)
        cardSubtitle.numberOfLines = 0
        cardSubtitle.pinTop(to: cardTitle.bottomAnchor, 10)
        cardSubtitle.pinHorizontal(to: card, 18)
        cardSubtitle.pinBottom(to: card.bottomAnchor, 18)
    }
}
