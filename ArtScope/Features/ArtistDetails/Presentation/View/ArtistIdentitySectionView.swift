//
//  ArtistIdentitySectionView.swift
//  ArtScope
//
//  Created by loxxy on 25.03.2026.
//

import UIKit

final class ArtistIdentitySectionView: UIView {
    // MARK: - Constants
    private enum Constants {
        static let stackSpacing: CGFloat = 6
        static let nameFont: UIFont = UIFont(name: "ByteBounce", size: 52) ?? .boldSystemFont(ofSize: 52)
        static let lifeSpanFont: UIFont = UIFont(name: "InstrumentSans-Regular", size: 16) ?? .systemFont(ofSize: 16)
        static let textAlignment: NSTextAlignment = .center
        static let linesCount: Int = 0
    }
    
    // MARK: - Properties
    private let nameLabel = UILabel()
    private let lifeSpanLabel = UILabel()
    private let stackView = UIStackView()
    
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
        addSubview(stackView)
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = Constants.stackSpacing
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(lifeSpanLabel)
        stackView.pinTop(to: topAnchor)
        stackView.pinLeft(to: leadingAnchor)
        stackView.pinRight(to: trailingAnchor)
        stackView.pinBottom(to: bottomAnchor)
        
        nameLabel.font = Constants.nameFont
        nameLabel.numberOfLines = Constants.linesCount
        nameLabel.textAlignment = Constants.textAlignment
        
        lifeSpanLabel.font = Constants.lifeSpanFont
        lifeSpanLabel.textAlignment = Constants.textAlignment
        lifeSpanLabel.numberOfLines = Constants.linesCount
    }
    
    // MARK: - Update
    func configure(name: String, lifeSpan: String) {
        nameLabel.text = name
        lifeSpanLabel.text = lifeSpan
    }
}
